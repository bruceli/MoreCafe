//
//  MaRootViewController.h
//  MoreCafe
//
//  Created by Thunder on 12/29/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaRootViewController : UIViewController <UIScrollViewDelegate>
{
	UIScrollView* _scrollView;
	NSInteger _currentIndex;
}

@end
