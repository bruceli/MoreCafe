//
//  MaListViewController.h
//  MoreCafe
//
//  Created by Thunder on 1/16/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaListViewController : UITableViewController
{
	NSArray* _dataArray;
}

@property (nonatomic, retain) NSArray* dataArray;

@end
