//
//  MapMKAnnotation.m
//  WeiBo_Project
//
//  Created by xzx on 13-12-5.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "MapMKAnnotation.h"

@implementation MapMKAnnotation
-(id)initWithWeibo:(WeiBoContext *)weibo
{
    self = [super init];
    if (self!=nil)
    {
        self.weiboText = weibo;
    }
    return self;
}

-(void)setWeiboText:(WeiBoContext *)weiboContext
{
    if (_weiboContext != weiboContext)
    {
        _weiboContext = weiboContext;
    }
    NSDictionary *geo = weiboContext.geo;
    
    if ([geo isKindOfClass:[NSDictionary class]])
    {
        NSArray *coord = [geo objectForKey:@"coordinates"];
        if (coord.count==2)
        {
            float lat = [[coord objectAtIndex:0]floatValue];
            float lon = [[coord objectAtIndex:1]floatValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
    }
    
}

@end
