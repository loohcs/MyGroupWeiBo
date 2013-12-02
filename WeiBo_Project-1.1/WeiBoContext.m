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
        NSLog(@"%s", __func__);
        
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
        _bmiddle_pic = [dic objectForKey:@"bmiddle_pic"];
        _original_pic = [dic objectForKey:@"original_pic"];
        
        _geo = [dic objectForKey:@"geo"];
        
        //user 是一个字典，同时存在一个user对象，用获得的user字典初始化
        _user = [dic objectForKey:@"user"];
        _userInfo = [[UserInfo alloc] initWithUser:_user];
        
        _retweeted_status = [dic objectForKey:@"retweeted_status"];
        _reposts_count = [[dic objectForKey:@"reposts_count"] intValue];
        _comments_count = [[dic objectForKey:@"comments_count"] intValue];
        _attitudes_count = [[dic objectForKey:@"attitudes_count"] intValue];
        _mlevel = [[dic objectForKey:@"mlevel"] intValue];
        _visible = [dic objectForKey:@"visible"];
        _type = [_visible objectForKey:@"type"];
        _list_id = [_visible objectForKey:@"list_id"];
        _pic_urls = [dic objectForKey:@"created_at"];
        _ad = [dic objectForKey:@"visible"];
        
        NSLog(@"_created_at = %@", _created_at);
        NSLog(@" _ID = %d", _ID);
        NSLog(@"_MID = %d", _MID);
        NSLog(@"_idstr = %@", _idstr);
        NSLog(@"_text = %@", _text);
        NSLog(@"_source = %@", _source);
        NSLog(@"_favorited value: %@" ,_favorited?@"YES":@"NO");
        NSLog(@"_truncated value: %@" ,_truncated?@"YES":@"NO");
        NSLog(@"_in_reply_to_status_id = %@", _in_reply_to_status_id);
        NSLog(@"_in_reply_to_user_id = %@", _in_reply_to_user_id);
        NSLog(@"_in_reply_to_screen_name = %@", _in_reply_to_screen_name);
        NSLog(@"_pic_urls = %@", _pic_urls);
        NSLog(@"_thumbnail_pic = %@", _thumbnail_pic);
        NSLog(@"_bmiddle_pic = %@", _bmiddle_pic);
        NSLog(@"_original_pic = %@", _original_pic);
        NSLog(@"_geo = %@", _geo);
        NSLog(@"_user = %@", _user);
        NSLog(@"_retweeted_status = %@", _retweeted_status);
        NSLog(@"_reposts_count = %d", _reposts_count);
        NSLog(@"_comments_count = %d", _comments_count);
        NSLog(@"_attitudes_count = %d", _attitudes_count);
        NSLog(@"_mlevel = %d", _mlevel);
        NSLog(@"_visible = %@", _visible);
        //    NSLog(@"_pic_urls = %@", _pic_urls);
        NSLog(@"_ad = %@", _ad);
        
#pragma mark -- 计算当宽度确定时，要显示一确定的文本长度所需的最小大小
        UIFont *font = [UIFont systemFontOfSize:13];
        CGSize contexsize = [_text sizeWithFont:font constrainedToSize:CGSizeMake(280, 1000)];
        NSLog(@"-----------------%g", contexsize.height);
    }
    
    return self;

}


@end
