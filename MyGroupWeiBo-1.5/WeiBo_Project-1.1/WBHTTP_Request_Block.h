//
//  WBHTTP_Request_Block.h
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WB_Block_fun)(NSMutableData *datas,float progressNum);

@interface WBHTTP_Request_Block : NSObject<WBHttpRequestDelegate>
{
    NSMutableData *receiveData;
    WB_Block_fun block_data;
    long long AllLength;
}

//初始化方法
-(WBHTTP_Request_Block *)initWithURlString:(NSString *)urlStr andArguments:(NSDictionary *)dic;
//block方法
-(void)setBlock:(WB_Block_fun) aBlock;

@end
