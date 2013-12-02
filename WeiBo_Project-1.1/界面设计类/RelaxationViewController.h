//
//  RelaxationViewController.h
//  SinaTwitterDemo
//
//  Created by 1014 on 13-11-26.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelaxationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_tableArray;
}
-(IBAction)xiuXian:(id)sender;
@end
