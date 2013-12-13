//
//  MapMKAnnotationView.m
//  WeiBo_Project
//
//  Created by xzx on 13-12-5.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "MapMKAnnotationView.h"
#import "MapMKAnnotation.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@implementation MapMKAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        [self initView];
    }
    return self;
}

-(void)initView
{
    userImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    userImage.layer.borderWidth =1;
    
    weiboImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 3;
    
    [self addSubview:weiboImage];
    [self addSubview:textLabel];
    [self addSubview:userImage];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.image = [UIImage imageNamed:@"nearby_map_content.png"];
    
    MapMKAnnotation *annotation = self.annotation;
    if (annotation.weiboContext.thumbnail_pic.length>0)
    {
        self.image = [UIImage imageNamed:@"nearby_map_photo_bg"];
        
        weiboImage.frame = CGRectMake(15, 15, 90, 90);
        [weiboImage setImageWithURL:[NSURL URLWithString:annotation.weiboContext.thumbnail_pic]];
        
        userImage.frame = CGRectMake(70, 70, 30, 30);
        [userImage setImageWithURL:[NSURL URLWithString:annotation.weiboContext.userInfo.profile_image_url]];
        textLabel.hidden = YES;
        weiboImage.hidden = NO;
    }
    
    else
    {
        userImage.frame = CGRectMake(15, 16, 50, 50);
        [userImage setImageWithURL:[NSURL URLWithString:annotation.weiboContext.userInfo.profile_image_url]];
        textLabel.frame = CGRectMake(userImage.right+5, userImage.top, 110, 45);
        textLabel.text = annotation.weiboContext.text;
        weiboImage.hidden = YES;
        textLabel.hidden = NO;
    }
    

    
    
}


@end
