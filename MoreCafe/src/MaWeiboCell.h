//
//  MaWeiboCell.h
//  MoreCafe
//
//  Created by Thunder on 1/7/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaWeiboCell : UITableViewCell<DTAttributedTextContentViewDelegate>
{
	AsyncImageView* _userIconView;
	UILabel* _userNameView;
	DTAttributedTextView* _timeView;
	DTAttributedTextView* _messageTextView;
	AsyncImageView* _messagePictView;
	
	UILabel* _sourceView;
	UILabel* _messageStatusView;
	
	NSDictionary* _message;
}
@end
