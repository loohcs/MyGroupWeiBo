//
//  Public_Timeline_Weibo.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-26.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "Public_Timeline_Weibo.h"
#import "WBHTTP_Request_Block.h"
#import "WeiBoContext.h"

@implementation Public_Timeline_Weibo

#pragma mark -- 请求最新的公共微博
- (void)getPublicTimeline
{
    NSLog(@"%s", __func__);
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"100",@"count", nil];
    statuses = [[WBHTTP_Request_Block alloc] initWithURlString:STATUSES_PUBLIC_TIMELINE andArguments:dic];
    NSLog(@"%@", STATUSES_PUBLIC_TIMELINE);
    _publicWeiboContex = [[WeiBoContext alloc] init];
    __weak Public_Timeline_Weibo *publicWeiboClass = self;
    [statuses setBlock:^(NSMutableData *datas, float progressNum)
     {
         //NSString *str = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
         //NSLog(@"%@", str);
         [publicWeiboClass getWeiboContex:datas];
     }];
}

- (void)getWeiboContex:(NSData *)data
{
    NSLog(@"%s", __func__);
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *weiboArr = [NSArray arrayWithArray:[dic objectForKey:@"statuses"]];
    for (int i = 0; i < weiboArr.count; i++) {
        
        NSDictionary *weiboDic = [NSDictionary dictionaryWithDictionary:[weiboArr objectAtIndex:i]];
        _publicWeiboContex = [[WeiBoContext alloc] initWithWeibo:weiboDic];
        
        [WeiboDataBase createWeiboTable];
        [WeiboDataBase addWithWeibo:_publicWeiboContex];
    }
    
    //TODO: 判断哪些微博是需要加入数据库的
    //仅仅需要将当前页面显示的微博都加入数据中，不需要所有的微博
    
    [WeiboDataBase findAll];
    
    NSNotification *noti = [NSNotification notificationWithName:@"完成微博数据请求" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

@end
