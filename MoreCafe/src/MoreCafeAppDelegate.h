//
//  MoreCafeAppDelegate.h
//  MoreCafe
//
//  Created by Bruce Li on 12/25/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SinaWeibo;
@class MaDataSourceController;
@class MaWeiboViewController;

@interface MoreCafeAppDelegate : UIResponder <UIApplicationDelegate>
{
	MaDataSourceController* _dataSourceController;
    SinaWeibo *_sinaweibo;
	MaWeiboViewController* _weiboViewController;
}
@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (readonly, nonatomic) MaWeiboViewController *weiboViewController;

@end
