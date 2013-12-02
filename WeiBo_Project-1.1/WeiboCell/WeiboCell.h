//
//  WeiboCell.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-28.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"
@interface WeiboCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *decLabel;
@property (strong, nonatomic)  UIImageView *weiboImage;
@property (strong, nonatomic)  UIButton *commentButton;
@property (strong, nonatomic)  UIButton *repeatButton;
@property (strong, nonatomic)  UIButton *praiseButton;
@property (strong, nonatomic)  TQRichTextView *richText;
@end
