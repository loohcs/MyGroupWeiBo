//
//  WeiboView.h
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-28.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"

@interface WeiboView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tabelView;
    NSMutableArray *_heightArray;
    TQRichTextView *_richTextView;
    
    NSMutableArray *_screenNameWidthArr;
    NSMutableArray *_sourceWidthArr;
}

@property (nonatomic,retain)NSArray *textArray;
@property (nonatomic,retain)NSArray *imageArray;
@property (nonatomic, strong)NSArray *headImageUrlArray;
@property (nonatomic, strong)NSArray *headImageArray;
@property (nonatomic, strong)NSArray *userScreenNameArray;
@property (nonatomic, strong)NSArray *sourceArray;
@property (nonatomic, strong)NSArray *timeArray;

-(void)initWithTabelView;

@end
