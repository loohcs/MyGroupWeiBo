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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
//    [self loadWeiboContextData];
}

-(void)loadWeiboContextData
{
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *accessToken = [user objectForKey:@"accessToken"];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"20",@"count",nil];
//    [WBHttpRequest requestWithAccessToken:accessToken url:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:params delegate:self];
    
}
#pragma mark--WBHttpRequestDelegate
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    
}
-(void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:result];
    NSDictionary *statuses = [dic objectForKey:@"statuses"];
     NSLog(@"%@",statuses);
    NSMutableArray *contexts = [[NSMutableArray alloc]init];
    for (NSDictionary *statuse in statuses)
    {
        WeiBoContext *weibo = [[WeiBoContext alloc]initWithWeibo:statuse];
        [contexts addObject:weibo];
    }
    
    
    WeiBoContext *context = [contexts objectAtIndex:0];
    _userInfo = context.userInfo;
   
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
#warning  图片未设
    
        [_tableView addSubview:backgroundView];
        
        //头像
        UIImageView *headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 125,50,50)];
        headImageV.backgroundColor = [UIColor clearColor];
        headImageV.layer.borderColor = [UIColor whiteColor].CGColor;
        headImageV.layer.borderWidth = 1;
        headImageV.layer.cornerRadius = 2;
        [headImageV setImageWithURL:[NSURL URLWithString:_userInfo.profile_image_url]];
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
        
    }

    //微博正文
    if (indexPath.row==1)
    {
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
