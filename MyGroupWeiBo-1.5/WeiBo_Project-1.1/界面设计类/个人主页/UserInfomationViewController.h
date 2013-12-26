//
//  UserInfomationViewController.h
//  WeiBo_Project
//
//  Created by xzx on 13-12-12.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+CreatCustomNaBar.h"
@interface UserInfomationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,retain)UserInfo *userInfo;
@end
