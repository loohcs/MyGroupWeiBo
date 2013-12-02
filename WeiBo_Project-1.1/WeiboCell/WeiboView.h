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
}
@property (nonatomic,retain)NSArray *textArray;
@property (nonatomic,retain)NSArray *imageArray;

-(void)initWithTabelView;
@end
