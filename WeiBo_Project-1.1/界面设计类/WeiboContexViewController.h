//
//  WeiboContexViewController.h
//  WeiBo_Project
//
//  Created by 1007 on 13-12-10.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "BaseViewController.h"

@interface WeiboContexViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,PullDelegate,UIScrollViewDelegate, WBHttpRequestDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)WeiBoContext *weiboContex;
@property (nonatomic, assign)float height;//得到在评论页显示微博正文的高度
@property (nonatomic, strong)NSMutableArray *commentArray;
@property (nonatomic, assign)int flag;

- (void)getWeiboContex:(WeiBoContext *)oneWeiboContex;

@end
