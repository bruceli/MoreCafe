//
//  MaWeiboViewController
//  MoreCafe
//
//  Created by Thunder on 1/6/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface MaWeiboViewController : UITableViewController <EGORefreshTableHeaderDelegate>
{
	EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;

}
@end
