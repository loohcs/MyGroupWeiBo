//
//  WriteViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"

@interface WriteViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, WBHttpRequestDelegate>
{
    UITextView *_textView;
    UIView *_keyBoardView;
    
    NSArray *emoNameArr;//存放表情的名字
}

@property (nonatomic, strong) UIScrollView *emoScrollView;//贴表情的view
@property (nonatomic, assign) int isEmotionsPushed;


@end
