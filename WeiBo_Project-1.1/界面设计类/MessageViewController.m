//
//  MessageViewController.m
//  WeiBo_Project
//
//  Created by 1007 on 13-12-17.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

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
    
    //初始化tableview
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    _tableView.canPullDown = YES;
    _tableView.canPullUp = YES;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentify = @"cellIndentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    else{
        if (indexPath.row == 0)
        {
            //messagescenter_at_os@2x.png
            NSString *str = [[NSBundle mainBundle] pathForResource:@"messagescenter_at_os@2x" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:str];
            cell.imageView.image = image;
            cell.textLabel.text = @"提到我的";
        }
        if (indexPath.row == 1) {
            //messagescenter_comments_os@2x.png
            NSString *str = [[NSBundle mainBundle] pathForResource:@"messagescenter_comments_os" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:str];
            cell.imageView.image = image;
            cell.textLabel.text = @"评论";
        }
        if (indexPath.row == 2) {
            //messagescenter_good.png
            NSString *str = [[NSBundle mainBundle] pathForResource:@"messagescenter_good" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:str];
            cell.imageView.image = image;
            cell.textLabel.text = @"赞";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
