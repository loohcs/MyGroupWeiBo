//
//  UIViewController+CreatCustomNaBar.m
//  WeiBo_Project
//
//  Created by xzx on 13-12-9.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "UIViewController+CreatCustomNaBar.h"

@implementation UIViewController (CreatCustomNaBar)

-(void)creatBackNavigationBarWithTitle:(NSString *)title sign:(int)sign
{
    UIView *navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navigationBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background"]]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110, 8, 100, 36-8)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = 1;
    label.text = title;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textColor = [UIColor grayColor];
    [navigationBar addSubview:label];
    //返回Button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
//    [back setTitle:@"返回" forState:UIControlStateNormal];
    
    [back setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToFormerViewController:) forControlEvents:UIControlEventTouchUpInside];
    back.tag = sign;
    back.frame = CGRectMake(5, 6, 40, 32);
    [navigationBar addSubview:back];
    [self.view addSubview:navigationBar];
}

-(void)backToFormerViewController:(UIButton *)sender
{
    if (sender.tag==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }

}


@end
