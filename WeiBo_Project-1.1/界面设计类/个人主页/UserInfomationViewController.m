//
//  UserInfomationViewController.m
//  WeiBo_Project
//
//  Created by xzx on 13-12-12.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "UserInfomationViewController.h"
#import "DateHelper.h"
@interface UserInfomationViewController ()

@end

@implementation UserInfomationViewController

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
    [self creatBackNavigationBarWithTitle:@"用户资料" sign:1];
    
	_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 548-44) style:UITableViewStyleGrouped];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark -- UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        return 4;
    }
    else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1)
    {
        return 10;
    }
    else
    {
        return 40;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return @"基本信息";
    }
    if (section==2)
    {
        return @"其他";
    }
    else
    {
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0&&indexPath.row == 0)
    {
        cell.textLabel.text =[NSString stringWithFormat:@"ID             %@",self.userInfo.userID];
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text =[NSString stringWithFormat:@"昵称          %@",self.userInfo.name];
        }
        if (indexPath.row==1)
        {
            if ([self.userInfo.gender isEqualToString:@"m"])
            {
                cell.textLabel.text =[NSString stringWithFormat:@"性别          %@",@"男"];
            }
            if ([self.userInfo.gender isEqualToString:@"f"])
            {
                cell.textLabel.text =[NSString stringWithFormat:@"性别          %@",@"女"];
            }
        }
        if (indexPath.row == 2)
        {
            cell.textLabel.text =[NSString stringWithFormat:@"所在地       %@",self.userInfo.location];
        }
        if (indexPath.row==3)
        {
            if ([self.userInfo.remark isEqualToString:@""])
            {
                cell.textLabel.text =[NSString stringWithFormat:@"简介          %@",@"暂无介绍"];
            }
            else
            {
                cell.textLabel.text =[NSString stringWithFormat:@"简介          %@",self.userInfo.remark];
            }
        }
    }
        if(indexPath.section==2)
    {
        NSMutableString *dateStr = [[NSMutableString alloc]initWithString:self.userInfo.created_at];
        [dateStr deleteCharactersInRange:NSMakeRange(0, 4)];
        [dateStr deleteCharactersInRange:NSMakeRange(7, 15)];
        NSDateFormatter *formtter = [[NSDateFormatter alloc]init];
        [formtter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
        [formtter setDateFormat:@"MM dd yyyy"];
        NSDate *date = [formtter dateFromString:dateStr];
        [formtter setDateFormat:@"yyyy-MM-dd"];
        NSString *str=[formtter stringFromDate:date];
        
        cell.textLabel.text =[NSString stringWithFormat:@"注册时间          %@",str];
//        NSDate *data = [dataFormatter dateFromString:self.userInfo.created_at];
//        NSLog(@"%@",data);
        
    }

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
