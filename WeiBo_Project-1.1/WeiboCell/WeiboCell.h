//
//  WeiboCell.h
//  WeiBo_Project
//
//  Created by 1007 on 13-12-8.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *decLabel;
@property (strong, nonatomic)  UIImageView *weiboImage;
@property (strong, nonatomic)  UIButton *commentButton;
@property (strong, nonatomic)  UIButton *retweetButton;
@property (strong, nonatomic)  UIButton *praiseButton;
@property (strong, nonatomic)  TQRichTextView *richText;

@property (strong, nonatomic)  UIView *retWeiboView;
@property (strong, nonatomic)  TQRichTextView *retWeiboText;
@property (strong, nonatomic)  UIImageView *retWeiboImage;

- (void)viewWeiboContex:(WeiBoContext *)weibo;

+ (CGFloat)getSize:(WeiBoContext *)weibo;

@end
