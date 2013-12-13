//
//  WriteViewController.m
//  SinaTwitterDemo
//
//  Created by xzx on 13-11-25.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "WriteViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "UIViewExt.h"
#define SCROLLWIDTH 320
#define SCROLLHEIGHT 180
@interface WriteViewController ()

@end

@implementation WriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _weiboContext = [[WeiBoContext alloc] init];
        _weiboView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 320, 70)];
        
        _style = sendWeiboContex;
        
        //_weiboView.backgroundColor = [UIColor cyanColor];
        [self.view addSubview:_weiboView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithTitle];
    [self initWithView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 568-49, 320, 49)];
    [self.view addSubview:view];
    _strArr = [[NSMutableArray alloc]init];
}

//设置导航栏以及标题
-(void)initWithTitle
{
    //页面标题
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 100, 36-8)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = 1;
    if (_style  == 0) {
        label.text = @"发微博";
    }
    if (_style  == 1) {
        label.text = @"转发微博";
    }
    if (_style  == 2) {
        label.text = @"评论";
    }

    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textColor = [UIColor grayColor];
    [titleView addSubview:label];
    self.navigationItem.titleView = titleView;
    
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
    
    //[self creatBackNavigationBarWithTitle:@"发微博" sign:1];
}

//TODO： 对键盘进行一些初始化和设置
-(void)initWithView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    _keyBoardView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bottom-44, 320, 44)];
    _keyBoardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background"]];
    [self.view addSubview:_keyBoardView];
    //增加keyBoardView上的button
    [self addKeyBoardButtons];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectZero];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    
    //将表情贴到scrollView
    _emoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bottom-SCROLLHEIGHT, 320, 0)];
    _emoScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _emoScrollView.showsHorizontalScrollIndicator = NO;
    _emoScrollView.showsVerticalScrollIndicator = NO;
    _emoScrollView.pagingEnabled = YES;
    _emoScrollView.contentSize = CGSizeMake(SCROLLWIDTH* 6, SCROLLHEIGHT);
    _emoScrollView.backgroundColor = [UIColor blackColor];
    _emoScrollView.bounces = NO;
    _isEmotionsPushed = 0;
    _emoScrollView.delegate = self;
    _emoScrollView.hidden = YES;
    [self.view addSubview:_emoScrollView];
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(60, self.view.bottom, 200, 10)];
    _page.numberOfPages = 6;
    [_page addTarget:self action:@selector(pageEvenMathod:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_page];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DefaultEmotion" ofType:@"plist"];
    _emoArr = [NSArray arrayWithContentsOfFile:plistPath];
    NSArray *emoNameArr = [[NSArray alloc]init];
    int m =0;
    for (int k=0; k<6; k++)
    {
        emoNameArr = [_emoArr objectAtIndex:k];
        int n=0;
        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < 7; j++) {
                NSString *emotionName = [emoNameArr objectAtIndex:n];
                NSString *emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", emotionName] ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:emotionPath];
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake (20+(32+8)*j+320*k, 20+(32+8)*i, 32, 32)];
                imageV.image = image;
                imageV.tag = 100+m;
                imageV.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputEmotions:)];
                tapGR.numberOfTapsRequired = 1;
                [imageV addGestureRecognizer:tapGR];
                [_emoScrollView addSubview:imageV];
                n+=1;
                m+=1;
            }
        }
        
        
    }
}

//TODO: 表情的页面控制
-(void)pageEvenMathod:(UIPageControl *)sender
{
    int num = _page.currentPage;
    _emoScrollView.contentOffset = CGPointMake(SCROLLWIDTH*num, 0);
}

- (void)inputEmotions:(UITapGestureRecognizer *)sender
{
    int tag = sender.view.tag;
    int index = (tag-100)%21;
    int sign = (tag-100)/21;
    if (index!=20&&tag<215)
    {
        NSArray *emotion = [_emoArr objectAtIndex:(tag-100)/21];
        NSString *string = [emotion objectAtIndex:index];
        _textView.text = [_textView.text stringByAppendingString:string];
        [_strArr addObject:string];
    }
    if ((index==20&&sign!=5)|(tag==215))
    {
        if (_strArr.count!=0)
        {
            NSString *string = [_strArr lastObject];
            NSRange range = [_textView.text rangeOfString:string options:NSBackwardsSearch];
            if (range.length!=0)
            {
                _textView.text = [_textView.text stringByReplacingCharactersInRange:range withString:@""];
                [_strArr removeLastObject];
            }
        }
        
    }
    
}

-(void)keyBoardWasShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView beginAnimations:@"keyBoaddView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationCurve:1.0f];
    _keyBoardView.frame = CGRectMake(0, self.view.bottom-44-height, 320, 44);
    _textView.frame = CGRectMake(0, 0, 320,_keyBoardView.top);
    [UIView commitAnimations];
    
}

-(void)keyBoardWasHidden:(NSNotification *)aNotification
{
    
    [UIView beginAnimations:@"keyBoardView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationCurve:1.0f];
    _keyBoardView.frame = CGRectMake(0, self.view.bottom-44-SCROLLHEIGHT, 320, 44);
    _emoScrollView.frame = CGRectMake(0, _keyBoardView.bottom, SCROLLWIDTH, SCROLLHEIGHT);
    _textView.frame = CGRectMake(0, 0, 320, self.view.bottom-_keyBoardView.top);
    _textView.frame = CGRectMake(0, 0, 320, _keyBoardView.top);
    [UIView commitAnimations];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int num = scrollView.contentOffset.x/SCROLLWIDTH;
    _page.currentPage = num;
}


#pragma mark -- 添加键盘上得按钮，以及动作响应
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
        
        _emoScrollView.hidden = NO;
        _isEmotionsPushed = 1;
    }
    else if(_isEmotionsPushed == 1)
    {
        _isEmotionsPushed = 0;
        [_emoScrollView setHidden:YES];
        
        [_textView becomeFirstResponder];
        
    }
    
    
}


-(void)more
{
    
}

#pragma mark -- 在转发微博的时候也会调用本页面，此时应该添加显示简单的微博内容
- (void)addWeiboContex:(WeiBoContext *)oneWeiboContex andContexStyle:(ContexStyle)aStyle
{
    _weiboContext = oneWeiboContex;
    _style = aStyle;
    [self initWithTitle];
    //创建一个imageView，将会粘贴需要显示的图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
    
    //创建一个Label用来显示微博的作者名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 240, 15)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:12.0f];
    nameLabel.text = [NSString stringWithFormat:@"@%@", oneWeiboContex.userInfo.name];
    [_weiboView addSubview:nameLabel];
    
    //创建一个label用来显示微博的内容
    TQRichTextView *textLabel = [[TQRichTextView alloc] initWithFrame:CGRectMake(70, 25, 240, 35)];
    textLabel.font = [UIFont systemFontOfSize:10.0f];
    textLabel.backgroundColor = [UIColor clearColor];
    [_weiboView addSubview:textLabel];
    
    if (oneWeiboContex.retweeted_status == nil)
    {
        if (oneWeiboContex.thumbnail_pic.length == 0) {
            //为原创微博，并且没有图片时，将用户头像贴上
            imageView.image = oneWeiboContex.headImage;
            [_weiboView addSubview:imageView];
        }
        else
        {
            //将微博的图片贴上
            imageView.image = oneWeiboContex.thumbnailImage;
            [_weiboView addSubview:imageView];
        }
        textLabel.text = oneWeiboContex.text;
    }
    else
    {
        if (oneWeiboContex.retweetedWeibo.thumbnail_pic.length == 0) {
            //将转发微博的用户头像贴上
            imageView.image = oneWeiboContex.headImage;
            [_weiboView addSubview:imageView];
        }
        else
        {
            //将转发微博的图片贴上
            imageView.image = oneWeiboContex.retweetedWeibo.thumbnailImage;
            [_weiboView addSubview:imageView];
        }
        textLabel.text = oneWeiboContex.retweetedWeibo.text;
        _textView.text = oneWeiboContex.text;
    }
}


#pragma mark -- 在微博内容完成之后，我们点击完成按钮，那么将会发送微博
- (void)finishAction
{
    NSString *statuses = [[NSString alloc] init];
    statuses = [URLEncode encodeUrlStr:_textView.text];
    
    NSLog(@"-------------------%d", _style);
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    
    if (_style == 0)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_textView.text, @"status", @"0", @"visible", nil];
        [WBHttpRequest requestWithAccessToken:[defaluts objectForKey:@"accessToken"] url:STATUSES_UPDATA
                                   httpMethod:@"POST" params:dic delegate:self];
    }
    if (_style == 1) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_textView.text, @"status", @"0", @"visible", _weiboContext.idstr, @"id", nil];
        [WBHttpRequest requestWithAccessToken:[defaluts objectForKey:@"accessToken"] url:STATUSES_REPOST
                                   httpMethod:@"POST" params:dic delegate:self];
    }
    if (_style == 2) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_textView.text, @"comment", _weiboContext.idstr, @"id", nil];
        [WBHttpRequest requestWithAccessToken:[defaluts objectForKey:@"accessToken"] url:COMMENTS_CREATE
                                   httpMethod:@"POST" params:dic delegate:self];
    }
    
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
    
    //微博发送成功之后，我们将自动跳转返回主页面
    [self dismissViewControllerAnimated:YES completion:nil];
}

//请求出错
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    NSLog(@"%@", error);
}

- (void)backToHomeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
