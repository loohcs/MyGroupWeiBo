//
//  FindFriendCell.m
//  WeiBo_Project
//
//  Created by xzx on 13-12-10.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "FindFriendCell.h"
#import "UIViewExt.h"
@implementation FindFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(250, 5, 20, 20)];
        [self.contentView addSubview:self.sexImage];
        self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self.contentView addSubview:self.headImage];
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 120, 30)];
        self.nameLable.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.nameLable];
        self.distance = [[UILabel alloc]initWithFrame:CGRectMake(100, self.nameLable.bottom, 150, 15)];
        self.distance.textColor = [UIColor grayColor];
        self.distance.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.distance];
        self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, self.distance.bottom, 240, 30)];
        self.descriptionLabel.font = [UIFont systemFontOfSize:15];
        self.descriptionLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.descriptionLabel];
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
