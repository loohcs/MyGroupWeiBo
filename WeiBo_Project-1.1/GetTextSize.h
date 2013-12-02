//
//  GetTextSize.h
//  WeiBo_Project
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTextSize : NSObject

- (CGSize)getTextSizeWithWidth:(NSString *)aText
                       andFont:(NSInteger)fontSize
                      andWidth:(float)textWidth;

- (CGSize)getTextSizeWithHeight:(NSString *)aText
                       andFont:(NSInteger)fontSize
                      andHeitht:(float)textHeight;

@end
