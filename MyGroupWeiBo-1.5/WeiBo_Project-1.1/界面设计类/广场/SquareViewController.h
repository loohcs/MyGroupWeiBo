//
//  SquareViewController.h
//  WeiBo_Project
//
//  Created by xzx on 13-12-4.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "BaseViewController.h"
#import "ZBarSDK.h"
@interface SquareViewController : BaseViewController<ZBarReaderDelegate>
{
  
    IBOutlet UISearchBar *_searchBar;
}
@end
