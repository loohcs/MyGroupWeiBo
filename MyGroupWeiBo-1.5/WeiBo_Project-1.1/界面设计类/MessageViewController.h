//
//  MessageViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource, PullDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *commentsArray;
@property (nonatomic, strong)NSMutableArray *weibosArray;

@end
