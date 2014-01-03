//
//  Geo.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-12-1.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "Geo.h"

@implementation Geo

- (id)initWithGeo:(NSDictionary *)dic
{
    if (self = [super init]) {
        _longitude = [dic objectForKey:@"longitude"];
        _latitude = [dic objectForKey:@"latitude"];
        _city = [dic objectForKey:@"city"];
        _province = [dic objectForKey:@"province"];
        _city_name = [dic objectForKey:@"city_name"];
        _province_name = [dic objectForKey:@"province_name"];
        _address = [dic objectForKey:@"address"];
        _pinyin = [dic objectForKey:@"pinyin"];
        _more = [dic objectForKey:@"more"];
        
    }
    return self;
}
@end
