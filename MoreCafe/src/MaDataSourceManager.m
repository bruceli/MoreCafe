//
//  MaDataSource.m
//  MoreCafe
//
//  Created by Thunder on 1/5/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaDataSourceManager.h"
#import "Reachability.h"
#import "MaUtility.h"


@implementation MaDataSourceManager

@synthesize dataSource = _dataSource;
@synthesize enumArray = _enumArray;

-(id)init
{
    self = [super init];
		//1. check if has connection
		//2. if has connection download plist file from server
		//	2.1 write plist file to sandbox as "latest.plist"
		//3. all connection was down,
		//	3.1 check if latest.plist exist.
		//	3.2 if latest.plist doesn't exist load dictionary from boundle "dataFile.plist"
	
    if (self) {
        NSLog(@"%@", @"Init DataSourceMgr");		
		Reachability *r = [Reachability reachabilityWithHostname:@"www.imagicapp.com"];
		NetworkStatus internetStatus = [r currentReachabilityStatus];

		if ((internetStatus == ReachableViaWiFi) || (internetStatus == ReachableViaWWAN))
		{
			[self loadDataFileFromServer];
		}
		
		NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *latestFilePath = [path stringByAppendingPathComponent:@"latest.plist"];

		if ([MaUtility isFileExist:latestFilePath]) {
			_rootDictonary = [[NSDictionary alloc] initWithContentsOfFile:latestFilePath];
			_enumArray = [_rootDictonary objectForKey:@"enumArray"];
			_currentActivityArray = [[NSMutableArray alloc] init];
			_dataSource = [[NSMutableArray alloc] init];
		}
		else
		{
			NSString* path = [[NSBundle mainBundle] pathForResource:@"dataFile" ofType:@"plist"];        
			_rootDictonary = [[NSDictionary alloc] initWithContentsOfFile:path];
			_enumArray = [_rootDictonary objectForKey:@"enumArray"];
			_currentActivityArray = [[NSMutableArray alloc] init];
			_dataSource = [[NSMutableArray alloc] init];
		}
//        [self loadImageIndex];
    }
    return self;
}

-(void)loadDataFileFromServer
{
	NSURL *theFileURL = [NSURL URLWithString:@"http://imagicapp.com/wp-content/uploads/2013/02/dataFile.plist_.txt"];
    NSDictionary *serverDict = [[NSDictionary alloc] initWithContentsOfURL:theFileURL];
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *finalPath = [path stringByAppendingPathComponent:@"latest.plist"];

	NSLog(@"%@",finalPath);
	[serverDict writeToFile:finalPath atomically:YES];
}

-(void)updateDataSourceArrayByViewType:(MO_CAFE_TYPE)type
{
    [_dataSource removeAllObjects];
	//    NSLog(@"%@", @"UpdateSiteArray");
    /*
     Get Array Name from enumArray type;
     Get array from Root ditionary;
     */
    NSString* arrayName = [_enumArray objectAtIndex:type];
	NSDictionary* dict = [_rootDictonary objectForKey:arrayName];
	[_dataSource addObjectsFromArray:[dict objectForKey:@"itemArray"]];

}

-(NSDictionary*)itemInfoByViewType:(MO_CAFE_TYPE)type;
{
	NSString* arrayName = [_enumArray objectAtIndex:type];
	return [_rootDictonary objectForKey:arrayName];
}


/*
-(void)loadImageIndex
{
    _imageIndexDict = [[NSMutableDictionary alloc] init];
    
    // Load imageIndex file.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"imageIndex" ofType:@"plist"];
    //    NSLog(@"Datasource Location... %@", path);
    NSDictionary* imageIndex = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString* sourceString = [imageIndex objectForKey:@"imageIndex"];
    
    // Fill all Item into Dict;
    NSString* withoutHeader = [sourceString stringByReplacingOccurrencesOfString:
                               [imageIndex objectForKey:@"headerString"] withString:@""];
    NSString* withoutMidd = [withoutHeader stringByReplacingOccurrencesOfString:
                             [imageIndex objectForKey:@"midString"] withString:@","];
    NSString* finalString = [withoutMidd stringByReplacingOccurrencesOfString:
                             [imageIndex objectForKey:@"endString"] withString:@"|"];
    
    //   NSLog(@"%@",finalString);
    
    for (int i = 0 ; i< ([finalString length]-1); ) {
        
        NSRange targetRange = NSMakeRange(i, [finalString length]-i);
        //        NSLog(@"targetRange is %@", NSStringFromRange(targetRange));
        
        NSRange subRange = [finalString rangeOfString:@"|" options:NSCaseInsensitiveSearch range: targetRange];
        //        NSLog(@"subRange is %@", NSStringFromRange(subRange));
        if(subRange.location == NSNotFound)
            break;
        
        NSRange itemRange = NSMakeRange(i, subRange.location -i );
        //        NSLog(@"itemRange is %@", NSStringFromRange(itemRange));
        
        NSString* itemString = [finalString substringWithRange:itemRange];
        //        NSLog(@"%@",itemString);
        
        NSRange splitRange = [itemString rangeOfString:@","];
        NSString* imagePath = [itemString substringWithRange:NSMakeRange(0, splitRange.location )];
        NSString* nameIndex = [itemString substringWithRange:NSMakeRange(splitRange.location + 1 ,itemString.length - splitRange.location -1)];
        
        [_imageIndexDict setObject:imagePath forKey:nameIndex];
        
        i=subRange.location+1;
    }
}
 */

@end
