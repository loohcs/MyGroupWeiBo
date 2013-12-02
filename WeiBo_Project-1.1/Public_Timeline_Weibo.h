//
//  Public_Timeline_Weibo.h
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-26.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeiBoContext;
@class WBHTTP_Request_Block;

@interface Public_Timeline_Weibo : NSObject
{
    WBHTTP_Request_Block *statuses;
    WeiboDataBase *weiboDB;
}

@property (nonatomic, strong) WeiBoContext *publicWeiboContex;


- (void)getPublicTimeline;
- (void)getWeiboContex:(NSData *)data;

@end
