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
	
	UIImage *shareImg = [UIImage imageNamed:@"action"];
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(weiboShare) buttomImage:shareImg];	
	
	
	CGRect frame = CGRectMake(5, 5, 310, 310);
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

}

-(void)fillData
{
	NSString* imgName = [_dict objectForKey:@"imagePrefix"];
	if ([imgName length]>0) {
		NSMutableString* imgPath = [NSMutableString stringWithString:imgName];
		[imgPath appendString:@".jpg"];
		[_imgView setImageByString:imgPath];
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

@end