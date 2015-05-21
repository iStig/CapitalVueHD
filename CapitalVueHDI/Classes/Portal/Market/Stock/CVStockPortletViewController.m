    //
//  CVStockPortletViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/14/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVStockPortletViewController.h"

#import "CVSetting.h"

#import "CVDataProvider.h"

enum StockPageView {
	StockPageMarketCap,
	StockPageTopGainer,
	StockPageHighestTurnover,
	StockPageInvalid
};

@interface CVStockPortletViewController()

@property (nonatomic, retain) NSDictionary *dataDict;
@property (nonatomic, retain) CVScrollPageViewController *_scrollPageController;
@property (nonatomic, retain) UIActivityIndicatorView *_activityIndicator;
@property (nonatomic, retain) NSMutableArray *_viewArray;
@property (nonatomic, retain) NSString *currentCode;
@property (nonatomic, retain) NSArray *stockInfoArray;

/*
 * It loads the data of top-10 largest market capital companies in
 * Shanghai Composite Index as well as Shenzhen Composite Index
 *
 * @param: none
 * @return: none
 */
- (void)loadData:(NSDictionary *)dict;

/*
 * it returns the origin point and size of scroll page frame
 * corresponding to the device orientation
 */
- (CGRect)scrollPageFrame:(UIInterfaceOrientation)orientation;

/*
 * load data in background
 */
-(void)loadThread:(NSMutableDictionary *)info;

@end

@implementation CVStockPortletViewController


@synthesize _scrollPageController;
@synthesize _activityIndicator;
@synthesize dataDict = _dataDict;
@synthesize _viewArray;
@synthesize currentCode;
@synthesize stockInfoArray = _stockInfoArray;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_ifLoaded = YES;
	
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self.style = CVPortletViewStyleRefresh| CVPortletViewStyleBarVisible;
    [super viewDidLoad];
	self.currentCode = @"";
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(codeChanged:) 
												 name:@"MarketCoverflowCodeChanged" 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waitForCoverFlowLoading:) name:kReloadMarketData object:nil];
	
	self.portletTitle = [langSetting localizedString:@"Maket Summary"];
	
	_ordinalNumberArray = [[NSArray alloc] initWithObjects:@"first", @"second", @"third",nil];
	
	CGRect rect;
	
	rect = [self scrollPageFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	CVScrollPageViewController *controller;
	controller = [[CVScrollPageViewController alloc] init];
	controller.indicatorStyle = CVScrollPageIndicatorStyleHigh;
	controller.frame = rect;
	controller.pageControlFrame = CGRectMake((controller.frame.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2, 
											 controller.frame.size.height - CVSCROLLPAGE_INDICTOR_HEIGHT - 10, 
											 CVSCROLLPAGE_INDICTOR_WIDTH,
											 CVSCROLLPAGE_INDICTOR_HEIGHT);
	[controller setDelegate:self];
	controller.pageCount = StockPageInvalid;
	self._scrollPageController = controller;
	[self.view addSubview:_scrollPageController.view];
	_scrollPageController.view.hidden = YES;
	[controller release];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_activityIndicator.frame = CGRectMake(rect.size.width / 2, 
										  rect.size.height / 2,
										  _activityIndicator.frame.size.width, 
										  _activityIndicator.frame.size.height);
	_activityIndicator.hidden = YES;
	[self.view addSubview:_activityIndicator];
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i = StockPageMarketCap;i<StockPageInvalid; i++) {
		CGRect tempRect = rect;
		tempRect.origin.x = 0;
		tempRect.origin.y = 0;
		CVStockTopMarketCapital *pageView = [[CVStockTopMarketCapital alloc] initWithFrame:tempRect];
		pageView.autoresizingMask = UIViewAutoresizingNone;
		pageView.backgroundColor = [UIColor clearColor];
		pageView.m_description.textColor = [UIColor darkGrayColor];
		pageView.m_description.font = [UIFont systemFontOfSize:15];
		[array addObject:pageView];
		[pageView release];
	}
	self._viewArray = array;
	[array release];
	
	_activityIndicator.hidesWhenStopped = YES;
	[_activityIndicator startAnimating];
	
	lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
	lbl.numberOfLines = 2;
	lbl.font = [UIFont systemFontOfSize:13];
	lbl.center = _activityIndicator.center;
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textAlignment = UITextAlignmentCenter;
	lbl.textColor = [UIColor darkGrayColor];
	lbl.text = [langSetting localizedString:@"NetworkFailedMessage"];
	[self.view addSubview:lbl];
	lbl.hidden = YES;
	// waiting the completion of data-loading in a while-iteration,
	// for 
	
	CVSetting *s = [CVSetting sharedInstance];
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	[dp setDataIdentifier:@"getLatestTurnover" lifecycle:[s cvCachedDataLifecycle:CVSettingMarketStock]];
	[dp setDataIdentifier:@"getLargestMarketCap" lifecycle:[s cvCachedDataLifecycle:CVSettingMarketStock]];
	[dp setDataIdentifier:@"getIndexTop10DailyGainersDecliners" lifecycle:[s cvCachedDataLifecycle:CVSettingMarketStock]];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_scrollPageController release];
	[_activityIndicator release];
	[_ordinalNumberArray release];
	[lbl release];
    [super dealloc];
}

#pragma mark -
#pragma mark private method
/*
 * It loads the data of top-10 largest market capital companies in
 * Shanghai Composite Index as well as Shenzhen Composite Index
 *
 * @param: none
 * @return: none
 */

- (void)loadData:(NSDictionary *)info {
	_ifLoaded = NO;
	if (nil==[info objectForKey:@"code"])
	{
		lbl.hidden = NO;
		[_activityIndicator stopAnimating];
		return;
	}
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *code = [[[info objectForKey:@"code"] copy] autorelease];
	BOOL isNeedRefresh = [[info objectForKey:@"isNeedRefresh"] boolValue];
	
	NSMutableArray *mutArray = [[[NSMutableArray alloc] init] autorelease];
	NSMutableDictionary *mutDict;
	
	NSString *strImage;

	NSDictionary *firstDict;

	
	CVSetting *s;
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	CVParamInfo *paramInfo = [[[CVParamInfo alloc] init] autorelease];
	NSDictionary *dict;
	NSDictionary *stockDict;
	
	
	s = [CVSetting sharedInstance];
	CGRect rect = [self scrollPageFrame:portalInterfaceOrientation];
	rect.origin.x=0;
	rect.origin.y=0;
	
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingMarketStock];
	
	//first Page Data
	mutDict = [[[NSMutableDictionary alloc] init] autorelease];
	paramInfo.parameters = code;
	if (isNeedRefresh) {
		dict = [dp RegetMostActivatedTopGainer:paramInfo];
	} else {
		dict = [dp GetMostActivatedTopGainer:paramInfo];
	}
	if (dict == nil) {
		[pool release];
		[self performSelectorOnMainThread:@selector(loadDataError) withObject:nil waitUntilDone:NO];
		return;
	}
	
	[mutDict setObject:dict forKey:@"Rank"];
	firstDict = [[dict objectForKey:@"data"] objectAtIndex:0];
	paramInfo.parameters = [firstDict objectForKey:@"DMGP"];
	if (isNeedRefresh) {
		stockDict = [[[dp ReGetMyStockDetail:CVDataProviderMyStockDetailTypeStock withParams:paramInfo] objectForKey:@"data"] objectAtIndex:0];
	}else {
		stockDict = [[[dp GetMyStockDetail:CVDataProviderMyStockDetailTypeStock withParams:paramInfo] objectForKey:@"data"] objectAtIndex:0];
	}
	if (stockDict == nil) {
		[pool release];
		[self performSelectorOnMainThread:@selector(loadDataError) withObject:nil waitUntilDone:NO];
		return;
	}
	[mutDict setObject:stockDict forKey:@"Stock"];
	strImage = [dp GetCompanyLogo:[firstDict objectForKey:@"DMGP"]];
	[mutDict setObject:strImage forKey:@"Logo"];
	[mutArray addObject:mutDict];
	
	//second Page Data
	mutDict = [[[NSMutableDictionary alloc] init] autorelease];
	paramInfo.parameters = code;
	if (isNeedRefresh) {
		dict = [dp RegetMostActivatedMarketCap:paramInfo];
	}else {
		dict = [dp GetMostActivatedMarketCap:paramInfo];
	}
	if (dict == nil) {
		[pool release];
		[self performSelectorOnMainThread:@selector(loadDataError) withObject:nil waitUntilDone:NO];
		return;
	}
	
	[mutDict setObject:dict forKey:@"Rank"];
	firstDict = [[dict objectForKey:@"data"] objectAtIndex:0];
	paramInfo.parameters = [firstDict objectForKey:@"GPDM"];
	if (isNeedRefresh) {
		stockDict = [[[dp ReGetMyStockDetail:CVDataProviderMyStockDetailTypeStock withParams:paramInfo] objectForKey:@"data"] objectAtIndex:0];
	}else {
		stockDict = [[[dp GetMyStockDetail:CVDataProviderMyStockDetailTypeStock withParams:paramInfo] objectForKey:@"data"] objectAtIndex:0];
	}
	
	if (stockDict == nil) {
		[pool release];
		[self performSelectorOnMainThread:@selector(loadDataError) withObject:nil waitUntilDone:NO];
		return;
	}
	[mutDict setObject:stockDict forKey:@"Stock"];
	strImage = [dp GetCompanyLogo:[firstDict objectForKey:@"GPDM"]];
	[mutDict setObject:strImage forKey:@"Logo"];
	[mutArray addObject:mutDict];
	
	//Third Page Data
	mutDict = [[[NSMutableDictionary alloc] init] autorelease];
	paramInfo.parameters = code;
	if (isNeedRefresh) {
		dict = [dp RegetMostActivatedTurnover:paramInfo];
	}else {
		dict = [dp GetMostActivatedTurnover:paramInfo];
	}
	if (dict == nil) {
		[pool release];
		[self performSelectorOnMainThread:@selector(loadDataError) withObject:nil waitUntilDone:NO];
		return;
	}
	
	[mutDict setObject:dict forKey:@"Rank"];
	firstDict = [[dict objectForKey:@"data"] objectAtIndex:0];
	paramInfo.parameters = [firstDict objectForKey:@"DMGP"];
	if (isNeedRefresh) {
		stockDict = [[[dp ReGetMyStockDetail:CVDataProviderMyStockDetailTypeStock withParams:paramInfo] objectForKey:@"data"] objectAtIndex:0];
	}else {
		stockDict = [[[dp GetMyStockDetail:CVDataProviderMyStockDetailTypeStock withParams:paramInfo] objectForKey:@"data"] objectAtIndex:0];
	}
	if (stockDict == nil) {
		[pool release];
		[self performSelectorOnMainThread:@selector(loadDataError) withObject:nil waitUntilDone:NO];
		return;
	}
	[mutDict setObject:stockDict forKey:@"Stock"];
	strImage = [dp GetCompanyLogo:[firstDict objectForKey:@"DMGP"]];
	[mutDict setObject:strImage forKey:@"Logo"];
	[mutArray addObject:mutDict];
	
	
	NSArray *theArray = [[[NSArray alloc] initWithArray:mutArray] autorelease];
	
	self.stockInfoArray = theArray;
	if (self.stockInfoArray && [self.stockInfoArray count]>0) {
		_valuedData = YES;
	}else {
		_valuedData = NO;
	}

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	if ([code isEqualToString:currentCode]) {
		[self performSelectorOnMainThread:@selector(insertValue) withObject:nil waitUntilDone:NO];
	}
	
	[pool release];
}

-(void)loadDataError{
	NSLog(@"Load Top List Error");
	_ifLoaded = YES;
	_valuedData = NO;
	lbl.hidden = NO;
	_scrollPageController.view.hidden = YES;
	[_activityIndicator stopAnimating];
}

-(void)waitForCoverFlowLoading:(NSNotification *)notification{
	_scrollPageController.view.hidden = YES;
	lbl.hidden = YES;
	
	[_activityIndicator startAnimating];
	_activityIndicator.hidden = NO;
}

/*
 * it returns the origin point and size of scroll page frame
 * corresponding to the device orientation
 */
- (CGRect)scrollPageFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(20, CVPORTLET_BAR_HEIGHT,
						  TOP_MARKET_CAPITAL_PORTRAIT_WIDTH,
						  self.view.frame.size.height - CVPORTLET_BAR_HEIGHT);
	} else {
		rect = CGRectMake(20, CVPORTLET_BAR_HEIGHT, 
						  TOP_MARKET_CAPITAL_LANDSCAPE_WIDTH,
						  self.view.frame.size.height - CVPORTLET_BAR_HEIGHT);
	}
	
	return rect;
}

#pragma mark -
#pragma mark CVPortletViewController
- (IBAction)clickFresh:(id)sender {
	if (!_ifLoaded) {
		return;
	}
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		if (!_valuedData) {
			_scrollPageController.view.hidden = YES;
			lbl.hidden = NO;
			[_activityIndicator stopAnimating];
		}
		return;
	}else {
		_scrollPageController.view.hidden = YES;
		lbl.hidden = YES;
	}
	
	_activityIndicator.hidden = NO;
	[_activityIndicator startAnimating];
	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:currentCode forKey:@"code"];
	[info setObject:[NSNumber numberWithBool:YES] forKey:@"isNeedRefresh"];
	[self loadThread:info];
	[info release];
}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	
	_scrollPageController.frame = [self scrollPageFrame:orientation];
	_scrollPageController.pageControlFrame = CGRectMake((_scrollPageController.frame.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2, 
											 _scrollPageController.frame.size.height - CVSCROLLPAGE_INDICTOR_HEIGHT - 10,
											 CVSCROLLPAGE_INDICTOR_WIDTH,
											 CVSCROLLPAGE_INDICTOR_HEIGHT);
	//for (CVStockTopMarketCapital *view in _viewArray)
	//{
	//	[view updateOrientation:orientation];
	//}
	_activityIndicator.center = _scrollPageController.view.center;
	float offset = ((float)_scrollPageController.pageControl.currentPage) * _scrollPageController.frame.size.width;
	CGPoint ptOffset = CGPointMake(offset,0);
	[_scrollPageController.scrollView setContentOffset:ptOffset];
	[_scrollPageController reloadData];
	
	lbl.center = _scrollPageController.view.center;
}

#pragma mark -
#pragma mark CVScrollPageViewDelegate
- (void)didScrollToPageAtIndex:(NSUInteger)index {
//	CVStockTopMarketCapital *scrollView = (CVStockTopMarketCapital *)[_scrollPageController.view viewWithTag:(700+index)];
	
//	[scrollView loadImage];
}

- (NSString *) stringWithB:(NSString *)str
{
	NSString *retStr;
	NSArray *strArray = [str componentsSeparatedByString:@","];
	int count = [strArray count];
	if (count<4)
		return str;
	else if (4==count)
		{
			retStr = [NSString stringWithFormat:@"%@.%@B",[strArray objectAtIndex:0],[strArray objectAtIndex:1]];
		}
		else
		{
			retStr = [NSString stringWithFormat:@"%@%@.%@B",[strArray objectAtIndex:0],[strArray objectAtIndex:1],[strArray objectAtIndex:2]];
		}
		return retStr;
}


- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index {
	CGRect rect = [self scrollPageFrame:portalInterfaceOrientation];
	rect.origin.x = rect.size.width * index;
	rect.origin.y = 0;
	CVStockTopMarketCapital *pageView;
	pageView = [_viewArray objectAtIndex:index];
	[pageView setFrame:rect];
//	[pageView updateOrientation:portalInterfaceOrientation];
	
//	NSDictionary *dict;
//	dict = [[NSDictionary alloc] initWithObjectsAndKeys:currentCode, @"code",
//			[NSNumber numberWithInteger:index], @"page",
//			nil];
	
	//[NSObject cancelPreviousPerformRequestsWithTarget:self];
//	[self performSelector:@selector(loadData:) withObject:dict afterDelay:0.2];
//	[dict release];
	[pageView updateOrientation:portalInterfaceOrientation];
	if (currentCode==nil){
		pageView.hidden = YES;
	}
	else
		pageView.hidden = NO;
//	NSString *strstr =  pageView.m_company.text;
	return pageView;
}

- (NSUInteger)numberOfPagesInScrollPageView {
	return 0;
}

- (void) codeChanged:(NSNotification *)notification
{
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		_scrollPageController.view.hidden = YES;
		lbl.hidden = NO;
		[_activityIndicator stopAnimating];
		return;
	}else {
		_scrollPageController.view.hidden = YES;
		lbl.hidden = YES;
	}
	NSDictionary *dict = [notification userInfo];
	NSString *code = [dict objectForKey:@"INDEX"];
	if (code == nil) {
		_scrollPageController.view.hidden = YES;
		lbl.hidden = NO;
		[_activityIndicator stopAnimating];
		return;
	}
	self.currentCode = code;
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[NSObject cancelPreviousPerformRequestsWithTarget:_scrollPageController];
	[_activityIndicator startAnimating];
	
	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:code forKey:@"code"];
	[info setObject:[NSNumber numberWithBool:NO] forKey:@"isNeedRefresh"];
	[self loadThread:info];
	[info release];
}


-(void)insertValue{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSDictionary *dict,*stockDict,*firstDict,*secondDict,*currentDict;
	NSString *strImage;
	UIImage *img;
	CVStockTopMarketCapital *pageView;
	
	
	
	//first page
	pageView = [_viewArray objectAtIndex:0];
	currentDict = [_stockInfoArray objectAtIndex:0];
	dict = [currentDict objectForKey:@"Rank"];
	stockDict = [currentDict objectForKey:@"Stock"];
	strImage = [currentDict objectForKey:@"Logo"];
	
	firstDict = [[dict objectForKey:@"data"] objectAtIndex:0];
	secondDict = [[dict objectForKey:@"data"] objectAtIndex:1];
	pageView.m_company.text = [firstDict objectForKey:@"MCGP"];
	pageView.m_code.text = [firstDict objectForKey:@"DMGP"];
	pageView.m_value.text = [NSString stringWithFormat:@"%@%%",[firstDict objectForKey:@"RZDF"] ];
	pageView.m_close.text = [stockDict objectForKey:@"SP"];
	pageView.m_chg.text = [stockDict objectForKey:@"ZF"];
	pageView.m_chgP.text = [NSString stringWithFormat:@"(%@%%)",[stockDict objectForKey:@"ZDF"]]; 
	img = [[UIImage alloc] initWithContentsOfFile:strImage];
	if (!img){
		img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CompanyDefaultLogo" ofType:@"png"]];
	}
	[pageView.m_imgvLogo setImage:img];
	[img release];
	pageView.m_title.text = [langSetting localizedString:@"Daily Top Gainer"];
	pageView.m_description.text =  [NSString stringWithFormat:[langSetting localizedString:@"MarketGainerSentence"],[firstDict objectForKey:@"MCGP"],[firstDict objectForKey:@"RZDF"],[secondDict objectForKey:@"MCGP"],[secondDict objectForKey:@"RZDF"]];
	
	
	
	//second page
	pageView = [_viewArray objectAtIndex:1];
	currentDict = [_stockInfoArray objectAtIndex:1];
	dict = [currentDict objectForKey:@"Rank"];
	stockDict = [currentDict objectForKey:@"Stock"];
	strImage = [currentDict objectForKey:@"Logo"];
	
	firstDict = [[dict objectForKey:@"data"] objectAtIndex:0];
	secondDict = [[dict objectForKey:@"data"] objectAtIndex:1];
	pageView.m_company.text = [firstDict objectForKey:@"GPMC"];
	pageView.m_code.text = [firstDict objectForKey:@"GPDM"];
	pageView.m_value.text = [firstDict objectForKey:@"LTZ"];
	pageView.m_close.text = [stockDict objectForKey:@"SP"];
	pageView.m_chg.text = [stockDict objectForKey:@"ZF"];
	pageView.m_chgP.text = [NSString stringWithFormat:@"(%@%%)",[stockDict objectForKey:@"ZDF"]]; 
	img = [[UIImage alloc] initWithContentsOfFile:strImage];
	if (!img){
		img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CompanyDefaultLogo" ofType:@"png"]];
	}
	[pageView.m_imgvLogo setImage:img];
	[img release];
	pageView.m_title.text = [langSetting localizedString:@"Largest Market Cap"];
	pageView.m_description.text =  [NSString stringWithFormat:[langSetting localizedString:@"MarketTradableSentence"],[firstDict objectForKey:@"GPMC"],[self stringWithB:[firstDict objectForKey:@"LTZ"]],[secondDict objectForKey:@"GPMC"],[self stringWithB:[secondDict objectForKey:@"LTZ"]]];

	
	
	//third page
	pageView = [_viewArray objectAtIndex:2];
	currentDict = [_stockInfoArray objectAtIndex:2];
	dict = [currentDict objectForKey:@"Rank"];
	stockDict = [currentDict objectForKey:@"Stock"];
	strImage = [currentDict objectForKey:@"Logo"];
	
	firstDict = [[dict objectForKey:@"data"] objectAtIndex:0];
	secondDict = [[dict objectForKey:@"data"] objectAtIndex:1];
	pageView.m_company.text = [firstDict objectForKey:@"MCGP"];
	pageView.m_code.text = [firstDict objectForKey:@"DMGP"];
	pageView.m_value.text = [NSString stringWithFormat:@"%@%%",[firstDict objectForKey:@"RHSL"]];
	pageView.m_close.text = [stockDict objectForKey:@"SP"];
	pageView.m_chg.text = [stockDict objectForKey:@"ZF"];
	pageView.m_chgP.text = [NSString stringWithFormat:@"(%@%%)",[stockDict objectForKey:@"ZDF"]]; 
	img = [[UIImage alloc] initWithContentsOfFile:strImage];
	if (!img){
		img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CompanyDefaultLogo" ofType:@"png"]];
	}
	[pageView.m_imgvLogo setImage:img];
	[img release];
	pageView.m_title.text = [langSetting localizedString:@"Highest Turnover(%)"];
	pageView.m_description.text =  [NSString stringWithFormat:[langSetting localizedString:@"MarketTurnoverSentence"],[firstDict objectForKey:@"MCGP"],[firstDict objectForKey:@"RHSL"],[secondDict objectForKey:@"MCGP"],[secondDict objectForKey:@"RHSL"]];
	
	
	_scrollPageController.pageCount = 3;
	
	for (CVStockTopMarketCapital *v in _viewArray)
		[v updateOrientation:portalInterfaceOrientation];
	[_scrollPageController reloadData];
	[_activityIndicator stopAnimating];
	_activityIndicator.hidden = YES;
	_scrollPageController.view.hidden = NO;
	
	_ifLoaded = YES;
}

-(void)loadThread:(NSMutableDictionary *)info{
	[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:info];
}
@end
