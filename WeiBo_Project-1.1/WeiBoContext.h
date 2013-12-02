//
//  WeiBoContext.h
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-26.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;
@interface WeiBoContext : NSObject

//@property (nonatomic, strong)NSArray *public_weibo_arr;//最新公共微博数组
//@property (nonatomic, strong)NSDictionary *one_public_weibo;//最新的一条公共微博

@property (nonatomic, strong)NSString *created_at;//微博创建时间
@property (nonatomic, assign)int ID;//微博ID
@property (nonatomic, assign)int MID;//微博MID
@property (nonatomic, strong)NSString *idstr;//字符串型的微博ID
@property (nonatomic, strong)NSString *text;//微博信息内容
@property (nonatomic, strong)NSString *source;//微博来源
@property (nonatomic, assign)Boolean favorited;//是否已收藏，TRUE：是，FALSE：否
@property (nonatomic, assign)Boolean truncated;//是否被截断，TRUE：是， FALSE：否
@property (nonatomic, strong)NSString *in_reply_to_status_id;//（暂未支持）回复ID
@property (nonatomic, strong)NSString *in_reply_to_user_id;//（暂未支持）回复人ID
@property (nonatomic, strong)NSString *in_reply_to_screen_name;//（暂未支持）回复人昵称
@property (nonatomic, strong)NSDictionary *pic_urls;//微博配图地址。多图时返回多图链接。无配图时返回“[]”
@property (nonatomic, strong)NSString *thumbnail_pic;//缩略图片地址，没有时不返回此字段
@property (nonatomic, strong)NSString *bmiddle_pic;//中等尺寸图片地址，没有时不返回此字段
@property (nonatomic, strong)NSString *original_pic;//原始图片地址，没有时不返回此字段
@property (nonatomic, strong)NSDictionary *geo;//地理信息字段
@property (nonatomic, strong)NSDictionary *user;//微博作者的用户信息字段
@property (nonatomic, strong)UserInfo *userInfo;//一个user的对象
@property (nonatomic, strong)NSDictionary *retweeted_status;//被转发的原来微博信息字段，当该微博为转发时返回
@property (nonatomic, assign)int reposts_count;//转发数
@property (nonatomic, assign)int comments_count;//评论数
@property (nonatomic, assign)int attitudes_count;//表态数
@property (nonatomic, assign)int mlevel;//暂未支持
@property (nonatomic, strong)NSDictionary *visible;//微博的可见性以及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为该分组的组号
@property (nonatomic, strong)NSString *type; //微博的可见性
@property (nonatomic, strong)NSString *list_id;//分组的组号
//@property (nonatomic, strong)NSDictionary *pic_urls;//微博配图地址。多图时返回多图链接。无配图时返回“[]”
@property (nonatomic, strong)NSArray *ad;//微博流内的推广微博ID

- (id)initWithWeibo:(NSDictionary *)dic;

@end
