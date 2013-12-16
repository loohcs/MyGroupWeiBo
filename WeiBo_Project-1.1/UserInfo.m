//
//  UserInfo.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-26.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (id)initWithUser:(NSDictionary *)dic
{
    if (self = [super init])
    {
        _userID = [dic objectForKey:@"id"];
        _userIDstr = [dic objectForKey:@"idstr"];
        _screen_name = [dic objectForKey:@"screen_name"];
        _name = [dic objectForKey:@"name"];
        _province = [[dic objectForKey:@"province"] intValue];
        _city = [[dic objectForKey:@"city"] intValue];
        _location = [dic objectForKey:@"location"];
        _description = [dic objectForKey:@"description"];
        _url = [dic objectForKey:@"url"];
        _profile_image_url = [dic objectForKey:@"profile_image_url"];
        _headImage = [[UIImage alloc] init];
        _profile_url = [dic objectForKey:@"profile_url"];
        _domain = [dic objectForKey:@"domain"];
        _weihao = [dic objectForKey:@"weihao"];
        _gender = [dic objectForKey:@"gender"];
        _followers_count = [[dic objectForKey:@"followers_count"] intValue];
        _friends_count = [[dic objectForKey:@"friends_count"] intValue];
        _statuses_count = [[dic objectForKey:@"statuses_count"] intValue];
        _favourites_count = [[dic objectForKey:@"favourites_count"] intValue];
        _created_at = [dic objectForKey:@"created_at"];
        _following = (Boolean)[dic objectForKey:@"following"];
        _allow_all_act_msg = (Boolean)[dic objectForKey:@"allow_all_act_msg"];
        _geo_enabled = (Boolean)[dic objectForKey:@"list_id"];
        _verified = (Boolean)[dic objectForKey:@"verified"];
        _verified_type = [[dic objectForKey:@"verified_type"] intValue];
        _remark = [dic objectForKey:@"remark"];
        _status = [dic objectForKey:@"status"];
        _allow_all_comment = (Boolean)[dic objectForKey:@"allow_all_comment"];
        _avatar_hd = [dic objectForKey:@"avatar_hd"];
        _verified_reason = [dic objectForKey:@"verified_reason"];
        _follow_me = (Boolean)[dic objectForKey:@"follow_me"];
        _online_status = [[dic objectForKey:@"online_status"] intValue];
        _bi_followers_count = [[dic objectForKey:@"bi_followers_count"] intValue];
        _lang = [dic objectForKey:@"lang"];

    }
    
    return self;
}


@end
