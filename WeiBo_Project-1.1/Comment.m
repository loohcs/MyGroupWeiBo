//
//  Comment.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-12-1.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (id)initWithComment:(NSDictionary *)dic
{
    if (self = [super init]) {
        _created_at = [dic objectForKey:@"created_at"];
        _ID = [[dic objectForKey:@"id"] intValue];
        _text = [dic objectForKey:@"text"];
        _source = [dic objectForKey:@"source"];
        _user = [dic objectForKey:@"user"];
        _userInfo = [[UserInfo alloc] initWithUser:(NSDictionary *)_user];
        _mid = [dic objectForKey:@"mid"];
        _idstr = [dic objectForKey:@"idstr"];
        _status = [dic objectForKey:@"status"];
        _commentWeiboContex = [[WeiBoContext alloc] initWithWeibo:(NSDictionary *)_status];
        _reply_comment = [dic objectForKey:@"reply_comment"];
    }
    return self;
}

@end
