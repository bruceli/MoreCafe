//
//  AsyncImageView.m
//
//  Version 1.4
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#asyncimageview
//  https://github.com/nicklockwood/AsyncImageView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "AsyncImageView.h"
#import "MoreCafeAppDelegate.h"
#import "MCProgressBarView.h"

#import <objc/message.h>


NSString *const AsyncImageLoadDidFinish = @"AsyncImageLoadDidFinish";
NSString *const AsyncImageLoadDidFail = @"AsyncImageLoadDidFail";
NSString *const AsyncImageTargetReleased = @"AsyncImageTargetReleased";
NSString *const AsyncImageUpdateProgressBar = @"AsyncImageUpdateProgressBar";

NSString *const AsyncImageImageKey = @"image";
NSString *const AsyncImageURLKey = @"URL";
NSString *const AsyncImageCacheKey = @"cache";
NSString *const AsyncImageErrorKey = @"error";


@interface AsyncImageConnection : NSObject

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL success;
@property (nonatomic, assign) SEL failure;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL cancelled;
@property (nonatomic) float expectedBytes; 

- (AsyncImageConnection *)initWithURL:(NSURL *)URL
                                cache:(NSCache *)cache
							   target:(id)target
							  success:(SEL)success
							  failure:(SEL)failure;

- (void)start;
- (void)cancel;
- (BOOL)isInCache;

@end


@implementation AsyncImageConnection

@synthesize connection = _connection;
@synthesize data = _data;
@synthesize URL = _URL;
@synthesize cache = _cache;
@synthesize target = _target;
@synthesize success = _success;
@synthesize failure = _failure;
@synthesize loading = _loading;
@synthesize cancelled = _cancelled;
@synthesize expectedBytes = _expectedBytes;
- (AsyncImageConnection *)initWithURL:(NSURL *)URL
                                cache:(NSCache *)cache
							   target:(id)target
							  success:(SEL)success
							  failure:(SEL)failure
{
    if ((self = [self init]))
    {
        self.URL = URL;
        self.cache = cache;
        self.target = target;
        self.success = success;
        self.failure = failure;
    }
    return self;
}

- (UIImage *)cachedImage
{
    if ([_URL isFileURL])
	{
		NSString *path = [[_URL absoluteURL] path];
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
		if ([path hasPrefix:resourcePath])
		{
			return [UIImage imageNamed:[path substringFromIndex:[resourcePath length]]];
		}
	}
    return [_cache objectForKey:_URL];
}

- (BOOL)isInCache
{
    return [self cachedImage] != nil;
}

- (void)loadFailedWithError:(NSError *)error
{
	_loading = NO;
	_cancelled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:AsyncImageLoadDidFail
                                                        object:_target
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                _URL, AsyncImageURLKey,
                                                                error, AsyncImageErrorKey,
                                                                nil]];
}

-(void)setProgressValue:(NSNumber*)value
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:value,@"value",nil];	
	[[NSNotificationCenter defaultCenter] postNotificationName:AsyncImageUpdateProgressBar
														object:_target
													  userInfo:[[dict copy] autorelease]];
//	NSLog(@"AsyncImageConnection set progress bar %f",[value floatValue]);
}

- (void)cacheImage:(UIImage *)image
{
	if (!_cancelled)
	{
        if (image && _URL)
        {
            BOOL storeInCache = YES;
            if ([_URL isFileURL])
            {
                if ([[[_URL absoluteURL] path] hasPrefix:[[NSBundle mainBundle] resourcePath]])
                {
                    //do not store in cache
                    storeInCache = NO;
                }
            }
            if (storeInCache)
            {
                [_cache setObject:image forKey:_URL];
            }
        }
        
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										 image, AsyncImageImageKey,
										 _URL, AsyncImageURLKey,
										 nil];
		if (_cache)
		{
			[userInfo setObject:_cache forKey:AsyncImageCacheKey];
		}
		
		_loading = NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:AsyncImageLoadDidFinish
															object:_target
														  userInfo:[[userInfo copy] autorelease]];
	}
	else
	{
		_loading = NO;
		_cancelled = NO;
	}
}

- (void)processDataInBackground:(NSData *)data
{
	@synchronized ([self class])
	{	
		if (!_cancelled)
		{
            UIImage *image = [[UIImage alloc] initWithData:data];
			if (image)
			{
				//add to cache (may be cached already but it doesn't matter)
                [self performSelectorOnMainThread:@selector(cacheImage:)
                                       withObject:image
                                    waitUntilDone:YES];
                [image release];
			}
			else
			{
                @autoreleasepool
                {
                    NSError *error = [NSError errorWithDomain:@"AsyncImageLoader" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Invalid image data" forKey:NSLocalizedDescriptionKey]];
                    [self performSelectorOnMainThread:@selector(loadFailedWithError:) withObject:error waitUntilDone:YES];
				}
			}
		}
		else
		{
			//clean up
			[self performSelectorOnMainThread:@selector(cacheImage:)
								   withObject:nil
								waitUntilDone:YES];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *r = (NSHTTPURLResponse*) response;
	NSDictionary *headers = [r allHeaderFields];
	if (headers){
		if ([headers objectForKey: @"Content-Length"]) {
		//	NSLog(@"Content-Length: %@", [headers objectForKey: @"Content-Length"]);
			_expectedBytes = [[headers objectForKey: @"Content-Length"] floatValue];
		}
	}
	
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //add data
    [_data appendData:data];
	float receivedLen = [_data length];
	float percentValue = 0.0;
	if (_expectedBytes > 0) {
		percentValue = receivedLen/_expectedBytes;
	}
	
	NSNumber* value = [NSNumber numberWithFloat:percentValue];
	[self performSelectorOnMainThread:@selector(setProgressValue:) withObject:value waitUntilDone:NO];
	
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self performSelectorInBackground:@selector(processDataInBackground:) withObject:_data];
    self.connection = nil;
    self.data = nil;
//	[MoreCafeAppDelegate decreaseNetworkActivityIndicator];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    self.data = nil;
    [self loadFailedWithError:error];
	[MoreCafeAppDelegate decreaseNetworkActivityIndicator];
}

- (void)start
{
    if (_loading && !_cancelled)
    {
        return;
    }
	
	//begin loading
	_loading = YES;
	_cancelled = NO;
    
    //check for nil URL
    if (_URL == nil)
    {
        [self cacheImage:nil];
        return;
    }
    
    //check for cached image
	UIImage *image = [self cachedImage];
    if (image)
    {
        //add to cache (cached already but it doesn't matter)
        [self performSelectorOnMainThread:@selector(cacheImage:)
                               withObject:image
                            waitUntilDone:NO];
        return;
    }
    
    //begin load
    NSURLRequest *request = [NSURLRequest requestWithURL:_URL
                                             cachePolicy:NSURLCacheStorageNotAllowed
                                         timeoutInterval:[AsyncImageLoader sharedLoader].loadingTimeout];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_connection start];
}

- (void)cancel
{
	_cancelled = YES;
    [_connection cancel];
    self.connection = nil;
    self.data = nil;
}

- (void)dealloc
{
    [_connection release];
    [_data release];
    [_URL release];
    [_target release];
    [super ah_dealloc];
}

@end


@interface AsyncImageLoader ()

@property (nonatomic, strong) NSMutableArray *connections;

@end


@implementation AsyncImageLoader

@synthesize cache = _cache;
@synthesize connections = _connections;
@synthesize concurrentLoads = _concurrentLoads;
@synthesize loadingTimeout = _loadingTimeout;

+ (AsyncImageLoader *)sharedLoader
{
	static AsyncImageLoader *sharedInstance = nil;
	if (sharedInstance == nil)
	{
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

+ (NSCache *)defaultCache
{
    static NSCache *sharedInstance = nil;
	if (sharedInstance == nil)
	{
		sharedInstance = [[NSCache alloc] init];
	}
	return sharedInstance;
}

- (AsyncImageLoader *)init
{
	if ((self = [super init]))
	{
        self.cache = [[self class] defaultCache];
        _concurrentLoads = 2;
        _loadingTimeout = 60.0;
		_connections = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageLoaded:)
													 name:AsyncImageLoadDidFinish
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageFailed:)
													 name:AsyncImageLoadDidFail
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(targetReleased:)
													 name:AsyncImageTargetReleased
												   object:nil];
	}
	return self;
}

- (void)updateQueue
{
    //start connections
    NSInteger count = 0;
    for (AsyncImageConnection *connection in _connections)
    {
        if (![connection isLoading])
        {
            if ([connection isInCache])
            {
                [connection start];
            }
            else if (count < _concurrentLoads)
            {
                count ++;
                [connection start];
            }
        }
    }
}

- (void)imageLoaded:(NSNotification *)notification
{  
    //complete connections for URL
    NSURL *URL = [notification.userInfo objectForKey:AsyncImageURLKey];
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.URL == URL || [connection.URL isEqual:URL])
        {
            //cancel earlier connections for same target/action
            for (int j = i - 1; j >= 0; j--)
            {
                AsyncImageConnection *earlier = [_connections objectAtIndex:j];
                if (earlier.target == connection.target &&
                    earlier.success == connection.success)
                {
                    [earlier cancel];
                    [_connections removeObjectAtIndex:j];
                    i--;
                }
            }
            
            //cancel connection (in case it's a duplicate)
            [connection cancel];
            
            //perform action
			UIImage *image = [notification.userInfo objectForKey:AsyncImageImageKey];
            objc_msgSend(connection.target, connection.success, image, connection.URL);

            //remove from queue
            [_connections removeObjectAtIndex:i];
        }
    }
    
    //update the queue
    [self updateQueue];
}

- (void)imageFailed:(NSNotification *)notification
{
    //remove connections for URL
    NSURL *URL = [notification.userInfo objectForKey:AsyncImageURLKey];
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if ([connection.URL isEqual:URL])
        {
            //cancel connection (in case it's a duplicate)
            [connection cancel];
            
            //perform failure action
            if (connection.failure)
            {
                NSError *error = [notification.userInfo objectForKey:AsyncImageErrorKey];
                objc_msgSend(connection.target, connection.failure, error, URL);
            }
            
            //remove from queue
            [_connections removeObjectAtIndex:i];
        }
    }
    
    //update the queue
    [self updateQueue];
}

- (void)targetReleased:(NSNotification *)notification
{
    //remove connections for URL
    id target = [notification object];
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target)
        {
            //cancel connection
            [connection cancel];
            [_connections removeObjectAtIndex:i];
        }
    }
    
    //update the queue
    [self updateQueue];
}

- (void)loadImageWithURL:(NSURL *)URL target:(id)target success:(SEL)success failure:(SEL)failure
{
    //check cache
    UIImage *image = [_cache objectForKey:URL];
    if (image)
    {
        [self cancelLoadingImagesForTarget:self action:success];
        if (success) [target performSelectorOnMainThread:success withObject:image waitUntilDone:NO];
        return;
    }
    
    //create new connection
    AsyncImageConnection *connection = [[AsyncImageConnection alloc] initWithURL:URL
                                                                           cache:_cache
                                                                          target:target
                                                                         success:success
                                                                         failure:failure];
    BOOL added = NO;
    for (int i = 0; i < [_connections count]; i++)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (!connection.loading)
        {
            [_connections insertObject:connection atIndex:i];
            added = YES;
            break;
        }
    }
    if (!added)
    {
        [_connections addObject:connection];
    }
    
    [connection release];
    [self updateQueue];
}

- (void)loadImageWithURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    [self loadImageWithURL:URL target:target success:action failure:NULL];
}

- (void)loadImageWithURL:(NSURL *)URL
{
    [self loadImageWithURL:URL target:nil success:NULL failure:NULL];
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if ([connection.URL isEqual:URL] && connection.target == target && connection.success == action)
        {
            [connection cancel];
            [_connections removeObjectAtIndex:i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if ([connection.URL isEqual:URL] && connection.target == target)
        {
            [connection cancel];
            [_connections removeObjectAtIndex:i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if ([connection.URL isEqual:URL])
        {
            [connection cancel];
            [_connections removeObjectAtIndex:i];
        }
    }
}

- (void)cancelLoadingImagesForTarget:(id)target action:(SEL)action
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target && connection.success == action)
        {
            [connection cancel];
        }
    }
}

- (void)cancelLoadingImagesForTarget:(id)target
{
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target)
        {
            [connection cancel];
        }
    }
}

- (NSURL *)URLForTarget:(id)target action:(SEL)action
{
    //return the most recent image URL assigned to the target for the given action
    //this is not neccesarily the next image that will be assigned
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target && connection.success == action)
        {
            return [[connection.URL ah_retain] autorelease];
        }
    }
    return nil;
}

- (NSURL *)URLForTarget:(id)target
{
    //return the most recent image URL assigned to the target
    //this is not neccesarily the next image that will be assigned
    for (int i = [_connections count] - 1; i >= 0; i--)
    {
        AsyncImageConnection *connection = [_connections objectAtIndex:i];
        if (connection.target == target)
        {
            return [[connection.URL ah_retain] autorelease];
        }
    }
    return nil;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [_cache release];
    [_connections release];
    [super ah_dealloc];
}

@end


@implementation UIImageView(AsyncImageView)

- (void)setImageURL:(NSURL *)imageURL
{
	[[AsyncImageLoader sharedLoader] loadImageWithURL:imageURL target:self action:@selector(setImage:)];
}

- (NSURL *)imageURL
{
	return [[AsyncImageLoader sharedLoader] URLForTarget:self action:@selector(setImage:)];
}


@end


@interface AsyncImageView ()

//@property (nonatomic, strong) UIActivityIndicatorView *progressBarView;
@property (nonatomic, strong) MCProgressBarView *progressBarView;

@end


@implementation AsyncImageView

@synthesize showProgressBar = _showProgressBar;
@synthesize activityIndicatorStyle = _activityIndicatorStyle;
@synthesize crossfadeImages = _crossfadeImages;
@synthesize crossfadeDuration = _crossfadeDuration;
@synthesize progressBarView = _progressBarView;
@synthesize delegate;

- (void)setUp
{
//	_showProgressBar = (self.image == nil);
	_showProgressBar = NO;
	_activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    _crossfadeImages = YES;
	_crossfadeDuration = 0.4;

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateProgressbarValue:)
												 name:AsyncImageUpdateProgressBar
											   object:nil];

}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)setImageByString:(NSString*)imageAddress
{
    NSURL* theURL;
    if (imageAddress!=nil) {
        if ([imageAddress hasPrefix:@"http://"]) {
            theURL = [NSURL URLWithString:imageAddress];
        }
        else
        {
            NSString* theFilePathString = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageAddress];
            theURL = [NSURL fileURLWithPath:theFilePathString];
        }
    }
    [self setImageURL:theURL];
}

- (void)setImageURL:(NSURL *)imageURL
{
    super.imageURL = imageURL;
    if (_showProgressBar && !self.image)
    {
        if (_progressBarView == nil)
        {
//            _progressBarView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_activityIndicatorStyle];
//            _progressBarView.hidesWhenStopped = YES;
			UIImage * backgroundImage = [[UIImage imageNamed:@"progress-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
			UIImage * foregroundImage = [[UIImage imageNamed:@"progress-fg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];

			CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width-40, 20);
			_progressBarView = [[MCProgressBarView alloc] initWithFrame:frame backgroundImage:backgroundImage foregroundImage:foregroundImage];
			_progressBarView.progress = 0.0;

			_progressBarView.backgroundColor = [UIColor clearColor];
            _progressBarView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
            _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [self addSubview:_progressBarView];
        }
//        [_progressBarView startAnimating];
    }
}

-(void)updateProgressbarValue:(NSNotification *)notification
{
//	_progressBarView.progress = value;
	NSNumber* value = [notification.userInfo objectForKey:@"value"];
	_progressBarView.progress = value.floatValue;
}


- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
	_activityIndicatorStyle = style;
	[_progressBarView removeFromSuperview];
	self.progressBarView = nil;
}

- (void)setImage:(UIImage *)image
{
    if (_crossfadeImages)
    {
        //implement crossfade transition without needing to import QuartzCore
        id animation = objc_msgSend(NSClassFromString(@"CATransition"), @selector(animation));
        objc_msgSend(animation, @selector(setType:), @"kCATransitionFade");
        objc_msgSend(animation, @selector(setDuration:), _crossfadeDuration);
        objc_msgSend(self.layer, @selector(addAnimation:forKey:), animation, nil);
    }
    super.image = image;
	
	// call delegate to resize self frame.
//	if([delegate respondsToSelector:@selector(imageIsReadyNotify)])
//		[self.delegate calendarMonthView:self monthDidChange:dateForMonth animated:YES];
	if (delegate) {
		[delegate imageIsReadyNotify:self];
	}
	
	[_progressBarView removeFromSuperview];
//    [_progressBarView stopAnimating];

}

- (void)dealloc
{
    [[AsyncImageLoader sharedLoader] cancelLoadingURL:self.imageURL target:self];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_progressBarView release];
    [super ah_dealloc];
}

- (CGSize)imageScale {
    CGFloat sx = self.frame.size.width / self.image.size.width;
    CGFloat sy = self.frame.size.height / self.image.size.height;
    CGFloat s = 1.0;
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFit:
            s = fminf(sx, sy);
            return CGSizeMake(s, s);
            break;
			
        case UIViewContentModeScaleAspectFill:
            s = fmaxf(sx, sy);
            return CGSizeMake(s, s);
            break;
			
        case UIViewContentModeScaleToFill:
            return CGSizeMake(sx, sy);
			
        default:
            return CGSizeMake(s, s);
    }
}


@end
