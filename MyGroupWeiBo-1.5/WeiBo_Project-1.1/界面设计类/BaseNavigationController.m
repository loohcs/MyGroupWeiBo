//
//  BaseNavigationController.m
//  SinaWeiBo
//
//  Created by xzx on 13-12-16.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //改变背景
	[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    //设置标题栏
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 28, 100, 36-8)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = 1;
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    _titleLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_titleLabel];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(10, 27, 30, 30);
    [self.backButton setImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(backToViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    [self.backButton setHidden:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange:) name:@"ThemeDidChangeNofication" object:nil];
}

-(void)backToViewController 
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)themeChange:(NSNotification *)notification
{
    NSString *type = [notification.userInfo objectForKey:@"type"];
    NSString *NavigationBg = [NSString stringWithFormat:@"%@navigationbar_background",type];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:NavigationBg] forBarMetrics:UIBarMetricsDefault];
    _titleLabel.textColor = [notification.userInfo objectForKey:@"titleColor"];
    [self.backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@navigationbar_back",type]] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@navigationbar_back_highlighted",type]] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
