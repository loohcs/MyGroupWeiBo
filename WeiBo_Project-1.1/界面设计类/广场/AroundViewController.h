//
//  AroundViewController.h
//  WeiBo_Project
//
//  Created by xzx on 13-12-4.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface AroundViewController : BaseViewController<CLLocationManagerDelegate,WBHttpRequestDelegate,MKMapViewDelegate>
{
    CLLocationManager *_location;
    MKMapView *_mapView;
}
@property (nonatomic,retain)NSArray *data;//需要显示的微博数据
@end
