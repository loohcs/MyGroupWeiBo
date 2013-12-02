//
//  Privacy.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-12-1.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "Privacy.h"

@implementation Privacy

- (id)initWithPrivacy:(NSDictionary *)dic
{
    if (self = [super init]) {
        _comment = [[dic objectForKey:@"comment"] intValue];
        _geo = [[dic objectForKey:@"geo"] intValue];
        _message = [[dic objectForKey:@"message"] intValue];
        _realname = [[dic objectForKey:@"realname"] intValue];
        _badge = [[dic objectForKey:@"badge"] intValue];
        _mobile = [[dic objectForKey:@"mobile"] intValue];
        _webim = [[dic objectForKey:@"webim"] intValue];
    }
    return self;
}


@end
