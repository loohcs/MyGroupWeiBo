//
//  MessageWeiboViewController.h
//  WeiBo_Project
//
//  Created by 1007 on 13-12-17.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageWeiboViewController : BaseViewController<PullDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *weiboContextsArr;

- (void)getWeiboCOntexArr:(NSMutableArray *)arr;

@end
