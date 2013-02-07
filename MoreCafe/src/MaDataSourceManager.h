//
//  MaDataSource.h
//  MoreCafe
//
//  Created by Thunder on 1/5/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaDataSourceManager : NSObject

{
	NSDictionary* _rootDictonary;
	NSMutableArray* _dataSource;
	NSArray* _enumArray;

	NSMutableArray* _currentActivityArray;
}

@property (nonatomic, retain) NSMutableArray* dataSource;
@property (nonatomic, retain) NSArray* enumArray;

-(void)updateDataSourceArrayByViewType:(MO_CAFE_TYPE)type;
-(NSDictionary*)itemInfoByViewType:(MO_CAFE_TYPE)type;
-(void)loadDataSource;
-(void)loadDataFileFromServer;
@end
