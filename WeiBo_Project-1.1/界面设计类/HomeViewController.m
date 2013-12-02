//
//  HomeViewController.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "HomeViewController.h"
#import "WriteViewController.h"

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
    
    middleFlag = 0;
    rightFlag = 0;
    flag = 0;
    middleTableV=[[UITableView alloc]initWithFrame:CGRectMake(110, 0, 100, 120) style:UITableViewStyleGrouped];
    rightTableV = [[UITableView alloc] initWithFrame:CGRectMake(230, 0, 80, 100) style:UITableViewStyleGrouped];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //创建左右button和中间标题栏
    [self initWithButtonAndTitle];
    self.navigationItem.title = @"";
    
    
    weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(0, 0, 320, 508)];
    [self getTimelineWeibo:@"statuses_friends_timeline"];
    //    [weiboView initWithTabelView];
    [self.view addSubview:weiboView];
    
}

#pragma mark -- 获取最新的微博，以及将微博内容显示出来
- (void)getTimelineWeibo:(NSString *)type
{
    NSLog(@"%s", __func__);
    if ([type isEqualToString:@"statuses_friends_timeline"])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"since_id", @"0", @"max_id", @"100",@"count", @"1", @"page", @"0", @"base_app", @"0",@"feature", @"0", @"trim_user", nil];
        statuses = [[WBHTTP_Request_Block alloc] initWithURlString:STATUSES_FRIENDS_TIMELINES andArguments:dic];
        NSLog(@"%@", STATUSES_FRIENDS_TIMELINES);
    }
    if ([type isEqualToString:@"statuses_public_timeline"]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"100",@"count", nil];
        statuses = [[WBHTTP_Request_Block alloc] initWithURlString:STATUSES_PUBLIC_TIMELINE andArguments:dic];
        NSLog(@"%@", STATUSES_PUBLIC_TIMELINE);
    }
    
    __weak HomeViewController *homeVC = self;
    [WeiboDataBase createWeiboTable];
    [statuses setBlock:^(NSMutableData *datas, float progressNum)
     {
         [homeVC getWeiboContex:datas];
     }];
    
    [WeiboDataBase findAll];
}

- (void)getWeiboContex:(NSData *)data
{
    NSLog(@"%s", __func__);
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *weiboArr = [NSArray arrayWithArray:[dic objectForKey:@"statuses"]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [WeiboDataBase createWeiboTable];
    for (int i = 0; i < 10; i++) {
        NSDictionary *weiboDic = [NSDictionary dictionaryWithDictionary:[weiboArr objectAtIndex:i]];
        WeiBoContext *oneWeiboContex = [[WeiBoContext alloc] initWithWeibo:weiboDic];
        [array addObject:oneWeiboContex.text];
        
    }
    
    weiboView.textArray = [[NSArray alloc] initWithArray:array];
    [weiboView initWithTabelView];
    
    //TODO: 判断哪些微博是需要加入数据库的
    //仅仅需要将当前页面显示的微博都加入数据中，不需要所有的微博
    
    [WeiboDataBase findAll];
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

//    middleTableV.rowHeight=10;
//    middleTableV.delegate=self;
//    middleTableV.dataSource=self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"popover_background_os7@2x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 100, 120)];
    imageView.image = image;
    [middleTableV setBackgroundView:imageView];
    
    //中间的弹出框与右边的弹出框相互斥
    if (middleFlag == 0 && flag == 0) {
        [self.view addSubview:middleTableV];
        middleFlag = 1;
        flag = 1;
    }
    else
        if (middleFlag == 0 && flag == 1)
        {
            [rightTableV removeFromSuperview];
            rightFlag = 0;
            [self.view addSubview:middleTableV];
            middleFlag = 1;
            
        }
        else
            if(middleFlag == 1)
            {
                [middleTableV removeFromSuperview];
                middleFlag = 0;
                flag = 0;
            }

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"popover_background_os7@2x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 0, 80, 100)];
    imageView.image = image;
    [rightTableV setBackgroundView:imageView];
    
    if (rightFlag == 0 && flag == 0) {
        [self.view addSubview:rightTableV];
        rightFlag = 1;
        flag = 1;
    }
    else
        if (rightFlag == 0 && flag == 1) {
            [middleTableV removeFromSuperview];
            middleFlag = 0;
            [self.view addSubview:rightTableV];
            rightFlag = 1;
            
        }
        else
            if(rightFlag == 1)
            {
                [rightTableV removeFromSuperview];
                rightFlag = 0;
                flag = 0;
            }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
