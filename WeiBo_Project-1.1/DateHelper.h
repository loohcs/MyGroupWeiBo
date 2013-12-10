//
//  DateHelper.h
//  LDG_Weibo
//
//  Created by SevenJustin on 13-12-2.
//  Copyright (c) 2013年 郭威. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+(NSString *)changDateWithString:(NSString *)aString;
+(NSString*)NSDateToNSString:(NSDate*)date withFormatter:(NSDateFormatter*)formatter;

@end
