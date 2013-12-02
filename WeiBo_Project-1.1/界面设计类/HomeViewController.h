//
//  HomeViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *middleTableV;
    int middleFlag;//标志中间的弹出框是否存在
    UITableView *rightTableV;
    int rightFlag;//标志右边的弹出框是否存在
    NSMutableArray *_array;
    int flag;//标志是否有弹出框存在
    
    WBHTTP_Request_Block *statuses;
    
    WeiboView *weiboView;

}

@end
