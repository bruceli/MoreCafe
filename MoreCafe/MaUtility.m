//
//  MaUtility.m
//  MoreCafe
//
//  Created by Thunder on 1/10/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaUtility.h"

@implementation MaUtility
+ (NSString*) encodeingText:(NSString*)text
{
	if ([text length]==0) {
		return @"";
	}
	
	NSString* path = [[NSBundle mainBundle] pathForResource:@"css" ofType:@"plist"];
    NSDictionary* cssStyleDict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	NSMutableString* subEventString = [[NSMutableString alloc] init];
	// Event Name <p style="font-size:15px;line-height:15px;color:white;">eventName</p>
	[subEventString insertString:[cssStyleDict objectForKey:@"kMA_MESSAGE_BODY_STYLE"] atIndex:0];
	[subEventString insertString:[cssStyleDict objectForKey:@"kMA_PARAGRPH_HEADER"] atIndex:0];
	[subEventString appendString:text];
	[subEventString appendString:[cssStyleDict objectForKey:@"kMA_PARAGRPH_END"]];
	//<ul  style="font-size:13px;line-height:15px;color:white;">
	
	return subEventString;
}

+ (void)fillText:(NSString*)inString to:(DTAttributedTextView*)view
{
	if ([inString length]==0) {
		return;
	}
	
	void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
		// if an element is larger than twice the font size put it in it's own block
		if (element.displayStyle == DTHTMLElementDisplayStyleInline && element.textAttachment.displaySize.height > 2.0 * element.fontDescriptor.pointSize)
		{
			element.displayStyle = DTHTMLElementDisplayStyleBlock;
		}
	};
	
	NSData *data = [inString dataUsingEncoding:NSUTF8StringEncoding];
    CGSize maxImageSize = CGSizeMake(view.bounds.size.width - 20.0, view.bounds.size.height - 20.0);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0],
                             NSTextSizeMultiplierDocumentOption,
                             [NSValue valueWithCGSize:maxImageSize],
                             DTMaxImageSize,
                             @"STHeitiSC-Light",
                             DTDefaultFontFamily,
                             @"",
                             DTDefaultLinkColor,
                             callBackBlock,
                             DTWillFlushBlockCallBack,
                             nil];
    
	NSAttributedString *string = [NSAttributedString alloc];
    string = [string initWithHTMLData:data options:options documentAttributes:NULL];
    
	view.attributedString = string;
}

+ (CGFloat) estimateHeightBy:(NSString*)text image:(NSString*)imageURL
{
	CGFloat height = 0;
	if ([text length]>0)
	{
		DTAttributedTextView* textView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0,0, MA_CELL_MESSAGE_WIDTH, MA_CELL_MESSAGE_HEIGHT)];
		NSString* string = [MaUtility encodeingText:text]; 
		[MaUtility fillText:string to:textView];
		
		CGSize textViewSize = [textView.contentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:MA_CELL_MESSAGE_WIDTH];
		
		height = textViewSize.height;
	}
	if ([imageURL length]>0)
		height += 65;
	
    return height;
}


@end
