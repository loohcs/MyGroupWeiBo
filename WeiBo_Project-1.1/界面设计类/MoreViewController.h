//
//  MoreViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_array;
    NSDictionary *dic;
    NSArray *keys;
    
    
   

}
@end
