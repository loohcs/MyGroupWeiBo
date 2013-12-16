//
//  HomeViewController.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "HomeViewController.h"
#import "WriteViewController.h"
#import "WeiboCell.h"
#import "WeiboContexViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

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
    
    weiboContextsArr = [[NSMutableArray alloc] init];
    _receivedData = [[NSMutableData alloc] init];
    _weiboCount = 0;
    
    middleFlag = 0;
    rightFlag = 0;
    flag = 0;
    middleView = [[UITableView alloc] initWithFrame:CGRectMake(110, 0, 100, 120) style:UITableViewStyleGrouped];
    rightView = [[UITableView alloc] initWithFrame:CGRectMake(230, 0, 80, 100) style:UITableViewStyleGrouped];
    //rightView.backgroundColor = [UIColor cyanColor];
    
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    //创建左右button和中间标题栏
    [self initWithButtonAndTitle];
    self.navigationItem.title = @"";
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.sina.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:
        {
            NSLog(@"没有网络连接!");
            weiboContextsArr = [WeiboDataBase findAll];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"使用3G网络!");
            [self getTimelineWeibo:@"statuses_friends_timeline"];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"使用WiFi网络!");
            [self getTimelineWeibo:@"statuses_friends_timeline"];
            break;
        }
        default:
            break;
    }
    
    //初始化tableview
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    _tableView.canPullDown = YES;
    _tableView.canPullUp = YES;
    [self.view addSubview:_tableView];
    
}

- (void)getTimelineWeibo:(NSString *)type
{
    NSLog(@"%s", __func__);
    if ([type isEqualToString:@"statuses_friends_timeline"])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"since_id", @"0", @"max_id", @"100",@"count", @"1", @"page", @"0", @"base_app", @"0",@"feature", @"0", @"trim_user", nil];
        statuses = [[WBHTTP_Request_Block alloc] initWithURlString:STATUSES_FRIENDS_TIMELINES andArguments:dic];
        NSLog(@"%@", STATUSES_FRIENDS_TIMELINES);
    }
    if ([type isEqualToString:@"statuses_public_timeline"]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"100",@"count", nil];
        statuses = [[WBHTTP_Request_Block alloc] initWithURlString:STATUSES_PUBLIC_TIMELINE andArguments:dic];
        NSLog(@"%@", STATUSES_PUBLIC_TIMELINE);
    }
    if ([type isEqualToString:@"statuses_user_timeline"]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"100",@"count", nil];
        statuses = [[WBHTTP_Request_Block alloc] initWithURlString:STATUSES_USER_TIMELINE andArguments:dic];
        NSLog(@"%@", STATUSES_USER_TIMELINE);
    }
    if ([type isEqualToString:@"statuses_home_timeline"]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"100",@"count", nil];
        statuses = [[WBHTTP_Request_Block alloc] initWithURlString:STATUSES_HOME_TIMELINE andArguments:dic];
        NSLog(@"%@", STATUSES_HOME_TIMELINE);
    }
    
    __weak HomeViewController *homeVC = self;
    //[WeiboDataBase createWeiboTable];
    [statuses setBlock:^(NSMutableData *datas, float progressNum)
     {
         [homeVC getWeiboContex:datas];
     }];

    //[WeiboDataBase findAll];
}

- (void)getWeiboContex:(NSData *)data
{
    NSLog(@"%s", __func__);
    
    if (_receivedData.length == 0) {
        _receivedData = [NSMutableData dataWithData:data];
    }
    
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *weiboArr = [NSArray arrayWithArray:[dic objectForKey:@"statuses"]];
    weiboContextsArr = [[NSMutableArray alloc] init];
    
    [WeiboDataBase createWeiboTable];
    if (weiboArr.count > _weiboCount+20) {
        for (int i = 0; i <_weiboCount+20; i++) {
            //获得微博正文
            NSDictionary *weiboDic = [NSDictionary dictionaryWithDictionary:[weiboArr objectAtIndex:i]];
            WeiBoContext *oneWeiboContex = [[WeiBoContext alloc] initWithWeibo:weiboDic];
            [weiboContextsArr addObject:oneWeiboContex];
            
            //判断是否是转发微博，如果是，则将字符串的转发微博初始化为WeiboContex类型
            if (oneWeiboContex.retweeted_status != nil) {
                oneWeiboContex.retweetedWeibo = [[WeiBoContext alloc] initWithWeibo:(NSDictionary *)oneWeiboContex.retweeted_status];
                [weiboContextsArr replaceObjectAtIndex:i withObject:oneWeiboContex];
                
                [WeiboDataBase addWithWeibo:oneWeiboContex.retweetedWeibo];
            }
            
            [WeiboDataBase addWithWeibo:oneWeiboContex];
        }
    }
    else
    {
        for (int i = 0; i <weiboArr.count; i++) {
            //获得微博正文
            NSDictionary *weiboDic = [NSDictionary dictionaryWithDictionary:[weiboArr objectAtIndex:i]];
            WeiBoContext *oneWeiboContex = [[WeiBoContext alloc] initWithWeibo:weiboDic];
            [weiboContextsArr addObject:oneWeiboContex];
            
            //判断是否是转发微博，如果是，则将字符串的转发微博初始化为WeiboContex类型
            if (oneWeiboContex.retweeted_status != nil) {
                oneWeiboContex.retweetedWeibo = [[WeiBoContext alloc] initWithWeibo:(NSDictionary *)oneWeiboContex.retweeted_status];
                [weiboContextsArr replaceObjectAtIndex:i withObject:oneWeiboContex];
                
                [WeiboDataBase addWithWeibo:oneWeiboContex.retweetedWeibo];
            }
            
            [WeiboDataBase addWithWeibo:oneWeiboContex];
        }
    }
    
    
    //下载微博所需要的图片，包括用户头像，微博缩略图，转发微博的缩略图
    [self prepareForWeiboImage:weiboContextsArr];
    
    //TODO: 获取pic_urls，并下载图片数组
    //[self getWeiboImages:weiboContextsArr];
}

#pragma mark -- 获取微博的各种图片
- (void)prepareForWeiboImage:(NSMutableArray *)weiboArray
{
    
#warning mark -- 因为下载图片是通过块的调用来实现的，具有一定的延时性。而且下载的图片都是按照顺序一张张下载的，所以我们在下载图片的同时，我们需要确定下载的本张图片到底是属于那一份微博。（目前，我们在微博中使用的都只是缩略图，并未使用图片数组，即pic_urls下载得到的weiboPics。使用数组时，在将图片贴到自定义的weiboCell上会出现一点点小问题，就是多张图片贴的时候会有时混乱。暂定解决思路：在init方法中就定义好九个imageView，然后通过switch语句，依次将图片贴上）
    
    __weak HomeViewController *homeVC = self;
    
    
    //为了确保将每一张图片准确的贴到转发微博上所准备的数据
    
    for (int i = 0; i <weiboArray.count; i++) {
        //获得微博正文
        WeiBoContext *oneWeiboContex = [weiboArray objectAtIndex:i];
        
        //判断是否是转发微博，如果是，则将字符串的转发微博初始化为WeiboContex类型
        if (oneWeiboContex.retweeted_status != nil) {
            
            //判断转发微博是否存在图片
            if (oneWeiboContex.retweetedWeibo.thumbnail_pic.length != 0) {
                
                //下载转发微博缩略图
                ImageDownload *retWeiboThumbImage = [[ImageDownload alloc] initWithURlString:oneWeiboContex.retweetedWeibo.thumbnail_pic];
                [retWeiboThumbImage setBlock:^(NSMutableData *datas, float progressNum) {
                    if (i < weiboContextsArr.count) {
                        [homeVC getRetWeiboThumbImage:datas andIndex:i];
                    }
                }];
            }
        }
        
        //下载用户头像
        ImageDownload *headImageDown = [[ImageDownload alloc] initWithURlString:oneWeiboContex.userInfo.profile_image_url];
        [headImageDown setBlock:^(NSMutableData *datas, float progressNum) {
            if (i < weiboContextsArr.count) {
                //因为所有的微博必定有一位用户，同样也肯定有用户头像，所以只需要++ 就可以了
                [homeVC getHeadImage:datas andIndex:i];
            }
        }];
        
        if (oneWeiboContex.thumbnail_pic.length != 0) {
            //将微博中存在图片的微博编号存入数组中，此时被默认为原创微博
            ImageDownload *weiboThumbnailImage = [[ImageDownload alloc] initWithURlString:oneWeiboContex.thumbnail_pic];
            [weiboThumbnailImage setBlock:^(NSMutableData *datas, float progressNum) {
                if (i < weiboContextsArr.count) {
                    [homeVC getThumbnailImage:datas andIndex:i];
                }
            }];
        }
        
    }
    
}

//准备路径，将所有下载的图片存入本地沙盒中
//获取头像图片存放地址
+ (NSString *)getImagePath:(NSString *)type
{
    NSFileManager *file = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageDirectory = [path stringByAppendingPathComponent:@"images"];
    if ([type isEqualToString:@"headImage"]) {
        NSString *headImage = [imageDirectory stringByAppendingPathComponent:@"headImage"];
        if (![file fileExistsAtPath:headImage]) {
            [file createDirectoryAtPath:headImage withIntermediateDirectories:YES attributes:nil error:nil];
            return headImage;
        }
        else return headImage;
    }
    else
    {
        NSString *weiboImage = [imageDirectory stringByAppendingPathComponent:@"weiboImage"];
        if (![file fileExistsAtPath:weiboImage]) {
            [file createDirectoryAtPath:weiboImage withIntermediateDirectories:YES attributes:nil error:nil];
            return weiboImage;
        }
        else return weiboImage;
    }
    

}



//通过块的调用，将数据传入方法中，实现头像图片的获取
- (void)getHeadImage:(NSMutableData *)data andIndex:(int)index
{

    NSFileManager *file = [NSFileManager defaultManager];
    WeiBoContext *weiboContexTemp = [weiboContextsArr objectAtIndex:index];
    NSString *str = weiboContexTemp.userInfo.userIDstr;
    NSString *str2 = [str stringByAppendingFormat:@".jpg"];
    NSString *path = [HomeViewController getImagePath:@"headImage"];
    NSString *imagePath = [path stringByAppendingPathComponent:str2];
    if (![file fileExistsAtPath:imagePath]) {
        [file createFileAtPath:imagePath contents:data attributes:nil];
    }
    UIImage *image = [UIImage imageWithData:data];
    if (index < weiboContextsArr.count) {
        WeiBoContext *oneWeiboContex = [weiboContextsArr objectAtIndex:index];
        //NSLog(@"%@", oneWeiboContex.userInfo.profile_image_url);
        oneWeiboContex.headImage = [[UIImage alloc] init];
        oneWeiboContex.headImage = image;
        [weiboContextsArr replaceObjectAtIndex:index withObject:oneWeiboContex];
        
        [_tableView reloadData];
    }
    
}

//通过块的调用，将数据传入方法中，实现微博缩略图片的获取与加载
- (void)getThumbnailImage:(NSMutableData *)data andIndex:(int)index
{
    
//已经解决
//#warning mark -- 每次执行本方法的时候，从块中得到的数据是块在上一次下载之后遗留下得数据，因此在界面中就显示出，所有图片都是上一趟运行时应该具有的图片，而本次图片的显示则会出现在下一次的运行之中。

    
    NSFileManager *file = [NSFileManager defaultManager];
    WeiBoContext *weiboContexTemp = [weiboContextsArr objectAtIndex:index];
    NSString *str = weiboContexTemp.idstr;
    NSString *str2 = [str stringByAppendingFormat:@".jpg"];
    NSString *path = [HomeViewController getImagePath:@"weiboImage"];
    NSString *imagePath = [path stringByAppendingPathComponent:str2];
    if (![file fileExistsAtPath:imagePath]) {
        [file createFileAtPath:imagePath contents:data attributes:nil];
    }
    
    UIImage *image = [[UIImage alloc] initWithData:data];
    if (data.length > 0) {
        WeiBoContext *oneWeiboContex = [weiboContextsArr objectAtIndex:index];
        oneWeiboContex.thumbnailImage = [[UIImage alloc] init];
        //NSLog(@"%@", oneWeiboContex.thumbnail_pic);
        oneWeiboContex.thumbnailImage = image;
        
        //更新微博内容中得图片属性
        [weiboContextsArr replaceObjectAtIndex:index withObject:oneWeiboContex];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
//        [_tableView reloadData];
        
    }
    
    
}

//通过块的调用，将数据传入方法中，实现转发微博缩略图片的获取与加载
- (void)getRetWeiboThumbImage:(NSMutableData *)data andIndex:(int)index
{
    NSFileManager *file = [NSFileManager defaultManager];
    WeiBoContext *weiboContexTemp = [weiboContextsArr objectAtIndex:index];
    NSString *str = weiboContexTemp.retweetedWeibo.idstr;
    NSString *str2 = [str stringByAppendingFormat:@".jpg"];
    NSString *path = [HomeViewController getImagePath:@"weiboImage"];
    NSString *imagePath = [path stringByAppendingPathComponent:str2];
    if (![file fileExistsAtPath:imagePath]) {
        [file createFileAtPath:imagePath contents:data attributes:nil];
    }
    
    if (data.length > 0) {
        
        WeiBoContext *oneWeiboContex = [weiboContextsArr objectAtIndex:index];
        oneWeiboContex.retweetedWeibo.thumbnailImage = [[UIImage alloc] init];
        UIImage *image = [[UIImage alloc] initWithData:data];
        oneWeiboContex.retweetedWeibo.thumbnailImage = image;
        
        //更新微博内容中得图片属性
        [weiboContextsArr replaceObjectAtIndex:index withObject:oneWeiboContex];
        
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index];
//        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [_tableView reloadData];
    }
    
    //[_tableView reloadData];
}

/*
 - (void)getWeiboImages:(NSMutableArray *)weiboArrTemp
 {
 NSLog(@"%s", __func__);
 __weak HomeViewController *homeVC = self;
 _imagesArray = [[NSMutableArray alloc] init];
 _flagArray = [[NSMutableArray alloc] init];
 _weiboFlag = 0;
 _lastFlag = -1;
 
 _retweetFlagArray = [[NSMutableArray alloc] init];
 _retweetLastFlag = -1;
 _retweetWeiboFlag = 0;
 
 for (int i=0; i < weiboArrTemp.count; i++) {
 
 //将存放微博内容的成员从数组中取出
 WeiBoContext *oneWeiboContex = [weiboArrTemp objectAtIndex:i];
 
 //从微博正文中获得微博正文图片的地址数组
 NSArray *picUrlsArr = [[NSArray alloc] initWithArray:(NSArray *)oneWeiboContex.pic_urls];
 
 //如果地址数组的成员存在，则下载图片
 if (picUrlsArr.count != 0) {
 _imagesArray = [[NSMutableArray alloc] init];
 for (NSDictionary *dic in picUrlsArr) {
 NSLog(@"000000000000000000--------%d", i);
 
 //将图片所在的微博编号存放进数组，便于在有多张图时准确存进微博正文
 [_flagArray addObject:[NSNumber numberWithInt:i]];
 
 //获得url
 NSString *url = [dic objectForKey:@"thumbnail_pic"];
 NSLog(@"%@", url);
 ImageDownload *weiboPicDown = [[ImageDownload alloc] initWithURlString:url];
 //通过块的调用实现图片的下载
 [weiboPicDown setBlock:^(NSMutableData *datas, float progressNum) {
 NSLog(@"11111111111111111");
 NSLog(@"%d", homeVC.weiboFlag);
 int temp = 0;
 if (homeVC.weiboFlag < homeVC.flagArray.count) {
 //因为块的下载有一定的延时性，必须要等图片下载完成了才调用块内代码
 //从存放微博编号的数组中取出编号
 temp = [[homeVC.flagArray objectAtIndex:homeVC.weiboFlag] intValue];
 //将下载好得数据，以及微博编号传到函数中去，对微博正文内容进行更新
 [homeVC getWeiboImageArr:datas andIndex:temp];
 homeVC.weiboFlag++;
 }
 }];
 }
 }
 else
 {
 NSLog(@"2222222222222222222222---------%d", i);
 //当pic_urls为空得时候，有两种情况，1：该微博没有图片，2：该微博为转发微博，则需要重复上一个过程，即转发微博图片的下载。
 if (oneWeiboContex.retweeted_status == nil) {
 NSLog(@"该微博为原创微博，没有图片！");
 oneWeiboContex.isRetweeted = NO;
 }
 else
 {
 NSLog(@"该微博为转发微博，在微博图片位置将添加转发的微博内容");
 oneWeiboContex.isRetweeted = YES;
 oneWeiboContex.retweetedWeibo = [[WeiBoContext alloc] initWithWeibo:(NSDictionary *)oneWeiboContex.retweeted_status];
 oneWeiboContex.retweetedWeibo.isRetweeted = NO;
 [weiboArrTemp replaceObjectAtIndex:i withObject:oneWeiboContex];
 weiboContextsArr = weiboArrTemp;
 
 //                if (i == weiboArrTemp.count) {
 //                    [self getWeiboImages:weiboArrTemp];
 //                }
 
 }
 }
 
 }
 
 }
 
 
 - (void)getWeiboImageArr:(NSMutableData *)data andIndex:(int)i
 {
 NSLog(@"%s", __func__);
 //NSLog(@"%@", data);
 #warning data对象存在，所以我们要判断的是data.length，而不是data是否存在或是否为空
 if (data.length > 0) {
 WeiBoContext *oneWeiboContex = [weiboContextsArr objectAtIndex:i];
 UIImage *image = [[UIImage alloc] initWithData:data];
 
 //判断现在下载好得图片跟上一张图片是否是同一份微博的
 if (_lastFlag != i) {
 //若不是，则对存放图片的数组进行初始化
 _imagesArray  = [[NSMutableArray alloc] init];
 
 //            //此时前一份微博的图片都已经下载完成，将isHasPics属性改为YES
 //            WeiBoContext *lastWeibo = [weiboContextsArr objectAtIndex:_lastFlag];
 //            lastWeibo.isHasPics = YES;
 //            [weiboContextsArr replaceObjectAtIndex:_lastFlag withObject:lastWeibo];
 }
 //若是，则将本张图片也添加到该微博中
 [_imagesArray addObject:image];
 oneWeiboContex.weiboPics = _imagesArray;
 
 //更新微博内容中得图片属性
 [weiboContextsArr replaceObjectAtIndex:i withObject:oneWeiboContex];
 _lastFlag = i;
 }
 if (self.weiboFlag == _flagArray.count-1) {
 NSLog(@"对tablev进行数据重载");
 }
 
 [_tableView reloadData];
 }
 */


#pragma mark -- TableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    NSLog(@"%s", __func__);
    return weiboContextsArr.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%s", __func__);
    WeiBoContext *weibo = [weiboContextsArr objectAtIndex:indexPath.section];
    float height = [WeiboCell getSize:weibo];
    
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
        WeiBoContext *oneWeiboContex = [weiboContextsArr objectAtIndex:indexPath.section];
        if (oneWeiboContex.retweeted_status == nil)
        {
            cell.retWeiboView.hidden = YES;
        }
    }
    [cell viewWeiboContex:[weiboContextsArr objectAtIndex:indexPath.section]];
    
    cell.retweetButton.tag = 100 + indexPath.section;
    [cell.retweetButton addTarget:self action:@selector(retweetedWeibo:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.commentButton.tag = 200 + indexPath.section;
    [cell.commentButton addTarget:self action:@selector(commentWeibo:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.praiseButton.tag = 300 + indexPath.section;
    [cell.praiseButton addTarget:self action:@selector(praiseWeibo:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeiboContexViewController *weiboVC = [[WeiboContexViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:weiboVC];
    navc.navigationBarHidden = YES;
    [self presentViewController:navc animated:YES completion:nil];
    [weiboVC getWeiboContex:[weiboContextsArr objectAtIndex:indexPath.section]];
}

#pragma mark -- 每个cell里面三个按钮触发的方法
- (void)retweetedWeibo:(UIButton *)sender
{
    WriteViewController *writeView = [[WriteViewController alloc]init];
    [writeView addWeiboContex:[weiboContextsArr objectAtIndex:sender.tag - 100] andContexStyle:repotWeiboContex];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:writeView];
    [naVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    naVC.title = @"转发微博";
    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)commentWeibo:(UIButton *)sender
{
    WeiboContexViewController *weiboConVC = [[WeiboContexViewController alloc] init];
    //通过tag值获取微博正文
    [weiboConVC getWeiboContex:[weiboContextsArr objectAtIndex:sender.tag - 200]];
    
    CGFloat height = [WeiboCell getSize:[weiboContextsArr objectAtIndex:sender.tag - 200]];

    weiboConVC.scrollView.frame = CGRectMake(0, 0, 320, height + 568-20-44-30);
    weiboConVC.scrollView.contentOffset = CGPointMake(0, height + 20);
    weiboConVC.scrollView.scrollEnabled = NO;
    weiboConVC.scrollView.bounces = NO;
    
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:weiboConVC];
    [naVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    naVC.navigationBarHidden = YES;
    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)praiseWeibo:(UIButton *)sender
{
    
}


//下拉刷新跟加载的方法
#pragma mark -
#pragma mark UIScrollView PullDelegate
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state
{
    if (state == PullDownLoadState)
    {
        [self performSelector:@selector(PullDownLoadEnd) withObject:nil afterDelay:3];
    }
    else
    {
        [self performSelector:@selector(PullUpLoadEnd) withObject:nil afterDelay:3];
    }
}
//下拉
- (void)PullDownLoadEnd
{
    _receivedData = [[NSMutableData alloc] init];
    
    [self getTimelineWeibo:@"statuses_friends_timeline"];
    _tableView.canPullUp = YES;
    //[_tableView reloadData];
    [_tableView stopLoadWithState:PullDownLoadState];
}
//加载
- (void)PullUpLoadEnd
{
    _weiboCount += 20;
    
    [self getWeiboContex:_receivedData];
    
    if (_weiboCount == 80) {
        _tableView.canPullUp = NO;
    }
    
    [_tableView reloadData];
    [_tableView stopLoadWithState:PullUpLoadState];
}

#pragma mark -- initWithButtonAndTitle
-(void)initWithButtonAndTitle
{
    //leftButton
    UIView *writeBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    writeBtn.frame = CGRectMake(0, 7, 30, 30);
    [writeBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_compose"] forState:UIControlStateNormal];
    [writeBtn setImage:[UIImage imageNamed:@"navigationbar_compose_highlighted"] forState:UIControlStateHighlighted];
    [writeBtn addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [writeBtnView addSubview:writeBtn];
    UIBarButtonItem *writeItem = [[UIBarButtonItem alloc]initWithCustomView:writeBtnView];
    self.navigationItem.leftBarButtonItem = writeItem;
    
    
    //middle
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background"]];
    UIButton *middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    middleButton.frame = CGRectMake(0, 0, 155, 43);
    [middleButton setImage:[UIImage imageNamed:@"skin_background"] forState:UIControlStateHighlighted];
    [middleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [middleButton addTarget:self action:@selector(middleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:middleButton];
    UIImage *image = [UIImage imageNamed:@"friendcircle_navigationbar_friendcircle"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(155-34, 15, 14, 14)];
    imageView.image = image;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 155-34, 44)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.text = @"好友圈";
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment =1;
    [middleButton addSubview:label];
    [middleButton addSubview:imageView];
    self.navigationItem.titleView = titleView;
    
    
    //right
    UIView *rightBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(30, 7, 30, 30);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_pop"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"navigationbar_pop_highlighted"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtnView addSubview:rightBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtnView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

//TODO: 左边按钮响应方法
-(void)leftButtonAction
{
    WriteViewController *writeView = [[WriteViewController alloc]init];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:writeView];
    [naVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:naVC animated:YES completion:nil];
}

//TODO: 中间按钮响应的方法
-(void)middleButtonAction
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"popover_background_os7@2x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 100, 120)];
    imageView.image = image;
    [middleView setBackgroundView:imageView];
    
    UIButton *homePage = [UIButton buttonWithType:UIButtonTypeCustom];
    homePage.frame = CGRectMake(5, 20, 100, 20);
    homePage.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [homePage setTitle:@"首页" forState:UIControlStateNormal];
    [homePage addTarget:self action:@selector(getHomeWeibo) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:homePage];
    
    UIButton *eachOther = [UIButton buttonWithType:UIButtonTypeCustom];
    eachOther.frame = CGRectMake(5, 45, 100, 20);
    eachOther.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [eachOther setTitle:@"互相关注" forState:UIControlStateNormal];
    [eachOther addTarget:self action:@selector(getFriendsWeibo) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:eachOther];
    
    UIButton *myWeibo = [UIButton buttonWithType:UIButtonTypeCustom];
    myWeibo.frame = CGRectMake(5, 70, 100, 20);
    myWeibo.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [myWeibo setTitle:@"我的微博" forState:UIControlStateNormal];
    [myWeibo addTarget:self action:@selector(getMyWeibo) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:myWeibo];
    
    UIButton *aroundWeibo = [UIButton buttonWithType:UIButtonTypeCustom];
    aroundWeibo.frame = CGRectMake(5, 95, 100, 20);
    aroundWeibo.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [aroundWeibo setTitle:@"公共微博" forState:UIControlStateNormal];
    [aroundWeibo addTarget:self action:@selector(getPublicWeibo) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:aroundWeibo];
    
    
    //中间的弹出框与右边的弹出框相互斥
    if (middleFlag == 0 && flag == 0) {
        [self.view addSubview:middleView];
        middleView.hidden = NO;
        middleFlag = 1;
        flag = 1;
    }
    else
        if (middleFlag == 0 && flag == 1)
        {
            [rightView removeFromSuperview];
            rightFlag = 0;
            [self.view addSubview:middleView];
            middleView.hidden = NO;
            middleFlag = 1;
            
        }
        else
            if(middleFlag == 1)
            {
                [middleView removeFromSuperview];
                middleView.hidden = YES;
                middleFlag = 0;
                flag = 0;
            }
    
}

//TODO: 获取不同类型的微博
//获取用户以及他关注的用户微博
- (void)getFriendsWeibo
{
    [self getTimelineWeibo:@"statuses_friends_timeline"];
    self.navigationItem.title = @"好友圈";
    [middleView removeFromSuperview];
}

//获取最新的公共微博
- (void)getPublicWeibo
{
    [self getTimelineWeibo:@"statuses_public_timeline"];
    self.navigationItem.title = @"公共微博";
    [middleView removeFromSuperview];
}

//获取用户以及他关注用户的最新微博
- (void)getHomeWeibo
{
    [self getTimelineWeibo:@"statuses_home_timeline"];
    self.navigationItem.title = @"首页微博";
    [middleView removeFromSuperview];
}

//获取用户的微博
- (void)getMyWeibo
{
    [self getTimelineWeibo:@"statuses_user_timeline"];
    self.navigationItem.title = @"我的微博";
    [middleView removeFromSuperview];
}

//TODO: 右边按钮触发的方法
-(void)rightButtonAction
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"popover_background_os7@2x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 0, 80, 100)];
    imageView.image = image;
    [rightView setBackgroundView:imageView];
        
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    refresh.frame = CGRectMake(5, 20, 70, 20);
    refresh.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [refresh setTitle:@"刷新" forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(PullDownLoadEnd) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:refresh];
    
    UIButton *sweep = [UIButton buttonWithType:UIButtonTypeCustom];
    sweep.frame = CGRectMake(5, 45, 70, 20);
    sweep.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [sweep setTitle:@"扫一扫" forState:UIControlStateNormal];
    [sweep addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:sweep];
    
    UIButton *rock = [UIButton buttonWithType:UIButtonTypeCustom];
    rock.frame = CGRectMake(5, 70, 70, 20);
    rock.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [rock setTitle:@"摇一摇" forState:UIControlStateNormal];
    [rock addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rock];
    
    if (rightFlag == 0 && flag == 0)
    {
        [self.view addSubview:rightView];
        rightFlag = 1;
        flag = 1;
    }
    else
    {
        if (rightFlag == 0 && flag == 1)
        {
            [middleView removeFromSuperview];
            middleFlag = 0;
            [self.view addSubview:rightView];
            rightView.hidden = NO;
            rightFlag = 1;
            
        }
        else
            if(rightFlag == 1)
            {
                //imageView.hidden = YES;
                [rightView removeFromSuperview];
                rightFlag = 0;
                flag = 0;
            }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

