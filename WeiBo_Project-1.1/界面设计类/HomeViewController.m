//
//  HomeViewController.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "HomeViewController.h"
#import "WriteViewController.h"
#import "Friends_Timeline_Weibo.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    friendWeibo = [[Friends_Timeline_Weibo alloc] init];
//    [friendWeibo getFriendsTimelineWeibo];
    
    //创建左右button和中间标题栏
    [self initWithButtonAndTitle];
    self.navigationItem.title = @"";
    
}
#pragma initWithButtonAndTitle
-(void)initWithButtonAndTitle
{
    //leftButton
    UIView *writeBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    writeBtn.frame = CGRectMake(0, 7, 30, 30);
    [writeBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_compose"] forState:UIControlStateNormal];
    [writeBtn setImage:[UIImage imageNamed:@"navigationbar_compose_highlighted"] forState:UIControlStateHighlighted];
    [writeBtn addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [writeBtnView addSubview:writeBtn];
    UIBarButtonItem *writeItem = [[UIBarButtonItem alloc]initWithCustomView:writeBtnView];
    self.navigationItem.leftBarButtonItem = writeItem;
    //middle
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background"]];
    UIButton *middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    middleButton.frame = CGRectMake(0, 0, 155, 43);
    [middleButton setImage:[UIImage imageNamed:@"skin_background"] forState:UIControlStateHighlighted];
    [middleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [middleButton addTarget:self action:@selector(middleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:middleButton];
    UIImage *image = [UIImage imageNamed:@"friendcircle_navigationbar_friendcircle"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(155-34, 15, 14, 14)];
    imageView.image = image;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 155-34, 44)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.text = @"好友圈";
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment =1;
    [middleButton addSubview:label];
    [middleButton addSubview:imageView];
    self.navigationItem.titleView = titleView;
    
    //right
    UIView *rightBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(30, 7, 30, 30);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_pop"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"navigationbar_pop_highlighted"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtnView addSubview:rightBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtnView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}



-(void)leftButtonAction
{
    WriteViewController *writeView = [[WriteViewController alloc]init];
    [self.navigationController pushViewController:writeView animated:YES];
}

-(void)middleButtonAction
{
//    _array = [[NSMutableArray array] initWithObjects:@"首页",@"好友圈",@"我的微博",@"周边微博", @"特别关注",@"同事",@"名人明星",@"同学",@"悄悄关注",@"智能排行",nil];
    
    middleTableV=[[UITableView alloc]initWithFrame:CGRectMake(110, 0, 100, 150) style:UITableViewStyleGrouped];
//    middleTableV.rowHeight=10;
//    middleTableV.delegate=self;
//    middleTableV.dataSource=self;
    [self.view addSubview:middleTableV];
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _array.count+1;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *str=@"_cell";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
//    if (cell==nil)
//    {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
//    }
//    return cell;
//}

-(void)rightButtonAction
{
    rightTableV = [[UITableView alloc] initWithFrame:CGRectMake(230, 0, 80, 100) style:UITableViewStyleGrouped];
    [self.view addSubview:rightTableV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
