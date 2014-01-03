//
//  BaseViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    UIWebView *detailWebView;
    BOOL reloading;
}

//@property (nonatomic, strong) UIImageView *imageView;


-(void)creatWebView:(NSURL *)URL;
-(void)reloadTableViewDataSource;
-(void)doneloadingData;

@end
