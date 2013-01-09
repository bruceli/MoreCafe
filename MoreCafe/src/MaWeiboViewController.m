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

@interface MaWeiboViewController ()

@end

@implementation MaWeiboViewController

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
		
	[self initSubViews];
	self.navigationItem.title = NSLocalizedString(@"Weibo", nil);
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([self isLoggedIn]) {
		[self logoutWeiboButtom];
	}
	else{
		[self loginWeiboButtom];
	}

}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	// Do any additional setup after loading the view.
	[self loadTimeLine];	
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

-(void) dismissViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loginWeiboButtom
{
	UIImage *accountStatusImage = [UIImage imageNamed:@"needLoginIcon"];
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(loginWeibo) buttomImage:accountStatusImage];
}

-(void) logoutWeiboButtom
{
	UIImage *accountStatusImage = [UIImage imageNamed:@"readyIcon"];
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBackBarImgButtonItemWithTarget:self selector:@selector(logoutWeibo) buttomImage:accountStatusImage];

}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    MaWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MaWeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	// Configure the cell.
	
    return cell;
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
	userInfo = nil;
	statuses = nil;
	
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

- (void)loadTimeLine
{
	if (![self isLoggedIn]) 
	{
		NSLog(@"%@",@"Weibo token expired... ");
		return;
	}
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
	[MoreCafeAppDelegate increaseNetworkActivityIndicator];

}

#pragma mark -
#pragma mark SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [self logoutWeiboButtom];
    [self storeAuthData];
	[MoreCafeAppDelegate decreaseNetworkActivityIndicator];

}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
    [self loginWeiboButtom];
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
    [self loginWeiboButtom];
}

#pragma mark - SinaWeiboRequest Delegate 
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
	[self doneLoadingTableViewData];
	[MoreCafeAppDelegate decreaseNetworkActivityIndicator];

    if ([request.url hasSuffix:@"users/show.json"])
    {
		userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" failed!", postStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", postImageStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
	[self doneLoadingTableViewData];
	[MoreCafeAppDelegate decreaseNetworkActivityIndicator];

    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = result;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        statuses = [result objectForKey:@"statuses"];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];		
		postStatusText = nil;
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        postImageStatusText = nil;
    }
}



@end
