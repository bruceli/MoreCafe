//
//  MoreCafeAppDelegate.m
//  MoreCafe
//
//  Created by Bruce Li on 12/25/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import "MoreCafeAppDelegate.h"
#import "MaRootViewController.h"
#import "MaDataSourceController.h"
#import "MaWeiboViewController.h"
#import "SinaWeibo.h"

@implementation MoreCafeAppDelegate
@synthesize sinaweibo = _sinaweibo;
@synthesize weiboViewController = _weiboViewController;
static int _networkActivityIndicatorCounter = 0;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	[AsyncImageLoader sharedLoader];	

	MaRootViewController* controller =[[MaRootViewController alloc] init];
	_dataSourceController = [[MaDataSourceController alloc] init];

	UINavigationController* theController = [[UINavigationController alloc] initWithRootViewController:controller];
    [theController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navbar"] forBarMetrics:UIBarMetricsDefault];
	controller.navigationItem.title = @"Café";

	self.window.rootViewController = theController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	[self initSinaWeibo];
    return YES;
}

- (void) initSinaWeibo
{
	_weiboViewController = [[MaWeiboViewController alloc]init];	

    _sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:_weiboViewController];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        _sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        _sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        _sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
		NSLog(@"%@",@"Weibo client is ready.");
    }   
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	NSLog(@"%@",url.absoluteString);
	
    return [self.sinaweibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{	
	NSLog(@"%@",url.absoluteString);
	
    return [self.sinaweibo handleOpenURL:url];
}


+ (void) increaseNetworkActivityIndicator
{
	_networkActivityIndicatorCounter++;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = _networkActivityIndicatorCounter > 0;
}

+ (void) decreaseNetworkActivityIndicator
{
	_networkActivityIndicatorCounter--;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = _networkActivityIndicatorCounter > 0;
}



@end
