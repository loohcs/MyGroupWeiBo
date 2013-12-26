//
//  AroundViewController.m
//  WeiBo_Project
//
//  Created by xzx on 13-12-4.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "AroundViewController.h"
#import "MapMKAnnotation.h"
#import "WeiBoContext.h"
#import "MapMKAnnotationView.h"
#import "UIViewController+CreatCustomNaBar.h"
#import "SBJson.h"
@interface AroundViewController ()

@end

@implementation AroundViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatBackNavigationBarWithTitle:@"周边" sign:1];
    
    //定位
    if (![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"定位服务正常");
    }
    else
    {
        NSLog(@"定位服务异常");
    }
    _location = [[CLLocationManager alloc]init];
    [_location setDesiredAccuracy:kCLLocationAccuracyBest];
    _location.delegate = self;
    [_location setDistanceFilter:100.0f];
    [_location startUpdatingLocation];
    //地图视图
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 44, 320, 568)];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = YES;
      _mapView.delegate = self;
    [self.view addSubview:_mapView];
}


#pragma mark -- MKAnnotatiobView delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    static NSString *identifier = @"MapMKView";
    MapMKAnnotationView *annotationView =(MapMKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView==nil)
    {
        annotationView = [[MapMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    return annotationView;
    
    
}

//实现定位服务的代理
#pragma mark -- CLLocationManager delegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    switch (error.code)
    {
        case kCLErrorDenied:
            NSLog(@"定位失败");
            break;
        case kCLErrorLocationUnknown:
            NSLog(@"没有找到该位置");
            break;
        default:
            NSLog(@"定位出错");
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    [manager stopUpdatingLocation];
    if (self.data==nil)
    {
        NSString *latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        
        //请求周边微博动态数据
        [self getWeiboNearbyDataWithLatitude:@"23.13" Longitude:@"113.27"];
    }
    //定义地图范围
    MKCoordinateRegion region;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(23.13, 113.27);
    region.center = center;
    //定义显示范围
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1f;
    span.longitudeDelta = 0.1f;
    region.span = span;
    _mapView.region = region;
}
#pragma mark -- 获取周边微博数据
-(void)getWeiboNearbyDataWithLatitude:(NSString *)lat Longitude:(NSString *)lon
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [user objectForKey:@"accessToken"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:lon,@"long",lat,@"lat",nil];
    [WBHttpRequest requestWithAccessToken:accessToken url:@"https://api.weibo.com/2/place/nearby_timeline.json" httpMethod:@"GET" params:params delegate:self];
}
#pragma mark -- 实现请求数据的代理
-(void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *rootDic = [parser objectWithString:result];
    NSArray *arr = [rootDic objectForKey:@"statuses"];
    NSMutableArray *annotations = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        WeiBoContext *weibo = [[WeiBoContext alloc]initWithWeibo:dic];
        MapMKAnnotation *mapMKA = [[MapMKAnnotation alloc]initWithWeibo:weibo];
        [annotations addObject:mapMKA];
    }
    [_mapView addAnnotations:annotations];
  
}   

-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
