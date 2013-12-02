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
        _profile_url = [dic objectForKey:@"profile_url"];
        _domain = [dic objectForKey:@"domain"];
        _weihao = [dic objectForKey:@"weihao"];
        _gender = [dic objectForKey:@"gender"];
        _followers_count = [[dic objectForKey:@"followers_count"] intValue];
        _friends_count = [[dic objectForKey:@"friends_count"] intValue];
        _statuses_count = [[dic objectForKey:@"statuses_count"] intValue];
        _favourites_count = [[dic objectForKey:@"favourites_count"] intValue];
        _created_at = [dic objectForKey:@"create_at"];
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
        
        NSLog(@"_userID = %@", _userID);
        NSLog(@"_userIDstr = %@", _userIDstr);
        NSLog(@"_screen_name = %@", _screen_name);
        NSLog(@"_name = %@", _name);
        NSLog(@"_province = %d", _province);
        NSLog(@"_city = %d", _city);
        NSLog(@"_location = %@" , _location);
        NSLog(@"_description = %@" , _description);
        NSLog(@"_url = %@", _url);
        NSLog(@"_profile_image_url = %@", _profile_image_url);
        NSLog(@"_profile_url = %@", _profile_url);
        NSLog(@"_domain = %@", _domain);
        NSLog(@"_weihao = %@", _weihao);
        NSLog(@"_gender = %@", _gender);
        NSLog(@"_followers_count = %d", _followers_count);
        NSLog(@"_friends_count = %d", _friends_count);
        NSLog(@"_statuses_count = %@", _status);
        NSLog(@"_favourites_count = %d", _favourites_count);
        NSLog(@"_following = %d", _following);
        NSLog(@"_allow_all_act_msg = %d", _allow_all_act_msg);
        NSLog(@"_geo_enabled = %d", _geo_enabled);
        NSLog(@"_verified = %d", _verified);
        NSLog(@"_verified_type = %d", _verified_type);
        NSLog(@"_remark = %@", _remark);
        NSLog(@"_status = %@", _status);
        NSLog(@"_allow_all_comment = %d", _allow_all_comment);
        NSLog(@"_avatar_large = %@", _avatar_large);
        NSLog(@"_avatar_hd = %@", _avatar_hd);
        NSLog(@"_verified_reason = %@", _verified_reason);
        NSLog(@"_bi_followers_count = %d", _bi_followers_count);
        NSLog(@"_lang = %@", _lang);

    }
    
    return self;
}


@end
