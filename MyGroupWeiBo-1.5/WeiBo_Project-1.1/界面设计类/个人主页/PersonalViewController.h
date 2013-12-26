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
@interface PersonalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, strong)WeiBoContext *weiboContex;

- (void)getUserInfo:(NSString *)userID;
- (void)getUerName:(NSString *)userName;
@end
