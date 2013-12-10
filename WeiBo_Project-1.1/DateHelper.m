//
//  DateHelper.m
//  LDG_Weibo
//
//  Created by SevenJustin on 13-12-2.
//  Copyright (c) 2013年 郭威. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+(NSString *)changDateWithString:(NSString *)aString
{
    //解析微博时间 /////Fri Nov 29 19:45:49 +0800 2013
    // NSString *tepStr;
    //aString =@"Fri Nov 29 19:45:49 +0800 2013";
    
    //初始化一个日期格式
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    //强制设置为美国时间 必须设置，否则无法解析
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    //转换微博时间为日期格式
    NSDate *date=[iosDateFormater dateFromString:aString];
    
    //获取当前时间     ///// 2013-11-30 05:57:01 +0000
    NSDate *myDate = [NSDate date];
    //NSLog(@"myDate = %@",myDate);
    
    //获取时间间隔
    NSTimeInterval secondsBetweenDates= [myDate timeIntervalSinceDate:date];
    secondsBetweenDates /= 60;
    //NSLog(@"-------  %lf",secondsBetweenDates);
    
    if (secondsBetweenDates<30) {
        return [NSString stringWithFormat:@"%d分钟前",(int)secondsBetweenDates];
    }
    else if (secondsBetweenDates>=30&&secondsBetweenDates<=40)
    {
        return @"半小时前" ;
    }
    else if (secondsBetweenDates>40&&secondsBetweenDates<60 )
    {
        return [NSString stringWithFormat:@"%d分钟前",(int)secondsBetweenDates];
    }
    else if (secondsBetweenDates>=60&&secondsBetweenDates<60*24)
    {
        return [NSString stringWithFormat:@"%d小时前",(int)(secondsBetweenDates/60)];
    }
    else{
        // 目的格式
        NSDateFormatter *resultFormatter=[[NSDateFormatter alloc]init];
        //[resultFormatter setDateFormat:@"MM月dd日 HH:mm"];
        [resultFormatter setDateFormat:@"MM月dd日"];
        
        
        //输出格式
        NSLog(@" %@",[DateHelper NSDateToNSString:date withFormatter:resultFormatter]);
        
        return [DateHelper NSDateToNSString:date withFormatter:resultFormatter];
    }
}

+(NSString*)NSDateToNSString:(NSDate*)date withFormatter:(NSDateFormatter*)formatter
{
    NSString *dateString=[formatter stringFromDate:date];
    return dateString;
}

@end
