//
//  WeiboView.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-28.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "WeiboView.h"
#import "WeiboCell.h"
#import "TQRichTextView.h"
@implementation WeiboView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _heightArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}

-(void)initWithTabelView
{
    _tabelView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource =self;
    [self addSubview:_tabelView];
  
    for (int i=0; i<self.textArray.count; i++)
    {
        NSString *str = [self.textArray objectAtIndex:i];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(320, 1000)];
        NSNumber *height= [NSNumber numberWithFloat:size.height];
        [_heightArray addObject:height];
    }
   
   
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[_heightArray objectAtIndex:indexPath.section]floatValue];
    return height+50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    WeiboCell *cell = (WeiboCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.richText.text = [self.textArray objectAtIndex:indexPath.section];
    cell.richText.frame = CGRectMake(20, 50, 280,[[_heightArray objectAtIndex:indexPath.section]floatValue]);
    return cell;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
