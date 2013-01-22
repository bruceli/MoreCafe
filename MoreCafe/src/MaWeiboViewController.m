//
//  MaWeiboViewController
//  MoreCafe
//
//  Created by Thunder on 1/6/13.
//  Copyright (c) 2013 MagicApp. All rights reserved.
//

#import "MaWeiboViewController.h"
#import "UIBarButtonItem+StyledButton.h"
#import "MaWeiboCell.h"
#import "MoreCafeAppDelegate.h"
#import "Accounts/Accounts.h"
#import "MaUtility.h"
#import "MaPostController.h"
#import "WBNoticeView.h"

@interface MaWeiboViewController ()

@end

@implementation MaWeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_messages = [[NSMutableArray alloc]init];
		_moreItem = [[NSDictionary alloc] initWithObjectsAndKeys:@"More",@"More",nil];
		_moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreCell"];
		[self configMoreCell];
		_pages = 1;
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIImage *image = [UIImage imageNamed:@"backButtom"];
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(dismissViewController) buttomImage:image];

	image = [UIImage imageNamed:@"composeButtom"];
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(composeWeibo) buttomImage:image];

	[self initSubViews];
//	self.navigationItem.title = NSLocalizedString(@"Weibo", nil);
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	_timeLineView = self.view;

	[self initLoginView];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([self isLoggedIn]) {
		[self removeLoginView];
	}
	else{
		[self setLoginView];
	}
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	// Do any additional setup after loading the view.
	if ([_messages count]==0) {
		[self loadTimeLine];	
	}
}

-(void)setLoginView
{
	self.view = _loginView;
}

-(void)removeLoginView
{
	self.view = _timeLineView;
}

-(void)initLoginView
{
	_loginView = [[UIView alloc] initWithFrame:self.view.frame];
	
	UIImage* image = [UIImage imageNamed:@"weiboLoginButtom"];
	UIImage* imageDown = [UIImage imageNamed:@"weiboLoginButtomDown"];

	UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
	
	UIButton * buttom = [[UIButton alloc]initWithFrame:CGRectMake(100, 230, imageView.frame.size.width, imageView.frame.size.height)];
	[buttom setImage:image forState:UIControlStateNormal];
	[buttom setImage:imageDown forState:UIControlStateHighlighted];
	[buttom addTarget:self action:@selector(loginWeibo) forControlEvents:UIControlEventTouchUpInside]; 

	[_loginView addSubview:buttom];
}

-(void)testACAccount
{
//	ACAccountStore *store = [[ACAccountStore alloc] init]; 
//	ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierSinaWeibo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubViews
{
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootbackground"]];
	
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
	_refreshHeaderView.backgroundColor = [UIColor darkGrayColor];
	_refreshHeaderView.delegate = self;
	[self.tableView addSubview:_refreshHeaderView];
}

-(void)dismissViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)composeWeibo
{		
    MaPostController* postViewController = [[MaPostController alloc] init];
    UINavigationController *postNavController = [[UINavigationController alloc] initWithRootViewController:postViewController];
	[self presentViewController: postNavController animated: YES completion:nil];
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messages count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	CGFloat height;	
	if ([self isMoreCell:indexPath]) {
		height = 44;
	}
	else
	{
		NSDictionary* dict = [_messages objectAtIndex:indexPath.row];
		height = [MaUtility estimateHeightBy:[dict objectForKey:@"text"] image:[dict objectForKey:@"thumbnail_pic"]];
		height += MA_CELL_MIN_HEIGHT;
		
		NSDictionary* retweets = [dict objectForKey:@"retweeted_status"];; 
		if (retweets) {
			NSMutableString* result = [[NSMutableString alloc]init];
			NSDictionary* user = [retweets objectForKey:@"user"];  
			NSString* displayName = [user objectForKey:@"screen_name"] ;
			if(displayName)
			{
				[result appendString:displayName];
				[result appendString:@": "];
				[result appendString:[retweets objectForKey:@"text"]];
			}

			CGFloat retweetHeight = [MaUtility estimateHeightBy:result image:[retweets objectForKey:@"thumbnail_pic"]];
			height = retweetHeight + height + MA_CELL_GAP*6;
		}
	}
	
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	if ([self isMoreCell:indexPath])
		cell = _moreCell;
	else
	{
		MaWeiboCell *weiboCell;
		static NSString *CellIdentifier = @"Cell";
		weiboCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (weiboCell == nil) {
			weiboCell = [[MaWeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		   
		NSDictionary* dict = [_messages objectAtIndex:indexPath.row];
		[weiboCell fillCellDataWith: dict];
		cell = weiboCell;
		// Configure the cell.
	}
    return cell;
}

- (BOOL) isMoreCell:(NSIndexPath*) indexPath
{
	BOOL status = NO; 
	NSDictionary* dict = [_messages objectAtIndex:indexPath.row];
	
	if (indexPath.row == [_messages count] -1)
	{
		if(dict == _moreItem)
			status =  YES;
	}
	return status;
}

- (void)addMoreItem
{
	[_messages removeObject:_moreItem];
	[_messages addObject:_moreItem];
	UILabel* lable = (UILabel*)[_moreCell viewWithTag:MA_MORE_CELL_LABLE_TAG];
	lable.text = NSLocalizedString(@"Load more...",nil);
}

-(void)configMoreCell
{
	[self addSingleTapGestureRecognizerTo:_moreCell];
	UILabel* lable= [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 200, 40)];
	lable.tag = MA_MORE_CELL_LABLE_TAG;
	lable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	lable.backgroundColor = [UIColor clearColor];
	lable.font = [UIFont systemFontOfSize:16];
	lable.textAlignment = NSTextAlignmentLeft;
	lable.textColor = [UIColor darkGrayColor];
	lable.opaque = NO;
	lable.text = NSLocalizedString(@"Load more...",nil);
	[_moreCell addSubview:lable];	
}

-(void)addSingleTapGestureRecognizerTo:(UIView*)view
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTap.numberOfTapsRequired = 1;
	[view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
//	[self.view viewWithTag:custTag]
	[self loadMore];
}


- (void)mergeMessages:(NSArray*)array isAppend:(BOOL)mode
{
//	[_messages addObjectsFromArray:message];
	NSMutableArray* sameArray = [[NSMutableArray alloc]init];
	
	if (!mode)	// load data from top of table 
	{
		for(NSDictionary* newDict in array)
		{
			NSString* newWeiboID = [newDict objectForKey:@"idstr"];
			for(NSDictionary* theDict in _messages)
			{
				NSString* theWeiboID = [theDict objectForKey:@"idstr"];
//				NSLog(@"   newDict ID %@",newWeiboID);
//				NSLog(@"theWeiboID ID %@",theWeiboID);

				if ([newWeiboID isEqualToString:theWeiboID]) {
					[sameArray addObject:newDict];
					break;
				}
			}
		}
		
		NSMutableArray* destArray = [NSMutableArray arrayWithArray:array];
		[destArray removeObjectsInArray:sameArray];
		NSIndexSet* indexSet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0,[destArray count])];
		
		if (_messages == nil) 
			_messages = [[NSMutableArray alloc]init];
		
		[_messages insertObjects:destArray atIndexes:indexSet];
	}	
	else	// load data from bottom of table
	{
		[_messages addObjectsFromArray:array];
	}
	
	[self addMoreItem];
	[self.tableView reloadData];

}

- (void)loadTimeLine
{
	if (![self isLoggedIn]) 
	{
		NSLog(@"%@",@"Weibo token expired... ");
		[self setLoginView];
		return;
	}
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/home_timeline.json"
	 // params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                       params:nil 
                   httpMethod:@"GET"
                     delegate:self];
	[MoreCafeAppDelegate increaseNetworkActivityIndicator];
}


- (void)loadMore
{
	UILabel* lable = (UILabel*)[_moreCell viewWithTag:MA_MORE_CELL_LABLE_TAG];
	if (lable.text == NSLocalizedString(@"Loading...",nil)) {
		return;
	}
	
	_pages ++;
	
	if (![self isLoggedIn]) 
	{
		NSLog(@"%@",@"Weibo token expired... ");
		return;
	}
	lable.text = NSLocalizedString(@"Loading...",nil);
	
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/home_timeline.json"
					   params:[NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", _pages] forKey:@"page"]
                   httpMethod:@"GET"
                     delegate:self];
	[MoreCafeAppDelegate increaseNetworkActivityIndicator];
}



#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	[self loadTimeLine];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
		[self loadMore];

		// we are at the end
//		[self reloadTableViewDataSource];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}


#pragma mark -
#pragma mark SinaWeibo Staff
-(BOOL)isLoggedIn
{
	SinaWeibo *sinaweibo = [self sinaweibo];
	return  [sinaweibo isLoggedIn];
}

- (void)loginWeibo
{
//	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//	NSLog(@"%@", [keyWindow subviews]);
	_userInfo = nil;
	_messages = nil;
	
	SinaWeibo *sinaweibo = [self sinaweibo];
	[sinaweibo logIn];
	[MoreCafeAppDelegate increaseNetworkActivityIndicator];
}

-(void)logoutWeibo
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logOut];
}

- (SinaWeibo *)sinaweibo
{
    MoreCafeAppDelegate *delegate = (MoreCafeAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -
#pragma mark SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
//    [self logoutWeiboButtom];

    [self removeLoginView];
	[self loadTimeLine];
	[self storeAuthData];
	[MoreCafeAppDelegate decreaseNetworkActivityIndicator];

}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
    [self setLoginView];
	_pages = 1;
}


- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
	[MoreCafeAppDelegate decreaseNetworkActivityIndicator];
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
    [self setLoginView];
	_pages = 1;
}

#pragma mark - SinaWeiboRequest Delegate 
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
	[self doneLoadingTableViewData];
	[MoreCafeAppDelegate decreaseNetworkActivityIndicator];	
	
    if ([request.url hasSuffix:@"users/show.json"])
    {
		_userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        //_messages = nil;
		NSLog(@"Timeline failed with error : %@", error);
		[MoreCafeAppDelegate showErrorNotification:NSLocalizedString(@"WeiboLoadFailed",nil) inView:self.view];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
		[MoreCafeAppDelegate showErrorNotification:NSLocalizedString(@"WeiboSendFailed",nil) inView:self.view];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
		[MoreCafeAppDelegate showErrorNotification:NSLocalizedString(@"WeiboSendFailed",nil) inView:self.view];
    }
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
	[self doneLoadingTableViewData];
	[MoreCafeAppDelegate decreaseNetworkActivityIndicator];

    if ([request.url hasSuffix:@"users/show.json"])
    {
        _userInfo = result;
    }
	else if ([request.url hasSuffix:@"statuses/home_timeline.json"])
    {
		BOOL appendMode = NO;
		NSArray* message = [result objectForKey:@"statuses"];
		NSString* page = [request.params objectForKey:@"page"];
		if ([page length]> 0) {
			appendMode = YES;
		}
		[MoreCafeAppDelegate showSuccessNotification:NSLocalizedString(@"WeiboLoadSuccess",nil) inView:self.view];

		[self mergeMessages:message isAppend:appendMode];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
		[MoreCafeAppDelegate showSuccessNotification:NSLocalizedString(@"WeiboSendSuccess",nil) inView:self.view];

		postStatusText = nil;
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
		[MoreCafeAppDelegate showSuccessNotification:NSLocalizedString(@"WeiboSendSuccess",nil) inView:self.view];

        postImageStatusText = nil;
    }
}



@end
