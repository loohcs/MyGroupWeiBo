//
//  MoreViewController.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "MoreViewController.h"
#import "DraftsViewController.h"
#import "ClosedidViewController.h"
#import "ThemeViewController.h"
#import "NewsViewController.h"
#import "SetstateViewController.h"
#import "PrivacyViewController.h"
#import "OpinionViewController.h"
#import "AboutWeiboViewController.h"
#define HIGHT 5

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self setTitle];

    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"data" ofType:@"plist"];
    dic=[[NSDictionary alloc]initWithContentsOfFile:path];
    keys=[[dic allKeys]sortedArrayUsingSelector:@selector(compare:)];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-44-44-20) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = HIGHT;
    _tableView.rowHeight = HIGHT*10;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    [self.view addSubview:_tableView];
}
-(void)setTitle
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 100, 36-8)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = 1;
    label.text = @"更多";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textColor = [UIColor grayColor];
    [titleView addSubview:label];
    self.navigationItem.titleView =titleView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section ==0|section==1|section==2)
//    {
//        return 1;
//        
//    }
//    else if(section == 3)
//    {
//        return _array.count;
//    }
//    else
//    {
//        return 2;
//    }
    return [[dic objectForKey:[keys objectAtIndex:section]]count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=[[dic objectForKey:[keys objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DraftsViewController *drafts = [DraftsViewController new];
    ClosedidViewController *closedid=[ClosedidViewController new];
    ThemeViewController *theme=[ThemeViewController new];
    NewsViewController *news=[NewsViewController new];
    SetstateViewController *setstate=[SetstateViewController new];
    PrivacyViewController *privacy=[PrivacyViewController new];
    OpinionViewController *opinion=[OpinionViewController new];
    AboutWeiboViewController *aboutWeibo=[AboutWeiboViewController new];
    
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:drafts animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:closedid animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:theme animated:YES];
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:news animated:YES];
                    break;
                case 1:
                    [self.navigationController pushViewController:setstate animated:YES];
                    break;
                case 2:
                    [self.navigationController pushViewController:privacy animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
        case 4:
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:opinion animated:YES];
                    break;
                case 1:
                    [self.navigationController pushViewController:aboutWeibo animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==4)
    {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(8, 5, 300, 50)];
        UIButton *btnOut = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOut.frame = footView.frame;
        [btnOut setBackgroundColor:[UIColor redColor]];
        [btnOut setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [footView addSubview:btnOut];
        return footView;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==4)
    {
        return 60;
    }
    else
    {
        return HIGHT;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
