//
//  MaScaleImageView.m
//  MoreArt
//
//  Created by Thunder on 11/30/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import "MaScaleImageView.h"


@implementation MaScaleImageView
@synthesize scaleImageViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		CGRect screenFrame = [[UIScreen mainScreen] bounds];

		_imageView = [[AsyncImageView alloc] initWithFrame:screenFrame];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		_imageView.clipsToBounds = YES;
		_imageView.showActivityIndicator = YES;
		_imageView.delegate = self;
		_imageView.backgroundColor = [UIColor clearColor];

		self.delegate = self;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		[self setMinimumZoomScale:MA_MIN_ZOOM_RATE];
		[self setMaximumZoomScale:MA_MAX_ZOOM_RATE];
		[self setZoomScale:MA_MIN_ZOOM_RATE];

		[_imageView setTag:ZOOM_VIEW_TAG];
		_imageView.showActivityIndicator = YES;
		_imageView.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
		[[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_imageView];
		[self addSubview:_imageView];
		
		[self addTapGestureRecognizer];
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self viewWithTag:ZOOM_VIEW_TAG];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
//    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

-(void)loadImageFrom:(NSString*)imgPath
{
	[_imageView setImageByString:imgPath];
}
-(void)setPreloadedImages:(UIImage*)img
{
//	_imageView.image = img;
}

-(void)setImage:(UIImage*)img
{
	_imageView.image = img;
}

-(void)imageIsReadyNotify:(UIView*)view
{	
}

-(void)addTapGestureRecognizer
{
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTap.numberOfTapsRequired = 2;
	[self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:doubleTap];

	
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTap.numberOfTapsRequired = 1;
	[self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:singleTap];
	[singleTap requireGestureRecognizerToFail:doubleTap];
	
//	NSLog(@"ScrollView frame size is %@",NSStringFromCGRect(self.frame));
//	NSLog(@"ScrollView content size is %@",NSStringFromCGSize(self.contentSize));


}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
	UIView* view = gestureRecognizer.view;	
	[scaleImageViewDelegate toggleZoom:view];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
//	NSLog(@"zoomScale is %f", [self zoomScale]);
	CGSize newContentSize;
	CGRect zoomRect;
	CGRect newImageFrame;
	if ([self zoomScale] > MA_MIN_ZOOM_RATE) {
		zoomRect = [self zoomRectForScale:MA_MIN_ZOOM_RATE withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
		newContentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
		newImageFrame = _imageViewFrame;
	}
	else
	{
		zoomRect = [self zoomRectForScale:MA_MAX_ZOOM_RATE withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
		newContentSize = CGSizeMake(self.frame.size.width*3, self.frame.size.height*3);
		newImageFrame = CGRectMake(0, 0, _imageViewFrame.size.width, _imageViewFrame.size.height);

	}
//	_imageView.frame = newImageFrame;
	[self zoomToRect:zoomRect animated:YES];
	//self.contentSize = newContentSize;
	
//	NSLog(@"zoomRect to %@ ",NSStringFromCGRect(zoomRect));
//	NSLog(@"ScrollView frame size is %@",NSStringFromCGRect(self.frame));
//	NSLog(@"ScrollView content size is %@",NSStringFromCGSize(self.contentSize));

	
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center 
{
    CGRect zoomRect;
    zoomRect.size.height = [self.superview frame].size.height / scale;
    zoomRect.size.width  = [self.superview frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / scale);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / scale);
    
    return zoomRect;
}

-(void)changeRotation
{


}

@end
