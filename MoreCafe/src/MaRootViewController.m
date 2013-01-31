//
//  MaRootViewController.m
//  MoreCafe
//
//  Created by Thunder on 12/29/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//

#import "MaRootViewController.h"
#import "MaWeiboViewController.h"
#import "MaListViewController.h"

#import "MoreCafeAppDelegate.h"
#import "MaDataSourceManager.h"
#import "MaAboutViewController.h"
#import "BBCyclingLabel.h"
#import "MaUtility.h"

@interface MaRootViewController ()
@end

@implementation MaRootViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_dataSourceMgr = [[MaDataSourceManager alloc] init];
		
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString* path = [[NSBundle mainBundle] pathForResource:@"proverb" ofType:@"plist"];        
	_proverbArray = [[NSArray alloc] initWithContentsOfFile:path];
	
	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];
	
	CGRect frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height - MA_TOOLBAR_HEIGHT);
	UIImageView* wallView = [[UIImageView alloc]initWithFrame:frame];	
	UIImage* wallImage = [UIImage imageNamed:@"wall"];
	wallView.image = wallImage;
	[self.view addSubview:wallView];
	
	_scrollView = [[UIScrollView alloc ] initWithFrame:frame ];
	_scrollView.showsHorizontalScrollIndicator=NO;
	_scrollView.showsVerticalScrollIndicator=NO;
	
	_scrollView.delegate = self;
	//_scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wall"]];
	_scrollView.backgroundColor = [UIColor clearColor];
	
	_currentIndex = 0;
	
	[self setupViewsByArray:_dataSourceMgr.enumArray];
	_scrollView.contentSize = CGSizeMake( MA_ART_WIDTH * [_dataSourceMgr.enumArray count] , bounds.size.height - MA_TOOLBAR_HEIGHT);
	
	CGRect proverbViewFrame = CGRectMake(30, 290, 270, 100);
	
	_proverbView = [[BBCyclingLabel alloc] initWithFrame:proverbViewFrame];
	_proverbView.transitionEffect = BBCyclingLabelTransitionEffectCrossFade;
	_proverbView.transitionDuration = 1.5;
	_proverbView.backgroundColor = [UIColor clearColor];
	_proverbView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_proverbView.font = [UIFont boldSystemFontOfSize:12];
	_proverbView.textAlignment = NSTextAlignmentLeft;
	_proverbView.textColor = [UIColor darkGrayColor];
	_proverbView.shadowColor = [UIColor whiteColor];
	_proverbView.shadowOffset = CGSizeMake(1, 1);
	_proverbView.opaque = NO;
	_proverbView.lineBreakMode = NSLineBreakByWordWrapping;
	_proverbView.numberOfLines = 0;
	_proverbView.clipsToBounds = YES;
	
	if ([MaUtility hasFourInchDisplay]) {
		UIImageView* bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 445, 320, 60)];
		bottomImageView.image = [UIImage imageNamed:@"bottomStyle"];
		[self.view addSubview:bottomImageView];	
	}

	[self updateProverb];
	[self.view addSubview:_proverbView];
	[self.view addSubview:_scrollView];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
//	[_proverbViewHelperThread cancel];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	UINavigationBar* navBar = self.navigationController.navigationBar;
	[navBar setBackgroundImage:[UIImage imageNamed: @"navBar"] forBarMetrics:UIBarMetricsDefault];

//	_proverbViewHelperThread = [[NSThread alloc] initWithTarget:self selector:@selector(refreshProverb) object:nil];
//	[_proverbViewHelperThread start];
}

-(void)refreshProverb
{
	while (TRUE) {
		[NSThread sleepForTimeInterval:10];
		if([[NSThread currentThread] isCancelled])
			break;
		
		[self performSelectorOnMainThread:@selector(updateProverb) withObject:nil waitUntilDone:YES]; 
	}
}

-(void)updateProverb
{
	NSInteger max = [_proverbArray count] - 1;
	NSInteger min = 0;
	NSInteger randNum = (arc4random() % (max - min) + min) ;
	
	NSString* string = [_proverbArray objectAtIndex:randNum];
	[_proverbView setText:string animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupViewsByArray:(NSArray*)itemArray
{
	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];
	UIImage* image = [UIImage imageNamed:@"artFrameLight"];
	
	for (int i = 0 ; i < [itemArray count]; i ++)
	{
		CGRect frame = CGRectMake(MA_ART_WIDTH * i ,
								  0,
								  MA_ART_WIDTH,
								  bounds.size.height - MA_TOOLBAR_HEIGHT );
		
		
		UIView* view = [[UIImageView alloc] initWithFrame:frame];
		[view setUserInteractionEnabled:YES];
		
		NSDictionary* dict = [_dataSourceMgr itemInfoByViewType:i];
		NSString* nameString = [dict objectForKey:@"name"];
		NSString* iconString = [dict objectForKey:@"icon"];
		
		UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20,20, 200, 250)];
		imgView.image = image;
		imgView.backgroundColor = [UIColor clearColor];
		imgView.contentMode = UIViewContentModeCenter;
		imgView.tag = Ma_VIEW_INDEX + i;
		[self addGestureRecognizerTo:imgView];
		
		AsyncImageView* iconView = [[AsyncImageView alloc] initWithFrame:CGRectMake(25, 60, 190, 190)]; 
		
		UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y+imgView.frame.size.height - 46,200,25)];
		lable.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
		lable.text = nameString;
		lable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		lable.font = [UIFont systemFontOfSize:18];
		lable.textAlignment = NSTextAlignmentCenter;
		lable.textColor = [UIColor whiteColor];
		lable.opaque = NO;
		
		
		[view addSubview:iconView];
		[view addSubview:lable];
		[view addSubview:imgView];
		
		if ([iconString length]>0) {
			NSMutableString* imgPath = [NSMutableString stringWithString:iconString];
			[imgPath appendString:@".jpg"];
			[iconView setImageByString:imgPath];
		}
		
		view.backgroundColor = [UIColor clearColor];
		//[UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
		
		[_scrollView addSubview:view];
		//		NSLog(@"item created,%d",i);
		
	}
}

-(void)addGestureRecognizerTo:(UIView*)view
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTap.numberOfTapsRequired = 1;
	[view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
	MoreCafeAppDelegate* app = (MoreCafeAppDelegate *)[[UIApplication sharedApplication] delegate];    
	
	MO_CAFE_TYPE type = gestureRecognizer.view.tag - Ma_VIEW_INDEX;
	if (type == MOCAFE_WEIBO) {
		[self setNavBarImage:type];
		[self.navigationController pushViewController: app.weiboViewController animated:YES];
	}
	else if (type == MOCAFE_ABOUT)
	{
		MaAboutViewController* controller = [[MaAboutViewController alloc] init];
		[_dataSourceMgr updateDataSourceArrayByViewType:type];
		controller.dict = [_dataSourceMgr itemInfoByViewType:type];
		[self setNavBarImage:type];

		[self.navigationController pushViewController: controller animated:YES];
	}
	else
	{
		MaListViewController* viewController = [[MaListViewController alloc]init];
		[_dataSourceMgr updateDataSourceArrayByViewType:type];
		viewController.dataArray = _dataSourceMgr.dataSource;
		[self setNavBarImage:type];
		[self.navigationController pushViewController: viewController animated:YES];
	}
}

-(void)setNavBarImage:(MO_CAFE_TYPE)type
{
	NSDictionary* dict = [_dataSourceMgr itemInfoByViewType:type];

	UINavigationBar* navBar = self.navigationController.navigationBar;
	[navBar setBackgroundImage:[UIImage imageNamed: [dict objectForKey:@"icon"]] forBarMetrics:UIBarMetricsDefault];
}

-(CGPoint)calculateScrollingOffset:(UIScrollView*)view
{
	CGFloat contentOffset = view.contentOffset.x + MA_ART_WIDTH/2; // half imageView width
	//	NSLog(@"offset.x = %f",view.contentOffset.x);
	NSInteger index = floorf(contentOffset / MA_ART_WIDTH);
	CGPoint offset;
	if (index==0) {	// first art frame -- Right alignment
		offset = CGPointMake((MA_ART_WIDTH * index), 0);
	}
	else if(index == [_dataSourceMgr.enumArray count]){	// end art frame -- left aligment
		offset = CGPointMake((MA_ART_WIDTH * index)- MA_ART_WIDTH_DELTA*2, 0);
	}
	else{	// art frame at middle
		offset = CGPointMake((MA_ART_WIDTH * index) - MA_ART_WIDTH_DELTA  , 0);
		//        NSLog(@"Drag to , %f", _scrollView.frame.size.width * _currentPageIndex);
	}
	//	NSLog(@"return offset.x = %f",offset.x);
	
	return offset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)view
{
	
	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];
	
	//	NSLog(@"return offset.x = %f",view.contentOffset.x);
	
	NSInteger maxWidth = MA_ART_WIDTH * [_dataSourceMgr.enumArray count];
	NSInteger maxOffset = maxWidth - MA_ART_WIDTH - (bounds.size.width - MA_ART_WIDTH);
	//	NSLog(@"calculated offset = %d", maxOffset);
	
	if (view.contentOffset.x < 0 ||view.contentOffset.x >= maxOffset )	// skip setContentOffset when unnecessary;
		return;
	
    [view setContentOffset:[self calculateScrollingOffset:view] animated:YES];
	[self updateProverb];
	//	NSLog(@"%@", @"scrollViewDidEndDecelerating");
}


- (void)scrollViewDidEndDragging:(UIScrollView *)view willDecelerate:(BOOL)decelerate
{
	if (!decelerate) {
		[view setContentOffset:[self calculateScrollingOffset:view] animated:YES];
		//		NSLog(@"%@", @"scrollViewDidEndDragging");
		[self updateProverb];
    }
}


@end
