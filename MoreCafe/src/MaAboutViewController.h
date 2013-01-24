//
//  MaAboutViewController.h
//  MoreCafe
//
//  Created by Thunder on 1/24/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaAboutViewController : UIViewController <DTAttributedTextContentViewDelegate>
{
	UIScrollView* _scrollerView;
	NSDictionary* _dict;
}
@property (nonatomic, retain) NSDictionary* dict;

@end
