//
//  ImageDownload.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-27.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "ImageDownload.h"

@implementation ImageDownload

-(ImageDownload *)initWithURlString:(NSString *)urlStr
{
    self=[super init];
    if (self)
    {
        NSURL *url=[NSURL URLWithString:urlStr];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    return self;
}

//块方法
-(void)setBlock:(Block_fun)aBlock
{
    if (block_data!=aBlock)
    {
        Block_release(block_data);
        block_data=Block_copy(aBlock);
    }
}

//响应请求
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receiveData=[[NSMutableData alloc] initWithCapacity:0];
    AllLength=[response expectedContentLength];
}

//下载数据时调用的方法
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
    long long currentDataLength=[receiveData length];
    if (block_data)
    {
        block_data(receiveData,((float)currentDataLength)/AllLength);
    }
}

//下载完毕时调用
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //下载完毕要做的事
    // [self.delegate sendReceiveData:receiveData];
}

//网络链接出错时调用
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"出错原因：%@", [error localizedDescription]);
}

- (void)dealloc
{
    [receiveData release];
    Block_release(block_data);
    [super dealloc];
}

@end
