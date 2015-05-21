//  CVSectorStatisticsPortletViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/12/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVSectorStatisticsPortletViewController.h"

#import "CVSetting.h"
#import "CVDataProvider.h"

#import "UIColor+DespInit.h"
#import "PieChartViewController.h"
#import "CVPieChartView.h"

@interface CVSectorStatisticsPortletViewController()

@property (nonatomic, retain) NSMutableArray *_pageViewCache;
@property (nonatomic, retain) NSMutableArray *_pageDataCache;
@property (nonatomic, retain) NSMutableArray *_sectorSummaryArray;
@property (nonatomic, retain) NSMutableDictionary *_sectorSummaryTitleDict;

@property (nonatomic, retain) DreamScroll *_scrollPageController;
@property (nonatomic, retain) UIActivityIndicatorView *_activityIndicator;

@property (nonatomic, retain) UIImage *imagePortraitBackground;
@property (nonatomic, retain) UIImage *imageLandscapeBackground;
@property (nonatomic, retain) UIImageView *imageViewBackground;

@property (nonatomic, retain) UILabel *_titleLabel;
@property (nonatomic, retain) UILabel *_statisticsLabel;

/*
 *
 *	dream's function
 *
 */
- (void) setPageControlCenter:(UIInterfaceOrientation)orientation;
- (void) createGesture;
- (void) handleSwipeLeft:(UISwipeGestureRecognizer*)sender;
- (void) handleSwipeRight:(UISwipeGestureRecognizer*)sender;
- (void) handlePan:(UIPanGestureRecognizer*)sender;
- (void) autoRotate;

/*
 *	refresh button click
 */
-(void)clickRefreshButton;

/*
 *  get notification from scroller
 */
- (void) postScrollNotification:(NSNumber *)number;

- (void) postNotificationToScroll:(NSInteger)index;

-(void) getNotificationFromScroll:(NSNotification *)notification;

-(void) postNotificationStopRoll;

-(void)getNotificationToRefreshData:(NSNotification *)notification;

/*
 * It loads the data of sectors' turnover, volume, total capital
 * tradable capital and summary.
 */
- (void)loadData:(NSNumber *)isRefresh;

/*
 * It returns the origin point and size of scroll page frame
 * corresponding to the device orientation
 */
- (CGRect)scrollPageFrame:(UIInterfaceOrientation)orientation;

- (CGRect)scrollPageIndicatorFrame:(UIInterfaceOrientation)orientation;

- (CGRect)titleLabelFrame:(UIInterfaceOrientation)orientation;

- (CGRect)statisticsLabelFrame:(UIInterfaceOrientation)orientation;

- (CGRect)refreshButtonFrame:(UIInterfaceOrientation)orientation;


/*
 * It loads the color setting for each share of pie chart
 *
 * @return	An array each of which represents color of a share.
 *			Element of the array is NSString type in a format of <alpha><red><green><blue>.
 *			e.g. FF6B372F, alpha is FF, red is 6B, green is 37 and blue is 2F.
 */
- (NSArray *)colorSettingForShare;

- (void) initOrientation;

@end

//static NSString * SectorIds[SECTOR_DEFITION_INVALID  +1]=
//{
//	@"10",
//	@"15",
//	@"20",
//	@"25",
//	@"30",
//	@"35",
//	@"40",
//	@"45",
//	@"50",
//	@"55",
//	nil				//should be the last one
//};

@implementation CVSectorStatisticsPortletViewController

@synthesize imagePortraitBackground;
@synthesize imageLandscapeBackground;
@synthesize imageViewBackground;

@synthesize _titleLabel;
@synthesize _statisticsLabel;

@synthesize _scrollPageController;
@synthesize _activityIndicator;

@synthesize _pageViewCache;
@synthesize _pageDataCache;
@synthesize _sectorSummaryArray;
@synthesize _sectorSummaryTitleDict;
@synthesize ifLoaded;

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
	bTurnover = NO;
	bVolume = NO;
	bTotalCap = NO;
	bTradableCap = NO;
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self.style = CVPortletViewStyleNone | CVPortletViewStyleContentTransparent;
    [super viewDidLoad];
	
	NSString *configPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"SectorConfigure_%@",[langSetting localizedString:@"LangCode"]] ofType:@"plist"];
	
	NSDictionary *configDict = [[NSDictionary alloc] initWithContentsOfFile:configPath];
	
	SectorIds = [[NSArray alloc] initWithArray:[configDict objectForKey:@"SectorIds"]];
	
	[configDict release];
	
	ifLoaded = NO;
	rotateCount = 0;
	UIImage *image;
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_sector_statistics_portrait_background.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	self.imagePortraitBackground = image;
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"portlet_sector_statistics_landscape_background.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	self.imageLandscapeBackground = image;
	[image release];
	
	UIImageView *imageView;
	if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CVPORTLET_SECTOR_STATISTICS_PORTRAIT_WIDTH, CVPORTLET_SECTOR_STATISTICS_PORTRAIT_HEIGHT)];
		imageView.image = imagePortraitBackground;
	} else {
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CVPORTLET_SECTOR_STATISTICS_LANDSCAPE_WIDTH, CVPORTLET_SECTOR_STATISTICS_LANDSCAPE_HEIGHT)];
		imageView.image = imageLandscapeBackground;
	}
	self.imageViewBackground = imageView;
	[self.view addSubview:imageViewBackground];
	[imageView release];
	
	UILabel *label;
	label = [[UILabel alloc] initWithFrame:[self titleLabelFrame:[[UIApplication sharedApplication] statusBarOrientation]]];
	label.autoresizingMask = UIViewAutoresizingNone;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:16.0];
	label.textColor = [UIColor whiteColor];
	label.text = [langSetting localizedString:@"Daily Sector Market Statistics"];
	self._titleLabel = label;
	[self.view addSubview:_titleLabel];
	[label release];
	
	label = [[UILabel alloc] initWithFrame:[self statisticsLabelFrame:[[UIApplication sharedApplication] statusBarOrientation]]];
	label.autoresizingMask = UIViewAutoresizingNone;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:16.0];
	label.textColor = [UIColor whiteColor];
	label.text =  [langSetting localizedString:@"Turnover(¥)"];
	self._statisticsLabel = label;
	[self.view addSubview:_statisticsLabel];
	[label release];
	
	_btnRefresh = [[UIButton alloc] initWithFrame:CGRectZero];
	pathx = [[NSBundle mainBundle] pathForResource:@"portlet_refresh_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	_btnRefresh.frame = [self refreshButtonFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	[_btnRefresh setImage:image forState:UIControlStateNormal];
	[image release];
	[_btnRefresh addTarget:self action:@selector(clickRefreshButton) forControlEvents:UIControlEventTouchUpInside];
	_btnRefresh.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	//[self.view addSubview:_btnRefresh];
	
	// create the cache
	NSMutableArray *array1, *array2;
	CVPieChartView *pieChart;
	array1 = [[NSMutableArray alloc] initWithCapacity:1];
	array2 = [[NSMutableArray alloc] initWithCapacity:1];
	for (unsigned i = 0; i < SECTOR_STATISTICS_INVALID; i++) {
		pieChart = [[CVPieChartView alloc] initWithFrame:CGRectMake(20, 20, 400, 900)];
		pieChart.delegate = self;
		[array1 addObject:pieChart];
		[pieChart release];
		
		[array2 addObject:[NSNull null]];
	}
	self._pageViewCache = array1;
	self._pageDataCache = array2;
	[array1 release];
	[array2 release];
	
	CGRect rect = [self scrollPageFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	DreamScroll *controller;
	controller = [[DreamScroll alloc] init];
	controller.scrollView.canCancelContentTouches = NO;
	controller.scrollView.scrollEnabled = NO;
	controller.frame = rect;
	controller.pageControlFrame = [self scrollPageIndicatorFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	controller.pageCount = SECTOR_STATISTICS_INVALID;
	[controller setDelegate:self];
	self._scrollPageController = controller;
	[self.view addSubview:_scrollPageController.view];
	[self.view addSubview:_scrollPageController.pageControl];
	_scrollPageController.pageControl.center = CGPointMake(kPageControlCenterX_P, kPageControlCenterY_P);
	_scrollPageController.pageControl.hidden = YES;
	[controller release];
	
	_shareInfoView = [[CVShareInfoView alloc] initWithFrame:CGRectMake(310, 61, kHorizonalInfoWidth, kHorizonalInfoHeight)];
	_shareInfoView.viewType = CVPieViewHorizonal;
	NSString *shareInfoPath = [[NSBundle mainBundle] pathForResource:@"ShareInfoPortrait.png" ofType:nil];
	UIImage *imgShareInfo = [[UIImage alloc] initWithContentsOfFile:shareInfoPath];
	imgvShareInfo = [[UIImageView alloc] initWithFrame:CGRectMake(330, 76, 368, 330)];
	[imgvShareInfo setImage:imgShareInfo];
	imgvShareInfo.hidden = YES;
	_shareInfoView.hidden = YES;
	[self.view addSubview:imgvShareInfo];
	_shareInfoView.backgroundColor = [UIColor clearColor];
	_shareInfoView.userInteractionEnabled = YES;
	[self.view addSubview:_shareInfoView];
	[imgShareInfo release];
	
	//total
	
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_activityIndicator.frame = CGRectMake(rect.size.width / 2 - 5,
									 rect.size.height / 2 - 5,
									 _activityIndicator.frame.size.width,
									 _activityIndicator.frame.size.height);
	_activityIndicator.center = CGPointMake(kIndicatorCenterX_P, kIndicatorCenterY_P);
	
	/*
	 *
	 */
	UIInterfaceOrientation dreamOrientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationPortrait == dreamOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == dreamOrientation) {
		_activityIndicator.center = CGPointMake(kIndicatorCenterX_P, kIndicatorCenterY_P);
	} else {
		_activityIndicator.center = CGPointMake(kIndicatorCenterX_L, kIndicatorCenterY_L);
	}
	/*
	 *
	 */
	_activityIndicator.hidden = NO;
	[_activityIndicator startAnimating];
	[self.view addSubview:_activityIndicator];
	[self createGesture];
	[NSTimer scheduledTimerWithTimeInterval:1.0 
									 target:self
								   selector:@selector(checkIfOnTouch)
								   userInfo:nil
									repeats:YES];
	[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:[NSNumber numberWithBool:NO]];
	//[self performSelector:@selector(initOrientation) withObject:nil afterDelay:0.1];
	
	CVSetting *s;
	CVDataProvider *dp;
	dp = [CVDataProvider sharedInstance];
	s = [CVSetting sharedInstance];
	[dp setDataIdentifier:@"IndustrialSectorStatistics" lifecycle:[s cvCachedDataLifecycle:CVSettingIndustrialMarketStatistics]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationFromScroll:) name:kScrollNotificationToPieChart object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshData:) name:kRefreshPieChartData object:nil];
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
	[imagePortraitBackground release];
	[imageLandscapeBackground release];
	[imageViewBackground release];
	[_titleLabel release];
	[_statisticsLabel release];
	[_btnRefresh release];
	
	[_imgvPortraitNoData release];
	[_imgvLandscapeNoData release];
	
	[_scrollPageController release];
	[_activityIndicator release];
	
	[_pageViewCache release];
	[_pageDataCache release];
	[_sectorSummaryArray release];
	[_sectorSummaryTitleDict release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark CVPortletViewController

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	CGRect dreamFrame;
	int iOr=0;
	CGPoint ptBefore =  _scrollPageController.scrollView.contentOffset;
	int n = ptBefore.x/_scrollPageController.frame.size.width;
	self.portalInterfaceOrientation = orientation;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		_activityIndicator.center = CGPointMake(kIndicatorCenterX_P, kIndicatorCenterY_P);
		NSString *shareInfoPath = [[NSBundle mainBundle] pathForResource:@"ShareInfoPortrait.png" ofType:nil];
		UIImage *imgShareInfo = [[UIImage alloc] initWithContentsOfFile:shareInfoPath];
		imgvShareInfo.frame = CGRectMake(330, 76, 368, 330);
		[imgvShareInfo setImage:imgShareInfo];
		[imgShareInfo release];
		
		_shareInfoView.frame = CGRectMake(310, 61, kHorizonalInfoWidth, kHorizonalInfoHeight);
		_shareInfoView.viewType = CVPieViewHorizonal;
		dreamFrame = CGRectMake(20, 20, kVertiacalChartWidth, kVertiacalChartWidth);
		self.imageViewBackground.image = imagePortraitBackground;
		self.imageViewBackground.frame = CGRectMake(0, 0, CVPORTLET_SECTOR_STATISTICS_PORTRAIT_WIDTH, CVPORTLET_SECTOR_STATISTICS_PORTRAIT_HEIGHT);
		if(_isEmptyData){
			[self.view addSubview:_imgvPortraitNoData];
			[_imgvLandscapeNoData removeFromSuperview];
		}
	} else {
		_activityIndicator.center = CGPointMake(kIndicatorCenterX_L, kIndicatorCenterY_L);
		NSString *shareInfoPath = [[NSBundle mainBundle] pathForResource:@"ShareInfoLandscape.png" ofType:nil];
		UIImage *imgShareInfo = [[UIImage alloc] initWithContentsOfFile:shareInfoPath];
		imgvShareInfo.frame = CGRectMake(24, 305, 416, 303);
		[imgvShareInfo setImage:imgShareInfo];
		[imgShareInfo release];
		iOr = 1;
		dreamFrame = CGRectMake(20, 20, kHorizonalChartWidth, kHorizonalChartWidth);
		_shareInfoView.frame = CGRectMake(23, 326, kVertiacalInfoWidth, kVertiacalInfoHeight);
		_shareInfoView.viewType = CVPiewViewVertical;
		self.imageViewBackground.image = imageLandscapeBackground;
		self.imageViewBackground.frame = CGRectMake(0, 0, CVPORTLET_SECTOR_STATISTICS_LANDSCAPE_WIDTH, CVPORTLET_SECTOR_STATISTICS_LANDSCAPE_HEIGHT);
		if(_isEmptyData){
			[_imgvPortraitNoData removeFromSuperview];
			[self.view addSubview:_imgvLandscapeNoData];
		}
	}
	_scrollPageController.frame = [self scrollPageFrame:orientation];
	[_scrollPageController.scrollView setContentOffset:CGPointMake(n*_scrollPageController.frame.size.width,0)];
	_scrollPageController.pageControlFrame = [self scrollPageIndicatorFrame:[[UIApplication sharedApplication] statusBarOrientation]];

	
	CVPieChartView *pieChart;
	for (unsigned i = 0; i < SECTOR_STATISTICS_INVALID; i++) {
		pieChart = [[CVPieChartView alloc] initWithFrame:dreamFrame];
		pieChart.delegate = self;
		if (iOr == 0)
			[pieChart orietationChangedTo:CVPieViewHorizonal];
		else
			[pieChart orietationChangedTo:CVPiewViewVertical];
		
		[_pageViewCache replaceObjectAtIndex:i withObject:pieChart];
		if (ifLoaded)
		{
			[pieChart adjustToIndex:dreamIndex];
		}
		[pieChart release];
	}
	
	_titleLabel.frame = [self titleLabelFrame:orientation];
	_statisticsLabel.frame = [self statisticsLabelFrame:orientation];
	_btnRefresh.frame = [self refreshButtonFrame:orientation];
	
	//fix rotation crash
	if(!ifLoaded)
		return;
	if (_isEmptyData) {
		return;
	}
	[self setPageControlCenter:orientation];
	[_scrollPageController reloadData];
}

#pragma mark -
#pragma mark Refresh Button Click

-(void)clickRefreshButton{
	if (ifLoaded) {
		CVSetting *setting = [CVSetting sharedInstance];
		if (![setting isReachable]) {
			return;
		}
		ifLoaded = NO;
		
		[self postNotificationStopRoll];
		[self.view bringSubviewToFront:_activityIndicator];
		
		_shareInfoView.hidden = YES;
		imgvShareInfo.hidden = YES;
		_scrollPageController.pageControl.hidden = YES;
		
		for (int i = 0; i < 4; i++) {
			CVPieChartView *pieChart = [self._pageViewCache objectAtIndex:i];
			pieChart.hidden = YES;
		}
		
		if (_imgvPortraitNoData != nil) {
			[_imgvPortraitNoData removeFromSuperview];
		}
		if (_imgvLandscapeNoData != nil) {
			[_imgvLandscapeNoData removeFromSuperview];
		}
		
		_activityIndicator.hidden = NO;
		[_activityIndicator startAnimating];
		[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:[NSNumber numberWithBool:YES]];
	}
}

#pragma mark -
#pragma mark pviate method
/*
 * It loads the data of sectors' turnover, volume, total capital
 * tradable capital and summary.
 */
- (void)loadData:(NSNumber *)isRefresh {
	
	bTurnover = NO;
	bVolume = NO;
	bTotalCap = NO;
	bTradableCap = NO;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CVSetting *s;
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	
	
	
	
	
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingIndustrialMarketStatistics];
	paramInfo.parameters = nil;
	dict = [dp GetSectorSummaryAtId:paramInfo];
	[paramInfo release];
	
	self._sectorSummaryArray = [dict objectForKey:@"data"];
	self._sectorSummaryTitleDict = [dict objectForKey:@"head"];
	
	
	NSDictionary *dd = [dp GetSectorAll];
	NSArray *dataArray = [dd objectForKey:@"gainers"];
	if (!dataArray)
		dataArray = [dd objectForKey:@"data"];
	
	
	
	
	
	NSMutableArray *mut1 = [[NSMutableArray alloc] init];
	NSMutableArray *mut2 = [[NSMutableArray alloc] init];
	NSMutableArray *mut3 = [[NSMutableArray alloc] init];
	NSMutableArray *mut4 = [[NSMutableArray alloc] init];
	
	
	
	for (NSString *icode in SectorIds){
		for (int i=0;i<[dataArray count];i++){
			NSString *strCode = [[dataArray objectAtIndex:i] objectForKey:@"CODE"];
			if ([strCode isEqualToString:icode]){
				NSString *strTurnover = [[dataArray objectAtIndex:i] objectForKey:@"成交额"];
				NSString *strVolume = [[dataArray objectAtIndex:i] objectForKey:@"成交量"];
				NSString *strTotalCap = [[dataArray objectAtIndex:i] objectForKey:@"总市值"];
				NSString *strTradableCap = [[dataArray objectAtIndex:i] objectForKey:@"流通市值"];
				
				[mut1 addObject:[NSNumber numberWithFloat:[strTurnover floatValue]]];
				[mut2 addObject:[NSNumber numberWithFloat:[strVolume floatValue]]];
				[mut3 addObject:[NSNumber numberWithFloat:[strTotalCap floatValue]]];
				[mut4 addObject:[NSNumber numberWithFloat:[strTradableCap floatValue]]];
			}	
		}
	}
	
	[_pageDataCache replaceObjectAtIndex:kDataTypeTurnover withObject:mut1];
	[_pageDataCache replaceObjectAtIndex:kDataTypeVolume withObject:mut2];
	[_pageDataCache replaceObjectAtIndex:kDataTypeTotalCap withObject:mut3];
	[_pageDataCache replaceObjectAtIndex:kDataTypeTradableCap withObject:mut4];
	
	[mut1 release];
	[mut2 release];
	[mut3 release];
	[mut4 release];
	
	ifLoaded = YES;
	[_activityIndicator stopAnimating];
	_activityIndicator.hidden = YES;
	
	if(_sectorSummaryArray && _sectorSummaryTitleDict){
		_isEmptyData = NO;
		_shareInfoView.hidden = NO;
		imgvShareInfo.hidden = NO;
		_scrollPageController.pageControl.hidden = NO;
		for (int i = 0; i < 4; i++) {
			CVPieChartView *pieChart = [self._pageViewCache objectAtIndex:i];
			pieChart.hidden = NO;
		}
		
		[_scrollPageController reloadData];
	}
	else {
		_isEmptyData = YES;
		if (_imgvPortraitNoData == nil) {
			NSString *path = [[NSBundle mainBundle] pathForResource:@"PortraitPie.png" ofType:nil];
			UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
			_imgvPortraitNoData = [[UIImageView alloc] initWithImage:img];
			_imgvPortraitNoData.frame = CGRectMake(20, 50, img.size.width, img.size.height);
			[img release];
		}
		if (_imgvLandscapeNoData == nil) {
			NSString *path = [[NSBundle mainBundle] pathForResource:@"LandscapePie.png" ofType:nil];
			UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
			_imgvLandscapeNoData = [[UIImageView alloc] initWithImage:img];
			_imgvLandscapeNoData.frame = CGRectMake(20, 50, img.size.width, img.size.height);
			[img release];
		}
		if (UIInterfaceOrientationPortrait == portalInterfaceOrientation ||
			UIInterfaceOrientationPortraitUpsideDown == portalInterfaceOrientation) {
			[self.view addSubview:_imgvPortraitNoData];
		} else {
			[self.view addSubview:_imgvLandscapeNoData];
		}
	}
	[self adjustSubviews:[UIApplication sharedApplication].statusBarOrientation];
	[self performSelectorOnMainThread:@selector(postScrollNotification:) withObject:[NSNumber numberWithInt:dreamIndex] waitUntilDone:NO];

	
	[pool release];
}

#pragma mark -
#pragma mark notification with scroller

- (void) postScrollNotification:(NSNumber *)number{
	[self postNotificationToScroll:[number intValue]];
}

- (void) postNotificationToScroll:(NSInteger)index{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToScroller object:[SectorIds objectAtIndex:index]];
}

-(void) getNotificationFromScroll:(NSNotification *)notification{
	if (!ifLoaded) {
		return;
	}
	NSString *icode = (NSString *)[notification object];
	int sectorCount = [SectorIds count];
	NSInteger index = 0;
	for(int i = 0; i < sectorCount; i++){
		NSString *tempCode = [SectorIds objectAtIndex:i];
		if ([tempCode isEqualToString:icode]) {
			index = i;
			break;
		}
	}
	dreamIndex = index;
	for (int i=0;i<4;i++)
	{
		CVPieChartView *pieChart = [_pageViewCache objectAtIndex:i];
		[pieChart.delegate didRunIntoRegion:dreamIndex];
	}
	rotateCount = 0;
}

-(void) postNotificationStopRoll{
	[[NSNotificationCenter defaultCenter] postNotificationName:kStopAutoScroll object:nil];
}

-(void)getNotificationToRefreshData:(NSNotification *)notification{
	[self clickRefreshButton];
}

#pragma mark -
/*
 * it returns the origin point and size of scroll page frame
 * corresponding to the device orientation
 */
- (CGRect)scrollPageFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(20, CVPORTLET_BAR_HEIGHT,
						  kVertiacalChartWidth+20,
						  kVertiacalChartWidth+20);
	} else {
		rect = CGRectMake((CVPORTLET_SECTOR_STATISTICS_LANDSCAPE_WIDTH-kHorizonalChartWidth-40)/2.0+22.0-8., CVPORTLET_BAR_HEIGHT-20,
						  kHorizonalChartWidth+20, 
						  kHorizonalChartWidth+40);
	}
	
	return rect;
}

- (CGRect)scrollPageIndicatorFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	rect = [self scrollPageFrame:orientation];
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake((rect.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2,
						  rect.size.height, 
						  CVSCROLLPAGE_INDICTOR_WIDTH,
						  CVSCROLLPAGE_INDICTOR_HEIGHT);
	} else {
		// FIXME, the position of page indicator
		rect = CGRectMake((rect.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2,
						  rect.size.height,
						  CVSCROLLPAGE_INDICTOR_WIDTH,
						  CVSCROLLPAGE_INDICTOR_HEIGHT);
	}

	return rect;
}

- (CGRect)titleLabelFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(20, 0, 240, CVPORTLET_BAR_HEIGHT);
	} else {
		rect = CGRectMake(20, 0, 240, CVPORTLET_BAR_HEIGHT);
	}
	
	return rect;
}

- (CGRect)statisticsLabelFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(580, 0, 130, CVPORTLET_BAR_HEIGHT);
	} else {
		rect = CGRectMake(320, 0, 130, CVPORTLET_BAR_HEIGHT);
	}
	
	return rect;
}

- (CGRect)refreshButtonFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(500, (CVPORTLET_BAR_HEIGHT - CVPORTLET_BUTTON_HEIGHT) / 2, CVPORTLET_BUTTON_WIDTH, CVPORTLET_BUTTON_HEIGHT);
	} else {
		rect = CGRectMake(260, (CVPORTLET_BAR_HEIGHT - CVPORTLET_BUTTON_HEIGHT) / 2, CVPORTLET_BUTTON_WIDTH, CVPORTLET_BUTTON_HEIGHT);
	}
	
	return rect;
}

/*
 * It loads the color setting for each share of pie chart
 *
 * @return	An array each of which represents color of a share.
 *			Element of the array is NSString type in a format of <alpha><red><green><blue>.
 *			e.g. FF6B372F, alpha is FF, red is 6B, green is 37 and blue is 2F.
 */
- (NSArray *)colorSettingForShare {
	NSString *filePath;
	NSDictionary *dict;
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"SectorPieChartConf_%@",[langSetting localizedString:@"LangCode"]] ofType:@"plist"];
	dict = [[[NSDictionary alloc] initWithContentsOfFile:filePath] autorelease];
	
	return [dict objectForKey:@"SectorColor"];
}

#pragma mark -
#pragma mark CVScrollPageViewDelegate

- (NSUInteger)numberOfPagesInScrollPageView{
	return 4;
}

- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CVPieChartView *pieChart;
	NSArray *mountArray;
	NSArray* settingArray;
	
	NSMutableArray *shareArray;
	NSMutableArray *colorArray;
	
	
	pieChart = [_pageViewCache objectAtIndex:index];

	if (pieChart!=nil){
		NSLog(@"Pie chart is not empty:%d",index);
	}
	
	assert([_pageViewCache count]==4);
	assert(pieChart!=nil);
	
	
	mountArray = [_pageDataCache objectAtIndex:index];
	NSNumber *mount;
	CGFloat sum, ratio;
	
	// caculate the mount of all sectors
	sum = 0;
	for (mount in mountArray) {
		sum = sum + [mount floatValue];
	}
	if (sum == 0) {
		return nil;
	}
	// construct the array consisting of ratio for each sector
	shareArray = [[NSMutableArray alloc] init];
	for (mount in mountArray) {
		ratio = [mount floatValue] / sum;
		NSAutoreleasePool *innerPool = [[NSAutoreleasePool alloc] init];
		[shareArray addObject:[NSNumber numberWithFloat:ratio]];
		[innerPool release];
	}
	
	// an array consists of color setting for each sector
	settingArray = [self colorSettingForShare];
	NSString *colorVlue;
	UIColor *color;
	colorArray = [[NSMutableArray alloc] init];
	for (colorVlue in settingArray) {
		color = [UIColor colorWithDesp:colorVlue];
		[colorArray addObject:color];
	}
	
	NSString *strSum;
	strSum = [[NSString alloc] initWithFormat:@"%.2fB", sum / 1000];
	assert(pieChart!=nil);
	[pieChart setSum:strSum];
	assert(strSum!=nil);
	[strSum release];
	
	if (UIInterfaceOrientationPortrait == portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == portalInterfaceOrientation) {
		[pieChart orietationChangedTo:CVPiewViewVertical];
	} else {
		[pieChart orietationChangedTo:CVPieViewHorizonal];
	}
	
	[pieChart illustrateShareArray:shareArray colorArray:colorArray];

	[shareArray release];
	[colorArray release];
	
	NSLog(@"Total piechart views:%d",[_pageViewCache count]);
	
	[pool release];
	
	return pieChart;
}

- (void)didScrollToPageAtIndex:(NSUInteger)index {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	switch (index) {
		case SECTOR_STATISTICS_TURNOVER:
			_statisticsLabel.text = [langSetting localizedString:@"Turnover(¥)"];
			break;
		case SECTOR_STATISTICS_VOLUME:
			_statisticsLabel.text = [langSetting localizedString:@"Volume"];
			break;
			
		case SECTOR_STATISTICS_TOTAL_CAP:
			_statisticsLabel.text = [langSetting localizedString:@"Total Cap(¥)"];
			break;
			
		case SECTOR_STATISTICS_TRADABLE_CAP:
			_statisticsLabel.text = [langSetting localizedString:@"Tradable Cap(¥)"];
			break;
			
		default:
			break;
	}
	currentIndex = index;
	
	CVShareInfo* shareInfo;
	shareInfo = [self sectorShareInfoAtIndex:dreamIndex];
	
	for (int i=0;i<4;i++)
	{
		
		CVPieChartView *pieChart = [_pageViewCache objectAtIndex:i];
		[pieChart adjustToIndex:dreamIndex];
		
	}
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [local localizedString:@"LangCode"];
	
	NSArray *array = [_pageDataCache objectAtIndex:currentIndex];
	NSNumber *value = [array objectAtIndex:dreamIndex];
	NSString *strValue = [NSString stringWithFormat:@"%d",[value intValue]];
	if ([_langCode isEqualToString:@"en"]) {
		strValue = [strValue formatToEnNumber];
	}
	NSString *strDate = [NSString stringWithFormat:@"%@    %@: %@M",shareInfo.date,_statisticsLabel.text,strValue];
	shareInfo.date = strDate;
	
	[_shareInfoView showData:shareInfo];
}

#pragma mark -
#pragma mark CVPieChartViewDelegate
- (CVShareInfo *)sectorShareInfoAtIndex:(int)index {
	CVShareInfo *shareInfo;
	NSDictionary *summary;
	
	NSString *sectorCode;
	
	shareInfo = nil;
	if (index < SECTOR_DEFITION_INVALID) {
		NSUInteger i;
		
		for (i = 0; i < [_sectorSummaryArray count]; i++) {
			summary = [_sectorSummaryArray objectAtIndex:i];
			
			// summary keys
			//<node name="CNT">CO.(#)</node>
			//<node name="JZCSYL">ROE (%)</node>
			//<node name="FSRQ">DATE</node>
			//<node name="CHG">CHG (%)</node>
			//<node name="INDUSTRY">SECTOR</node>
			//<node name="CAP">TRADABLE CAP</node>
			//<node name="PE_AVERAGE">AVG P/E</node>
			//<node name="CODE">GICS CODE</node>
			//<node name="XSJLL">NET MARGIN (%)</node>
			//<node name="PB_AVERAGE">AVG P/B</node>
			//<node name="NO1">GAINERS</node>
			//<node name="NO2">DECLINERS</node>	
			sectorCode = [summary objectForKey:@"CODE"];
			
			
			if ([sectorCode isEqualToString:[SectorIds objectAtIndex:index]]) {
				
				shareInfo = [[[CVShareInfo alloc] init] autorelease];
				
				shareInfo.sectorCode = sectorCode;
				NSString *strTemp;
				shareInfo.chgTitle = [_sectorSummaryTitleDict objectForKey:@"CHG"];
				shareInfo.chg = [summary objectForKey:@"CHG"];
				shareInfo.coTitle = [_sectorSummaryTitleDict objectForKey:@"CNT"];
				shareInfo.co = [summary objectForKey:@"CNT"];
				strTemp = [summary objectForKey:@"FSRQ"];
				strTemp = (strTemp == nil)?@"":strTemp;
				shareInfo.date = strTemp;
				shareInfo.gainersTitle = [_sectorSummaryTitleDict objectForKey:@"NO1"];
				shareInfo.gainers = [summary objectForKey:@"NO1"];
				shareInfo.declinersTitle = [_sectorSummaryTitleDict objectForKey:@"NO2"];		
				shareInfo.decliners = [summary objectForKey:@"NO2"];
				shareInfo.netmarginTitle = [_sectorSummaryTitleDict objectForKey:@"XSJLL"];
				shareInfo.netmargin =[summary objectForKey:@"XSJLL"];
				shareInfo.pbTitle = [_sectorSummaryTitleDict objectForKey:@"PB_AVERAGE"];
				shareInfo.pb = [summary objectForKey:@"PB_AVERAGE"];
				shareInfo.peTitle = [_sectorSummaryTitleDict objectForKey:@"PE_AVERAGE"];
				shareInfo.pe = [summary objectForKey:@"PE_AVERAGE"];
				shareInfo.roeTitle = [_sectorSummaryTitleDict objectForKey:@"JZCSYL"];
				shareInfo.roe = [summary objectForKey:@"JZCSYL"];
				shareInfo.title = [summary objectForKey:@"INDUSTRY"];
				shareInfo.tradableTitle = [_sectorSummaryTitleDict objectForKey:@"CAP"];
				shareInfo.tradable = [summary objectForKey:@"CAP"];
				break;
			}
		}
	}
	
//	NSLog(@"dream's share info:%@",shareInfo.tradableTitle);
	
	return shareInfo;
}

- (void)didRunIntoRegion:(int)index
{
	if(index<0)
		return;
	dreamIndex = index;
	CVShareInfo* shareInfo;
	shareInfo = [self sectorShareInfoAtIndex:index];
	
	for (int i=0;i<4;i++)
	{
		
		CVPieChartView *pieChart = [_pageViewCache objectAtIndex:i];
		[pieChart adjustToIndex:index];
		
	}
	
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [local localizedString:@"LangCode"];
	
	NSArray *array = [_pageDataCache objectAtIndex:currentIndex];
	NSNumber *value = [array objectAtIndex:index];
	NSString *strValue = [NSString stringWithFormat:@"%d",[value intValue]];
	if ([_langCode isEqualToString:@"en"]) {
		strValue = [strValue formatToEnNumber];
	}
	NSString *strDate = [NSString stringWithFormat:@"%@    %@: %@M",shareInfo.date,_statisticsLabel.text,strValue];
	shareInfo.date = strDate;
	
	[_shareInfoView showData:shareInfo];
	dreamIndex = index;
	
	if (_scrollPageController.pageControl.currentPage==currentIndex) {
		[self postNotificationToScroll:index];
	}
}

- (NSInteger) numberOfPagesInScrollPageView:(UIScrollView *)scrollView
{
	return 4;
}


- (void) initOrientation
{
	[self adjustSubviews:[UIApplication sharedApplication].statusBarOrientation];
}

- (void) setPageControlCenter:(UIInterfaceOrientation)orientation
{
	if (orientation==UIInterfaceOrientationPortrait
		|| orientation==UIInterfaceOrientationPortraitUpsideDown)
		self._scrollPageController.pageControl.center = CGPointMake(kPageControlCenterX_P, kPageControlCenterY_P);
	else
		self._scrollPageController.pageControl.center = CGPointMake(kPageControlCenterX_L, kPageControlCenterY_L-10.);
}

- (void) createGesture
{
	UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
	UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
	rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
	
	[_shareInfoView addGestureRecognizer:leftSwipe];
	[_shareInfoView addGestureRecognizer:rightSwipe];
	[leftSwipe release];
	[rightSwipe release];
	[panGesture release];
}

#pragma mark -
#pragma mark Gesture Handler
- (void) handleSwipeLeft:(UISwipeGestureRecognizer *)sender
{
	NSUInteger index = _scrollPageController.pageControl.currentPage;
	if (index!=3)
		index++;
	CGRect dFrame = _scrollPageController.scrollView.frame;
    dFrame.origin.x = dFrame.size.width * index;
    dFrame.origin.y = 0;
    [_scrollPageController.scrollView scrollRectToVisible:dFrame animated:YES];
	
	
}

- (void) handleSwipeRight:(UISwipeGestureRecognizer *)sender
{
	NSUInteger index = _scrollPageController.pageControl.currentPage;
	if (index!=0)
		index--;
	CGRect dFrame = _scrollPageController.scrollView.frame;
    dFrame.origin.x = dFrame.size.width * index;
    dFrame.origin.y = 0;
    [_scrollPageController.scrollView scrollRectToVisible:dFrame animated:YES];
}

- (void) handlePan:(UIPanGestureRecognizer *)sender
{
	
}

- (void) checkIfOnTouch{
	if (!ifLoaded){
		rotateCount = 0;
		[self postNotificationStopRoll];
	}
	for (int i=0;i<4;i++)
	{
		CVPieChartView *pieChart = [_pageViewCache objectAtIndex:i];
		if([pieChart isMoving])
		{
			rotateCount = 0;
			[self postNotificationStopRoll];
		}
	}
}

- (void) autoRotate
{
	rotateCount++;
	if (!ifLoaded)
		rotateCount = 0;
	for (int i=0;i<4;i++)
	{
		CVPieChartView *pieChart = [_pageViewCache objectAtIndex:i];
		if([pieChart isMoving])
		{
			rotateCount = 0;
		}
	}
	if (rotateCount==5)
	{
		if (0==dreamIndex)
			dreamIndex = [_sectorSummaryArray count]-1;
		else
			dreamIndex--;
		for (int i=0;i<4;i++)
		{
			CVPieChartView *pieChart = [_pageViewCache objectAtIndex:i];
			[pieChart.delegate didRunIntoRegion:dreamIndex];
		}
		[self postNotificationToScroll:dreamIndex];
		rotateCount = 0;
	}
}

- (void)reloadData {
	CVDataProvider *dp;
	dp = [CVDataProvider sharedInstance];
	if ([dp isDataExpired:@"IndustrialSectorStatistics"]) {
		[self clickRefreshButton];
	}
}




-(void)getSectorData:(NSDictionary *)param{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	BOOL needRefresh = [[param objectForKey:@"update"] boolValue];
	NSUInteger dataType = [[param objectForKey:@"type"] unsignedIntegerValue];
	
	CVSetting *s;
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	NSMutableArray *mutDataArray;
	
	mutDataArray = [[NSMutableArray alloc] init];
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingIndustrialMarketStatistics];
	
	
	dict = [[dp GetSectorAll] objectForKey:@"data"];
	
	
	
	for (int i=SECTOR_DEFITION_ENERGY;i<SECTOR_DEFITION_INVALID;i++){
		NSArray *dataArray;
		NSDictionary *dataDict;
		NSString *value;
		CGFloat sum;
		paramInfo.parameters = [SectorIds objectAtIndex:i];
		
		switch (dataType) {
			case kDataTypeTurnover:
				if (needRefresh)
					dict = [dp ReGetSectorTurnoverAtId:paramInfo];
				else
					dict = [dp GetSectorTurnoverAtId:paramInfo];
				dataArray = [dict objectForKey:@"data"];
				sum = 0;
				for (dataDict in dataArray){
					value = [dataDict objectForKey:@"成交额"];
					sum = sum + [value floatValue];
				}
				[mutDataArray addObject:[NSNumber numberWithFloat:sum]];
				break;
			case kDataTypeVolume:
				if (needRefresh)
					dict = [dp ReGetSectorVolumeAtId:paramInfo];
				else
					dict = [dp GetSectorVolumeAtId:paramInfo];
				dataArray = [dict objectForKey:@"data"];
				sum = 0;
				for (dataDict in dataArray){
					value = [dataDict objectForKey:@"成交量"];
					sum = sum + [value floatValue];
				}
				[mutDataArray addObject:[NSNumber numberWithFloat:sum]];
				break;
			case kDataTypeTotalCap:
				if (needRefresh)
					dict = [dp ReGetSectorTotalCapitalAtId:paramInfo];
				else
					dict = [dp GetSectorTotalCapitalAtId:paramInfo];
				dataArray = [dict objectForKey:@"data"];
				sum = 0;
				for (dataDict in dataArray){
					value = [dataDict objectForKey:@"总市值"];
					sum = sum + [value floatValue];
				}
				[mutDataArray addObject:[NSNumber numberWithFloat:sum]];
				break;
			case kDataTypeTradableCap:
				if (needRefresh)
					dict = [dp ReGetSectorTradableCapitalAtId:paramInfo];
				else
					dict = [dp GetSectorTradableCapitalAtId:paramInfo];
				dataArray = [dict objectForKey:@"data"];
				sum = 0;
				for (dataDict in dataArray){
					value = [dataDict objectForKey:@"流通市值"];
					sum = sum + [value floatValue];
				}
				[mutDataArray addObject:[NSNumber numberWithFloat:sum]];
				break;
			default:
				break;
		}
		
		
	}
	if (0==dataType)
		bTurnover = YES;
	else if (1==dataType)
		bVolume = YES;
	else if (2==dataType)
		bTotalCap = YES;
	else
		bTradableCap = YES;
	
	[_pageDataCache replaceObjectAtIndex:dataType withObject:mutDataArray];
	
	[mutDataArray release];
	
	if (bTurnover && bVolume && bTotalCap && bTradableCap){
		ifLoaded = YES;
		[_activityIndicator stopAnimating];
		_activityIndicator.hidden = YES;
		
		if(_sectorSummaryArray && _sectorSummaryTitleDict){
			_isEmptyData = NO;
			_shareInfoView.hidden = NO;
			imgvShareInfo.hidden = NO;
			_scrollPageController.pageControl.hidden = NO;
			for (int i = 0; i < 4; i++) {
				CVPieChartView *pieChart = [self._pageViewCache objectAtIndex:i];
				pieChart.hidden = NO;
			}
			
			[_scrollPageController reloadData];
		}
		else {
			_isEmptyData = YES;
			if (_imgvPortraitNoData == nil) {
				NSString *path = [[NSBundle mainBundle] pathForResource:@"PortraitPie.png" ofType:nil];
				UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
				_imgvPortraitNoData = [[UIImageView alloc] initWithImage:img];
				_imgvPortraitNoData.frame = CGRectMake(20, 50, img.size.width, img.size.height);
				[img release];
			}
			if (_imgvLandscapeNoData == nil) {
				NSString *path = [[NSBundle mainBundle] pathForResource:@"LandscapePie.png" ofType:nil];
				UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
				_imgvLandscapeNoData = [[UIImageView alloc] initWithImage:img];
				_imgvLandscapeNoData.frame = CGRectMake(20, 50, img.size.width, img.size.height);
				[img release];
			}
			if (UIInterfaceOrientationPortrait == portalInterfaceOrientation ||
				UIInterfaceOrientationPortraitUpsideDown == portalInterfaceOrientation) {
				[self.view addSubview:_imgvPortraitNoData];
			} else {
				[self.view addSubview:_imgvLandscapeNoData];
			}
		}
		[self adjustSubviews:[UIApplication sharedApplication].statusBarOrientation];
		[self performSelectorOnMainThread:@selector(postScrollNotification:) withObject:[NSNumber numberWithInt:dreamIndex] waitUntilDone:NO];
	}
		
	[paramInfo release];
	[pool release];
}


@end


