//
//  NewsViewController.h
//  SinaTwitterDemo
//
//  Created by 1014 on 13-11-27.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController<UITableViewDelegate , UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_tableArray;
    NSDictionary *dic;
    NSArray *keys;
    
}

@end
