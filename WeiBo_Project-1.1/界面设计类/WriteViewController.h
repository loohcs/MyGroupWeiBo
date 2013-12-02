//
//  WriteViewController.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"

@interface WriteViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextView *_textView;
    UIView *_keyBoardView;
}

@end
