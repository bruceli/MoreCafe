//
//  MaDataSource.m
//  MoreCafe
//
//  Created by Thunder on 1/5/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaDataSourceController.h"

@implementation MaDataSourceController
@synthesize dataSource = _dataSource;
-(id)init
{
    self = [super init];
    
    if (self) {
        NSLog(@"%@", @"Init DataSourceMgr");		
        NSString* path = [[NSBundle mainBundle] pathForResource:@"dataFile" ofType:@"plist"];        
        _rootDictonary = [[NSDictionary alloc] initWithContentsOfFile:path];
//        _enumActivitiesArray = [_rootDictonary objectForKey:@"enumArray"];
//        _currentActivityArray = [[NSMutableArray alloc] init];
        _dataSource = [[NSMutableArray alloc] init];
//        [self loadImageIndex];
    }
    return self;
}


@end
