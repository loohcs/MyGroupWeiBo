//
//  Url_short.h
//  Weibo_Test-0001
//
//  Created by 1007 on 13-12-1.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Url_short : NSObject

@property (nonatomic, strong) NSString *url_short;//短链接
@property (nonatomic, strong) NSString *url_long;//长链接
@property (nonatomic, assign) int type;//链接的类型， 0：普通网页， 1：视频，2：音乐，3：活动，5，投票
@property (nonatomic, assign) Boolean result;//短链的可用状态，true：可用， false：不可用

- (id)initWithUrlShort:(NSDictionary *)dic;

@end
