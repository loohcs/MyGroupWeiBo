//
//  MessageViewController.h
//  WeiBo_Project
//
//  Created by 1007 on 13-12-17.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface MessageViewController : BaseNavigationViewController<UITableViewDataSource, UITableViewDelegate, PullDelegate>

@property (nonatomic, strong)UITableView *tableView;

@end
