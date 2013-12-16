//
//  WeiboDataBase.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-29.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "WeiboDataBase.h"
#import "WeiBoContext.h"
@implementation WeiboDataBase

#pragma mark -- 通过数据库来存取数据
+ (NSString *)getPathDB
{
    NSLog(@"%s", __func__);
    
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArr lastObject] stringByAppendingPathComponent:@"WeiBoDB.sqlite"];
    
    return path;
}

//???: 创建表
+ (BOOL)createWeiboTable
{
    NSLog(@"%s", __func__);
    
#pragma mark -- 使用FMDB第三方类库来实现数据的打开
    FMDatabase *db = [FMDatabase databaseWithPath:[WeiboDataBase getPathDB]];
    if (![db open]) {
        NSLog(@"打开数据库失败！");
        return NO;
    }
    
#pragma mark -- 使用FMDB第三方类库来实现数据的创建
    BOOL isSucess = [db executeUpdate:@"create table if not exists WeiboDataBases(id integer primary key autoincrement, mid integer, idstr text, userIDstr text, userName text, created_at text, text text, source text, favorited bool, truncated bool, thumbnail_pic blob, bmiddle_pic blob, original_pic blob, retweeted_status_id text, reposts_count integer, comments_count integer, attitudes_count integer)"];
    
    if (isSucess) {
        NSLog(@"表创建成功！");
    }
    
    [db close];
    
    return isSucess;
    
}

+ (BOOL)addWithWeibo:(WeiBoContext *)weibo
{
    NSLog(@"%s", __func__);

    FMDatabase *db = [FMDatabase databaseWithPath:[WeiboDataBase getPathDB]];
    
    if (![db open]) {
        NSLog(@"数据库打开失败！");
        return NO;
    }
    
    BOOL isSucess = [db executeUpdate:@"insert into WeiboDataBases(id, mid, idstr, userIDstr,userName, created_at, text, source, favorited, truncated, retweeted_status_id, reposts_count, comments_count, attitudes_count) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithInteger:weibo.ID], [NSNumber numberWithInteger:weibo.MID], weibo.idstr, weibo.userInfo.userIDstr,weibo.userInfo.name, weibo.created_at, weibo.text, weibo.source, [NSNumber numberWithBool:weibo.favorited], [NSNumber numberWithBool:weibo.truncated], [NSNumber numberWithInt:weibo.retweetedWeibo.ID], [NSNumber numberWithInteger:weibo.reposts_count], [NSNumber numberWithInteger:weibo.comments_count], [NSNumber numberWithInteger:weibo.attitudes_count]];
    
    [db close];
    return isSucess;
}

+ (BOOL)updateWithWeibo:(WeiBoContext *)weibo andWeiboDBID:(NSInteger)ID
{
    NSLog(@"%s", __func__);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[WeiboDataBase getPathDB]];
    
    if (![db open]) {
        NSLog(@"数据库打开失败！");
        return NO;
    }
    
    BOOL isSucess = [db executeUpdate:@"update WeiboDataBases set id = ?, mid = ?, idstr = ?,userIDstr = ?,userName = ?, created_at = ?, text = ?, source = ?, favorited = ?, truncated = ?, retweeted_status_id = ?, reposts_count = ?, comments_count = ?, attitudes_count = ? where id = ?", [NSNumber numberWithInteger:weibo.ID], [NSNumber numberWithInteger:weibo.MID], weibo.idstr, weibo.userInfo.userIDstr, weibo.userInfo.name, weibo.created_at, weibo.text, weibo.source, [NSNumber numberWithBool:weibo.favorited], [NSNumber numberWithBool:weibo.truncated], weibo.retweeted_status, [NSNumber numberWithInteger:weibo.reposts_count], [NSNumber numberWithInteger:weibo.comments_count], [NSNumber numberWithInteger:weibo.attitudes_count], [NSNumber numberWithInteger:ID]];
    
    [db close];
    
    return isSucess;
}

+ (NSDictionary *)findOneWeibo:(NSString *)weiboID
{

    FMDatabase *db = [FMDatabase databaseWithPath:[WeiboDataBase getPathDB]];
    
    if (![db open]) {
        NSLog(@"数据库打开失败！");
        return NO;
    }
    
    FMResultSet *rs = [db executeQuery:@"select * from WeiboDataBases where id = ?", weiboID];
    NSDictionary *dic = [rs resultDictionary];
    
    return dic;
}

+ (NSMutableArray *)findAll
{
    NSLog(@"%s", __func__);
    
    __autoreleasing NSMutableArray *array = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[WeiboDataBase getPathDB]];
    
    if (![db open]) {
        NSLog(@"数据库打开失败！");
        return NO;
    }
    
    FMResultSet *rs = [db executeQuery:@"select * from WeiboDataBases"];
    
    while ([rs next]) {
        NSDictionary *dic = [rs resultDictionary];
        WeiBoContext *weibo = [[WeiBoContext alloc] initWithWeibo:dic];
        
        NSString *userName = [dic objectForKey:@"userName"];
        weibo.userInfo.name = userName;
        
        NSString *path = [HomeViewController getImagePath:@"headImage"];
        NSString *userID = [dic objectForKey:@"userIDstr"];
        NSString *str = [userID stringByAppendingFormat:@".jpg"];
        NSString *headImagePath = [path stringByAppendingPathComponent:str];
        NSFileManager *file = [NSFileManager defaultManager];
        if ([file fileExistsAtPath:headImagePath]) {
            weibo.headImage = [UIImage imageWithContentsOfFile:headImagePath];
        }
        
        NSString *path2 = [HomeViewController getImagePath:@"weiboImage"];
        
        NSString *retWeiboID = [dic objectForKey:@"retweeted_statuses_id"];
        if (retWeiboID.length > 0) {
            weibo.retweetedWeibo = [[WeiBoContext alloc] initWithWeibo:[WeiboDataBase findOneWeibo:retWeiboID]];
            NSString *str1 = [retWeiboID stringByAppendingFormat:@".jpg"];
            NSString *retImagePath = [path2 stringByAppendingPathComponent:str1];
            weibo.retweetedWeibo.thumbnailImage = [UIImage imageWithContentsOfFile:retImagePath];
        }
        else
        {
            NSString *str2 = [weibo.idstr stringByAppendingFormat:@".jpg"];
            NSString *weiboImagePath = [path2 stringByAppendingPathComponent:str2];
            weibo.thumbnailImage = [UIImage imageWithContentsOfFile:weiboImagePath];
        }
        
        
        
        
        [array addObject:weibo];
    }
    
    [db close];
    
    return array;
    
}

+ (BOOL)deleteDataByID:(int)aID
{
    NSLog(@"%s", __func__);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[WeiboDataBase getPathDB]];
    
    if (![db open]) {
        NSLog(@"数据库打开失败！");
    }
    
    BOOL isSucess = [db executeUpdate:@"delete from WeiboDataBases where id = ?", [NSNumber numberWithInt:aID]];
    
    if (isSucess) {
        NSLog(@"删除成功！");
    }
    
    [db close];
    
    return YES;
    
}


@end
