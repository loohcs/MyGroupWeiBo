//
//  MapMKAnnotationView.h
//  WeiBo_Project
//
//  Created by xzx on 13-12-5.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapMKAnnotationView : MKAnnotationView
{
    UIImageView *userImage;//用户头像
    UIImageView *weiboImage;//微博图片
    UILabel *textLabel;//微博内容
}
@property (nonatomic,retain)NSString *text;
@end
