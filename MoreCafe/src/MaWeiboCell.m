//
//  MaWeiboCell.m
//  MoreCafe
//
//  Created by Thunder on 1/7/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//
#import "MaWeiboCell.h"
#import "MaTimeLabel.h"
#import "MaUtility.h"

@implementation MaWeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self initCell];
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)initCell
{
	_userIconView = [[AsyncImageView alloc]initWithFrame:CGRectMake(MA_CELL_GAP, MA_CELL_GAP, MA_CELL_IMG_SIZE, MA_CELL_IMG_SIZE)];
	_userNameView = [[UILabel alloc] initWithFrame:CGRectMake(_userIconView.frame.origin.x + _userIconView.frame.size.width + MA_CELL_GAP, MA_CELL_GAP, MA_CELL_NAME_WIDTH, MA_CELL_NAME_HEIGHT)];
	_userNameView.backgroundColor = [UIColor clearColor];
	_userNameView.textColor = [UIColor darkGrayColor];
    _userNameView.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:18.0f];


	_timeView = [[MaTimeLabel alloc] initWithFrame:CGRectMake(_userNameView.frame.origin.x+_userNameView.frame.size.width +MA_CELL_GAP , MA_CELL_GAP, MA_CELL_TIME_WIDTH, MA_CELL_TIME_HEIGHT)];
	_timeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_timeView.backgroundColor = [UIColor clearColor];
	_timeView.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
	_timeView.textAlignment = NSTextAlignmentRight;
	_timeView.highlightedTextColor = [UIColor whiteColor];
	_timeView.textColor = [UIColor lightGrayColor];
	_timeView.opaque = NO;

	_messageTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(_userIconView.frame.origin.x + _userIconView.frame.size.width + MA_CELL_GAP, _userNameView.frame.origin.y + MA_CELL_NAME_HEIGHT, MA_CELL_MESSAGE_WIDTH, MA_CELL_MESSAGE_HEIGHT)];
	_messageTextView.textDelegate = self;
	_messageTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_messageTextView.backgroundColor = [UIColor clearColor];
	_messageTextView.scrollEnabled = NO;
	
	_messagePictView = [[AsyncImageView alloc]initWithFrame:CGRectMake(_userIconView.frame.origin.x + _userIconView.frame.size.width + MA_CELL_GAP, _messageTextView.frame.origin.y + 60 + MA_CELL_GAP,  MA_CELL_MESSAGE_PICT_SIZE, MA_CELL_MESSAGE_PICT_SIZE)];
	_messagePictView.contentMode = UIViewContentModeScaleAspectFit;
//	_messagePictView.backgroundColor = [UIColor orangeColor];
	
	_sourceView = [[UILabel alloc]initWithFrame:CGRectZero];
	_messageStatusView = [[UILabel alloc]initWithFrame:CGRectZero];
	
	_customSeperator=[[UIImageView alloc]initWithFrame:CGRectMake(0, 248, 320, 2)];
	_customSeperator.image = [UIImage imageNamed:@"cell_seperator"];
//	[self addSubview:_customSeperator];  

	[self addSubview:_userIconView];
	[self addSubview:_userNameView];
	[self addSubview:_timeView];
	[self addSubview:_messageTextView];
	[self addSubview:_messagePictView];
	[self addSubview:_sourceView];
	[self addSubview:_messageStatusView];

//	[self drawBubble:MA_CELL_MESSAGE_HEIGHT];
}

- (void)fillCellContent
{
	[_userIconView setImageByString:@"b.jpeg"];
	_userNameView.text = @"MoreCafé";
	_timeView.text = @"10月10日 23:00";
//	[self fillText:@"<p>Surface weather analysis is a special type of weather map that provides a view of weather elements over a geographical area at a specified time </p>" to:_messageTextView];
	_sourceView.text = @"MoreCafé";
	_messageStatusView.text = @"Replay:10 | Comment:20";
}

- (void)drawBubble:(CGFloat)height
{	
	CGFloat scaleValue = [[UIScreen mainScreen] scale];

	UIGraphicsBeginImageContextWithOptions(CGSizeMake(MA_CELL_MESSAGE_WIDTH,height), NO, scaleValue);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, MA_CELL_MESSAGE_LINE_WIDTH);
	CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]); 
	CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
	
	// Draw and fill the bubble
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, MA_CELL_MESSAGE_X_BORDER , MA_CELL_MESSAGE_Y_BORDER );
	CGContextAddLineToPoint(context, MA_CELL_MESSAGE_X_BORDER,  height - MA_CELL_MESSAGE_LINE_WIDTH);
	CGContextAddLineToPoint(context, MA_CELL_MESSAGE_WIDTH_OF_RETANGLE,	height-MA_CELL_MESSAGE_LINE_WIDTH);
	CGContextAddLineToPoint(context, MA_CELL_MESSAGE_WIDTH_OF_RETANGLE,	MA_CELL_MESSAGE_Y_BORDER);
	
	CGContextAddLineToPoint(context, MA_CELL_MESSAGE_WIDTH_OF_POPUP_TRIANGLE+MA_CELL_MESSAGE_X_DELTA_OF_POPUP_TRIANGLE,	MA_CELL_MESSAGE_Y_BORDER);
	CGContextAddLineToPoint(context, MA_CELL_MESSAGE_WIDTH_OF_POPUP_TRIANGLE/2+ MA_CELL_MESSAGE_X_DELTA_OF_POPUP_TRIANGLE, MA_CELL_MESSAGE_Y_BORDER - MA_CELL_MESSAGE_HEIGHT_OF_POPUP_TRIANGLE);
	CGContextAddLineToPoint(context,MA_CELL_MESSAGE_X_DELTA_OF_POPUP_TRIANGLE,MA_CELL_MESSAGE_Y_BORDER);
	
	CGContextAddLineToPoint(context, MA_CELL_MESSAGE_X_BORDER,  MA_CELL_MESSAGE_Y_BORDER);

	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);

	CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage* img = [UIImage imageWithCGImage:imgRef scale:scaleValue orientation:UIImageOrientationUp];
	
	if([_bubbleView isDescendantOfView:self])
	{
		[_bubbleView removeFromSuperview];
	}
	_bubbleView = nil;	
	_bubbleView = [[UIImageView alloc] initWithImage:img];
	[self addSubview:_bubbleView];
}

-(void) fillCellDataWith:(NSDictionary*)detail
{
	//------------------ 
	// Message Info
	//------------------ 
	// User tweets text
	NSString *msgText = [detail objectForKey:@"text"];
	// User tweets image
	NSString *msgImageURL = [detail objectForKey:@"thumbnail_pic"];
	// User tweets create time
	NSString *strTime = [detail objectForKey:@"created_at"];
	//        NSTimeInterval crtTime = [self getTimeValue:strTime defaultValue:0];
	//        NSDate *createdAt =  [NSDate dateWithTimeIntervalSince1970: crtTime];
	
	//------------------ 
	// User Info
	//------------------ 
	NSDictionary* user = [detail objectForKey:@"user"];
	NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
	NSString *screenName = [user objectForKey:@"screen_name"];
	
	//------------------ 
	// Retweets Info
	//------------------ 
	NSDictionary* retweets = [detail objectForKey:@"retweeted_status"];; 
	NSString* retweetImgURL = [retweets objectForKey:@"thumbnail_pic"];
	NSString* retweetMsgText = [retweets objectForKey:@"text"];
	
	//----------------
	// Fill Data
	//----------------
	[_userIconView setImageByString:profileImageUrl];
	_userNameView.text = screenName;
	NSString* string = [MaUtility encodeingText:msgText]; 
	[MaUtility fillText:string to:_messageTextView];
	[self adjustViewsBelowMessageTextView];
	
	[_timeView initWithCreateTime:strTime];
	[_timeView refreshLabel];

	if ([msgImageURL length]>0) {
		[_messagePictView setImageByString:msgImageURL];
		if(!([_messagePictView isDescendantOfView:self])) { 
			[self addSubview:_messagePictView];
		}
	}
	else
		[_messagePictView removeFromSuperview];
	
	if (retweets) {
		CGFloat height = [MaUtility estimateHeightBy:retweetMsgText image:retweetImgURL];
		height += MA_CELL_GAP*2;
		[self drawBubble:height];
		_bubbleView.frame = CGRectMake(_messageTextView.frame.origin.x,_messageTextView.frame.origin.y + _messageTextView.frame.size.height, _bubbleView.frame.size.width,_bubbleView.frame.size.height);
	}
	else
		[_bubbleView removeFromSuperview];

}

-(void)adjustViewsBelowMessageTextView
{
	CGSize textViewSize = [_messageTextView.contentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:MA_CELL_MESSAGE_WIDTH];
	
	CGFloat height = textViewSize.height+MA_CELL_GAP;
	_messageTextView.frame = CGRectMake(_messageTextView.frame.origin.x, _messageTextView.frame.origin.y, _messageTextView.frame.size.width, height);
	_messagePictView.frame = CGRectMake(_messagePictView.frame.origin.x, _messageTextView.frame.origin.y + height + MA_CELL_GAP, _messagePictView.frame.size.width, _messagePictView.frame.size.height);

	_customSeperator.frame = CGRectMake(0, _messagePictView.frame.origin.y+_messagePictView.frame.size.height  ,320 ,2);
}

// 
CGContextRef initContext (int pixelsWide,int pixelsHigh)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
        return NULL;
    
    context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        free (bitmapData);
        return NULL;
    }
	
    CGColorSpaceRelease( colorSpace );
    return context;
}

@end
