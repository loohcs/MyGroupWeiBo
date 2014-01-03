//
//  MessageViewController.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageWeiboViewController.h"
#import "SinaNewsViewController.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

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
    // Do any additional setup after loading the view from its nib.
    
    _commentsArray = [[NSMutableArray alloc] init];
    _weibosArray = [[NSMutableArray alloc] init];
    
    //初始化tableview
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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

#pragma mark -- TableViewDelegate || TableViewDataBase
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
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentify = @"cellIndentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    
    if (indexPath.row == 0)
    {
        //messagescenter_at_os@2x.png
        NSString *str = [[NSBundle mainBundle] pathForResource:@"messagescenter_at_os7@2x" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:str];
        cell.imageView.image = image;
        cell.textLabel.text = @"提到我的";
    }
    if (indexPath.row == 1) {
        //messagescenter_comments_os@2x.png
        NSString *str = [[NSBundle mainBundle] pathForResource:@"messagescenter_comments_os7@2x" ofType:@"png"];
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
    if (indexPath.row == 3) {
        
        NSString *str = [[NSBundle mainBundle] pathForResource:@"messagescenter_messagebox@2x" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:str];
        cell.imageView.image = image;
        cell.textLabel.text = @"未关注人的私信";
    }
    if (indexPath.row == 4) {
        
        NSString *str = [[NSBundle mainBundle] pathForResource:@"more_weibo@2x" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:str];
        cell.imageView.image = image;
        cell.textLabel.text = @"新浪新闻";
    }
    
    return cell;
}

WBHTTP_Request_Block *requestBlock;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak MessageViewController *messageVC = self;
    switch (indexPath.row) {
        case 0:
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"100",@"count", nil];
            requestBlock = [[WBHTTP_Request_Block alloc] initWithURlString:STATUSES_MENTIONS andArguments:dic];
            [requestBlock setBlock:^(NSMutableData *datas, float progressNum) {
                [messageVC statusesGet:datas];
            }];
            break;
        }
        case 1:
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"50",@"count", nil];
            requestBlock = [[WBHTTP_Request_Block alloc] initWithURlString:COMMENTS_TIMELINE andArguments:dic];
            [requestBlock setBlock:^(NSMutableData *datas, float progressNum) {
                [messageVC commentsGet:datas];
            }];
            break;
        }
        case 2:
        {
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"100",@"count", nil];
//            WBHTTP_Request_Block *commentGet = [[WBHTTP_Request_Block alloc] initWithURlString:COMMENTS_TIMELINE andArguments:dic];
//            [commentGet setBlock:^(NSMutableData *datas, float progressNum) {
//                
//            }];
            break;
        }
        case 3:
        {
            break;
        }
        case 4:
        {
            SinaNewsViewController *sinaNewsVC = [[SinaNewsViewController alloc] init];
            BaseNavigationController *naVC = [[BaseNavigationController alloc]initWithRootViewController:sinaNewsVC];
            naVC.backButton.hidden = NO;
            [self presentViewController:naVC animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

- (void)statusesGet:(NSMutableData *)data
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *array = [dic objectForKey:@"statuses"];
    for (NSDictionary *dic in array) {
        WeiBoContext *oneWeiboContex = [[WeiBoContext alloc] initWithWeibo:dic];
        [_weibosArray addObject:oneWeiboContex];
    }
    MessageWeiboViewController *weiboVC = [[MessageWeiboViewController alloc] init];
    BaseNavigationController *naVC = [[BaseNavigationController alloc]initWithRootViewController:weiboVC];
    naVC.titleLabel.text = @"所有微博";
    naVC.backButton.hidden = NO;
    [weiboVC getWeiboCOntexArr:_weibosArray];
    [self presentViewController:naVC animated:YES completion:nil];
    
}


- (void)commentsGet:(NSMutableData *)data
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *array = [dic objectForKey:@"comments"];
    for (NSDictionary *dic in array) {
        Comment *oneComment = [[Comment alloc] initWithComment:dic];
        [_commentsArray addObject:oneComment];
        
        WeiBoContext *oneWeiboContex = oneComment.commentWeiboContex;
        [_weibosArray addObject:oneWeiboContex];
    }
    MessageWeiboViewController *weiboVC = [[MessageWeiboViewController alloc] init];
    BaseNavigationController *naVC = [[BaseNavigationController alloc]initWithRootViewController:weiboVC];
    naVC.titleLabel.text = @"所有评论";
    naVC.backButton.hidden = NO;
    [weiboVC getWeiboCOntexArr:_weibosArray];
    [self presentViewController:naVC animated:YES completion:nil];
    
}

@end
