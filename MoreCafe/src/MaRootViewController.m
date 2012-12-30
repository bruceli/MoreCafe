//
//  MaRootViewController.m
//  MoreCafe
//
//  Created by Thunder on 12/29/12.
//  Copyright (c) 2012 MagicApp. All rights reserved.
//
#define MA_TOOLBAR_HEIGHT 44

#import "MaRootViewController.h"
#import "MaSubItemController.h"

@interface MaRootViewController ()

@end

@implementation MaRootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];

	CGRect frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height - MA_TOOLBAR_HEIGHT);
	_scrollView = [[UIScrollView alloc ] initWithFrame:frame ];
	_scrollView.showsHorizontalScrollIndicator=NO;
	_scrollView.showsVerticalScrollIndicator=NO;

	_scrollView.delegate = self;
	_scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbackground"]];
	_currentIndex = 0;
	NSArray* itemArray = [[NSArray alloc] initWithObjects:@"test", @"test",@"test",@"test",nil];
	
	[self setupViewsByArray:itemArray];
	_scrollView.contentSize = CGSizeMake( bounds.size.width * [itemArray count] , bounds.size.height - MA_TOOLBAR_HEIGHT);
	
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
	
	for (int i = 0 ; i < [itemArray count]; i ++)
	{
		CGRect frame = CGRectMake(bounds.size.width * i ,
								  0,
								  bounds.size.width,
								  bounds.size.height - MA_TOOLBAR_HEIGHT );
		
		UIImageView* imgView = [[UIImageView alloc] initWithFrame:frame];
		[self addGestureRecognizerTo:imgView];

/*		AsyncImageView* imgView = [[AsyncImageView alloc] initWithFrame:frame];
		imgView.contentMode = UIViewContentModeScaleAspectFill;
		imgView.clipsToBounds = YES;
		imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		[imgView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
		[imgView.layer setBorderWidth: 1.0];
		
		
		NSDictionary* dict = [itemArray objectAtIndex:i];
		NSString* path = [imgDict objectForKey:[dict objectForKey:@"imageName"]];
		[imgView setImageByString:path];
 */
		
		imgView.backgroundColor = [UIColor colorWithRed:(arc4random()%100)/(float)100 green:(arc4random()%100)/(float)100 blue:(arc4random()%100)/(float)100 alpha:0.3];
		[_scrollView addSubview:imgView];
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
	
    MaSubItemController* viewController = [[MaSubItemController alloc]init];
//    viewController.indexPath = indexPath;
//    NSDictionary* dict = [_dataSourceMgr.dataSource objectAtIndex: indexPath.row];
    viewController.navigationItem.title = @"Café";
    
    [self.navigationController pushViewController: viewController animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)view
{
	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];

	CGFloat contentOffset = view.contentOffset.x + bounds.size.width/2; // half imageView width
    NSInteger index = floorf(contentOffset / view.frame.size.width);
    CGPoint offset = CGPointMake(view.frame.size.width * index, 0);
    [view setContentOffset:offset animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)view willDecelerate:(BOOL)decelerate
{
	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];

    if (!decelerate) {
        CGFloat contentOffset = view.contentOffset.x + bounds.size.width/2; // half imageView width
        _currentIndex = floorf(contentOffset / view.frame.size.width);
        CGPoint offset = CGPointMake(view.frame.size.width * _currentIndex, 0);
        [view setContentOffset:offset animated:YES];
		//        NSLog(@"Drag to , %f", _scrollView.frame.size.width * _currentPageIndex);
    }
}

@end
