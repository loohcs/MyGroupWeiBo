//
//  CustomTabbarController.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-21.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "CustomTabbarController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "PersonalViewController.h"
#import "SquareViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationViewController.h"

#import "Public_Timeline_Weibo.h"
#import "Friends_Timeline_Weibo.h"

@interface CustomTabbarController ()

@end

@implementation CustomTabbarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBar.hidden = YES;
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    _publicTimelineWeibo = [[Public_Timeline_Weibo alloc] init];
//    _friendsTimelineWeibo = [[Friends_Timeline_Weibo alloc] init];
//    [_publicTimelineWeibo getPublicTimeline];
//    [_friendsTimelineWeibo getFriendsTimelineWeibo];
    
    
    //初始化五个viewController并设置标题
    title = [NSArray arrayWithObjects:@"首页",@"消息",@"我",@"广场",@"更多",nil];
    [self initWithVCTitle];
    
    self.navigationItem.title=@"";
    //初始化自定义tabbar
    [self initWithTabbar];
    

}

- (void)initWithTabbar
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 568-49, 320, 49)];
    imageView.image = [UIImage imageNamed:@"tabbar_background"];
    [self.view addSubview:imageView];
    NSArray *btnImageName = [NSArray arrayWithObjects:@"tabbar_home",@"tabbar_message_center",@"tabbar_profile",@"tabbar_discover",@"tabbar_more",nil];
    NSArray *btnHImageName = [NSArray arrayWithObjects:@"tabbar_home_highlighted",@"tabbar_message_center_highlighted",@"tabbar_profile_highlighted",@"tabbar_discover_highlighted",@"tabbar_more_highlighted",nil];
    for (int i=0; i<5; i++)
    {
    
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0+64*i, 568-49, 64, 49);
        [btn setImage:[UIImage imageNamed:[btnImageName objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[btnHImageName objectAtIndex:i]] forState:UIControlStateHighlighted];
        btn.tag = i;
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49-18, 64, 49-30)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.text = [title objectAtIndex:i];
		[titleLabel setFont:[UIFont systemFontOfSize:9]];
		titleLabel.textAlignment = 1;
		titleLabel.textColor = [UIColor grayColor];
		[btn addSubview:titleLabel];
        
    }
    
}

- (void)initWithVCTitle
{
    HomeViewController *home = [[HomeViewController alloc]init];
    BaseNavigationViewController *homeNaVC = [[BaseNavigationViewController alloc]initWithRootViewController:home];
    MessageViewController *message = [[MessageViewController alloc]init];
    
    BaseNavigationViewController *messageNaVC = [[BaseNavigationViewController alloc]initWithRootViewController:message];
    PersonalViewController *personal = [[PersonalViewController alloc]init];
    
    BaseNavigationViewController *profileNaVC = [[BaseNavigationViewController alloc]initWithRootViewController:personal];
    SquareViewController *square = [[SquareViewController alloc]init];
    
    BaseNavigationViewController *discoverNaVC = [[BaseNavigationViewController alloc]initWithRootViewController:square];
    MoreViewController *more = [[MoreViewController alloc]init];
    
    BaseNavigationViewController *moreNaVC = [[BaseNavigationViewController alloc]initWithRootViewController:more];
    NSArray *viewCs = [NSArray arrayWithObjects:homeNaVC,messageNaVC,profileNaVC,discoverNaVC,moreNaVC,nil];
    self.viewControllers = viewCs;
    for (int i=0; i<5; i++)
    {
    UINavigationController *naVC = [viewCs objectAtIndex:i];
    if (i==0|i==1|i==4)
    {
        [naVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
        UILabel *naTitle = [[UILabel alloc]initWithFrame:CGRectMake(110, 8, 100, 36-8)];
        naTitle.backgroundColor = [UIColor clearColor];
        naTitle.textAlignment = 1;
        naTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        if (i==1)
        {
            naTitle.text = [title objectAtIndex:i];
            naTitle.textColor = [UIColor grayColor];
            [naVC.navigationBar addSubview:naTitle];
        }
        
    }
    else
    {
        [naVC.navigationBar setHidden:YES];
    }
    }
}

- (void)selectedTab:(UIButton *)button
{
    self.selectedIndex = button.tag;
    self.selectedViewController = [self.viewControllers objectAtIndex:button.tag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
