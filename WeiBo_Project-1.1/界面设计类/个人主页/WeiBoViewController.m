//
//  WeiBoViewController.m
//  WeiBo_Project
//
//  Created by 1014 on 13-12-4.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "WeiBoViewController.h"

@interface WeiBoViewController ()

@end

@implementation WeiBoViewController

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
    // Do any additional setup after loading the view from its nib.
    [self creatBackNavigationBarWithTitle:@"全部微博" sign:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
