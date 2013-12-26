//
//  SinaNewsViewController.h
//  WeiBo_Project
//
//  Created by 1014 on 13-12-16.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CreatCustomNaBar.h"
@interface SinaNewsViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate>
{
    UIView *view;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UITextField *textURL;
@property (nonatomic, retain) UIWebView *webView;
@end
