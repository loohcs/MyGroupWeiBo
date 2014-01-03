//
//  SinaNewsViewController.m
//  WeiBo_Project
//
//  Created by 1014 on 13-12-16.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "SinaNewsViewController.h"

@interface SinaNewsViewController ()

@end

@implementation SinaNewsViewController

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
	// Do any additional setup after loading the view.
    [self initWithButtonAndTitle];
    //返回Button
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(5, 5, 30, 40);
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnV) forControlEvents:UIControlEventTouchUpInside];
    [returnView addSubview:returnBtn];
    UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] initWithCustomView:returnView];
    self.navigationItem.leftBarButtonItem=returnItem;
    
    UIWebView *webTemp = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 464)];
    webTemp.delegate = self;
    webTemp.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕,用sina.com试这个,baidu.com试不出来
    
    self.webView = webTemp;
    [self.view addSubview:self.webView];
    NSURL *url = [[NSURL alloc] initWithString:@"http://news.sina.com.cn"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}
//开始加载的时候执行该方法。
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    //创建UIActivityIndicatorView背底半透明View
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 464)];
    view.tag = 8080;
    view.alpha = 0.6;
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [view addGestureRecognizer:tap];
 
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    self.activityView.center = view.center;
    [self.activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [view addSubview:self.activityView];
    
    [self.activityView startAnimating];
}

-(void) tapAction
{
    [self.activityView stopAnimating];
    [view removeFromSuperview];
}
//完成加载的时候执行该方法。
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[self.view viewWithTag:8080] removeFromSuperview];
    self.textURL.text = webView.request.URL.absoluteString;
}
//加载失败的时候执行该方法。
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
    self.textURL = nil;
    self.activityView = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)returnV
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initWithButtonAndTitle
{
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background"]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 155-34, 44)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.text = @"新浪新闻";
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment =1;
    [titleView addSubview:label];
    self.navigationItem.titleView = titleView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
