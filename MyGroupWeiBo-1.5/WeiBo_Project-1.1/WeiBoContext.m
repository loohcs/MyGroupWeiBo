//
//  WeiBoContext.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-26.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "WeiBoContext.h"
#import "UserInfo.h"
@implementation WeiBoContext

- (id)initWithWeibo:(NSDictionary *)dic
{
    if (self = [super init])
    {
        _created_at = [dic objectForKey:@"created_at"];
        _ID = [[dic objectForKey:@"id"] intValue];
        _MID = [[dic objectForKey:@"mid"] intValue];
        _idstr = [dic objectForKey:@"idstr"];
        _text = [dic objectForKey:@"text"];
        _source = [dic objectForKey:@"source"];
        _favorited = (Boolean)[dic objectForKey:@"favorited"];
        _truncated = (Boolean)[dic objectForKey:@"truncated"];
        _in_reply_to_status_id = [dic objectForKey:@"in_reply_to_status_id"];
        _in_reply_to_user_id = [dic objectForKey:@"in_reply_to_user_id"];
        _in_reply_to_screen_name = [dic objectForKey:@"in_reply_to_screen"];
        
        //_pic_urls = [dic objectForKey:@"pic_urls"];
        _thumbnail_pic = [dic objectForKey:@"thumbnail_pic"];
        _thumbnailImage = [[UIImage alloc] init];
        _bmiddle_pic = [dic objectForKey:@"bmiddle_pic"];
        _bmiddleImage = [[UIImage alloc] init];
        _original_pic = [dic objectForKey:@"original_pic"];
        _originalImage = [[UIImage alloc] init];
        
        _geo = [dic objectForKey:@"geo"];
        
        //user 是一个字典，同时存在一个user对象，用获得的user字典初始化
        _user = [dic objectForKey:@"user"];
        _userInfo = [[UserInfo alloc] initWithUser:(NSDictionary *)_user];
        
        _retweeted_status = [dic objectForKey:@"retweeted_status"];
        
        
        _reposts_count = [[dic objectForKey:@"reposts_count"] intValue];
        _comments_count = [[dic objectForKey:@"comments_count"] intValue];
        _attitudes_count = [[dic objectForKey:@"attitudes_count"] intValue];
        _mlevel = [[dic objectForKey:@"mlevel"] intValue];
        _visible = [dic objectForKey:@"visible"];
        _type = [_visible objectForKey:@"type"];
        _list_id = [_visible objectForKey:@"list_id"];
        _pic_urls = [dic objectForKey:@"pic_urls"];
        _weiboPics = [[NSMutableArray alloc] init];
        _ad = [dic objectForKey:@"ad"];

    }
    
    return self;

}


@end
