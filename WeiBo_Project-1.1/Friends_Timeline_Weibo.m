//
//  Friends_Timeline_Weibo.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "Friends_Timeline_Weibo.h"

#import "WBHTTP_Request_Block.h"
#import "WeiBoContext.h"
@implementation Friends_Timeline_Weibo

#pragma mark -- 获取最新的好友圈微博
- (void)getFriendsTimelineWeibo
{
    NSLog(@"%s", __func__);
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"since_id", @"0", @"max_id", @"10",@"count", @"1", @"page", @"0", @"base_app", @"0",@"feature", @"0", @"trim_user", nil];
    statuses = [[WBHTTP_Request_Block alloc] initWithURlString:STATUSES_FRIENDS_TIMELINES andArguments:dic];
    NSLog(@"%@", STATUSES_FRIENDS_TIMELINES);
    _friendsWeiboContext = [[WeiBoContext alloc] init];
    [statuses setBlock:^(NSMutableData *datas, float progressNum)
     {
         //NSString *str = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
         //NSLog(@"%@", str);
         
         Friends_Timeline_Weibo *friendWeiboClass = [[Friends_Timeline_Weibo alloc] init];
         [friendWeiboClass getWeiboContex:datas];
     }];
}


//通过已经下载下来的微博内容（json类型），来初始化一个WeiboContex类对象，并具体解析类中的每一个成员
- (void)getWeiboContex:(NSData *)data
{
    NSLog(@"%s", __func__);
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *weiboArr = [NSArray arrayWithArray:[dic objectForKey:@"statuses"]];
    for (int i = 0; i < weiboArr.count; i++) {
        
        NSDictionary *weiboDic = [NSDictionary dictionaryWithDictionary:[weiboArr objectAtIndex:i]];
        _friendsWeiboContext = [[WeiBoContext alloc] initWithWeibo:weiboDic];
        
        [WeiboDataBase createWeiboTable];
        [WeiboDataBase addWithWeibo:_friendsWeiboContext];
    }
    
    //TODO: 判断哪些微博是需要加入数据库的
    //仅仅需要将当前页面显示的微博都加入数据中，不需要所有的微博
    
    [WeiboDataBase findAll];
    
    //???: 在完成数据的下载以及对下载的数据进行了解析和类对象的初始化之后发布通知
    NSNotification *noti = [NSNotification notificationWithName:@"完成最新好友圈微博数据请求" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

@end
