//
//  FindFriendViewController.m
//  WeiBo_Project
//
//  Created by xzx on 13-12-9.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "FindFriendViewController.h"
#import "UIViewController+CreatCustomNaBar.h"
#import "UserInfo.h"
#import "FindFriendCell.h"

@interface FindFriendViewController ()

@end

@implementation FindFriendViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建NavigationBar
    [self creatBackNavigationBarWithTitle:@"找朋友" sign:1];
    
    
    //显示周边人微博的tableview
    _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 568-44-20-49) style:UITableViewStylePlain];
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    _tabelView.pullDelegate = self;
    _tabelView.canPullDown = YES;
    _tabelView.canPullUp =YES;
    
    [self getPreseentIp];
    
}

WBHTTP_Request_Block *getGeoBlock;

- (void)getPreseentIp
{
    NSURL *url = [NSURL URLWithString:@"http://www.whatismyip.com.tw/"];
    NSString *str  = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSRange range1= [str rangeOfString:@"h2>"];
    NSRange range2= [str rangeOfString:@"</h2"];
    NSLog(@"-----------%d ,%d",range1.length,range1.location);
    NSLog(@"-----------%d ,%d",range2.length,range2.location);
    int location = range1.location+range1.length;
    int length = range2.location-(range1.location+range1.length);
    NSString *ip = [str substringWithRange:NSMakeRange(location, length)];
    
    __weak FindFriendViewController *findFriendVC = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:ip,@"ip", nil];
    getGeoBlock = [[WBHTTP_Request_Block alloc] initWithURlString:LOCATION_GEO_IP_TO_GEO andArguments:dic];
    [getGeoBlock setBlock:^(NSMutableData *datas, float progressNum) {
        [findFriendVC getGeoInfo:datas];
    }];
}


WBHTTP_Request_Block *nearbyUsers;

- (void)getGeoInfo:(NSMutableData *)data
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *geoInfoArray = [dic objectForKey:@"geos"];
    NSDictionary *geoInfo = [geoInfoArray objectAtIndex:0];
    Geo *geo = [[Geo alloc] initWithGeo:geoInfo];
    _geo = geo;
    [self getNearByUsers];
}


- (void)getNearByUsers
{
    
    NSLog(@"++++++++++++%@", _geo);
    
    NSString *latitude = [NSString stringWithString:_geo.latitude];
    NSString *longitude = [NSString stringWithString:_geo.longitude];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:latitude,@"lat", longitude,@"long", nil];
    
    //TODO: 通过ip得到本地的地理位置，然后通过地理位置获取周边微博信息
    __weak FindFriendViewController *findFriendVC = self;
    nearbyUsers = [[WBHTTP_Request_Block alloc] initWithURlString:PLACE_NEARBY_USERS andArguments:params];
    [nearbyUsers setBlock:^(NSMutableData *datas, float progressNum) {
        //周边人数据请求
        [findFriendVC getFriendData:datas];
    }];
    
}

-(void)getFriendData:(NSMutableData *)datas
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:&error];
    NSArray *users = [dic objectForKey:@"users"];
    NSLog(@"--------%@",users);
    NSMutableArray *data = [[NSMutableArray alloc]init];
    
    for (NSDictionary *user in users)
    {
        UserInfo *userInfo = [[UserInfo alloc]initWithUser:user];
        [data addObject:userInfo];
    }
    self.data = data;
    //重载数据
    [_tabelView reloadData];
    [self.view addSubview:_tabelView];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    FindFriendCell *cell =(FindFriendCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[FindFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    UserInfo *user = [self.data objectAtIndex:indexPath.row];
    cell.nameLable.text = user.screen_name;
    
    [cell.headImage setImageWithURL:[NSURL URLWithString:user.profile_image_url]];
    
    if ([user.description isEqualToString:@""])
    {
        cell.descriptionLabel.text = @"该用户很懒没有写任何详情";
    }
    else
    {
        cell.descriptionLabel.text = user.description;
    }
    
    cell.distance.text = [NSString stringWithFormat:@"%d米",user.distance];
    
    if ([user.gender isEqualToString:@"m"])
    {
        cell.sexImage.image = [UIImage imageNamed:@"list_male"];
    }
    if ([user.gender isEqualToString:@"f"])
    {
        cell.sexImage.image = [UIImage imageNamed:@"list_female"];
    }
       return cell;
}



#pragma mark -- UIScrollView PullDelegate
-(void)scrollView:(UIScrollView *)scrollView loadWithState:(LoadState)state
{
    if (state == PullDownLoadState) {
        [self performSelector:@selector(PullDownLoadEnd) withObject:nil afterDelay:3];
    }
    else {
        [self performSelector:@selector(PullUpLoadEnd) withObject:nil afterDelay:3];
    }
}

- (void)PullDownLoadEnd {
    [self getPreseentIp];
    
    _tabelView.canPullUp = YES;
    [_tabelView reloadData];
    [_tabelView stopLoadWithState:PullDownLoadState];
}

- (void)PullUpLoadEnd {
    [_tabelView reloadData];
    [_tabelView stopLoadWithState:PullUpLoadState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
