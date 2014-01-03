//
//  DeleteImageINBundle.m
//  WeiBo_Project
//
//  Created by 1007 on 13-12-18.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "DeleteImageINBundle.h"

@implementation DeleteImageINBundle

+ (void)getImageAttribute
{
//    NSString *headImageDirectory = [HomeViewController getImagePath:@"headImage"];
    NSString *weiboImageDirectory = [HomeViewController getImagePath:@"weiboImage"];
    
    
    
    NSMutableDictionary *fileNameWithTime = [[NSMutableDictionary alloc] init];
    NSArray *sortedByTime = [[NSArray alloc] init];
    
    NSFileManager *file = [NSFileManager defaultManager];
    NSError *error = nil;
    
    
    NSDictionary *directoryAttribution = [file attributesOfItemAtPath:weiboImageDirectory error:&error];
    NSLog(@"%@", directoryAttribution);
    
    if ([file fileExistsAtPath:weiboImageDirectory]) {
        NSArray *array = [file subpathsOfDirectoryAtPath:weiboImageDirectory error:&error];
        //NSLog(@"%@", array);
        
        for (int i = 1; i< array.count; i++) {
            NSString *imageName = [array objectAtIndex:i];
            NSString *imagePath = [weiboImageDirectory stringByAppendingPathComponent:imageName];
            if ([file fileExistsAtPath:imagePath])
            {
                NSDictionary *dicTemp = [file attributesOfItemAtPath:imagePath error:&error];
                NSDate *creatDate = [dicTemp objectForKey:@"NSFileCreationDate"];
                
                NSLog(@"%@", creatDate);
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setAMSymbol:@"AM"];
                [format setPMSymbol:@"PM"];
                [format setDateFormat:@"YYYY-MM-dd HH:mm:ss aaaa"];
                NSString *strTemp = [format stringFromDate:creatDate];
                NSLog(@"%@", strTemp);
                
                
                //NSLog(@"%@------%@", creatDate, imageName);
                
                [fileNameWithTime setObject:creatDate forKey:imageName];
            }
        }
        
        sortedByTime = [fileNameWithTime keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *date1 = (NSDate *)obj1;
            NSDate *date2 = (NSDate *)obj2;
            
            NSComparisonResult result = [date1 compare:date2];
            return result;
        }];
        NSLog(@"%@", sortedByTime);
    }
    
}

@end
