//
//  NSDate+MaDate.m
//  MoreCafe
//
//  Created by Thunder on 1/8/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "NSDate+MaDate.h"

@implementation NSDate (MaDate)
- (NSString*)formatRelativeTime {
	NSTimeInterval elapsed = [self timeIntervalSinceNow];
	if (elapsed > 0) {
		if (elapsed <= 1) {
			return NSLocalizedString(@"in just a moment", @"");
		}
		else if (elapsed < MA_MINUTE) {
			int seconds = (int)(elapsed);
			return [NSString stringWithFormat:NSLocalizedString(@"in %d seconds", @""), seconds];
			
		}
		else if (elapsed < 2*MA_MINUTE) {
			return NSLocalizedString(@"in about a minute", @"");
		}
		else if (elapsed < MA_HOUR) {
			int mins = (int)(elapsed/MA_MINUTE);
			return [NSString stringWithFormat:NSLocalizedString(@"in %d minutes", @""), mins];
		}
		else if (elapsed < MA_HOUR*1.5) {
			return NSLocalizedString(@"in about an hour", @"");
		}
		else if (elapsed < MA_DAY) {
			int hours = (int)((elapsed+MA_HOUR/2)/MA_HOUR);
			return [NSString stringWithFormat:NSLocalizedString(@"in %d hours", @""), hours];
		}
		else {
			return [self formatDateTime];
		}
	}
	else {
		elapsed = -elapsed;
		
		if (elapsed <= 1) {
			return NSLocalizedString(@"just a moment ago", @"");
			
		} else if (elapsed < MA_MINUTE) {
			int seconds = (int)(elapsed);
			return [NSString stringWithFormat:NSLocalizedString(@"%d seconds ago", @""), seconds];
			
		} else if (elapsed < 2*MA_MINUTE) {
			return NSLocalizedString(@"about a minute ago", @"");
			
		} else if (elapsed < MA_HOUR) {
			int mins = (int)(elapsed/MA_MINUTE);
			return [NSString stringWithFormat:NSLocalizedString(@"%d minutes ago", @""), mins];
			
		} else if (elapsed < MA_HOUR*1.5) {
			return NSLocalizedString(@"about an hour ago", @"");
			
		} else if (elapsed < MA_DAY) {
			int hours = (int)((elapsed+MA_HOUR/2)/MA_HOUR);
			return [NSString stringWithFormat:NSLocalizedString(@"%d hours ago", @""), hours];
			
		} else {
			return [self formatDateTime];
		}
	}
}

- (NSString*)formatTime {
	static NSDateFormatter* formatter = nil;
	if (nil == formatter) {
		formatter = [[NSDateFormatter alloc] init];
		formatter.dateFormat = NSLocalizedString(@"h:mm a", @"Date format: 1:05 pm");
		formatter.locale = MaCurrentLocale();
	}
	return [formatter stringFromDate:self];
}

- (NSString*)formatDateTime {
	NSTimeInterval diff = abs([self timeIntervalSinceNow]);
	if (diff < MA_DAY) {
		return [self formatTime];
		
	} else if (diff < MA_5_DAYS) {
		static NSDateFormatter* formatter = nil;
		if (nil == formatter) {
			formatter = [[NSDateFormatter alloc] init];
			formatter.dateFormat = NSLocalizedString(@"EEE h:mm a", @"Date format: Mon 1:05 pm");
			formatter.locale = MaCurrentLocale();
		}
		return [formatter stringFromDate:self];
		
	} else {
		static NSDateFormatter* formatter = nil;
		if (nil == formatter) {
			formatter = [[NSDateFormatter alloc] init];
			formatter.dateFormat = NSLocalizedString(@"MMM d h:mm a", @"Date format: Jul 27 1:05 pm");
			formatter.locale = MaCurrentLocale();
		}
		return [formatter stringFromDate:self];
	}
}

NSLocale* MaCurrentLocale() {
	NSArray* languages = [NSLocale preferredLanguages];
	if (languages.count > 0) {
		NSString* currentLanguage = [languages objectAtIndex:0];
		return [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] autorelease];
		
	} else {
		return [NSLocale currentLocale];
	}
}

@end
