//
//  CustomCell.h
//  IbokanProjects
//
//  Created by 1007 on 13-11-12.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (nonatomic,retain) UIImageView * imgv;
@property (nonatomic,retain) UILabel * userName;
@property (nonatomic,retain) TQRichTextView * text;
@property (nonatomic, strong) UILabel *timeLabel;

- (void)viewCommentForWeibo:(Comment *)oneComment;

@end
