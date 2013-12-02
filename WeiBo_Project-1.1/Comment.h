//
//  Comment.h
//  Weibo_Test-0001
//
//  Created by 1007 on 13-12-1.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, strong)NSString *created_at;//评论创建时间
@property (nonatomic, assign)int ID;//评论的id
@property (nonatomic, strong)NSString *text;//评论的主要内容
@property (nonatomic, strong)NSString *source;//评论的来源
@property (nonatomic, strong)NSObject *user;//评论作者的用户信息字段
@property (nonatomic, strong)UserInfo *userInfo;//评论作者的具体用户信息
@property (nonatomic, strong)NSString *mid;//评论的MID
@property (nonatomic, strong)NSString *idstr;//字符串类型的评论ID
@property (nonatomic, strong)NSObject *status;//评论的微博信息字段
@property (nonatomic, strong)WeiBoContext *commentWeiboContex;//评论的微博对象
@property (nonatomic, strong)NSObject *reply_comment;//评论的来源评论，当本评论属于另一条评论的回复时返回此字段

- (id)initWithComment:(NSDictionary *)dic;

@end
