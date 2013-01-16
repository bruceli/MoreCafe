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

@interface MaRootViewController ()
@end

@implementation MaRootViewController
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
	_scrollView.backgroundColor = [UIColor clearColor];
		
	_currentIndex = 0;
	NSArray* itemArray = [[NSArray alloc] initWithObjects:@"test", @"test",@"test",@"test",nil];
	
	[self setupViewsByArray:itemArray];
	_scrollView.contentSize = CGSizeMake( MA_ART_WIDTH * [itemArray count] , bounds.size.height - MA_TOOLBAR_HEIGHT);
	
	[self.view addSubview:_scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupViewsByArray:(NSArray*)itemArray
{
	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];
	UIImage* image = [UIImage imageNamed:@"artFrame"];

	for (int i = 0 ; i < [itemArray count]; i ++)
	{
		CGRect frame = CGRectMake(MA_ART_WIDTH * i ,
								  0,
								  MA_ART_WIDTH,
								  bounds.size.height - MA_TOOLBAR_HEIGHT );
		// 
		UIView* view = [[UIImageView alloc] initWithFrame:frame];
		[view setUserInteractionEnabled:YES];
		
		UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20,20, 200, 250)];
		imgView.image = image;
		imgView.backgroundColor = [UIColor clearColor];
		imgView.contentMode = UIViewContentModeCenter;
		[view addSubview:imgView];
		[self addGestureRecognizerTo:imgView];

		view.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
		[_scrollView addSubview:view];
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
	
//    MaSubItemController* viewController = [[MaSubItemController alloc]init];
//    viewController.indexPath = indexPath;
//    NSDictionary* dict = [_dataSourceMgr.dataSource objectAtIndex: indexPath.row];
	
//	MoreCafeAppDelegate* app = (MoreCafeAppDelegate *)[[UIApplication sharedApplication] delegate];    
//    [self.navigationController pushViewController: app.weiboViewController animated:YES];
	
	MaListViewController* viewController = [[MaListViewController alloc]init];
	[self.navigationController pushViewController: viewController animated:YES];


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
	else if(index == 3){	// end art frame -- left aligment
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
	if (view.contentOffset.x < 0 ||view.contentOffset.x > bounds.size.width )	// do not call setContentOffset when unnecessary;
		return;
	
    [view setContentOffset:[self calculateScrollingOffset:view] animated:YES];
//	NSLog(@"%@", @"scrollViewDidEndDecelerating");
}


- (void)scrollViewDidEndDragging:(UIScrollView *)view willDecelerate:(BOOL)decelerate
{
	if (!decelerate) {
		[view setContentOffset:[self calculateScrollingOffset:view] animated:YES];
//		NSLog(@"%@", @"scrollViewDidEndDragging");

    }
}

@end
