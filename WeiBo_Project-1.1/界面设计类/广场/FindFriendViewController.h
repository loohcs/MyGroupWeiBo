//
//  FindFriendViewController.h
//  WeiBo_Project
//
//  Created by xzx on 13-12-9.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "BaseViewController.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+PullLoad.h"
@interface FindFriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PullDelegate>
{
    UITableView *_tabelView;
}

@property (nonatomic,retain)NSArray *data;
@property (nonatomic, strong)NSString *ipString;
@property (nonatomic, strong)Geo *geo;

@property (nonatomic, strong)NSString *latitude;
@property (nonatomic, strong)NSString *longitude;



@end
