//
//  PersonalViewController.h
//  WeiBo_Project
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "UserInfomationViewController.h"
@interface PersonalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WBHttpRequestDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,retain)UserInfo *userInfo;

@end
