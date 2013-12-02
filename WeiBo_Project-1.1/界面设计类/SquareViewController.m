//
//  SquareViewController.m
//  WeiBo_Project
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "SquareViewController.h"
#import "RelaxationViewController.h"
#import "AmbitusViewController.h"
#import "ApplyViewController.h"
#import "HotWeiboViewController.h"
#import "SeekFriendViewController.h"
#import "ScanLifeViewController.h"
#import "GameViewController.h"
@interface SquareViewController ()

@end

@implementation SquareViewController

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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"searchbar_background"]];
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.view addGestureRecognizer:tap];
}

- (void)hiddenKeyBoard
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UISearchBar class]])
        {
            [view resignFirstResponder];
        }
    }
}
-(IBAction)scanlife:(id)sender
{
    ScanLifeViewController *scanlife = [ScanLifeViewController new];
    [self.navigationController pushViewController:scanlife animated:YES];
}
-(IBAction)seekFriend:(id)sender
{
    SeekFriendViewController *seek = [SeekFriendViewController new];
    [self.navigationController pushViewController:seek animated:YES];
}
-(IBAction)relaxation:(id)sender
{
    RelaxationViewController *relaxation=[RelaxationViewController new];
    [self.navigationController pushViewController:relaxation animated:YES];
}
-(IBAction)ambitus:(id)sender
{
    AmbitusViewController *ambitus =[AmbitusViewController new];
    [self.navigationController pushViewController:ambitus animated:YES];
}
-(IBAction)game:(id)sender
{
    GameViewController *game=[GameViewController new];
    
    [self.navigationController pushViewController:game animated:YES];
}
-(IBAction)apply:(id)sender
{
    ApplyViewController *apply=[ApplyViewController new];
    [self.navigationController pushViewController:apply animated:YES];
}
-(IBAction)hotWeibo:(id)sender
{
    HotWeiboViewController *hotWeibo=[HotWeiboViewController new];
    [self.navigationController pushViewController:hotWeibo animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
