//
//  Emotions.h
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-27.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotions : NSObject

@property (nonatomic, strong)NSString *phrase;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)UIImage *largeImage;
@property (nonatomic, assign)Boolean hot;
@property (nonatomic, assign)Boolean common;
@property (nonatomic, strong)NSString *category;
@property (nonatomic, strong)NSString *icon_url;
@property (nonatomic, strong)UIImage *thumbnailImage;
@property (nonatomic, strong)NSString *value;
@property (nonatomic, strong)NSString *picid;

- (id)initWithEmotions:(NSDictionary *)dic;

@end
