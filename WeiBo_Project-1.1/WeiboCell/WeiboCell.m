//
//  WeiboCell.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-28.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "WeiboCell.h"
@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLabel.font = [UIFont systemFontOfSize:10];
        self.nameLabel.frame = CGRectMake(65, 5, 100, 25);
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.decLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.decLabel.font = [UIFont systemFontOfSize:6];
        self.decLabel.backgroundColor = [UIColor clearColor];
        self.decLabel.frame = CGRectMake(105, 30, 80, 10);
        self.decLabel.textColor = [UIColor grayColor];
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.timeLabel.font = [UIFont systemFontOfSize:6];
        self.timeLabel.textColor = [UIColor redColor];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.frame = CGRectMake(65, 30, 80, 10);
        self.richText =[[TQRichTextView alloc]init];
        self.richText.font = [UIFont systemFontOfSize:15];
        self.richText.backgroundColor = [UIColor clearColor];
        self.weiboImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.headImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.headImage.frame = CGRectMake(20, 10, 30, 30);
        self.commentButton = [[UIButton alloc]initWithFrame:CGRectZero];
        self.repeatButton = [[UIButton alloc]initWithFrame:CGRectZero];
        self.praiseButton = [[UIButton alloc]initWithFrame:CGRectZero];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.decLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.weiboImage];
        [self addSubview:self.headImage];
        [self addSubview:self.commentButton];
        [self addSubview:self.repeatButton];
        [self addSubview:self.praiseButton];
        [self addSubview:self.richText];
        
                
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
