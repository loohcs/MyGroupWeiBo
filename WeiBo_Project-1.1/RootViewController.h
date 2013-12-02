//
//  RootViewController.h
//  WeiBo_Project
//
//  Created by 1007 on 13-11-27.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Public_Timeline_Weibo;
@class Friends_Timeline_Weibo;
@interface RootViewController : UIViewController

@property (nonatomic, strong)Public_Timeline_Weibo *publicTimelineWeibo;
@property (nonatomic, strong)Friends_Timeline_Weibo *frindsTimelineWeibo;

@end
