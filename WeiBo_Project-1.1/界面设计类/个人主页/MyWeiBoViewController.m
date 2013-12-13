//
//  MyWeiBoViewController.m
//  WeiBo_Project
//
//  Created by 1014 on 13-12-9.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "MyWeiBoViewController.h"

@interface MyWeiBoViewController ()

@end

@implementation MyWeiBoViewController

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
    [self creatBackNavigationBarWithTitle:@"微博数据" sign:1];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
