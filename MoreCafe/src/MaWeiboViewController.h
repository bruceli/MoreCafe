//
//  MaWeiboViewController
//  MoreCafe
//
//  Created by Thunder on 1/6/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"


@interface MaWeiboViewController : UITableViewController <EGORefreshTableHeaderDelegate,SinaWeiboDelegate, SinaWeiboRequestDelegate>
{
	// refreshHeaderView stuff
	EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;

	//Weibo stuff
	NSDictionary *_userInfo;
    NSMutableArray *_messages;
    NSString *postStatusText;
    NSString *postImageStatusText;
	NSInteger _pages;
	
	NSDictionary* _moreItem;
	UITableViewCell* _moreCell;
}
@end
