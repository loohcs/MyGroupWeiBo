//
//  BaseViewController.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 80, 80)];
//    UIImage *image=[UIImage imageNamed:@"h1.jpg"];
//    UIImage *image1=[UIImage imageNamed:@"h4.jpg"];
//    _imageView.image=image;
//    _imageView.highlightedImage=image1;
//    _imageView.highlighted=NO;
//    _imageView.userInteractionEnabled=YES;
//    NSMutableArray *imageArray=[NSMutableArray new];
//    for (int i=0; i<4; i++)
//    {
//        NSString *str=[[NSString alloc]initWithFormat:@"h%d.png",i+1 ];
//        UIImage *image=[UIImage imageNamed:str];
//        [imageArray  addObject:image];
//    }
//    _imageView.animationImages=imageArray;
//    _imageView.animationDuration=1;
//    _imageView.animationRepeatCount=0;
//    _imageView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)reloadTableViewDataSource
{
    
}

-(void)doneloadingData
{
    
}

-(void)creatWebView:(NSURL *)URL
{
    detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - 44)];
    detailWebView.scalesPageToFit = YES;
    detailWebView.userInteractionEnabled = YES;
    detailWebView.opaque = YES;
    detailWebView.clearsContextBeforeDrawing = YES;
    detailWebView.autoresizesSubviews = YES;
    [detailWebView loadRequest:[NSURLRequest requestWithURL:URL]];
    [self.view addSubview:detailWebView];
}


@end
