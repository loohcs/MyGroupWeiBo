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
        weiboContextsArr = [[NSMutableArray alloc] init];
        _receivedData = [[NSMutableData alloc] init];
        _weiboCount = 0;
        
        middleFlag = 0;
        rightFlag = 0;
        flag = 0;
        middleTableV=[[UITableView alloc]initWithFrame:CGRectMake(110, 0, 100, 120) style:UITableViewStyleGrouped];
        rightTableV = [[UITableView alloc] initWithFrame:CGRectMake(230, 0, 80, 100) style:UITableViewStyleGrouped];
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
    middleTableV=[[UITableView alloc]initWithFrame:CGRectMake(110, 0, 100, 120) style:UITableViewStyleGrouped];
    rightTableV = [[UITableView alloc] initWithFrame:CGRectMake(230, 0, 80, 100) style:UITableViewStyleGrouped];
    
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    //创建左右button和中间标题栏
    [self initWithButtonAndTitle];
    self.navigationItem.title = @"";
    
    [self getTimelineWeibo:@"statuses_friends_timeline"];
    
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
    //[WeiboDataBase createWeiboTable];
    
    for (int i = 0; i <_weiboCount+20; i++) {
        //获得微博正文
        NSDictionary *weiboDic = [NSDictionary dictionaryWithDictionary:[weiboArr objectAtIndex:i]];
        WeiBoContext *oneWeiboContex = [[WeiBoContext alloc] initWithWeibo:weiboDic];
        [weiboContextsArr addObject:oneWeiboContex];
        
        //判断是否是转发微博，如果是，则将字符串的转发微博初始化为WeiboContex类型
        if (oneWeiboContex.retweeted_status != nil) {
            oneWeiboContex.retweetedWeibo = [[WeiBoContext alloc] initWithWeibo:(NSDictionary *)oneWeiboContex.retweeted_status];
            [weiboContextsArr replaceObjectAtIndex:i withObject:oneWeiboContex];
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


//通过块的调用，将数据传入方法中，实现头像图片的获取
- (void)getHeadImage:(NSMutableData *)data andIndex:(int)index
{
    //    //Test
    //    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //    NSString *path = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"headImage_%d.jpg", index]];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    if (![fileManager fileExistsAtPath:path]) {
    //        [fileManager createFileAtPath:path contents:data attributes:nil];
    //    }
    //    else
    //    {
    //        [data writeToFile:path atomically:YES];
    //    }
    
    //NSLog(@"-----------headImage--------%d", index);
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
    
#warning mark -- 每次执行本方法的时候，从块中得到的数据是块在上一次下载之后遗留下得数据，因此在界面中就显示出，所有图片都是上一趟运行时应该具有的图片，而本次图片的显示则会出现在下一次的运行之中。
    
    //    //Test
    //    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //    NSString *path = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"thumbnailImage_%d.jpg", index]];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    if (![fileManager fileExistsAtPath:path]) {
    //        [fileManager createFileAtPath:path contents:data attributes:nil];
    //    }
    //    else
    //    {
    //        [data writeToFile:path atomically:YES];
    //    }
    
    //NSLog(@"-----------ThumbnailImage--------%d", index);
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
        
        
    }
    
    
}

//通过块的调用，将数据传入方法中，实现转发微博缩略图片的获取与加载
- (void)getRetWeiboThumbImage:(NSMutableData *)data andIndex:(int)index
{
    //NSLog(@"-----------retWeiboThumbImage--------%d", index);
    if (data.length > 0) {
        
        //        //Test
        //        NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //        NSString *path = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"retWeiboThumb_%d.jpg", index]];
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //        if (![fileManager fileExistsAtPath:path]) {
        //            [fileManager createFileAtPath:path contents:data attributes:nil];
        //        }
        //        else
        //        {
        //            [data writeToFile:path atomically:YES];
        //        }
        
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
    [writeView addWeiboContex:[weiboContextsArr objectAtIndex:sender.tag - 100]];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:writeView];
    [naVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
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



-(void)leftButtonAction
{
    WriteViewController *writeView = [[WriteViewController alloc]init];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:writeView];
    [naVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:naVC animated:YES completion:nil];
}

-(void)middleButtonAction
{
    //    _array = [[NSMutableArray array] initWithObjects:@"首页",@"好友圈",@"我的微博",@"周边微博", @"特别关注",@"同事",@"名人明星",@"同学",@"悄悄关注",@"智能排行",nil];
    //    middleTableV.rowHeight=10;
    //    middleTableV.delegate=self;
    //    middleTableV.dataSource=self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"popover_background_os7@2x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 100, 120)];
    imageView.image = image;
    [middleTableV setBackgroundView:imageView];
    
    //中间的弹出框与右边的弹出框相互斥
    if (middleFlag == 0 && flag == 0) {
        [self.view addSubview:middleTableV];
        middleFlag = 1;
        flag = 1;
    }
    else
        if (middleFlag == 0 && flag == 1)
        {
            [rightTableV removeFromSuperview];
            rightFlag = 0;
            [self.view addSubview:middleTableV];
            middleFlag = 1;
            
        }
        else
            if(middleFlag == 1)
            {
                [middleTableV removeFromSuperview];
                middleFlag = 0;
                flag = 0;
            }
    
    
}

-(void)rightButtonAction
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"popover_background_os7@2x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 0, 80, 100)];
    imageView.image = image;
    [rightTableV setBackgroundView:imageView];
    
    if (rightFlag == 0 && flag == 0) {
        [self.view addSubview:rightTableV];
        rightFlag = 1;
        flag = 1;
    }
    else
        if (rightFlag == 0 && flag == 1) {
            [middleTableV removeFromSuperview];
            middleFlag = 0;
            [self.view addSubview:rightTableV];
            rightFlag = 1;
            
        }
        else
            if(rightFlag == 1)
            {
                [rightTableV removeFromSuperview];
                rightFlag = 0;
                flag = 0;
            }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

