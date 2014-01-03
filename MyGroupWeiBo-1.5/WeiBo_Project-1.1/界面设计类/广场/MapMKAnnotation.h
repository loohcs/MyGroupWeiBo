//
//  MapMKAnnotation.h
//  WeiBo_Project
//
//  Created by xzx on 13-12-5.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiBoContext.h"
@interface MapMKAnnotation : NSObject<MKAnnotation>

@property (nonatomic,readonly)CLLocationCoordinate2D coordinate;

@property (nonatomic,retain)WeiBoContext *weiboContext;

- (id)initWithWeibo:(WeiBoContext *)weibo;

@end
