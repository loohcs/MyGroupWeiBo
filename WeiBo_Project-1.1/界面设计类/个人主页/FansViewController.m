//
//  FansViewController.m
//  WeiBo_Project
//
//  Created by 1014 on 13-12-4.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "FansViewController.h"
#import "UIViewController+CreatCustomNaBar.h"
@interface FansViewController ()

@end

@implementation FansViewController

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
    [self creatBackNavigationBarWithTitle:@"粉丝" sign:1];

      
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
