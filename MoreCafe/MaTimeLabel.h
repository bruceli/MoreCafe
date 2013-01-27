//
//  MaTimeLabel.h
//  MoreCafe
//
//  Created by Thunder on 1/8/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaTimeLabel : UILabel
{
	NSTimeInterval createTime;
}
-(void)initWithCreateTime:(NSString*)inTime;
-(void)refreshLabel;
@end
