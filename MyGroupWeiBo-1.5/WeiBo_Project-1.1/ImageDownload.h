//
//  ImageDownload.h
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-27.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Block_fun)(NSMutableData *datas,float progressNum);

@interface ImageDownload : NSObject
{
    NSMutableData *receiveData;
    Block_fun block_data;
    long long AllLength;
}

//初始化方法
-(ImageDownload *)initWithURlString:(NSString *)urlStr;
//block方法
-(void)setBlock:(Block_fun) aBlock;

@end
