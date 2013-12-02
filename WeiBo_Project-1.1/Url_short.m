//
//  Url_short.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-12-1.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "Url_short.h"

@implementation Url_short

- (id)initWithUrlShort:(NSDictionary *)dic
{
    if (self = [super init]) {
        _url_short = [dic objectForKey:@"url_short"];
        _url_long = [dic objectForKey:@"url_long"];
        _type = [[dic objectForKey:@"type"] intValue];
        _result = (Boolean)[dic objectForKey:@"result"];
    }
    return self;
}

@end
