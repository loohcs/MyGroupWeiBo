//
//  GetTextSize.m
//  WeiBo_Project
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "GetTextSize.h"

@implementation GetTextSize

- (CGSize)getTextSizeWithWidth:(NSString *)aText
                       andFont:(NSInteger)fontSize
                      andWidth:(float)textWidth
{
    //列宽
    CGFloat contentWidth = textWidth;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    //该行要显示的内容
    NSString *content = aText;
    //计算出显示完内容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000)];

    return size;
}

- (CGSize)getTextSizeWithHeight:(NSString *)aText andFont:(NSInteger)fontSize andHeitht:(float)textHeight
{
    //列宽
    CGFloat contentHeight = textHeight;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    //该行要显示的内容
    NSString *content = aText;
    //计算出显示完内容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(1000, contentHeight)];
    
    return size;
}

@end
