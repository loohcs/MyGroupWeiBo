//
//  GetIPToGeo.m
//  WeiBo_Project
//
//  Created by 1007 on 13-12-13.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "GetIPToGeo.h"
#import "FindFriendViewController.h"

@implementation GetIPToGeo

- (void)getPreseentIp
{
    NSURL *url = [NSURL URLWithString:@"http://www.whatismyip.com.tw/"];
    NSString *str  = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSRange range1= [str rangeOfString:@"h2>"];
    NSRange range2= [str rangeOfString:@"</h2"];
    NSLog(@"-----------%d ,%d",range1.length,range1.location);
    NSLog(@"-----------%d ,%d",range2.length,range2.location);
    int location = range1.location+range1.length;
    int length = range2.location-(range1.location+range1.length);
    NSString *ip = [str substringWithRange:NSMakeRange(location, length)];
    
    __weak GetIPToGeo *getIpToGeo = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:ip,@"ip", nil];
    WBHTTP_Request_Block *getGeoBlock = [[WBHTTP_Request_Block alloc] initWithURlString:LOCATION_GEO_IP_TO_GEO andArguments:dic];
    [getGeoBlock setBlock:^(NSMutableData *datas, float progressNum) {
        [getIpToGeo getGeoInfo:datas];
    }];
}


- (void)getGeoInfo:(NSMutableData *)data
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSDictionary *geoInfo = [dic objectForKey:@"geos"];
    Geo *geo = [[Geo alloc] initWithGeo:geoInfo];
    
}

@end
