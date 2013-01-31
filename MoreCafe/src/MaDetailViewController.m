//
//  MaDetailViewController.m
//  MoreCafe
//
//  Created by Thunder on 1/18/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaDetailViewController.h"
#import "UIBarButtonItem+StyledButton.h"
#import "MaUtility.h"
#import "MaPostController.h"
#import "SinaWeibo.h"
#import "MoreCafeAppDelegate.h"


@interface MaDetailViewController ()

@end

@implementation MaDetailViewController
@synthesize dict = _dict;

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
	CGRect scrollViewFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height - MA_TOOLBAR_HEIGHT);
	_scrollerView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
	self.view = _scrollerView;
	
	_scrollerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbackground"]];
	
	UIImage *backImg = [UIImage imageNamed:@"backButtom"];
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(dismissViewController) buttomImage:backImg];
	
	if ([self isLoggedIn]) {
		UIImage *shareImg = [UIImage imageNamed:@"actionButtom"];
		self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(weiboShare) buttomImage:shareImg];	
	}
	
	
	CGRect frame = CGRectMake(20, 20, 280, 280);
	_imgView = [[AsyncImageView alloc]initWithFrame:frame];
	_nameLable = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x,frame.origin.y+frame.size.height-40,frame.size.width,40)];
	_nameLable.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
	_nameLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_nameLable.font = [UIFont boldSystemFontOfSize:20];
	_nameLable.textAlignment = NSTextAlignmentRight;
	_nameLable.textColor = [UIColor whiteColor];
	_nameLable.opaque = NO;
	
	
	_detailTextView = [[DTAttributedTextView alloc]initWithFrame:CGRectMake(frame.origin.x,frame.origin.y+frame.size.height +5,frame.size.width,300 )];
	_detailTextView.textDelegate = self;
	_detailTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_detailTextView.backgroundColor = [UIColor clearColor];
	_detailTextView.scrollEnabled = NO;
	
	[_scrollerView addSubview:_imgView];
	[_scrollerView addSubview:_nameLable];
	[_scrollerView addSubview:_detailTextView];
	
	[self fillData];
}


-(void) dismissViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)weiboShare
{
	MaPostController* postViewController = [[MaPostController alloc] init];
	[postViewController setText:[_dict objectForKey:@"discription"] image: _imgView.image];
	UINavigationController *postNavController = [[UINavigationController alloc] initWithRootViewController:postViewController];
	[postNavController.navigationBar setBackgroundImage:[UIImage imageNamed: @"share"] forBarMetrics:UIBarMetricsDefault];
	
	[self presentViewController: postNavController animated: YES completion:nil];
}

-(void)fillData
{
	NSString* imgPrefix = [_dict objectForKey:@"imagePrefix"];
	
	if ([imgPrefix length]>0  && [MaUtility isFileExist:imgPrefix]) {
		[_imgView setImageByString:imgPrefix];
	}
	else
	{
		[_imgView setImageByString:@"emptyImg.jpg"];
	}

	_nameLable.text = [_dict objectForKey:@"name"];
	
	NSString* string = [MaUtility encodeingText:[_dict objectForKey:@"detail"]]; 
	[MaUtility fillText:string to:_detailTextView];
	
	CGFloat height = [MaUtility estimateHeightBy:string image:nil];
	height+= _imgView.frame.size.height+_imgView.frame.origin.y;
	
	CGSize size = CGSizeMake(_scrollerView.frame.size.width, height);
	_scrollerView.contentSize = size;	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)isLoggedIn
{
	MoreCafeAppDelegate *app = (MoreCafeAppDelegate *)[UIApplication sharedApplication].delegate;

//	SinaWeibo *sinaweibo = [app sinaweibo];
	return  [app.sinaweibo isLoggedIn];
}

@end
