//
//  HotWeiboViewController.m
//  SinaTwitterDemo
//
//  Created by 1014 on 13-11-26.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "HotWeiboViewController.h"

@interface HotWeiboViewController ()

@end

@implementation HotWeiboViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)reMen:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
