//
//  Friends_Timeline_Weibo.h
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeiBoContext;
@class WBHTTP_Request_Block;

@interface Friends_Timeline_Weibo : NSObject
{
    WBHTTP_Request_Block *statuses;
    
    //NSDictionary *weiboDic;
}

@property (nonatomic, strong)WeiBoContext *friendsWeiboContext;

- (void)getFriendsTimelineWeibo;
- (void)getWeiboContex:(NSData *)data;

@end
