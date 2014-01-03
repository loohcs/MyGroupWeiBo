//
//  ClosedidViewController.m
//  SinaTwitterDemo
//
//  Created by 1014 on 13-11-27.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "ClosedidViewController.h"

@interface ClosedidViewController ()

@end

@implementation ClosedidViewController

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
    [self setNaTitle];
    self.navigationItem.title=@"";
    
    //返回Button
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(5, 5, 30, 40);
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnV) forControlEvents:UIControlEventTouchUpInside];
    [returnView addSubview:returnBtn];
    UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] initWithCustomView:returnView];
    self.navigationItem.leftBarButtonItem=returnItem;
    
    //设置
    UIView *setBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(30, 7, 30, 30);
    [setBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_account_edit_os7@2x"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [setBtnView addSubview:setBtn];
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithCustomView:setBtnView];
    self.navigationItem.rightBarButtonItem = setItem;
    
}

-(void)setNaTitle
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 100, 36-8)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = 1;
    label.text = @"账号管理";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textColor = [UIColor grayColor];
    [titleView addSubview:label];
    self.navigationItem.titleView =titleView;
}

-(void)returnV
{
    //推回上一个页面
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setButtonAction
{
    
}
-(IBAction)registered:(id)sender
{
    
}
-(IBAction)addtion:(id)sender
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
