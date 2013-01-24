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


@interface MaAboutViewController ()

@end

@implementation MaAboutViewController
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
	
	UIImage *image = [UIImage imageNamed:@"backButtom"];
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(dismissViewController) buttomImage:image];

	CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];
	CGRect scrollViewFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height - MA_TOOLBAR_HEIGHT);
	_scrollerView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
	self.view = _scrollerView;
	
	_scrollerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbackground"]];
	[self initSubViews];
	// Do any additional setup after loading the view.
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
	UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 280, 186)];
	UIImage* img = [UIImage imageNamed:@"cafeAbout.jpg"];
	imgView.image = img;
	
	NSString* aboutString = [self getAboutString];
	CGFloat height = [MaUtility estimateHeightBy:aboutString image:nil];

	DTAttributedTextView* _detailTextView = [[DTAttributedTextView alloc]initWithFrame:CGRectMake(20,220,280,height)];
	_detailTextView.textDelegate = self;
	_detailTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_detailTextView.backgroundColor = [UIColor clearColor];
	_detailTextView.scrollEnabled = NO;
	
	
	[MaUtility fillText:aboutString to:_detailTextView];
	
	
	
	
	[self.view addSubview: imgView];
	[self.view addSubview: _detailTextView];

	

	
	height+= imgView.frame.size.height+imgView.frame.origin.y;
	
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

@end
