//
//  WeiboContexViewController.m
//  WeiBo_Project
//
//  Created by 1007 on 13-12-10.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "WeiboContexViewController.h"

@interface WeiboContexViewController ()

@end

@implementation WeiboContexViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.


    [self creatBackNavigationBarWithTitle:@"微博正文" sign:2];
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _commentArray = [[NSMutableArray alloc] init];
    _flag = 0;
    
    //_scrollView.frame = CGRectMake(0, 44, 320, 568-20-44-30 + _height);
    _scrollView.backgroundColor = [UIColor redColor];
    _height = 0;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 568-44-20-30)];
    _scrollView.contentSize = CGSizeMake(320, 568+_height-30);
    [self.view addSubview:_scrollView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568+_height-30) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.pullDelegate = self;
    self.tableView.canPullDown = YES;
    self.tableView.canPullUp = YES;
    [_scrollView addSubview:self.tableView];
    
    
    //准备和添加屏幕页面下方的三个按钮。
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 518, 320, 30)];
    view.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *retBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retBtn.backgroundColor = [UIColor blackColor];
    retBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [retBtn setTitle:@"转发" forState:UIControlStateNormal];
    retBtn.frame = CGRectMake(20, 5, 70, 20);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"toolbar_icon_retweet_os7@2x" ofType:@"png"];
    UIImage *retBtnImage = [UIImage imageWithContentsOfFile:path];
    [retBtn setImage:retBtnImage forState:UIControlStateNormal];
    [retBtn addTarget:self action:@selector(retweetedWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:retBtn];
    
    UIButton *comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comBtn.backgroundColor = [UIColor blackColor];
    comBtn.frame = CGRectMake(120, 5 , 70, 20);
    comBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [comBtn setTitle:@"评论" forState:UIControlStateNormal];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"toolbar_icon_comment_os7@2x" ofType:@"png"];
    UIImage *comBtnImage = [UIImage imageWithContentsOfFile:path1];
    [comBtn setImage:comBtnImage forState:UIControlStateNormal];
    [comBtn addTarget:self action:@selector(commentWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:comBtn];
    
    UIButton *praBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    praBtn.backgroundColor = [UIColor blackColor];
    praBtn.frame = CGRectMake(220,  5, 70, 20);
    praBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [praBtn setTitle:@"赞" forState:UIControlStateNormal];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"toolbar_icon_unlike_os7@2x" ofType:@"png"];
    UIImage *praBtnImage = [UIImage imageWithContentsOfFile:path2];
    [praBtn setImage:praBtnImage forState:UIControlStateNormal];
    [view addSubview:praBtn];
    
    [self.view addSubview:view];
    
}

//通过调用该方法，获得我们需要评论的微博
- (void)getWeiboContex:(WeiBoContext *)oneWeiboContex
{
    _weiboContex = [[WeiBoContext alloc] init];
    _weiboContex = oneWeiboContex;
    
    
    float height = [WeiboCell getSize:_weiboContex];
    _height = height;
    
    [self getCommentForWeibo:_weiboContex.idstr];
}

#pragma mark -- 通过微博ID请求该微博相关的评论
- (void)getCommentForWeibo:(NSString *)weiboID
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    [WBHttpRequest requestWithAccessToken:[defaluts objectForKey:@"accessToken"] url:COMMENTS_SHOW httpMethod:@"GET" params:[NSDictionary dictionaryWithObjectsAndKeys:weiboID, @"id", nil] delegate:self];
}


//响应请求
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s", __func__);
    NSLog(@"收到微博数据请求！！！");
}

//完成请求
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSLog(@"%s", __func__);
    //NSLog(@"%@", result);
    
    NSError *error = nil;
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *array = [dic objectForKey:@"comments"];
    __weak WeiboContexViewController *weiboConVC = self;
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        Comment *oneComment = [[Comment alloc] initWithComment:dic];
        ImageDownload *commentUserHeadImage = [[ImageDownload alloc] initWithURlString:oneComment.userInfo.profile_image_url];
        [commentUserHeadImage setBlock:^(NSMutableData *datas, float progressNum) {
            if (weiboConVC.flag < _commentArray.count) {
                [weiboConVC getHeadImage:datas];
            }
        }];
        
        [_commentArray addObject:oneComment];
    }
    
    [_tableView reloadData];
}

- (void)getHeadImage:(NSMutableData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    Comment *oneComment = [_commentArray objectAtIndex:_flag];
    oneComment.headImage = image;
    [_commentArray replaceObjectAtIndex:_flag withObject:oneComment];
    _flag++;
    [_tableView reloadData];
}

//请求出错
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        float height = [WeiboCell getSize:_weiboContex];
        return height;
    }
    else
    {
        if (_commentArray.count > 0) {
            float height = [self getCommentHeight:[_commentArray objectAtIndex:indexPath.row]];
            return height;
        }
        else return 0;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else
    {
        return _commentArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 30;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else
    {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
        view.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *retBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        retBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        NSString *repotsCount = [NSString stringWithFormat:@"%d",_weiboContex.reposts_count];
        [retBtn setTitle:repotsCount forState:UIControlStateNormal];
        retBtn.frame = CGRectMake(10, 0, 60, 30);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"toolbar_icon_retweet_os7@2x" ofType:@"png"];
        UIImage *retBtnImage = [UIImage imageWithContentsOfFile:path];
        [retBtn setImage:retBtnImage forState:UIControlStateNormal];
        [view addSubview:retBtn];
        
        UIButton *comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        comBtn.frame = CGRectMake(80, 0 , 60, 30);
        comBtn.backgroundColor = [UIColor darkGrayColor];
        comBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        NSString *commentsCount = [NSString stringWithFormat:@"%d", _weiboContex.comments_count];
        [comBtn setTitle:commentsCount forState:UIControlStateNormal];
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"toolbar_icon_comment_os7@2x" ofType:@"png"];
        UIImage *comBtnImage = [UIImage imageWithContentsOfFile:path1];
        [comBtn setImage:comBtnImage forState:UIControlStateNormal];
        [view addSubview:comBtn];
        
        UIButton *praBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        praBtn.frame = CGRectMake(240,  0, 60, 30);
        praBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        NSString *attitudesCount = [NSString stringWithFormat:@"%d", _weiboContex.attitudes_count];
        [praBtn setTitle:attitudesCount forState:UIControlStateNormal];
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"toolbar_icon_unlike_os7@2x" ofType:@"png"];
        UIImage *praBtnImage = [UIImage imageWithContentsOfFile:path2];
        [praBtn setImage:praBtnImage forState:UIControlStateNormal];
        [praBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:praBtn];
        
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellTestIdentifier = @"CellTest";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    }
    
    if (indexPath.section == 0) {
        WeiboCell *cellTest = [tableView dequeueReusableCellWithIdentifier:CellTestIdentifier];
        
        if (cellTest == nil) {
            cellTest = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTestIdentifier];
        }
        [cellTest viewWeiboContex:_weiboContex];
        
        return cellTest;
    }
    else
    {
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        else
        {
            if (_commentArray.count > 0) {
                Comment *oneComment = [_commentArray objectAtIndex:indexPath.row];
                [cell viewCommentForWeibo:oneComment];
            }
        }
        
        return cell;
        
    }
    // Configure the cell...
    
    //    return cell;
}


#pragma mark -- 屏幕下方三个按钮触发的方法
- (void)retweetedWeibo:(UIButton *)sender
{
    WriteViewController *writeView = [[WriteViewController alloc]init];
    writeView.title = @"转发微博";
    [writeView addWeiboContex:_weiboContex andContexStyle:repotWeiboContex];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:writeView];
    [naVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)commentWeibo:(UIButton *)sender
{
    WriteViewController *writeView = [[WriteViewController alloc]init];
    [writeView addWeiboContex:_weiboContex andContexStyle:sendWeiboComment];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:writeView];
    [naVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    naVC.title = @"发表评论";
    [self presentViewController:naVC animated:YES completion:nil];
    
}

- (void)praiseWeibo:(UIButton *)sender
{
    
}


- (CGFloat)getCommentHeight:(Comment *)oneComment
{
    NSString *name = oneComment.userInfo.name;
    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(200, 15)];
    
    NSString *text = oneComment.text;
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(200, 1000)];
    
    NSString *created_at = oneComment.created_at;
    NSString *time = [DateHelper changDateWithString:created_at];
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(200, 20)];
    
    float height = nameSize.height + textSize.height + timeSize.height + 15;
    
    return height;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//下拉刷新跟加载的方法
#pragma mark -
#pragma mark UIScrollView PullDelegate
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state
{
    if (state == PullDownLoadState)
    {
        [self performSelector:@selector(PullDownLoadEnd) withObject:nil afterDelay:1];
    }
    else
    {
        [self performSelector:@selector(PullUpLoadEnd) withObject:nil afterDelay:1];
    }
}

//下拉
- (void)PullDownLoadEnd
{

    self.tableView.canPullUp = YES;
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    [WBHttpRequest requestWithAccessToken:[defaluts objectForKey:@"accessToken"] url:COMMENTS_SHOW httpMethod:@"GET" params:[NSDictionary dictionaryWithObjectsAndKeys:_weiboContex.idstr, @"id", nil] delegate:self];
    [self.tableView reloadData];
    [self.tableView stopLoadWithState:PullDownLoadState];
}
//加载
- (void)PullUpLoadEnd
{
    [self.tableView reloadData];
    [self.tableView stopLoadWithState:PullUpLoadState];
}


@end
