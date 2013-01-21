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

	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];

	CGRect frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height - MA_TOOLBAR_HEIGHT);
	UIImageView* wallView = [[UIImageView alloc]initWithFrame:frame];	
	UIImage* wallImage = [UIImage imageNamed:@"background"];
	wallView.image = wallImage;
	[self.view addSubview:wallView];
	
	_scrollView = [[UIScrollView alloc ] initWithFrame:frame ];
	_scrollView.showsHorizontalScrollIndicator=NO;
	_scrollView.showsVerticalScrollIndicator=NO;

	_scrollView.delegate = self;
	_scrollView.backgroundColor = [UIColor clearColor];
		
	_currentIndex = 0;
	
	[self setupViewsByArray:_dataSourceMgr.enumArray];
	_scrollView.contentSize = CGSizeMake( MA_ART_WIDTH * [_dataSourceMgr.enumArray count] , bounds.size.height - MA_TOOLBAR_HEIGHT);
	
	CGRect proverbViewFrame = CGRectMake(30, 300, 260, 60);

	_proverbView = [[UILabel alloc] initWithFrame:proverbViewFrame];
	_proverbView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
	_proverbView.text = @"人生，总让人无语。笑的时候，不一定开心，也许是一种无奈；哭的时候，不一定流泪，也许是一种释放；痛的时候，不一定受伤，也许是一种心动。走过一段路，总想看到一道风景，因为已经刻骨铭心；想起一个人，总会流泪，因为已经融入生命；唱起一首歌，总会沉默，因为已经难以释怀。风雨人生，淡然在心。";
	_proverbView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
	_proverbView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_proverbView.font = [UIFont systemFontOfSize:12];
	_proverbView.textAlignment = NSTextAlignmentLeft;
	_proverbView.textColor = [UIColor whiteColor];
	_proverbView.opaque = NO;
	_proverbView.lineBreakMode = NSLineBreakByWordWrapping;
	_proverbView.numberOfLines = 0;
	
	//[self.view addSubview:_proverbView];
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
		
		UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y+imgView.frame.size.height - 48,200,25)];
		lable.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
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
	
//    MaSubItemController* viewController = [[MaSubItemController alloc]init];
//    viewController.indexPath = indexPath;
//    NSDictionary* dict = [_dataSourceMgr.dataSource objectAtIndex: indexPath.row];
	
	MoreCafeAppDelegate* app = (MoreCafeAppDelegate *)[[UIApplication sharedApplication] delegate];    
//    [self.navigationController pushViewController: app.weiboViewController animated:YES];
	
	MO_CAFE_TYPE type = gestureRecognizer.view.tag - Ma_VIEW_INDEX;
	if (type == MOCAFE_WEIBO) {
		[self.navigationController pushViewController: app.weiboViewController animated:YES];
	}
	else
	{
		MaListViewController* viewController = [[MaListViewController alloc]init];
		[_dataSourceMgr updateDataSourceArrayByViewType:type];
		viewController.dataArray = _dataSourceMgr.dataSource;
		[self.navigationController pushViewController: viewController animated:YES];
	}
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
