//
//  MaAboutViewController.h
//  MoreCafe
//
//  Created by Thunder on 1/24/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaScaleImageView.h"

@interface MaAboutViewController : UIViewController <DTAttributedTextContentViewDelegate,MaScaleImageViewDelegate>
{
	UIScrollView* _scrollerView;
	NSDictionary* _dict;
	
	UIImageView* _imgView;
	DTAttributedTextView* _detailTextView;
	UILabel* _mapLable;
	
	UIView* _hiddenView;
	MaScaleImageView* _scaleImageView;
	UILabel* _logoutLable;
	UITapGestureRecognizer* _weiboButtomTap;
	NSThread* _checkThread;
}
@property (nonatomic, retain) NSDictionary* dict;

@end
