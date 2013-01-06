//
//  MaDataSource.h
//  MoreCafe
//
//  Created by Thunder on 1/5/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaDataSourceController : NSObject

{
	NSDictionary* _rootDictonary;
	NSMutableArray* _dataSource;
	
}

@property (nonatomic, retain) NSMutableArray* dataSource;

@end
