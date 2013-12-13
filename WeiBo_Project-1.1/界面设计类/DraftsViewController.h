//
//  DraftsViewController.h
//  SinaTwitterDemo
//
//  Created by 1014 on 13-11-27.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableData *dataInDrafts;

@end
