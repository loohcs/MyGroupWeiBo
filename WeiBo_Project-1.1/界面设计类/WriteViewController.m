//
//  WriteViewController.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "WriteViewController.h"
#import "HomeViewController.h"
@interface WriteViewController ()

@end

@implementation WriteViewController

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
    [self initWithTitle];
    [self initWithView];
    
}


-(void)initWithTitle
{
    //页面标题
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 100, 36-8)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = 1;
    label.text = @"发微博";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textColor = [UIColor grayColor];
    [titleView addSubview:label];
    self.navigationItem.titleView =titleView;
    
    //返回Button
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setBackgroundImage:[UIImage imageNamed:@"page_like_button_background"] forState:UIControlStateNormal];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToHomeView) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(5, 6, 50, 32);
    [view addSubview:back];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //编辑完成Button
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *finish = [UIButton buttonWithType:UIButtonTypeCustom];
    [finish setBackgroundImage:[UIImage imageNamed:@"page_like_button_background"] forState:UIControlStateNormal];
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [finish setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    finish.frame = CGRectMake(5, 6, 50, 32);
    [rightView addSubview:finish];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)initWithView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 248)];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    [_textView becomeFirstResponder];
    //    _textView.delegate = self;
    [self.view addSubview:_textView];
    _keyBoardView = [[UIView alloc]initWithFrame:CGRectMake(0, 248, 320, 40)];
    [_keyBoardView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_keyBoardView];
    //增加keyBoardView上的button
    [self addKeyBoardButtons];
    
    //    _emoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 288, 320, 568-64-288)];
    //    _emoScrollView.backgroundColor = [UIColor cyanColor];
    
    
    //将表情贴到scrollView
    _emoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 288, 320, 568-64-288)];
    _emoScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _emoScrollView.showsHorizontalScrollIndicator = NO;
    _emoScrollView.showsVerticalScrollIndicator = NO;
    _emoScrollView.pagingEnabled = YES;
    _emoScrollView.contentSize = CGSizeMake(280 * 4, 200);
    _emoScrollView.backgroundColor = [UIColor blackColor];
    _emoScrollView.bounces = NO;
    _isEmotionsPushed = 0;
    emoNameArr = [[NSArray alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"faceEmotion" ofType:@"plist"];
    NSDictionary *emoDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    emoNameArr = [emoDic allKeys];
    
    for (int i = 0; i < 6; i++)
    {
        for (int j = 0; j < 36; j++) {
            NSString *emotionName = [NSString stringWithString:[emoDic objectForKey:[emoNameArr objectAtIndex:(i*10+j*1)]]];
            NSString *emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", emotionName] ofType:@"gif"];
            UIImage *image = [UIImage imageWithContentsOfFile:emotionPath];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(30*j+5, 30*i+5, 22, 22)];
            imageV.image = image;
            imageV.tag = 100+(i*10 + j*1);
            imageV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputEmotions:)];
            tapGR.numberOfTapsRequired = 1;
            [imageV addGestureRecognizer:tapGR];
            [_emoScrollView addSubview:imageV];
        }
    }
    
}

- (void)inputEmotions:(UITapGestureRecognizer *)sender
{
    int tag = sender.view.tag;
    NSLog(@"%d", tag);
    NSString *str = [emoNameArr objectAtIndex:(tag-100)];
    _textView.text = [_textView.text stringByAppendingString:str];
    NSLog(@"%@", str);
}

-(void)keyBoardWasShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _keyBoardView.frame = CGRectMake(0, 548-44-40-height, 320, 40);
    NSLog(@"%d",height);
}

-(void)keyBoardWasHidden:(NSNotification *)aNotification
{
    _keyBoardView.frame = CGRectMake(0, 248, 320, 40);
    //    self.tabBarController.hidesBottomBarWhenPushed = YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)addKeyBoardButtons
{
    NSArray *imageName = [NSArray arrayWithObjects:@"compose_camerabutton_background",@"compose_toolbar_picture",@"compose_mentionbutton_background",@"compose_emoticonbutton_background",@"compose_toolbar_more",nil];
    NSArray *hImageName = [NSArray arrayWithObjects:@"compose_camerabutton_background_highlighted",@"compose_toolbar_picture_highlighted",@"compose_mentionbutton_background_highlighted",@"compose_emoticonbutton_background_highlighted",@"compose_toolbar_more_highlighted", nil];
    for (int i=0; i<5; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        switch (i)
        {
            case 0:
            {
                [btn addTarget:self action:@selector(OpenCamera) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 1:
            {
                [btn addTarget:self action:@selector(OpenPhoto) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 2:
            {
                [btn addTarget:self action:@selector(atSomeBody) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 3:
            {
                [btn addTarget:self action:@selector(emotions) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 4:
            {
                [btn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
                break;
        }
        [btn setBackgroundImage:[UIImage imageNamed:[imageName objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag =i+1;
        [btn setImage:[UIImage imageNamed:[hImageName objectAtIndex:i]] forState:UIControlStateHighlighted];
        btn.frame = CGRectMake(20+64*i, 10, 24, 24);
        [_keyBoardView addSubview:btn];
    }
}

-(void)OpenCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)OpenPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        
    }
    picker.delegate = self;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)atSomeBody
{
    
}

-(void)emotions
{
    if (_isEmotionsPushed == 0)
    {
        
        [_textView resignFirstResponder];
        //_keyBoardView.frame = CGRectMake(0, 208, 320, 40);
        self.hidesBottomBarWhenPushed = YES;
        
        [self.view addSubview:_emoScrollView];
        _isEmotionsPushed = 1;
    }
    else if(_isEmotionsPushed == 1)
    {
        _isEmotionsPushed = 0;
        [_emoScrollView removeFromSuperview];
        [_textView becomeFirstResponder];
    }
    
    
}


-(void)more
{
    
}
- (void)finishAction
{
    NSString *statuses = [[NSString alloc] init];
    statuses = [URLEncode encodeUrlStr:_textView.text];
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_textView.text, @"status", @"0", @"visible",nil];
    [WBHttpRequest requestWithAccessToken:[defaluts objectForKey:@"accessToken"] url:STATUSES_UPDATA
                               httpMethod:@"POST" params:dic delegate:self];
    NSLog(@"--------------------%@", statuses);
}

//响应请求
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s", __func__);
    NSLog(@"收到微博数据请求！！！");
}

//完成请求
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSLog(@"%s", __func__);
    //NSLog(@"%@", result);
}

//请求出错
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    NSLog(@"%@", error);
}

- (void)backToHomeView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

