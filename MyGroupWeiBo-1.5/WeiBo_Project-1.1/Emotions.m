//
//  Emotions.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-27.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "Emotions.h"

#import "ImageDownload.h"

@implementation Emotions

- (id)initWithEmotions:(NSDictionary *)dic
{
    if (self = [super init]) {
        _phrase = [dic objectForKey:@"phrase"];
        _type = [dic objectForKey:@"type"];
        _url = [dic objectForKey:@"url"];
        _hot = (Boolean)[dic objectForKey:@"hot"];
        _common = (Boolean)[dic objectForKey:@"common"];
        _category = [dic objectForKey:@"category"];
        _icon_url = [dic objectForKey:@"icon"];
        _value = [dic objectForKey:@"value"];
        _picid = [dic objectForKey:@"picid"];
    }
    return self;
}



@end
