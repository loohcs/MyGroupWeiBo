//
//  CustomTabbarController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-21.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Public_Timeline_Weibo;
@class Friends_Timeline_Weibo;

@interface CustomTabbarController : UITabBarController
{
    NSArray *title;
}

@property (nonatomic, strong) Public_Timeline_Weibo *publicTimelineWeibo;
@property (nonatomic, strong) Friends_Timeline_Weibo *friendsTimelineWeibo;

@end
