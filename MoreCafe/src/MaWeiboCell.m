//
//  MaWeiboCell.m
//  MoreCafe
//
//  Created by Thunder on 1/7/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//
#import "MaWeiboCell.h"
#import "MaTimeLabel.h"

@implementation MaWeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self initCell];
		[self fillCellContent];
		
		
		
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initCell
{
/*
 AsyncImageView* _userIconView;
 UILabel* _userNameView;
 UILabel* _timeView;
 DTAttributedTextView* _messageTextView;
 AsyncImageView* _messagePictView;
 
 UILabel* _sourceView;
 UILabel* _messageStatusView;
	 */
	_userIconView = [[AsyncImageView alloc]initWithFrame:CGRectMake(MA_CELL_GAP, MA_CELL_GAP, MA_CELL_IMG_SIZE, MA_CELL_IMG_SIZE)];
	_userNameView = [[UILabel alloc] initWithFrame:CGRectMake(_userIconView.frame.origin.x + _userIconView.frame.size.width + MA_CELL_GAP * 2, MA_CELL_GAP, MA_CELL_NAME_WIDTH, MA_CELL_NAME_HEIGHT)];
	
	_timeView = [[MaTimeLabel alloc] initWithFrame:CGRectMake(_userNameView.frame.origin.x+_userNameView.frame.size.width +MA_CELL_GAP , MA_CELL_GAP, MA_CELL_TIME_WIDTH, MA_CELL_TIME_HEIGHT)];
	_timeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	//	[_timeView initWithCreateTime:item.creatTime];
	//	[_timeView refreshLabel];	
	
	_messageTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(_userIconView.frame.origin.x + _userIconView.frame.size.width + MA_CELL_GAP * 2, _userNameView.frame.origin.y + MA_CELL_NAME_HEIGHT + MA_CELL_GAP, MA_CELL_MESSAGE_WIDTH, MA_CELL_MESSAGE_HEIGHT)];
	_messageTextView.textDelegate = self;
	_messageTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_messageTextView.backgroundColor = [UIColor clearColor];
	
	_messagePictView = [[AsyncImageView alloc]initWithFrame:CGRectMake(_userIconView.frame.origin.x + _userIconView.frame.size.width + MA_CELL_GAP * 2, _messageTextView.frame.origin.y + 60 + MA_CELL_GAP,  270, 110)];
//	_messagePictView.backgroundColor = [UIColor orangeColor];
	
	_sourceView = [[UILabel alloc]initWithFrame:CGRectZero];
	_messageStatusView = [[UILabel alloc]initWithFrame:CGRectZero];
	
	UIImageView* customSeperator=[[UIImageView alloc]initWithFrame:CGRectMake(0, 248, 320, 2)];
	customSeperator.image = [UIImage imageNamed:@"cell_seperator"];
	[self addSubview:customSeperator];  

	[self addSubview:_userIconView];
	[self addSubview:_userNameView];

	[self addSubview:_timeView];
	[self addSubview:_messageTextView];
	[self addSubview:_messagePictView];
	[self addSubview:_sourceView];
	[self addSubview:_messageStatusView];
	[self drawBubble:MA_CELL_MESSAGE_HEIGHT];
}

- (void)fillCellContent
{
	[_userIconView setImageByString:@"b.jpeg"];
	_userNameView.text = @"MoreCafé";
	_timeView.text = @"10月10日 23:00";
	[self fillText:@"<p>Surface weather analysis is a special type of weather map that provides a view of weather elements over a geographical area at a specified time </p>" to:_messageTextView];
	_sourceView.text = @"MoreCafé";
	_messageStatusView.text = @"Replay:10 | Comment:20";
}

-(void)fillText:(NSString*)inString to:(DTAttributedTextView*)view
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
	_messagePictView.image = img;
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
