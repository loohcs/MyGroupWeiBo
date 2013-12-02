//
//  AppDelegate.m
//  WeiBo_Project
//
//  Created by 1007 on 13-11-27.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "CustomTabbarController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"accessToken"])
    {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        request.scope = @"all";
        [WeiboSDK sendRequest:request];
    }
    else
    {
        CustomTabbarController *tabBar = [[CustomTabbarController alloc]init];
        self.window.rootViewController = tabBar;
    }

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSLog(@"%@", result);
}

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"收到请求的响应！");
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"收到微博数据请求！");
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:((WBAuthorizeResponse *)response).accessToken forKey:@"accessToken"];
    NSLog(@"accessToken = %@", [defaults objectForKey:@"accessToken"]);
    RootViewController *rootVC = [[RootViewController alloc]init];
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window.rootViewController = naviController;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
