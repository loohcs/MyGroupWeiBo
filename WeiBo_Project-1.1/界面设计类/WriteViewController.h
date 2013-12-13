//
//  WriteViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"
#import "URLEncode.h"

//发送内容的类型
typedef enum{
    sendWeiboContex,//发微博
    repotWeiboContex,//转发微博
    sendWeiboComment,//发表微博评论
}ContexStyle;

@interface WriteViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, WBHttpRequestDelegate,UIScrollViewDelegate>
{
    UITextView *_textView;//存放并且显示输入内容
    UIView *_keyBoardView;//显示键盘
    UIPageControl *_page;//控制表情的scrollView的页面
    NSArray *_emoArr;//存放表情的名字
    NSMutableArray *_strArr;//存放输入的字符串
}

@property (nonatomic, assign) ContexStyle style;//发送内容的类型
@property (nonatomic, strong) UIScrollView *emoScrollView;//贴表情的view
@property (nonatomic, assign) int isEmotionsPushed;

@property (nonatomic, strong)UIView *weiboView;//在转发微博的时候，将被显示

@property (nonatomic, strong)WeiBoContext *weiboContext;

- (void)addWeiboContex:(WeiBoContext *)oneWeiboContex andContexStyle:(ContexStyle)aStyle;


@end