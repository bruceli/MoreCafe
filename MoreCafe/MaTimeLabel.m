//
//  MaTimeLabel.m
//  MoreCafe
//
//  Created by Thunder on 1/8/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaTimeLabel.h"
#import "NSDate+MaDate.h"

@implementation MaTimeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        createTime = 0;
        [NSThread detachNewThreadSelector:@selector(updateRelativeTime) toTarget:self withObject:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (time_t)getTimeValue:(NSString *)stringTime defaultValue:(time_t)defaultValue {
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}


-(void)initWithCreateTime:(NSString*)inTime
{
    // User tweets create time
    createTime = [self getTimeValue:inTime defaultValue:0];
}

-(void)refreshLabel
{
    NSDate* createdAt =  [NSDate dateWithTimeIntervalSince1970: createTime];
    NSString* dateString = [createdAt formatRelativeTime];
    self.text = dateString;
    
    //    NSLog(@"Updating: CreateAt %@ ",dateString);
}

-(void)updateRelativeTime
{
    while(TRUE) {
        [NSThread sleepForTimeInterval:1];
        [self performSelectorOnMainThread:@selector(refreshLabel) withObject:nil waitUntilDone:YES]; 
    }
}

@end
