//
//  HomeViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"
@class Friends_Timeline_Weibo;
@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *middleTableV;
    UITableView *rightTableV;
    NSMutableArray *_array;
    
    Friends_Timeline_Weibo *friendWeibo;
}

@end
