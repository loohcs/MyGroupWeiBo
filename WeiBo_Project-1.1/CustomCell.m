//
//  CustomCell.m
//  IbokanProjects
//
//  Created by 1007 on 13-11-12.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)Cell reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:Cell reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _imgv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
        [self addSubview:_imgv];
        //设置附属按钮的类型
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 15)];
        _userName.numberOfLines = 2;
        [self addSubview:_userName];
        
        _text = [[TQRichTextView alloc] initWithFrame:CGRectMake(60, 50, 200, 20)];
        [self addSubview:_text];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 200, 20)];
        [self addSubview:_timeLabel];
        
    }
    return self;
}

- (void)viewCommentForWeibo:(Comment *)oneComment
{
    self.userName.text = oneComment.userInfo.name;
    self.userName.font = [UIFont systemFontOfSize:12.0f];
    self.userName.textColor = [UIColor redColor];
    NSString *name = oneComment.userInfo.name;
    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(200, 15)];
    self.userName.frame = CGRectMake(60, 5, nameSize.width, 15);
    
    NSString *text = oneComment.text;
    self.text.font = [UIFont systemFontOfSize:13.0f];
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(200, 1000)];
    self.text.frame = CGRectMake(60, 25, 240, textSize.height);
    self.text.backgroundColor = [UIColor clearColor];
    self.text.text = oneComment.text;
    
    
    NSString *created_at = oneComment.created_at;
    NSString *time = [DateHelper changDateWithString:created_at];
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:10.0f] constrainedToSize:CGSizeMake(200, 10)];
    self.timeLabel.frame = CGRectMake(60, 30+textSize.height, timeSize.width, 10);
    self.timeLabel.textColor = [UIColor blueColor];
    self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
    self.timeLabel.text = time;
    
    self.imgv.frame = CGRectMake(15, 5, 25, 25);
    self.imgv.image = oneComment.headImage;
    
    self.frame = CGRectMake(0, 0, 320, nameSize.height + textSize.height + timeSize.height + 15 );
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
