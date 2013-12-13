//
//  MoresViewController.m
//  WeiBo_Project
//
//  Created by 1014 on 13-12-4.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "MoresViewController.h"

@interface MoresViewController ()

@end

@implementation MoresViewController

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
    self.view.backgroundColor = [UIColor cyanColor];
    [self creatBackNavigationBarWithTitle:@"更多" sign:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
