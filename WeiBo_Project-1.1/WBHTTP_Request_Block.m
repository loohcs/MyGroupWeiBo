//
//  WBHTTP_Request_Block.m
//  Weibo_Test-0001
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "WBHTTP_Request_Block.h"

@implementation WBHTTP_Request_Block

-(WBHTTP_Request_Block *)initWithURlString:(NSString *)urlStr andArguments:(NSDictionary *)dic
{
    self=[super init];
    if (self)
    {
        NSLog(@"%s", __func__);
        NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
        [WBHttpRequest requestWithAccessToken:[defaluts objectForKey:@"accessToken"] url:urlStr httpMethod:@"GET" params:dic delegate:self];
    }
    return self;
}

//块方法
-(void)setBlock:(WB_Block_fun)aBlock
{
    if (block_data!=aBlock)
    {
        Block_release(block_data);
        block_data=Block_copy(aBlock);
    }
}

//响应请求
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s", __func__);
    NSLog(@"收到微博数据请求！！！");
    receiveData=[[NSMutableData alloc] initWithCapacity:0];
    AllLength=[response expectedContentLength];
}

//完成请求
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSLog(@"%s", __func__);
    receiveData = [[NSMutableData alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding]];
    block_data(receiveData, 1.0f);
    NSLog(@"%@", result);
}

//请求出错
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    NSLog(@"%@", error);
}

////响应请求
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    receiveData=[[NSMutableData alloc] initWithCapacity:0];
//    AllLength=[response expectedContentLength];
//}
//
////下载数据时调用的方法
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [receiveData appendData:data];
//    long long currentDataLength=[receiveData length];
//    if (block_data)
//    {
//        block_data(receiveData,((float)currentDataLength)/AllLength);
//    }
//}
//
////下载完毕时调用
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    //下载完毕要做的事
//    // [self.delegate sendReceiveData:receiveData];
//}
//
////网络链接出错时调用
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSLog(@"出错原因：%@", [error localizedDescription]);
//}

- (void)dealloc
{
    [receiveData release];
    Block_release(block_data);
    [super dealloc];
}

@end
