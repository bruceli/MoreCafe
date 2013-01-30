//
//  MaAboutViewController.m
//  MoreCafe
//
//  Created by Thunder on 1/24/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaAboutViewController.h"
#import "AsyncImageView.h"
#import "UIBarButtonItem+StyledButton.h"
#import "MaUtility.h"
#import "MoreCafeAppDelegate.h"
#import "SinaWeibo.h"

@interface MaAboutViewController ()

@end

@implementation MaAboutViewController
@synthesize dict = _dict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIImage *image = [UIImage imageNamed:@"backButtom"];
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(dismissViewController) buttomImage:image];
	
	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];
	CGRect scrollViewFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height - MA_TOOLBAR_HEIGHT);
	_scrollerView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
	self.view = _scrollerView;
	
	_scrollerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbackground"]];
	[self initSubViews];
	
	_checkThread = [[NSThread alloc] initWithTarget:self selector:@selector(checkWeiboStatus) object:nil];
	[_checkThread start];
	// Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[_checkThread cancel];
}

-(void) dismissViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initSubViews
{	
	[self setupImageView];
	
	NSString* aboutString = [self getAboutString];
	CGFloat height = [MaUtility estimateHeightBy:aboutString image:nil];
	
	_detailTextView = [[DTAttributedTextView alloc]initWithFrame:CGRectMake(20,220,280,height)];
	_detailTextView.textDelegate = self;
	_detailTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_detailTextView.backgroundColor = [UIColor clearColor];
	_detailTextView.scrollEnabled = NO;
	
	[MaUtility fillText:aboutString to:_detailTextView];
	
	[self.view addSubview: _imgView];
	[self.view addSubview: _detailTextView];
	
	[self setupMapView];
	[self setupWeiboLogoutView];
	[self updateWeiboStatus];
	
	height+= _imgView.frame.size.height+_imgView.frame.origin.y+_mapLable.frame.size.height + _logoutLable.frame.size.height;
	
	CGSize size = CGSizeMake(_scrollerView.frame.size.width, height);
	_scrollerView.contentSize = size;	
	
	
}

-(NSString*)getAboutString
{
	NSMutableString* string = [[NSMutableString alloc] init];
	
	NSString* detailString = [MaUtility encodeingText:[_dict objectForKey:@"detail"]]; 
	NSString* addressString = [MaUtility encodeingText:[_dict objectForKey:@"address"]]; 
	NSString* telString = [MaUtility encodeingText:[_dict objectForKey:@"tel"]]; 
	NSString* tipsString = [MaUtility encodeingText:[_dict objectForKey:@"tips"]]; 
	
	[string appendString:detailString];
	[string appendString:addressString];
	[string appendString:telString];
	[string appendString:tipsString];
	
	return string;
}

-(void)setupImageView
{
	_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 280, 186)];
	UIImage* img = [UIImage imageNamed:@"cafeAbout.jpg"];
	_imgView.image = img;
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTap.numberOfTapsRequired = 1;
	[_imgView setUserInteractionEnabled:YES];
    [_imgView addGestureRecognizer:singleTap];
}



-(void)setupMapView
{
	CGRect frame = CGRectMake(20, 540, 280, 40);
	_mapLable = [[UILabel alloc] initWithFrame:frame];
	
	_mapLable.backgroundColor = [UIColor colorWithRed:79/255.0 green:48/255.0 blue:48/255.0 alpha:0.5 ];
	
	_mapLable.text = NSLocalizedString(@"checkMap",nil);
	_mapLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_mapLable.font = [UIFont systemFontOfSize:18];
	_mapLable.textAlignment = NSTextAlignmentCenter;
	_mapLable.textColor = [UIColor whiteColor];
	_mapLable.opaque = NO;
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTap.numberOfTapsRequired = 1;
	[_mapLable setUserInteractionEnabled:YES];
    [_mapLable addGestureRecognizer:singleTap];
	
	[self.view addSubview:_mapLable];
}


-(void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
	[self toggleZoom:gestureRecognizer.view];
}

-(void) toggleZoom:(UIView*) sender 
{
	if (_hiddenView)
	{					
		// zoomout
		CGRect frame = [sender.window convertRect:_hiddenView.frame fromView:_hiddenView.superview];
		[UIView animateWithDuration:0.3 animations:
		 ^{ sender.frame = frame; sender.alpha = 0.0;} 
						 completion:
		 ^(BOOL finished){
			 [_scaleImageView removeFromSuperview];
			 _hiddenView = nil;
			 _scaleImageView = nil;
		 }];
	}
	else
	{					// zoom in		
		_hiddenView = (AsyncImageView*)sender;
		CGRect frame = [sender.window convertRect:sender.frame fromView:sender.superview];
		
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		_scaleImageView = [[MaScaleImageView alloc] initWithFrame:frame];
		_scaleImageView.scaleImageViewDelegate = self;
		[UIView animateWithDuration:0.2 animations:^{ _scaleImageView.frame = screenRect; }];
		
		if (sender == _imgView) {
			[_scaleImageView setImage:[UIImage imageNamed:@"cafeAbout.jpg"] ]; 
		}
		else if (sender == _mapLable)
		{
			[_scaleImageView setImage:[UIImage imageNamed:@"maps.jpg"] ]; 
		}
		[sender.window addSubview:_scaleImageView];		
	}
}

-(void)setupWeiboLogoutView
{
	/*	_weiboStatusView = [[DTAttributedTextView alloc]initWithFrame:CGRectMake(20,600,280,30)];
	 _weiboStatusView.textDelegate = self;
	 _weiboStatusView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	 _weiboStatusView.backgroundColor = [UIColor clearColor];
	 _weiboStatusView.scrollEnabled = NO;
	 NSMutableString* string = [[NSMutableString alloc]init];
	 [string appendString:NSLocalizedString(@"WeiboDisconnected",nil)];
	 //replaceCharactersInRange:(NSRange)range withString:(NSString *)aString;
	 [MaUtility fillText:[MaUtility encodeingText:string] to:_weiboStatusView];
	 [self.view addSubview:_weiboStatusView];
	 */	
	
	
	CGRect frame = CGRectMake(20, 600, 280, 40);
	_logoutLable = [[UILabel alloc] initWithFrame:frame];
	
	_logoutLable.backgroundColor = [UIColor colorWithRed:160/255.0 green:0/255.0 blue:0/255.0 alpha:0.5 ];
	
	_logoutLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_logoutLable.font = [UIFont systemFontOfSize:18];
	_logoutLable.textAlignment = NSTextAlignmentCenter;
	_logoutLable.textColor = [UIColor whiteColor];
	_logoutLable.opaque = NO;
	[_logoutLable setUserInteractionEnabled:YES];
	
	[self.view addSubview:_logoutLable];	
}

-(void)checkWeiboStatus
{
	while (TRUE) {
		[NSThread sleepForTimeInterval:3];
		if([[NSThread currentThread] isCancelled])
			break;
		
		[self performSelectorOnMainThread:@selector(updateWeiboStatus) withObject:nil waitUntilDone:YES]; 
	}
}


-(void)updateWeiboStatus
{
    MoreCafeAppDelegate *app = (MoreCafeAppDelegate *)[UIApplication sharedApplication].delegate;
	if([app.sinaweibo isLoggedIn])
	{
		//		NSLog(@"%@",@"loggedIN");
		_logoutLable.backgroundColor = [UIColor colorWithRed:160/255.0 green:0/255.0 blue:0/255.0 alpha:0.5 ];
		_logoutLable.text = NSLocalizedString(@"WeiboDisconnect",nil);
		_weiboButtomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWeiboTap:)];
		_weiboButtomTap.numberOfTapsRequired = 1;
		[_logoutLable addGestureRecognizer:_weiboButtomTap];
		
	}
	else{
		//		NSLog(@"%@",@"logged Out");
		_logoutLable.backgroundColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5 ];
		_logoutLable.text = NSLocalizedString(@"WeiboNotConnect",nil);
		[_logoutLable removeGestureRecognizer:_weiboButtomTap];
	}
}

-(void)handleWeiboTap:(UIGestureRecognizer *)gestureRecognizer
{
	[_logoutLable removeGestureRecognizer:_weiboButtomTap];
	_logoutLable.backgroundColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5 ];
	_logoutLable.text = NSLocalizedString(@"WeiboDisconnecting",nil);
    MoreCafeAppDelegate *app = (MoreCafeAppDelegate *)[UIApplication sharedApplication].delegate;
	[app.sinaweibo logOut];
}

@end
