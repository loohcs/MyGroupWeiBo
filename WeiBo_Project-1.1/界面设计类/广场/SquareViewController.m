//
//  SquareViewController.m
//  WeiBo_Project
//
//  Created by xzx on 13-12-4.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "SquareViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AroundViewController.h"
#import "FindFriendViewController.h"
@interface SquareViewController ()

@end

@implementation SquareViewController

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.view addGestureRecognizer:tap];
    [self initSquareButtons];
    
}
//初始化广场的button
#pragma mark -- initSquareButtons
-(void)initSquareButtons
{
    //创建Button上的label和UIImageView数据
    
    NSArray *text1 = [NSArray arrayWithObjects:@"扫一扫",@"找朋友",nil];
    NSArray *text2 = [NSArray arrayWithObjects:@"娱乐",@"周边",nil];
    NSArray *text3 = [NSArray arrayWithObjects:@"游戏",@"应用",nil];
    NSMutableArray *labelTextArr = [NSMutableArray arrayWithObjects:text1,text2,text3 ,nil];
    NSArray *image1 = [NSArray arrayWithObjects:[UIImage imageNamed:@"sqcar"],[UIImage imageNamed:@"square_icon_findfriends"],nil];
    NSArray *image2 = [NSArray arrayWithObjects:[UIImage imageNamed:@"square_icon_movie"],[UIImage imageNamed:@"findfriend_icon_around"],nil];
    NSArray *image3 = [NSArray arrayWithObjects:[UIImage imageNamed:@"game"],[UIImage imageNamed:@"app"],nil];
    NSMutableArray *imageArr = [NSMutableArray arrayWithObjects:image1,image2,image3,nil];
    //创建UIbutton
    int k=1;
    for (int i=0;i<3; i++)
    {
        NSArray *text = [labelTextArr objectAtIndex:i];
        
        NSArray *image = [imageArr objectAtIndex:i];
        for (int j=0; j<2; j++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+(142.5+15)*j, 44+10+(50+15)*i, 142.5, 50);
            [btn setBackgroundImage:[UIImage imageNamed:@"square_card_bg"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"buttonBackground.jpg"] forState:UIControlStateHighlighted];
            btn.layer.cornerRadius = 5;
            btn.tag =k ;
            k++;
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 36, 36)];
            imageView.image = [image objectAtIndex:j];
            [btn addSubview:imageView];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(56, 6, 70, 36)];
            label.text = [text objectAtIndex:j];
            label.font = [UIFont systemFontOfSize:18];
            label.backgroundColor = [UIColor clearColor];
            [btn addSubview:label];
            
            
            [self.view addSubview:btn];
        }
    }
    [self buttonAddAction];
}
//为创建的Button加方法
#pragma mark -- buttonAddAction
-(void)buttonAddAction
{
    //扫一扫
    UIButton *sweepBtn = (UIButton *)[self.view viewWithTag:1];
    [sweepBtn addTarget:self action:@selector(sweepAction) forControlEvents:UIControlEventTouchUpInside];
    //找朋友
    UIButton *findFriendBtn = (UIButton *)[self.view viewWithTag:2];
    [findFriendBtn addTarget:self action:@selector(findFriendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //娱乐
    UIButton *amusementBtn = (UIButton *)[self.view viewWithTag:3];
    [amusementBtn addTarget:self action:@selector(amusementBtn) forControlEvents:UIControlEventTouchUpInside];
    //周边
    UIButton *aroundBtn = (UIButton *)[self.view viewWithTag:4];
    [aroundBtn addTarget:self action:@selector(aroundBtn) forControlEvents:UIControlEventTouchUpInside];
    //游戏
    UIButton *gameBtn = (UIButton *)[self.view viewWithTag:5];
    [gameBtn addTarget:self action:@selector(gameBtn) forControlEvents:UIControlEventTouchUpInside];
    //应用
    UIButton *appBtn = (UIButton *)[self.view viewWithTag:6];
    [appBtn addTarget:self action:@selector(appBtn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sweepAction
{
    //如果有摄像头的话就打开摄像头扫描二维码
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //初始化通过摄像头扫描二维码的视图控制器
        ZBarReaderViewController *reader = [[ZBarReaderViewController alloc]init];
        //设置代理
        reader.readerDelegate = self;
        //配置解码器
        ZBarImageScanner *scanner = reader.scanner;
        [scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
        [self presentViewController:reader animated:YES completion:nil];
    }
    //否则从相册中打开存在的二维码图片
    else
    {
        ZBarReaderController *reader = [[ZBarReaderController alloc] init];
        //设置代理
        reader.readerDelegate = self;
        //配置解码器
        ZBarImageScanner *scanner = reader.scanner;
        [scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
        [self presentViewController:reader animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获得解码结果
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    //获得结果中的第一个有效数据
    ZBarSymbol *symbol = nil;
    for (symbol in results)
        break;
    //处理结果
    if ([symbol.data hasPrefix:@"http://"] || [symbol.data hasPrefix:@"https://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:symbol.data]];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:symbol.data delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)findFriendBtnAction
{
    FindFriendViewController *view = [[FindFriendViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)amusementBtn
{
    NSLog(@"3");
}

-(void)aroundBtn
{
    //推送到周边页面
    AroundViewController *aroundView = [[AroundViewController alloc]init];
    [self.navigationController pushViewController:aroundView animated:YES];
}

-(void)gameBtn
{
    NSLog(@"5");
}

-(void)appBtn
{
    NSLog(@"6");
}

- (void)hiddenKeyBoard
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UISearchBar class]])
        {
            [view resignFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
