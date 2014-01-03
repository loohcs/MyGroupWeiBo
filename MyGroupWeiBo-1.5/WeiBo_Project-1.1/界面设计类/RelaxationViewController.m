//
//  RelaxationViewController.m
//  SinaTwitterDemo
//
//  Created by 1014 on 13-11-26.
//  Copyright (c) 2013年 xzx. All rights reserved.
//

#import "RelaxationViewController.h"

@interface RelaxationViewController ()

@end

@implementation RelaxationViewController

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
    // Do any additional setup after loading the view from its nib.
    
    _tableArray = [[NSMutableArray alloc] initWithObjects:@"书籍",@"音乐",@"电影", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 568-44-44-20) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view   addSubview:_tableView];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str=@"_cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text=[_tableArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)xiuXian:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
