//
//  WeiboDataBase.h
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-29.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@class WeiBoContext;

@interface WeiboDataBase : NSObject

+ (BOOL)createWeiboTable;
+ (BOOL)addWithWeibo:(WeiBoContext *)weibo;
//+ (NSMutableDictionary *)findAll;
+ (NSMutableArray *)findAll;
+ (BOOL)deleteDataByID:(int)aID;
+ (BOOL)updateWithWeibo:(WeiBoContext *)weibo andWeiboDBID:(NSInteger)ID;


+ (NSString *)getPathDB;


@end
