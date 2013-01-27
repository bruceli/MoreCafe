//
//  MaWeiboCell.h
//  MoreCafe
//
//  Created by Thunder on 1/7/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaScaleImageView.h"

@class MaTimeLabel;

@interface MaWeiboCell : UITableViewCell<DTAttributedTextContentViewDelegate,MaScaleImageViewDelegate>
{
	AsyncImageView* _userIconView;
	UILabel* _userNameView;
	MaTimeLabel* _timeView;
	DTAttributedTextView* _messageTextView;
	AsyncImageView* _messagePictView;
	UIImageView* _customSeperator;
	UIImageView* _bubbleView;
	
	UILabel* _sourceView;
	UILabel* _messageStatusView;
	
	NSDictionary* _message;
	
	AsyncImageView* _hiddenView;
	MaScaleImageView* _scaleImageView;

}

-(void) fillCellDataWith:(NSDictionary*)dict;

@end
