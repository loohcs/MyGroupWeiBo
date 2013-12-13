//
//  HomeViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"
#import "UIScrollView+PullLoad.h"

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
    
    
}

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) int weiboCount;
@end

