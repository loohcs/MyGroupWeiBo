//
//  HomeViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate, PullDelegate>
{
    UITableView *middleTableV;
    int middleFlag;//标志中间的弹出框是否存在
    UITableView *rightTableV;
    int rightFlag;//标志右边的弹出框是否存在
    NSMutableArray *_array;
    int flag;//标志是否有弹出框存在
    
    UITableView *_tableView;
    WBHTTP_Request_Block *statuses;
    NSMutableArray *weiboContextsArr;
    //    WeiboView *weiboView;
    
    NSMutableArray *_imagesArray;
    NSMutableArray *_headImagesArray;
    
    
}

@property (nonatomic, strong) NSMutableArray *allWeiboArray;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) int weiboCount;

@property (nonatomic, strong) NSMutableArray *thumbnailImagesArray;
@property (nonatomic, assign)int thumbnailNum;
@property (nonatomic, assign)int thumbnailFlag;
@property (nonatomic, assign)int thumbnailLastFlag;
@property (nonatomic, strong)NSMutableArray *thumbnailFlagArray;



@property (nonatomic, assign)int headNum;

@property (nonatomic, strong)NSMutableArray *weibosArray;

@property (nonatomic, strong)NSMutableArray *flagArray;//存放所有图片所在的微博编号
@property (nonatomic, assign)int lastFlag;//在块每次下载完成并将数据传入方法时，用来判断前后两次的图片是否在同一份微博中
@property (nonatomic, assign)int weiboFlag;//在块中标识块执行的次数，即下载完成的图片张数。用于取出图片所在微博编号。

@property (nonatomic, assign)Boolean isRetweeted;//判断该微博是否是转发微博
@property (nonatomic, strong)NSMutableArray *retweetFlagArray;//存放所有转发微博图片所在的微博编号
@property (nonatomic, assign)int retweetNum;//方便取出存放转发微博图片的编号，每次进入块时++
@property (nonatomic, assign)int retweetLastFlag;//在块每次下载完成并将数据传入方法时，用来判断前后两次的图片是否在同一份微博中
@property (nonatomic, assign)int retweetWeiboFlag;//在块中标识块执行的次数，即下载完成的图片张数。用于取出图片所在微博编号。

@end

