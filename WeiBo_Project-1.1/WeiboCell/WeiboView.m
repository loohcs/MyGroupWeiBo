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
        _screenNameWidthArr = [[NSMutableArray alloc] init];
        _userScreenNameArray = [[NSMutableArray alloc] init];
        _sourceWidthArr = [[NSMutableArray alloc] init];
        _sourceArray = [[NSMutableArray alloc] init];
        _timeArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)initWithTabelView
{
    _tabelView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource =self;
    [self addSubview:_tabelView];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    __weak WeiboView *weiboView = self;
    
    for (int i=0; i<self.textArray.count; i++)
    {
        NSString *str = [self.textArray objectAtIndex:i];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 1000)];
        NSNumber *height= [NSNumber numberWithFloat:size.height];
        [_heightArray addObject:height];
        
        NSString *url = [self.headImageUrlArray objectAtIndex:i];
        ImageDownload *imageDownStatuses = [[ImageDownload alloc] initWithURlString:url];
        
        [imageDownStatuses setBlock:^(NSMutableData *datas, float progressNum) {
            UIImage *image = [UIImage imageWithData:datas];
            [arr addObject:image];
            [weiboView getHeadImage:arr];
        }];
        
        NSString *screenName = [self.userScreenNameArray objectAtIndex:i];
        CGSize sNameSize = [screenName sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(200, 25)];
        NSNumber *width = [NSNumber numberWithFloat:sNameSize.width];
        [_screenNameWidthArr addObject:width];
        
        NSString *source = [self.sourceArray objectAtIndex:i];
        CGSize sourceSize = [source sizeWithFont:[UIFont systemFontOfSize:6] constrainedToSize:CGSizeMake(200, 10)];
        NSNumber *sourceWidth = [NSNumber numberWithFloat:sourceSize.width];
        [_sourceWidthArr addObject:sourceWidth];
    }
    
}

- (void)getHeadImage:(NSMutableArray *)arr
{
    NSLog(@"%s", __func__);
    self.headImageArray = [[NSMutableArray alloc] initWithArray:arr];
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
    cell.headImage.image = [self.headImageArray objectAtIndex:indexPath.section];
    cell.nameLabel.frame = CGRectMake(65, 5, [[_screenNameWidthArr objectAtIndex:indexPath.section] floatValue], 25);
    cell.nameLabel.text = [self.userScreenNameArray objectAtIndex:indexPath.section];
    cell.decLabel.frame = CGRectMake(105, 30, [[_sourceWidthArr objectAtIndex:indexPath.section] floatValue], 10);
    cell.decLabel.text = [self.sourceArray objectAtIndex:indexPath.section];
    cell.timeLabel.text = [self.timeArray objectAtIndex:indexPath.section];

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
