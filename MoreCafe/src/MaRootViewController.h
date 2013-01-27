//
//  MaRootViewController.h
//  MoreCafe
//
//  Created by Thunder on 12/29/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaDataSourceManager;
@class BBCyclingLabel;
@interface MaRootViewController : UIViewController <UIScrollViewDelegate>
{
	UIScrollView* _scrollView;
	NSInteger _currentIndex;
	MaDataSourceManager* _dataSourceMgr;
	BBCyclingLabel* _proverbView;
	
	NSArray* _proverbArray;
//	NSThread* _proverbViewHelperThread;
}

@end
