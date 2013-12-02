//
//  SquareViewController.h
//  WeiBo_Project
//
//  Created by 1007 on 13-11-28.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareViewController : UIViewController
{
    IBOutlet UISearchBar *_searchBar;
}
-(IBAction)scanlife:(id)sender;
-(IBAction)seekFriend:(id)sender;
-(IBAction)relaxation:(id)sender;
-(IBAction)ambitus:(id)sender;
-(IBAction)game:(id)sender;
-(IBAction)apply:(id)sender;
-(IBAction)hotWeibo:(id)sender;
@end
