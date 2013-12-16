//
//  PersonalViewController.m
//  WeiBo_Project
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "PersonalViewController.h"
#import "UIImageView+WebCache.h"
#import "HomeViewController.h"
#import "SBJson.h"
#import <QuartzCore/QuartzCore.h>
@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //加载数据
        
    }
    return self;
}

WBHTTP_Request_Block *personInfoDown;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.sina.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:
        {
            NSLog(@"没有网络连接！");
            NSString *str = [PersonalViewController getUserInfoPath];
            NSString *path = [str stringByAppendingPathComponent:@"userInfo"];
            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            _userInfo = [[UserInfo alloc] initWithUser:dic];
            _weiboContex = [[WeiBoContext alloc] initWithWeibo:[dic objectForKey:@"status"]];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"使用3G网络！");
            __weak PersonalViewController *personVC = self;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *uerId = [defaults objectForKey:@"userID"];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uerId,@"uid", nil];
            personInfoDown = [[WBHTTP_Request_Block alloc] initWithURlString:USERS_SHOW andArguments:dic];
            [personInfoDown setBlock:^(NSMutableData *datas, float progressNum) {
                [personVC loadUserInfoData:datas];
            }];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"使用WiFi网络！");
            __weak PersonalViewController *personVC = self;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *uerId = [defaults objectForKey:@"userID"];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uerId,@"uid", nil];
            personInfoDown = [[WBHTTP_Request_Block alloc] initWithURlString:USERS_SHOW andArguments:dic];
            [personInfoDown setBlock:^(NSMutableData *datas, float progressNum) {
                [personVC loadUserInfoData:datas];
            }];
            break;
        }
        default:
            break;
    }
    
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
}

+ (NSString *)getUserInfoPath
{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [str stringByAppendingPathComponent:@"PersonalInfo"];
    NSFileManager *file = [NSFileManager defaultManager];
    if (![file fileExistsAtPath:path]) {
        [file createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return path;
    }
    else return path;
    
}

ImageDownload *imageDownLoad;
ImageDownload *weiboImageDownload;
ImageDownload *retWeiboImage;
- (void)loadUserInfoData:(NSMutableData *)data
{
    NSError *error = nil;
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error]];
    
    _userInfo = [[UserInfo alloc] initWithUser:dic];
    NSDictionary *weiboDic = [dic objectForKey:@"status"];
    _weiboContex = [[WeiBoContext alloc] initWithWeibo:weiboDic];

    __weak PersonalViewController *personalVC = self;
    imageDownLoad = [[ImageDownload alloc] initWithURlString:_userInfo.profile_image_url];
    [imageDownLoad setBlock:^(NSMutableData *datas, float progressNum) {
        [personalVC getHeadImage:datas];
    }];
    
    if (_weiboContex.thumbnail_pic.length > 0) {
        ImageDownload *weiboImageDownload = [[ImageDownload alloc] initWithURlString:_weiboContex.thumbnail_pic];
        [weiboImageDownload setBlock:^(NSMutableData *datas, float progressNum) {
            [personalVC getWeiboImage:datas andType:@"weiboImage"];
        }];
    }
    else
    {
        if (_weiboContex.retweeted_status != nil) {
            _weiboContex.retweetedWeibo = [[WeiBoContext alloc] initWithWeibo:(NSDictionary *)_weiboContex.retweeted_status];
            if (_weiboContex.retweetedWeibo.thumbnail_pic.length > 0) {
                retWeiboImage = [[ImageDownload alloc] initWithURlString:_weiboContex.thumbnail_pic];
                [retWeiboImage setBlock:^(NSMutableData *datas, float progressNum) {
                    [personalVC getWeiboImage:datas andType:@"retWeiboImage"];
                }];
            }
        }
    }
    
    
    NSFileManager *file = [NSFileManager defaultManager];
    NSString *str = [PersonalViewController getUserInfoPath];
    NSString *path = [str stringByAppendingPathComponent:@"userInfo"];
    if (![file fileExistsAtPath:path])
    {
        [file createFileAtPath:path contents:data attributes:nil];
    }
    else [data writeToFile:path atomically:YES];
}

- (void)getHeadImage:(NSMutableData *)data
{
    NSString *path = [PersonalViewController getUserInfoPath];
    NSString *headImagePath = [path stringByAppendingPathComponent:@"myself.jpg"];
    NSFileManager *file = [NSFileManager defaultManager];
    if (![file fileExistsAtPath:headImagePath]) {
        [file createFileAtPath:headImagePath contents:data attributes:nil];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    _userInfo.headImage = image;
    [_tableView reloadData];
}

-(void)getWeiboImage:(NSMutableData *)data andType:(NSString *)type
{
    UIImage *image = [UIImage imageWithData:data];
    if ([type isEqualToString:@"weiboImage"]) {
        NSString *path = [PersonalViewController getUserInfoPath];
        NSString *str = [_weiboContex.idstr stringByAppendingFormat:@".jpg"];
        NSString *weiboImagePath = [path stringByAppendingPathComponent:str];
        NSFileManager *file = [NSFileManager defaultManager];
        if (![file fileExistsAtPath:weiboImagePath]) {
            [file createFileAtPath:weiboImagePath contents:data attributes:nil];
        }
        _weiboContex.thumbnailImage = image;
    }
    if ([type isEqualToString:@"retWeiboImage"]) {
        NSString *path = [PersonalViewController getUserInfoPath];
        NSString *str = [_weiboContex.retweetedWeibo.idstr stringByAppendingFormat:@".jpg"];
        NSString *retWeiboImagePath = [path stringByAppendingPathComponent:str];
        NSFileManager *file = [NSFileManager defaultManager];
        if (![file fileExistsAtPath:retWeiboImagePath]) {
            [file createFileAtPath:retWeiboImagePath contents:data attributes:nil];
        }
        _weiboContex.retweetedWeibo.thumbnailImage = image;
        
    }
    [_tableView reloadData];
}


#pragma mark -- UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str=@"_cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    else
    {
        cell.textLabel.text=nil;
        cell.imageView.image = nil;
        cell.textLabel.textAlignment=0;
    }
    if (indexPath.row==0)
    {
        //封面背景
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
        backgroundView.backgroundColor = [UIColor redColor];
        NSString *str = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:str];
        backgroundView.image = image;
        [_tableView addSubview:backgroundView];
        
        //头像
        UIImageView *headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 125,50,50)];
        headImageV.backgroundColor = [UIColor clearColor];
        headImageV.layer.borderColor = [UIColor whiteColor].CGColor;
        headImageV.layer.borderWidth = 1;
        headImageV.layer.cornerRadius = 2;
        headImageV.image = _userInfo.headImage;
        [_tableView addSubview:headImageV];
    
        //昵称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 115, 100, 25)];
        nameLabel.text = _userInfo.name;
        nameLabel.backgroundColor = [UIColor clearColor];
        [_tableView addSubview:nameLabel];
        
        //性别
        UIImageView *sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(160, 115, 20, 20)];
        if ([_userInfo.gender isEqualToString:@"m"])
        {
            sexImage.image = [UIImage imageNamed:@"list_male"];
        }
        if ([_userInfo.gender isEqualToString:@"f"])
        {
            sexImage.image = [UIImage imageNamed:@"list_female"];
        }
        
        [_tableView addSubview:sexImage];
        
        //皇冠
        UIImageView *verifiedImage = [[UIImageView alloc]initWithFrame:CGRectMake(240, 115, 40, 25)];
        if (_userInfo.verified ==YES)
        {
             verifiedImage.Image=[UIImage imageNamed:@"userinfo_membership"];
        }
        else
        {
             verifiedImage.Image=[UIImage imageNamed:@"userinfo_membership_expired"];
        }
        [_tableView addSubview:verifiedImage];
        
        //个人信息
        UIButton *editUserInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        editUserInfo.frame = CGRectMake(120, 160, 82, 30);
        [editUserInfo setBackgroundImage:[UIImage imageNamed:@"page_like_button_background"] forState:UIControlStateNormal];
        [editUserInfo setImage:[UIImage imageNamed:@"userinfo_relationship_indicator_edit.png"] forState:UIControlStateNormal];
        [editUserInfo setTitle:@"个人资料" forState:UIControlStateNormal];
        editUserInfo.titleLabel.font = [UIFont systemFontOfSize:12];
        [editUserInfo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [editUserInfo addTarget:self action:@selector(userInformation) forControlEvents:UIControlEventTouchUpInside];
        [_tableView addSubview:editUserInfo];
        
        //关注、粉丝等数量
        NSArray *title = [[NSArray alloc] initWithObjects:@"粉丝数", @"微博数",@"关注",@"收藏",@"互粉数",nil];
        
        NSArray *count = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",self.userInfo.followers_count],[NSString stringWithFormat:@"%d",self.userInfo.statuses_count],[NSString stringWithFormat:@"%d",self.userInfo.friends_count],[NSString stringWithFormat:@"%d",self.userInfo.favourites_count],[NSString stringWithFormat:@"%d",self.userInfo.bi_followers_count], nil];
        
        for (int i=0; i<5; i++)
        {
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+60*i, 220, 60, 50)];
            nameLabel.text = [title objectAtIndex:i];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font = [UIFont systemFontOfSize:12];
            
            UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+60*i, 200, 60, 50)];
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel.backgroundColor = [UIColor clearColor];
            countLabel.font = [UIFont systemFontOfSize:10];
            countLabel.textColor = [UIColor blueColor];
            if (![[count objectAtIndex:i]isEqualToString:@"0"])
            {
                countLabel.text = [count objectAtIndex:i];
            }
            [_tableView addSubview:nameLabel];
            [_tableView addSubview:countLabel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    //微博正文
    else
        if(indexPath.row==1)
        {
            static NSString *cellIndentify = @"CellIndentify";
            WeiboCell *cellTest = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
            if (cellTest  == nil) {
                cellTest = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
                if (_weiboContex != nil) {
                    [cellTest viewWeiboContex:_weiboContex];
                }
            }
            return cellTest;
        }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 280;
    }
    else 
    {
        //微博正文高度
        return 280;
    }
    
}

//编辑个人资料
-(void)userInformation
{
    UserInfomationViewController *infoView = [UserInfomationViewController new];
    infoView.userInfo = self.userInfo;
    [self.navigationController pushViewController:infoView animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
