//
//  Remind.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-12-1.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "Remind.h"

@implementation Remind

- (id)initWithRemind:(NSDictionary *)dic
{
    if (self = [super init]) {
        _status = [[dic objectForKey:@"status"] intValue];
        _follower = [[dic objectForKey:@"follower"] intValue];
        _cmt = [[dic objectForKey:@"cmt"] intValue];
        _dm = [[dic objectForKey:@"dm"] intValue];
        _mention_status = [[dic objectForKey:@"mention_status"] intValue];
        _mention_cmt = [[dic objectForKey:@"mention_cmt"] intValue];
        _group = [[dic objectForKey:@"group"] intValue];
        _private_group = [[dic objectForKey:@"private_group"] intValue];
        _notice = [[dic objectForKey:@"notice"] intValue];
        _invite = [[dic objectForKey:@"invite"] intValue];
        _badge = [[dic objectForKey:@"badge"] intValue];
        _photo = [[dic objectForKey:@"photo"] intValue];
        _msgbox = [[dic objectForKey:@"msgbox"] intValue];
    }
    return self;
}

@end
