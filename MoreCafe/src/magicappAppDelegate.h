//
//  magicappAppDelegate.h
//  MoreCafe
//
//  Created by Bruce Li on 12/25/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaDataSourceController.h"

@interface magicappAppDelegate : UIResponder <UIApplicationDelegate>
{
	MaDataSourceController* _dataSourceController;
}
@property (strong, nonatomic) UIWindow *window;

@end
