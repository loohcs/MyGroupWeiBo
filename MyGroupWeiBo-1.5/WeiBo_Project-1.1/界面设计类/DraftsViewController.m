//
//  DraftsViewController.m
//  SinaTwitterDemo
//
//  Created by 1014 on 13-11-27.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "DraftsViewController.h"

@interface DraftsViewController ()

@end

@implementation DraftsViewController

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
    
    [self setNaTitle];
    self.navigationItem.title=@"";
    
    //返回Button
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(5, 5, 30, 40);
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnV) forControlEvents:UIControlEventTouchUpInside];
    [returnView addSubview:returnBtn];
    UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] initWithCustomView:returnView];
    self.navigationItem.leftBarButtonItem=returnItem;
    
    NSString *path = [NSString stringWithString:[DraftsViewController getPath]];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    _dataInDrafts = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"weibo"]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 504) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.pullDelegate = self;
    self.tableView.canPullDown = YES;
    self.tableView.canPullUp = YES;
    [self.view addSubview:_tableView];
    
}

+ (NSString *)getPath
{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [str stringByAppendingPathComponent:@"dataInDraft.plist"];
    
    return path;
}



-(void)setNaTitle
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 100, 36-8)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = 1;
    label.text = @"草稿箱";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textColor = [UIColor grayColor];
    [titleView addSubview:label];
    self.navigationItem.titleView =titleView;
}

-(void)returnV
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -- UITableViewDelegete || UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataInDrafts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"%s", __func__);
    static NSString *identify = @"WeiboCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    NSDictionary *dic = [_dataInDrafts objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [dic objectForKey:@"text"];
    int type = [[dic objectForKey:@"type"] intValue];
    switch (type) {
        case 0:
            cell.textLabel.text = @"微博";
            break;
        case 1:
        {
            NSString *writer = [dic objectForKey:@"writer"];
            cell.textLabel.text = [NSString stringWithFormat:@"转发微博@%@", writer];
            break;
        }
        case 2:
        {
            NSString *writer = [dic objectForKey:@"writer"];
            cell.textLabel.text = [NSString stringWithFormat:@"评论@%@", writer];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WriteViewController *writeView = [[WriteViewController alloc]init];
    NSDictionary *dic = [_dataInDrafts objectAtIndex:indexPath.row];
    NSString *weiboID = [dic objectForKey:@"weiboID"];
    NSString *userName = [dic objectForKey:@"writer"];
    
    WeiBoContext *oneWeiboContex = [WeiboDataBase findOneWeibo:weiboID];
    oneWeiboContex.userInfo.name = userName;
    
    int type = [[dic objectForKey:@"type"] intValue];
    switch (type) {
        case 0:
            writeView.title = @"发微博";
            
            [writeView addWeiboContex:oneWeiboContex andContexStyle:repotWeiboContex];
            
            break;
        case 1:
        {
            writeView.title = @"转发微博";
            [writeView addWeiboContex:oneWeiboContex andContexStyle:repotWeiboContex];
            
            break;
        }
        case 2:
        {
            [writeView addWeiboContex:oneWeiboContex andContexStyle:sendWeiboComment];
            break;
        }
        default:
            break;
    }
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:writeView];
    [naVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
