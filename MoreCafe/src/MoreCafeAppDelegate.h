//
//  MoreCafeAppDelegate.h
//  MoreCafe
//
//  Created by Bruce Li on 12/25/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SinaWeibo;
@class MaDataSourceManager;
@class MaWeiboViewController;
@class MaRootViewController;

@interface MoreCafeAppDelegate : UIResponder <UIApplicationDelegate>
{
    SinaWeibo *_sinaweibo;
	MaWeiboViewController* _weiboViewController;
	MaRootViewController* _rootViewController;
}
@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (readonly, nonatomic) MaWeiboViewController *weiboViewController;

+ (void)increaseNetworkActivityIndicator;
+ (void)decreaseNetworkActivityIndicator;
+ (void)showSuccessNotification:(NSString*)message inView:(UIView*)view;
+ (void)showErrorNotification:(NSString*)message inView:(UIView*)view;


@end
