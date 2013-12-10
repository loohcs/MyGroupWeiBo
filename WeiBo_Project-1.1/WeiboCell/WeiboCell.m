//
//  WeiboCell.m
//  WeiBo_Project
//
//  Created by 1007 on 13-12-8.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "WeiboCell.h"

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.frame = CGRectMake(65, 5, 200, 25);
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        self.decLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.decLabel.font = [UIFont systemFontOfSize:10];
        self.decLabel.backgroundColor = [UIColor clearColor];
        self.decLabel.frame = CGRectMake(105, 30, 200, 10);
        self.decLabel.textColor = [UIColor grayColor];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = [UIColor redColor];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.frame = CGRectMake(65, 30, 80, 10);
        
        self.richText =[[TQRichTextView alloc]init];
        self.richText.font = [UIFont systemFontOfSize:13];
        self.richText.backgroundColor = [UIColor clearColor];
        
        self.weiboImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 120, 80)];
        
        self.headImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.headImage.frame = CGRectMake(20, 10, 30, 30);
        
        
        self.retWeiboView = [[UIView alloc] initWithFrame:CGRectZero];
        self.retWeiboView.backgroundColor = [UIColor grayColor];
        
        self.retWeiboText = [[TQRichTextView alloc] init];
        self.retWeiboText.font = [UIFont systemFontOfSize:12];
        self.retWeiboText.backgroundColor = [UIColor clearColor];
        
        self.retWeiboImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.retweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.decLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.weiboImage];
        [self addSubview:self.headImage];
        [self addSubview:self.commentButton];

        [self addSubview:self.praiseButton];
        [self addSubview:self.richText];
        [self addSubview:self.retweetButton];
        
        //[self.retWeiboView addSubview:self.retWeiboImage];
        //[self.retWeiboView addSubview:self.retWeiboText];
        [self addSubview:self.retWeiboView];
        
    }
    return self;
}

- (void)viewWeiboContex:(WeiBoContext *)weibo
{
    //添加用户名称
    NSString *name = weibo.userInfo.name;
    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 15)];
    self.nameLabel.frame = CGRectMake(65, 5, nameSize.width, nameSize.height);
    self.nameLabel.text = name;
    
    //添加微博创建时间
    NSString *created_at = weibo.created_at;
    NSString *time = [DateHelper changDateWithString:created_at];
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(200, 10)];
    self.timeLabel.frame = CGRectMake(65, 25, timeSize.width, timeSize.height);
    self.timeLabel.text = time;
    
    //添加微博来源
    NSString *source = weibo.source;
    NSArray *sourceArr1 = [source componentsSeparatedByString:@">"];
    NSArray *sourceArr2 = [[sourceArr1 objectAtIndex:1] componentsSeparatedByString:@"<"];
    NSString *sourceText = [sourceArr2 objectAtIndex:0];
    NSString *sourceText1 = @"来自：";
    NSString *sourceText2 = [sourceText1 stringByAppendingString:sourceText];
    CGSize sourceSize = [sourceText2 sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(200, 15)];
    self.decLabel.frame = CGRectMake(65+timeSize.width+10, 25, sourceSize.width, sourceSize.height);
    self.decLabel.text = sourceText2;
    
    self.headImage.image = weibo.headImage;
    self.headImage.frame = CGRectMake(20, 5, 30, 30);
    
    //添加微博的主要内容
    NSString *text = weibo.text;
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000)];
    self.richText.frame = CGRectMake(20, 50, textSize.width, textSize.height);
    //self.richText.backgroundColor = [UIColor cyanColor];
    self.richText.text = text;
    
    //添加转发微博内容
    if (weibo.retweetedWeibo != nil) {
        self.retWeiboView.hidden = NO;
        NSString *retText = weibo.retweetedWeibo.text;
        NSString *retWeiboWriter = weibo.retweetedWeibo.userInfo.name;
        NSString *at = @"@";
        NSString *str1 = [at stringByAppendingFormat:@"%@:", retWeiboWriter];
        NSString *string = [str1 stringByAppendingString:retText];
        CGSize retTextSize = [string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, 1000)];
        self.retWeiboText.frame = CGRectMake(5, 5, retTextSize.width, retTextSize.height);
        self.retWeiboText.text = string;
        
        UIImage *retImage = weibo.retweetedWeibo.thumbnailImage;
        self.retWeiboImage.frame = CGRectMake(5, 5 + retTextSize.height, retImage.size.width, retImage.size.height);
        self.retWeiboImage.image = retImage;
        
        self.retWeiboView.frame = CGRectMake(20, 50 + textSize.height, 280, retTextSize.height + retImage.size.height + 10);
        [self.retWeiboView addSubview:self.retWeiboText];
        [self.retWeiboView addSubview:self.retWeiboImage];
    }
    else
    {
//        self.retWeiboView = [[UIView alloc] initWithFrame:CGRectZero];
//        self.retWeiboView.backgroundColor = [UIColor grayColor];
//        
//        self.retWeiboText = [[TQRichTextView alloc] init];
//        self.retWeiboText.font = [UIFont systemFontOfSize:12];
//        self.retWeiboText.backgroundColor = [UIColor clearColor];
//        
//        self.retWeiboImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    CGFloat height = [WeiboCell getSize:weibo];
    
    //添加微博图片
    UIImage *image = weibo.thumbnailImage;
    self.weiboImage.frame = CGRectMake(20, 50 + textSize.height + 5, image.size.width, image.size.height);
    self.weiboImage.image = image;
    
    
    
    
    //添加微博下方的三个按钮
    self.retweetButton.frame = CGRectMake(10,  height-50, 100, 40);
    self.retweetButton.backgroundColor = [UIColor lightGrayColor];
    [self.retweetButton setTitle:@"转发" forState:UIControlStateNormal];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"toolbar_icon_retweet_os7@2x" ofType:@"png"];
    UIImage *retBtnImage = [UIImage imageWithContentsOfFile:path];
    [self.retweetButton setImage:retBtnImage forState:UIControlStateNormal];
    
    self.commentButton.frame = CGRectMake(110,  height-50, 100, 40);
    self.commentButton.backgroundColor = [UIColor lightGrayColor];
    [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"toolbar_icon_comment_os7@2x" ofType:@"png"];
    UIImage *comBtnImage = [UIImage imageWithContentsOfFile:path1];
    [self.commentButton setImage:comBtnImage forState:UIControlStateNormal];
    
    self.praiseButton.frame = CGRectMake(210,  height-50, 100, 40);
    self.praiseButton.backgroundColor = [UIColor lightGrayColor];
    [self.praiseButton setTitle:@"赞" forState:UIControlStateNormal];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"toolbar_icon_unlike_os7@2x" ofType:@"png"];
    UIImage *praBtnImage = [UIImage imageWithContentsOfFile:path2];
    [self.praiseButton setImage:praBtnImage forState:UIControlStateNormal];
 
    
#warning mark -- 下面的方法下载微博多张图片时，微博高度的计算，以及将图片贴上cell
    /*
//    CGSize weiboImageSize = CGSizeZero;
//    UIImageView *weiboImageTemp = [[UIImageView alloc] initWithFrame:CGRectMake(20, height, image.size.width, image.size.height)];
//    
//    if (weibo.weiboPics.count == 1 || weibo.weiboPics.count == 2) {
//        weiboImageSize = CGSizeMake(image.size.width * weibo.weiboPics.count, image.size.height);
//        for (int i = 0; i< weibo.weiboPics.count; i++) {
//            UIImageView *imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake((5 + image.size.width)*i, 5, image.size.width, image.size.height)];
//            UIImage *imageTemp = [weibo.weiboPics objectAtIndex:i];
//            imageViewTemp.image = imageTemp;
//            [weiboImageTemp addSubview:imageViewTemp];
//        }
//    }
//    if (weibo.weiboPics.count == 4 || weibo.weiboPics.count == 6) {
//        weiboImageSize = CGSizeMake(image.size.width * (weibo.weiboPics.count/2), image.size.height * 2 + 10);
//        for (int i = 0; i< weibo.weiboPics.count; i++) {
//            UIImageView *imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectZero];
//            if ((5 + image.size.width)*i < 280) {
//                imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake((5 + image.size.width)*i, 5, image.size.width, image.size.height)];
//                
//            }
//            else
//            {
//                imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake((5 + image.size.width)*(weibo.weiboPics.count - 1 - i), 5+image.size.height, image.size.width, image.size.height)];
//            }
//            UIImage *imageTemp = [weibo.weiboPics objectAtIndex:i];
//            imageViewTemp.image = imageTemp;
//            [weiboImageTemp addSubview:imageViewTemp];
//        }
//    }
//    if (weibo.weiboPics.count >6) {
//        if (image.size.width * 3 > 280) {
//            
//            weiboImageSize = CGSizeMake(280, 280*image.size.height/image.size.width);
//        }
//        else
//        {
//            weiboImageSize = CGSizeMake(image.size.width * 3, image.size.height * 3 + 20);
//        }
//    }
//    
//    [self.imageView addSubview:weiboImageTemp];

//    if (weibo.retweeted_status != nil) {
//        self.retWeiboView = [[WeiboCell alloc] initWithFrame:CGRectZero];
//        self.retWeiboView.backgroundColor = [UIColor clearColor];
//        WeiBoContext *retweetedWeibo = [[WeiBoContext alloc] initWithWeibo:(NSDictionary *)weibo.retweeted_status];
//        NSString *retText = retweetedWeibo.text;
//        CGSize retTextSize = [retText sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000)];
//        self.retWeiboView.richText.frame = CGRectMake(20, 50, retTextSize.width, retTextSize.height);
//        self.retWeiboView.richText.backgroundColor = [UIColor cyanColor];
//        self.retWeiboView.richText.text = retText;
//    }
     */
     
     
}


#pragma mark -- 类方法，可以获得整个微博cell的高度
+ (CGFloat)getSize:(WeiBoContext *)weibo
{

    //获得微博文本高度
    NSString *text = weibo.text;
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000)];
    
    
    //获得微博图片高度
    UIImage *image = weibo.thumbnailImage;
    
    CGSize weiboImageSize = image.size;
    
    //多张图片的高度计算
//    if (weibo.weiboPics.count == 1 || weibo.weiboPics.count == 2) {
//        weiboImageSize = CGSizeMake(image.size.width * weibo.weiboPics.count, image.size.height);
//    }
//    if (weibo.weiboPics.count == 4 || weibo.weiboPics.count == 6) {
//        weiboImageSize = CGSizeMake(image.size.width * (weibo.weiboPics.count/2), image.size.height * 2 + 10);
//    }
//    if (weibo.weiboPics.count >6) {
//        if (image.size.width * 3 > 280) {
//            
//            weiboImageSize = CGSizeMake(280, 280*image.size.height/image.size.width);
//        }
//        else
//        {
//            weiboImageSize = CGSizeMake(image.size.width * 3, image.size.height * 3 + 20);
//        }
//    }

    CGSize retTextSize = CGSizeZero;
    UIImage *retImage = [[UIImage alloc] init];
    
    if (weibo.retweeted_status != nil) {
        NSString *retText = weibo.retweetedWeibo.text;
        NSString *retWeiboWriter = weibo.retweetedWeibo.userInfo.name;
        NSString *at = @"@";
        NSString *str1 = [at stringByAppendingFormat:@"%@:", retWeiboWriter];
        NSString *string = [str1 stringByAppendingString:retText];
        retTextSize = [string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, 1000)];
        retImage = weibo.retweetedWeibo.thumbnailImage;
    }
    
    
    float height = 50 + 60 + textSize.height + weiboImageSize.height + retTextSize.height + retImage.size.height;
    
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
