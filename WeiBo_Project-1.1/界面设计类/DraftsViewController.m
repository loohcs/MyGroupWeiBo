//
//  DraftsViewController.m
//  SinaTwitterDemo
//
//  Created by 1014 on 13-11-27.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "DraftsViewController.h"

@interface DraftsViewController ()

@end

@implementation DraftsViewController

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
    
  
    
}
-(void)setNaTitle
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 100, 36-8)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = 1;
    label.text = @"草稿箱";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textColor = [UIColor grayColor];
    [titleView addSubview:label];
    self.navigationItem.titleView =titleView;
}
-(void)returnV
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
