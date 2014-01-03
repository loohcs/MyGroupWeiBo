//
//  MessageWeiboViewController.m
//  WeiBo_Project
//
//  Created by 1007 on 13-12-17.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "MessageWeiboViewController.h"

@interface MessageWeiboViewController ()

@end

@implementation MessageWeiboViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getWeiboCOntexArr:(NSMutableArray *)arr
{
    _weiboContextsArr = arr;
    //获得图片存储地址
    NSString *path = [HomeViewController getImagePath:@"headImage"];
    NSString *path2 = [HomeViewController getImagePath:@"weiboImage"];
    
    __weak MessageWeiboViewController *messageWeiboVC = self;
    for (int i = 0 ; i < _weiboContextsArr.count; i ++) {
        WeiBoContext *oneWeiboContex = [_weiboContextsArr objectAtIndex:i];
        NSString *imageName = [oneWeiboContex.userInfo.userIDstr stringByAppendingFormat:@".jpg"];
        NSString *imagePath = [path stringByAppendingPathComponent:imageName];
        
        NSFileManager *file = [NSFileManager defaultManager];
        
        //首先判断头像图片是否存在，如果存在，那么我们就不需要下载，否则下载
        if (![file fileExistsAtPath:imagePath]) {
            ImageDownload *imageDown = [[ImageDownload alloc] initWithURlString:oneWeiboContex.userInfo.profile_image_url];
            [imageDown setBlock:^(NSMutableData *datas, float progressNum) {
                [messageWeiboVC getHeadImage:datas andIndex:i];
            }];
        }
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        oneWeiboContex.headImage = image;
        
        NSString *weiboImageName = [oneWeiboContex.idstr stringByAppendingFormat:@".jpg"];
        NSString *weiboImagePath = [path2 stringByAppendingPathComponent:weiboImageName];
        if (oneWeiboContex.thumbnail_pic.length != 0) {
            //首先判断图片是否存在，如果存在，那么我们就不需要下载，否则下载
            if (![file fileExistsAtPath:weiboImagePath]) {
                //将微博中存在图片的微博编号存入数组中，此时被默认为原创微博
                ImageDownload *weiboThumbnailImage = [[ImageDownload alloc] initWithURlString:oneWeiboContex.thumbnail_pic];
                [weiboThumbnailImage setBlock:^(NSMutableData *datas, float progressNum) {
                    if (i < _weiboContextsArr.count) {
                        [messageWeiboVC getThumbnailImage:datas andIndex:i];
                    }
                }];
                
            }
            else
            {
                UIImage *image = [UIImage imageWithContentsOfFile:weiboImagePath];
                oneWeiboContex.thumbnailImage = image;
                [_weiboContextsArr replaceObjectAtIndex:i withObject:oneWeiboContex];
            }
        }
        
        if (oneWeiboContex.retweeted_status != nil) {
            oneWeiboContex.retweetedWeibo = [[WeiBoContext alloc] initWithWeibo:(NSDictionary *)oneWeiboContex.retweeted_status];
            NSString *retWeiboImageName = [oneWeiboContex.retweetedWeibo.idstr stringByAppendingFormat:@".jpg"];
            NSString *retWeiboImagePath = [path2 stringByAppendingPathComponent:retWeiboImageName];
            
            //判断转发微博是否存在图片
            if (oneWeiboContex.retweetedWeibo.thumbnail_pic.length != 0) {
                
                //首先判断图片是否存在，如果存在，那么我们就不需要下载，否则下载
                if (![file fileExistsAtPath:retWeiboImagePath]) {
                    
                    //下载转发微博缩略图
                    ImageDownload *retWeiboThumbImage = [[ImageDownload alloc] initWithURlString:oneWeiboContex.retweetedWeibo.thumbnail_pic];
                    [retWeiboThumbImage setBlock:^(NSMutableData *datas, float progressNum) {
                        if (i < _weiboContextsArr.count) {
                            [messageWeiboVC getRetWeiboThumbImage:datas andIndex:i];
                        }
                    }];
                }
                else
                {
                    UIImage *image = [UIImage imageWithContentsOfFile:retWeiboImagePath];
                    oneWeiboContex.retweetedWeibo.thumbnailImage = image;
                }
                
            }
        }
        
        [_weiboContextsArr replaceObjectAtIndex:i withObject:oneWeiboContex];
    }
    
    //初始化tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 504) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    _tableView.canPullDown = YES;
    _tableView.canPullUp = YES;
    [self.view addSubview:_tableView];
}

- (void)getHeadImage:(NSMutableData *)data andIndex:(int)index
{
    NSFileManager *file = [NSFileManager defaultManager];
    WeiBoContext *weiboContexTemp = [_weiboContextsArr objectAtIndex:index];
    NSString *str = weiboContexTemp.userInfo.userIDstr;
    NSString *str2 = [str stringByAppendingFormat:@".jpg"];
    NSString *path = [HomeViewController getImagePath:@"headImage"];
    NSString *imagePath = [path stringByAppendingPathComponent:str2];
    if (![file fileExistsAtPath:imagePath]) {
        [file createFileAtPath:imagePath contents:data attributes:nil];
    }
    UIImage *image = [UIImage imageWithData:data];
    if (index < _weiboContextsArr.count) {
        WeiBoContext *oneWeiboContex = [_weiboContextsArr objectAtIndex:index];
        //NSLog(@"%@", oneWeiboContex.userInfo.profile_image_url);
        oneWeiboContex.headImage = [[UIImage alloc] init];
        oneWeiboContex.headImage = image;
        [_weiboContextsArr replaceObjectAtIndex:index withObject:oneWeiboContex];
        
        [_tableView reloadData];
    }
    
}

- (void)getThumbnailImage:(NSMutableData *)data andIndex:(int)index
{

    NSFileManager *file = [NSFileManager defaultManager];
    WeiBoContext *weiboContexTemp = [_weiboContextsArr objectAtIndex:index];
    NSString *str = weiboContexTemp.idstr;
    NSString *str2 = [str stringByAppendingFormat:@".jpg"];
    NSString *path = [HomeViewController getImagePath:@"weiboImage"];
    NSString *imagePath = [path stringByAppendingPathComponent:str2];
    if (![file fileExistsAtPath:imagePath]) {
        [file createFileAtPath:imagePath contents:data attributes:nil];
    }
    
    UIImage *image = [[UIImage alloc] initWithData:data];
    if (data.length > 0) {
        WeiBoContext *oneWeiboContex = [_weiboContextsArr objectAtIndex:index];
        oneWeiboContex.thumbnailImage = [[UIImage alloc] init];
        //NSLog(@"%@", oneWeiboContex.thumbnail_pic);
        oneWeiboContex.thumbnailImage = image;
        
        //更新微博内容中得图片属性
        [_weiboContextsArr replaceObjectAtIndex:index withObject:oneWeiboContex];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //        [_tableView reloadData];
        
    }
    
    
}

//通过块的调用，将数据传入方法中，实现转发微博缩略图片的获取与加载
- (void)getRetWeiboThumbImage:(NSMutableData *)data andIndex:(int)index
{
    NSFileManager *file = [NSFileManager defaultManager];
    WeiBoContext *weiboContexTemp = [_weiboContextsArr objectAtIndex:index];
    NSString *str = weiboContexTemp.retweetedWeibo.idstr;
    NSString *str2 = [str stringByAppendingFormat:@".jpg"];
    NSString *path = [HomeViewController getImagePath:@"weiboImage"];
    NSString *imagePath = [path stringByAppendingPathComponent:str2];
    if (![file fileExistsAtPath:imagePath]) {
        [file createFileAtPath:imagePath contents:data attributes:nil];
    }
    
    if (data.length > 0) {
        
        WeiBoContext *oneWeiboContex = [_weiboContextsArr objectAtIndex:index];
        oneWeiboContex.retweetedWeibo.thumbnailImage = [[UIImage alloc] init];
        UIImage *image = [[UIImage alloc] initWithData:data];
        oneWeiboContex.retweetedWeibo.thumbnailImage = image;
        
        //更新微博内容中得图片属性
        [_weiboContextsArr replaceObjectAtIndex:index withObject:oneWeiboContex];
        
        //        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index];
        //        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [_tableView reloadData];
    }
    
    //[_tableView reloadData];
}


#pragma mark -- TableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    NSLog(@"%s", __func__);
    return _weiboContextsArr.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%s", __func__);
    WeiBoContext *weibo = [_weiboContextsArr objectAtIndex:indexPath.section];
    float height = [WeiboCell getSize:weibo] - 45;
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    NSLog(@"%s", __func__);
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"%s", __func__);
    static NSString *identify = @"WeiboCell";
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    else
    {
        WeiBoContext *oneWeiboContex = [_weiboContextsArr objectAtIndex:indexPath.section];
        if (oneWeiboContex.retweeted_status == nil)
        {
            cell.retWeiboView.hidden = YES;
        }
    }
    [cell.retweetButton removeFromSuperview];
    [cell.commentButton removeFromSuperview];
    [cell.praiseButton removeFromSuperview];
    
    [cell viewWeiboContex:[_weiboContextsArr objectAtIndex:indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeiboContexViewController *weiboVC = [[WeiboContexViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:weiboVC];
    navc.navigationBarHidden = YES;
    [self presentViewController:navc animated:YES completion:nil];
    [weiboVC getWeiboContex:[_weiboContextsArr objectAtIndex:indexPath.section]];
}


@end

