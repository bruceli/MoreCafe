//
//  MaDetailViewController.h
//  MoreCafe
//
//  Created by Thunder on 1/18/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaDetailViewController : UIViewController <DTAttributedTextContentViewDelegate>
{
	UIScrollView* _scrollerView;
	AsyncImageView* _imgView;
	UILabel* _nameLable;
	DTAttributedTextView* _detailTextView;

	
	NSDictionary* _dict;
}
@property (nonatomic, retain) NSDictionary* dict;


@end
