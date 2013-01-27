//
//  MaUtility.h
//  MoreCafe
//
//  Created by Thunder on 1/10/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaUtility : NSObject

+ (NSString*) encodeingText:(NSString*)text;
+ (void)fillText:(NSString*)inString to:(DTAttributedTextView*)view;
+ (CGFloat) estimateHeightBy:(NSString*)text image:(NSString*)imageURL;

@end
