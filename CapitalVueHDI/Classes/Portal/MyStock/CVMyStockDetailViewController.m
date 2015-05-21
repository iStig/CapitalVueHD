    //
//  CVMyStockDetailViewController.m
//  CapitalVueHD
//
//  Created by leon on 10-9-28.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMyStockDetailViewController.h"
#import "CVPortalSetMyStockCoordinates.h"
#import "CVDataProvider.h"
#import "CVPortal.h"
#import "CVPortletViewController.h"
#import "MKStoreManager.h"
#import "NoConnectionAlert.h"
#import "CVSetting.h"

@interface CVMyStockDetailViewController()

@property (nonatomic, retain) UIImageView *_imageBackground;
@property (nonatomic, retain) UIImage *_imgLandscape;
@property (nonatomic, retain) UIImage *_imgPortrait;

@property (nonatomic, retain) NSDictionary *_dictCurrentElement;

@property (nonatomic, retain) cvChartView *_stockChartView;
@property (nonatomic, retain) NSArray *_stockDataArray;
@property (nonatomic, retain) CVBlanceSheetViewController *_balanceSheetController;
@property (nonatomic, retain) CVIncomeStatementViewController *_incomeStatementController;
@property (nonatomic, retain) CVCashFlowViewController *_cashFlowController;
@property (nonatomic, retain) CVMyStockDetailInfoViewController *_detailInfoController;
@property (nonatomic, retain) CVMyIndexDetailInfoViewController *_indexDetailInfoController;
@property (nonatomic, retain) CVCompanyProfileViewController *_companyProfileController;
@property (nonatomic, retain) CVCompositeIndexProfileViewController *_compositeProfileController;
@property (nonatomic, retain) CVPeriodSegmentControl *_segmentControl;

@property (nonatomic, retain) NSTimer *_intradayChartTimer;
@property (nonatomic, retain) NSTimer *_intradayDetailTimer;



/*
 * It enable the in-app-puchase function, if ENABLE_IN_APP_PURCHASE is defined.
 */
//#define ENABLE_IN_APP_PURCHASE

/*
 * It loads the data of current stock/fund/bond.
 *
 * @param:	obj - NSDictionary-typed object consists of leftAxis and rightAxis
 * @return:	none
 */
- (void)loadData:(NSDictionary *)obj;


/*
 * It returns the origin point and size of stock/fund/chart chart view
 *
 * @param:	orientation - the device orientation
 * @return: the frame of macro chart view
 */
- (CGRect)stockChartViewFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the origin point and size of segment control for stock chart
 *
 * @param:	orientation - the device orientation
 * @return:	the frame of segment control
 */
- (CGRect)segmentControlFrame:(UIInterfaceOrientation)orientation;
/*
 *	Refresh button frame
 */
- (CGRect)refreshButtonFrame:(UIInterfaceOrientation)orientation;

/*
 *	The indicator frame
 */
- (CGRect)detailIndicatorFrame:(UIInterfaceOrientation)orientation;

/*
 *
 */
- (void)touchSegmentAtIndex:(NSUInteger)index;
- (void)loadCompositeIndexDetail:(NSMutableDictionary *)dict;
- (void)loadEquityDetail:(NSMutableDictionary *)compDict;

/*
 * It responds to the button touch-up-inside event and is responsible to
 * add favorite event
 */
- (IBAction)clickAddButton:(id)sender;

/*
 *	click refresh button
 */
-(void)clickRefreshButton;
/*
 * It checks whether the current equity/fund/bonds
 * 
 * @param:	dictionary with code, name and isEquity
 * @return: YES, if it is already in the favorite list; else NO
 */
- (BOOL)isMyFavorite:(NSDictionary *)description;

/*
 *	show default '-' to view
 */
- (void)showDefaultData;

/*
 * It adds the current equity/fund/bond to the favorite list
 *
 * @param:	dictionary with code, name and isEqutiy to be saved locally
 * @return:	none
 */
- (void)addMyFavorite:(NSDictionary *)description;

/*
 * It reads the data of intraday every a time span
 */
- (void)updateIntradayChart:(NSTimer *)timer;

/*
 * It starts the updating of intraday
 */
- (void)startIntradayChart:(NSDictionary *)userInfo;

/*
 * It stops the updating of intraday
 */
- (void)stopIntradayChart;

- (void)updateIntradayDetail:(NSTimer *)timer;

- (void)startIntradayDetail:(NSDictionary *)userInfo;

- (void)stopIntradayDetail;

- (BOOL)shouldBuyService;

/*
 * It will happen while getting realtime chart data back
 */
- (void)syncIntroDayFromChart:(NSDictionary *)dict andCode:(NSString *)name;

/*
 * called while no realtime chart data
 */
- (void)syncWhileNoIntroDayChartWithCode:(NSString *)name;

@end

@implementation CVMyStockDetailViewController

@synthesize detailOrientation;
@synthesize _stockChartView;
@synthesize _stockDataArray;
@synthesize myStockNavigatorController = _myStockNavigatorController;

@synthesize _imageBackground;
@synthesize _imgLandscape;
@synthesize _imgPortrait;

@synthesize _dictCurrentElement;

@synthesize _balanceSheetController;
@synthesize _incomeStatementController;
@synthesize _cashFlowController;
@synthesize _companyProfileController;
@synthesize _compositeProfileController;

@synthesize _segmentControl;
@synthesize _strCurrentType;

@synthesize _detailInfoController;
@synthesize _indexDetailInfoController;

@synthesize _intradayChartTimer;
@synthesize _intradayDetailTimer;
@synthesize dream_delegate;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    [super viewDidLoad];

	//dream's code begins here
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setButtonImage)
												 name:@"setButtonImage"
											   object:nil];
	
	UIImageView *aImageView;
	aImageView = [[UIImageView alloc] init];
	self._imageBackground = aImageView;
	[aImageView release];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"portal_mystock_detail_landscape_background.png" ofType:nil];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	self._imgLandscape = img;
	[img release];
	path = [[NSBundle mainBundle] pathForResource:@"portal_mystock_detail_portrait_background.png" ofType:nil];
	img = [[UIImage alloc] initWithContentsOfFile:path];
	self._imgPortrait  = img;
	[img release];
	_imageBackground.userInteractionEnabled = YES;
	
	_buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
	_buttonShow = [UIButton buttonWithType:UIButtonTypeCustom];
	_labelClass = [[UILabel alloc] init];
	_labelCode  = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 300, 30)];
	_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 400, 30)];
	
	_labelCode.backgroundColor = [UIColor clearColor];
	_labelCode.textColor =[UIColor whiteColor];
	_labelCode.font = [UIFont boldSystemFontOfSize:18];
	
	_labelTitle.backgroundColor = [UIColor clearColor];
	_labelTitle.textColor = [UIColor whiteColor];
	_labelTitle.font = [UIFont systemFontOfSize:18];
	
	_labelClass.backgroundColor = [UIColor clearColor];
	_labelClass.textColor = [UIColor whiteColor];
	_labelClass.font = [UIFont boldSystemFontOfSize:16];
	
	[self createButtons];
	
	if (UIInterfaceOrientationPortrait == detailOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == detailOrientation) {
		[_imageBackground setFrame:CGRectMake(0, 0, 727, 911)];
		_imageBackground.image = _imgPortrait;
	}
	else {
		[_imageBackground setFrame:CGRectMake(0, 0, 683, 655)];
		_imageBackground.image = _imgLandscape;
	}
	
	[buttonNews setCenter:CGPointMake(_imageBackground.frame.size.width/2-165-15, _imageBackground.frame.size.height-28)];
	[buttonBalanceSheet setCenter:CGPointMake(_imageBackground.frame.size.width/2-55-15, _imageBackground.frame.size.height-28)];
	[buttonIncomeStatement setCenter:CGPointMake(_imageBackground.frame.size.width/2+55-15, _imageBackground.frame.size.height-28)];
	[buttonCashFlow setCenter:CGPointMake(_imageBackground.frame.size.width/2+165-15, _imageBackground.frame.size.height-28)];
	
	[_buttonAdd setFrame:[self addDetailButtonFrame:detailOrientation]];
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"detail_add_normal_button.png" ofType:nil];
	UIImage *imgButtonNormal = [[UIImage alloc] initWithContentsOfFile:pathx];
	[_buttonAdd setBackgroundImage:imgButtonNormal forState:UIControlStateNormal];
	[imgButtonNormal release];
	[_buttonAdd addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
	
	[_buttonShow setFrame:[self showDetailButtonFrame:detailOrientation]];
	_buttonShow.tag = tagButtonShow;
	pathx = [[NSBundle mainBundle] pathForResource:@"detail_show_button.png" ofType:nil];
	UIImage *imgButtonShowNormal = [[UIImage alloc] initWithContentsOfFile:pathx];
	[_buttonShow setBackgroundImage:imgButtonShowNormal forState:UIControlStateNormal];
	[imgButtonShowNormal release];
	
	_btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
	pathx = [[NSBundle mainBundle] pathForResource:@"portlet_refresh_button.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[_btnRefresh setFrame:[self refreshButtonFrame:detailOrientation]];
	[_btnRefresh setImage:image forState:UIControlStateNormal];
	[image release];
	[_btnRefresh addTarget:self action:@selector(clickRefreshButton) forControlEvents:UIControlEventTouchUpInside];
	_btnRefresh.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	
	[_labelClass setFrame:[self classLabelFrame:detailOrientation]];
	[_imageBackground addSubview:_labelCode];
	[_imageBackground addSubview:_labelClass];
	[_imageBackground addSubview:_labelTitle];
	[self.view addSubview:_imageBackground];
	[self.view addSubview:_buttonAdd];
	[self.view addSubview:_buttonShow];
	[self.view addSubview:_btnRefresh];
	
	
	CGRect detailInfoRect;
	detailInfoRect = [self detailInfoControllerFrame:detailOrientation];
	self._detailInfoController = [[CVMyStockDetailInfoViewController alloc] initWithNibName:[NSString stringWithFormat:@"CVMyStockDetailInfoView_%@",[langSetting localizedString:@"LangCode"]] bundle:nil];
	[_detailInfoController release];
	_detailInfoController.view.frame = detailInfoRect;
	_detailInfoController.view.hidden = YES;
	[self.view addSubview:_detailInfoController.view];
	
	self._indexDetailInfoController = [[CVMyIndexDetailInfoViewController alloc] init];
	[_indexDetailInfoController release];
	_indexDetailInfoController.view.frame = detailInfoRect;
	_indexDetailInfoController.view.hidden = YES;
	[self.view addSubview:_indexDetailInfoController.view];
	
	CGRect rect;
	// create chart view
	cvChartView *aChart;
	NSString *cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"StockChart_%@",[langSetting localizedString:@"LangCode"]] ofType:@"plist"];
	rect = [self stockChartViewFrame:detailOrientation];
    aChart = [[cvChartView alloc] initWithFrame:rect FormatFile:cfgFilePath];
	aChart.frame = [self stockChartViewFrame:detailOrientation];
    aChart.dataProvider = self;
	aChart.dream_delegate = self;
	self._stockChartView = aChart;
	[aChart release];
	[_imageBackground addSubview:_stockChartView];
	[_stockChartView resize:[self stockChartViewFrame:detailOrientation]];
	
	// create segment control
	CVPeriodSegmentControl *control;
	control = [[CVPeriodSegmentControl alloc] initWithFrame:[self segmentControlFrame:detailOrientation]];
	control.delegate = self;
	self._segmentControl = control;
	_segmentControl.userInteractionEnabled = NO;
	_segmentControl.index = 0;
	[control release];
	[self.view addSubview:_segmentControl];
	
	[_imageBackground addSubview:buttonInfo];
	[_imageBackground addSubview:buttonCashFlow];
	[_imageBackground addSubview:buttonIncomeStatement];
	[_imageBackground addSubview:buttonBalanceSheet];
	[_imageBackground addSubview:buttonNews];
	
	_detailIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_detailIndicator.frame = [self detailIndicatorFrame:detailOrientation];
	[self.view addSubview:_detailIndicator];
	_detailIndicator.hidden = NO;
	[_detailIndicator startAnimating];
		
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dismissRotationView)
												 name:CVPortalDismissRotationViewNotification object:nil];
	
	// FIXE: it is better to judge the notification from button or other portalset
}

- (void)createButtons{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	buttonNews = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	buttonNews.tag = 1;
	buttonBalanceSheet = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	buttonBalanceSheet.tag = 2;
	buttonIncomeStatement = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	buttonIncomeStatement.tag = 3;
	buttonCashFlow = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	buttonCashFlow.tag = 4;
	buttonInfo = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	buttonInfo.tag = 5;
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonNews setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonBalanceSheet setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonIncomeStatement setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonCashFlow setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonInfo setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	
	[buttonNews sizeToFit];
	[buttonBalanceSheet sizeToFit];
	[buttonIncomeStatement sizeToFit];
	[buttonCashFlow sizeToFit];
	[buttonInfo sizeToFit];
	
	UILabel *labelNews = [[UILabel alloc] initWithFrame:CGRectMake(50, 23, 100, 20)];
	labelNews.backgroundColor = [UIColor clearColor];
	labelNews.font = [UIFont boldSystemFontOfSize:13];
	labelNews.textColor = [UIColor whiteColor];
	labelNews.text = [langSetting localizedString:@"News"];
	labelNews.userInteractionEnabled = NO;
	[buttonNews addSubview:labelNews];
	[labelNews release];
	
	UILabel *labelBalanceSheet = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 50, 40)];
	labelBalanceSheet.backgroundColor = [UIColor clearColor];
	labelBalanceSheet.font = [UIFont boldSystemFontOfSize:13];
	labelBalanceSheet.textAlignment = UITextAlignmentCenter;
	labelBalanceSheet.numberOfLines = 2;
	labelBalanceSheet.textColor = [UIColor whiteColor];
	labelBalanceSheet.text = [langSetting localizedString:@"Balance Sheet"];
	labelBalanceSheet.userInteractionEnabled = NO;
	[buttonBalanceSheet addSubview:labelBalanceSheet];
	[labelBalanceSheet release];
	
	UILabel *labelIncomeStatement = [[UILabel alloc] initWithFrame:CGRectMake(38, 15, 70, 40)];
	labelIncomeStatement.backgroundColor = [UIColor clearColor];
	labelIncomeStatement.font = [UIFont boldSystemFontOfSize:13];
	labelIncomeStatement.textAlignment = UITextAlignmentCenter;
	labelIncomeStatement.numberOfLines = 2;
	labelIncomeStatement.textColor = [UIColor whiteColor];
	labelIncomeStatement.text = [langSetting localizedString:@"Income Statement"];
	labelIncomeStatement.userInteractionEnabled = NO;
	[buttonIncomeStatement addSubview:labelIncomeStatement];
	[labelIncomeStatement release];
	
	UILabel *labelCashFlow = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 50, 40)];
	labelCashFlow.backgroundColor = [UIColor clearColor];
	labelCashFlow.font = [UIFont boldSystemFontOfSize:13];
	labelCashFlow.textAlignment = UITextAlignmentCenter;
	labelCashFlow.numberOfLines = 2;
	labelCashFlow.textColor = [UIColor whiteColor];
	labelCashFlow.text = [langSetting localizedString:@"Cash Flow"];
	labelCashFlow.userInteractionEnabled = NO;
	[buttonCashFlow addSubview:labelCashFlow];
	[labelCashFlow release];
	
	UILabel *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 23, 100, 20)];
	labelInfo.backgroundColor = [UIColor clearColor];
	labelInfo.font = [UIFont boldSystemFontOfSize:13];
	labelInfo.textAlignment = UITextAlignmentCenter;
	labelInfo.textColor = [UIColor whiteColor];
	labelInfo.text = [langSetting localizedString:@"Info"];
	labelInfo.userInteractionEnabled = NO;
	[buttonInfo addSubview:labelInfo];
	[labelInfo release];
	
	
	[buttonNews addTarget:self action:@selector(clickNewsButton) forControlEvents:UIControlEventTouchUpInside];
	[buttonBalanceSheet addTarget:self action:@selector(clickBalanceButton) forControlEvents:UIControlEventTouchUpInside];
	[buttonIncomeStatement addTarget:self action:@selector(clickIncomeStatementButton) forControlEvents:UIControlEventTouchUpInside];
	[buttonCashFlow addTarget:self action:@selector(clickCashFlowButton) forControlEvents:UIControlEventTouchUpInside];
	[buttonInfo addTarget:self action:@selector(clickInfoButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (CGRect)addDetailButtonFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(185, 10,
						  CVMYSTOCK_DETAIL_ADDBUTTON_WIDTH, 
						  CVMYSTOCK_DETAIL_ADDBUTTON_HEIGHT);
	} else {
		rect = CGRectMake(27, 10, 
						  CVMYSTOCK_DETAIL_ADDBUTTON_WIDTH, 
						  CVMYSTOCK_DETAIL_ADDBUTTON_HEIGHT);
	}
	
	return rect;
}

- (CGRect)showDetailButtonFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(27, 10,
						  CVMYSTOCK_DETAIL_ADDBUTTON_WIDTH, 
						  CVMYSTOCK_DETAIL_ADDBUTTON_HEIGHT);
	} else {
		rect = CGRectMake(27, 10, 
						  CVMYSTOCK_DETAIL_ADDBUTTON_WIDTH, 
						  CVMYSTOCK_DETAIL_ADDBUTTON_HEIGHT);
	}
	
	return rect;
}

- (CGRect)refreshButtonFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(525, (CVPORTLET_BAR_HEIGHT - CVPORTLET_BUTTON_HEIGHT) / 2, CVPORTLET_BUTTON_WIDTH, CVPORTLET_BUTTON_HEIGHT);
	} else {
		rect = CGRectMake(475, (CVPORTLET_BAR_HEIGHT - CVPORTLET_BUTTON_HEIGHT) / 2, CVPORTLET_BUTTON_WIDTH, CVPORTLET_BUTTON_HEIGHT);
	}
	
	return rect;
}

- (CGRect)classLabelFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(590, 10,
						  CVMYSTOCK_DETAIL_CLASSLABEL_WIDTH, 
						  CVMYSTOCK_DETAIL_CLASSLABEL_HEIGHT);
	} else {
		rect = CGRectMake(540, 10, 
						  CVMYSTOCK_DETAIL_CLASSLABEL_WIDTH, 
						  CVMYSTOCK_DETAIL_CLASSLABEL_HEIGHT);
	}
	
	return rect;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[_imageBackground release];
	[_imgLandscape release];
	[_imgPortrait release];
	[_detailIndicator release];
	
	[_dictCurrentElement release];
	
	[_myStockNavigatorController release];
	[_detailInfoController release];
	[_indexDetailInfoController release];
	[_incomeStatementController release];
	[_balanceSheetController release];
	[_cashFlowController release];
	[_companyProfileController release];
	[_compositeProfileController release];
	
	[_segmentControl release];
	
	[_intradayChartTimer release];
	[_intradayDetailTimer release];
	
	[buttonInfo release];
	[buttonIncomeStatement release];
	[buttonCashFlow release];
	[buttonBalanceSheet release];
	[buttonNews release];
	
	[_stockDataArray release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark private method
/*
 * It returns the origin point and size of stock/fund/chart chart view
 *
 * @param:	orientation - the device orientation
 * @return: the frame of macro chart view
 */
- (CGRect)stockChartViewFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVMYSTOCK_DETAIL_CHART_PORTRAIT_X,
						  CVMYSTOCK_DETAIL_CHART_PORTRAIT_Y, 
						  CVMYSTOCK_DETAIL_CHART_PORTRAIT_WIDTH, 
						  CVMYSTOCK_DETAIL_CHART_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVMYSTOCK_DETAIL_CHART_LANDSCAPE_X,
						  CVMYSTOCK_DETAIL_CHART_LANDSCAPE_Y, 
						  CVMYSTOCK_DETAIL_CHART_LANDSCAPE_WIDTH, 
						  CVMYSTOCK_DETAIL_CHART_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

- (CGRect)detailInfoControllerFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVMYSTOCK_DETAIL_INFO_PORTRAIT_X,
						  CVMYSTOCK_DETAIL_INFO_PORTRAIT_Y, 
						  CVMYSTOCK_DETAIL_INFO_PORTRAIT_WIDTH, 
						  CVMYSTOCK_DETAIL_INFO_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVMYSTOCK_DETAIL_INFO_LANDSCAPE_X,
						  CVMYSTOCK_DETAIL_INFO_LANDSCAPE_Y, 
						  CVMYSTOCK_DETAIL_INFO_LANDSCAPE_WIDTH, 
						  CVMYSTOCK_DETAIL_INFO_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

/*
 * It returns the origin point and size of segment control for stock chart
 *
 * @param:	orientation - the device orientation
 * @return:	the frame of segment control
 */
- (CGRect)segmentControlFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVMYSTOCK_SEGMENT_CONTROL_PORTRAIT_X,
						  CVMYSTOCK_SEGMENT_CONTROL_PORTRAIT_Y, 
						  CVMYSTOCK_SEGMENT_CONTROL_PORTRAIT_WIDTH, 
						  CVMYSTOCK_SEGMENT_CONTROL_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVMYSTOCK_SEGMENT_CONTROL_LANDSCAPE_X,
						  CVMYSTOCK_SEGMENT_CONTROL_LANDSCAPE_Y, 
						  CVMYSTOCK_SEGMENT_CONTROL_LANDSCAPE_WIDTH, 
						  CVMYSTOCK_SEGMENT_CONTROL_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

/*
 * It returns the origin point and size of activityindicator
 *
 * @param:	orientation - the device orientation
 * @return:	the frame of segment control
 */
- (CGRect)detailIndicatorFrame:(UIInterfaceOrientation)orientation{
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVMYSTOCK_DETAIL_INDICATOR_PORTRAIT_X,
						  CVMYSTOCK_DETAIL_INDICATOR_PORTRAIT_Y, 
						  _detailIndicator.frame.size.width,
						  _detailIndicator.frame.size.height);
	} else {
		rect = CGRectMake(CVMYSTOCK_DETAIL_INDICATOR_LANDSCAPE_X,
						  CVMYSTOCK_DETAIL_INDICATOR_LANDSCAPE_Y, 
						  _detailIndicator.frame.size.width,
						  _detailIndicator.frame.size.height);
	}
	
	return rect;
}

/*
 * It loads the data of current stock/fund/bond.
 *
 * @param:	obj - NSDictionary-typed object consists of leftAxis and rightAxis
 * @return:	none
 */
- (void)loadData:(NSDictionary *)obj {
	ifLoaded = NO;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	_randomKey = arc4random();
	u_int32_t currentKey = _randomKey;
	
	NSString *code;
	NSString *name;
	NSNumber *numIsEquity;
	BOOL isEquity;
	
	// retrieve code from the dictionary
	code = [obj objectForKey:@"code"];
	NSString *symbol = @"￥";
	if(code)
	{
		if([code intValue]!=0)
		{
			int iHead = [code intValue]/100000;
			if(iHead==2)
			{
				symbol = @"HK$";
			}
			else if (iHead==9){
				symbol = @"$";
			}
			else
				symbol = @"￥";
		}
	}
	NSMutableDictionary *symbolDict = [[NSMutableDictionary alloc] init];
	[symbolDict setObject:symbol forKey:@"symbol"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMoneySymbol" object:nil userInfo:symbolDict];
	[symbolDict release];
	name = [obj objectForKey:@"name"];
	numIsEquity = [obj objectForKey:@"isEquity"];
	isEquity = [numIsEquity boolValue];
	if (!_dictCurrentElement){
		self._dictCurrentElement = obj;
	} else {
		if (NO == [[_dictCurrentElement objectForKey:@"code"] isEqualToString:code] || isEquity != [[_dictCurrentElement objectForKey:@"isEquity"] boolValue]) {
			self._dictCurrentElement = obj;
		}
	} 
	
	if (NO == [self isMyFavorite:obj]) {
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"detail_add_button.png" ofType:nil];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[_buttonAdd setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
		pathx = [[NSBundle mainBundle] pathForResource:@"detail_show_button.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[_buttonShow setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
	} else {
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"detail_add_normal_button.png" ofType:nil];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[_buttonAdd setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
		pathx = [[NSBundle mainBundle] pathForResource:@"detail_show_normal_button.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[_buttonShow setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
	}
	
	if (nil != code) {		
		if (isEquity) {
			buttonNews.hidden = NO;
			buttonBalanceSheet.hidden = NO;
			buttonIncomeStatement.hidden = NO;
			buttonCashFlow.hidden = NO;
			buttonInfo.hidden = NO;
			// FIXME
			// it gets the equity detai of yesterday, because some informatino, e.g. P/E and Chinese localization,
			// are avaiable in this kind of data. It is better to get intraday data consisting of them.
			if (currentKey != _randomKey) {
				[pool release];
				
				ifLoaded = YES;
				return;
			}
			NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
			[dict setValue:obj forKey:@"data"];
			[dict setValue:[NSNumber numberWithBool:NO] forKey:@"isIntraday"];
			[self performSelector:@selector(loadEquityDetail:) withObject:dict];
			
			if (currentKey != _randomKey) {
				[pool release];
				
				ifLoaded = YES;
				return;
			}
			// it gets the latest equity detail
			dict = [[[NSMutableDictionary alloc] init] autorelease];
			[dict setValue:obj forKey:@"data"];
			[dict setValue:[NSNumber numberWithBool:YES] forKey:@"isIntraday"];
			[self performSelector:@selector(loadEquityDetail:) withObject:dict];
		} else {
			buttonNews.hidden = YES;
			buttonBalanceSheet.hidden = YES;
			buttonIncomeStatement.hidden = YES;
			buttonCashFlow.hidden = YES;
			buttonInfo.hidden = NO;
			
			// FIXME
			// it gets the index detai of yesterday, because some informatino, e.g. Chinese localization,
			// are avaiable in this kind of data.
			// It is better to get intraday data consisting of them.
			if (currentKey != _randomKey) {
				[pool release];
				
				ifLoaded = YES;
				return;
			}
			NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
			[dict setValue:obj forKey:@"data"];
			[dict setValue:[NSNumber numberWithBool:NO] forKey:@"isIntraday"];
			[self performSelector:@selector(loadCompositeIndexDetail:) withObject:dict];
			
			if (currentKey != _randomKey) {
				[pool release];
				
				ifLoaded = YES;
				return;
			}
			// it gets the latest index detail
			dict = [[[NSMutableDictionary alloc] init] autorelease];
			[dict setValue:obj forKey:@"data"];
			[dict setValue:[NSNumber numberWithBool:YES] forKey:@"isIntraday"];
			[self performSelector:@selector(loadCompositeIndexDetail:) withObject:dict];
		}
		if (currentKey != _randomKey) {
			[pool release];
			return;
		}
		[_stockChartView defineSymbolName:code timeFrame:StockDataIntraDay];
		[self performSelectorOnMainThread:@selector(startIntradayChart:) withObject:obj waitUntilDone:NO];
		
		
		ifLoaded = YES;
	}
	
	if (currentKey != _randomKey) {
		[pool release];
		
		ifLoaded = YES;
		return;
	}
	[self performSelectorOnMainThread:@selector(startIntradayDetail:) withObject:obj waitUntilDone:NO];
	[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];
	[pool release];
}

-(void)afterLoadData{
	[_detailIndicator stopAnimating];
}

- (void)loadCompositeIndexDetail:(NSMutableDictionary *)dict{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	u_int32_t currentKey = _randomKey;
	
	NSDictionary *dictionary = [dict objectForKey:@"data"];
	BOOL isIntraday = [[dict objectForKey:@"isIntraday"] boolValue];
	
	NSString *code = nil;
	NSString *name = nil;
	NSNumber *numIsEquity;
	BOOL isEquity;
	
	code = [dictionary objectForKey:@"code"];
	name = [dictionary objectForKey:@"name"];
	numIsEquity = [dictionary objectForKey:@"isEquity"];
	isEquity = [numIsEquity boolValue];
	
	if (code || NO == isEquity) {
		CVDataProvider *dp;
		CVParamInfo *paramInfo;
		
		NSArray *dataArray;
		NSDictionary *dict, *titleDict, *valueDict;
	
		_detailInfoController.view.hidden = YES;
		_indexDetailInfoController.view.hidden = NO;
	
		dp = [CVDataProvider sharedInstance];
		paramInfo = [[CVParamInfo alloc] init];
		paramInfo.minutes = 5;
		paramInfo.parameters = code;
		
		titleDict = nil;
		dataArray = nil;
		valueDict = nil;
		
		if (isIntraday) {
			dict = [dp GetMyStockDetail:CVDataProviderMyStockDetailTypeMinuteMultipleComposite withParams:paramInfo];
			
			if (currentKey != _randomKey) {
				[pool release];
				return;
			}
			
			_indexDetailInfoController.intrayDict = dict;
			//[_indexDetailInfoController performSelectorOnMainThread:@selector(getIntrayData:) withObject:dict waitUntilDone:NO];
			
			// what a mess ...
		} else {
			dict = [dp GetIndexLatestPrice:paramInfo];
			
			if (currentKey != _randomKey) {
				[pool release];
				return;
			}
			
			_indexDetailInfoController.nonIntrayDict = dict;
			//[_indexDetailInfoController performSelectorOnMainThread:@selector(getNonIntrayData:) withObject:dict waitUntilDone:NO];
			if (dict) {
				_labelCode.text = name;
				_labelTitle.text = nil;
				_labelClass.text = nil;
			}
		}
		[paramInfo release];
	}
	[pool release];
}

- (void)loadEquityDetail:(NSMutableDictionary *)compDict{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	u_int32_t currentKey = _randomKey;
	
	NSMutableDictionary *ditionary = [compDict objectForKey:@"data"];
	BOOL isIntraday = [[compDict objectForKey:@"isIntraday"] boolValue];
	NSString *code;
	NSString *name;
	NSNumber *numIsEquity;
	BOOL isEquity;
	code = [ditionary objectForKey:@"code"];
	name = [ditionary objectForKey:@"name"];
	numIsEquity = [ditionary objectForKey:@"isEquity"];
	isEquity = [numIsEquity boolValue];
	
	if (code && YES == isEquity) {
		CVDataProvider *dp;
		CVParamInfo *paramInfo;
		NSDictionary *dict;
	
		_detailInfoController.view.hidden = NO;
		_indexDetailInfoController.view.hidden = YES;
		dp = [CVDataProvider sharedInstance];
		paramInfo = [[[CVParamInfo alloc] init] autorelease];
		NSMutableString *param = [[[NSMutableString alloc] init] autorelease];
		[param appendFormat:code];
		paramInfo.minutes = 5;
		paramInfo.parameters =param;
		
		if (isIntraday) {
			dict = [dp GetMyStockDetail:CVDataProviderMyStockDetailTypeMinuteMultipleStock withParams:paramInfo];
		} else {
			dict = [dp GetMyStockDetail:CVDataProviderMyStockDetailTypeStock withParams:paramInfo];
		}
		
		if (currentKey != _randomKey) {
			[pool release];
			return;
		}
		
		//load title non-intraday
		if (!isIntraday) {
			NSMutableArray *detailList = [dict valueForKey:@"data"];
			if ([detailList count] > 0) {
				NSDictionary *tempDict = [detailList objectAtIndex:0];
				NSString *strTemp;
				strTemp = [tempDict valueForKey:@"GPDM"];
				if (strTemp){
					_labelCode.text = strTemp;
				}else {
					_labelCode.text = @"--";
				}
				
				
				strTemp = [tempDict valueForKey:@"GPJC"];
				if (strTemp){
					_labelTitle.text = strTemp;
				} else {
					_labelTitle.text = @"--";
				}
				NSString *industryCode = [tempDict valueForKey:@"CODE"];
				if (industryCode){
					[self getClassName:industryCode];
				}
			}
		}
		
		//load data  intraday and non-intraday
		NSMutableArray *detailList = [dict valueForKey:@"data"];
		if ([detailList count] > 0){
			dict = [detailList objectAtIndex:0];
			NSMutableDictionary *mutalDict = [[[NSMutableDictionary alloc] init] autorelease];
			[mutalDict setObject:dict forKey:@"dict"];
			[mutalDict setObject:[NSNumber numberWithBool:isIntraday] forKey:@"isIntraday"];
			[_detailInfoController setData:mutalDict];
			//[_detailInfoController performSelectorOnMainThread:@selector(getData:) withObject:mutalDict waitUntilDone:NO];
		}
	}
	
	[pool release];
}

- (void)getClassName:(NSString *)CODE{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *strClassCode = [CODE substringWithRange:NSMakeRange(0, 2)];
	NSInteger classCode = [strClassCode integerValue];
	switch (classCode) {
		case 10:
			_labelClass.text = [langSetting localizedString:@"Energy"];
			break;
		case 15:
			_labelClass.text = [langSetting localizedString:@"Materials"];
			break;
		case 20:
			_labelClass.text = [langSetting localizedString:@"Industrials"];
			break;
		case 25:
			_labelClass.text = [langSetting localizedString:@"Discretionary"];
			break;
		case 30:
			_labelClass.text = [langSetting localizedString:@"Staples"];
			break;
		case 35:
			_labelClass.text = [langSetting localizedString:@"Health Care"];
			break;
		case 40:
			_labelClass.text = [langSetting localizedString:@"Financial"];
			break;
		case 45:
			_labelClass.text = [langSetting localizedString:@"IT"];
			break;
		case 50:
			_labelClass.text = [langSetting localizedString:@"Telecom"];
			break;
		case 55:
			_labelClass.text = [langSetting localizedString:@"Utilities"];
			break;
		default:
			break;
	}
}


/*
 * It checks whether the current equity/fund/bonds
 * 
 * @param:	dictionary with code, name and isEquity
 * @return: YES, if it is already in the favorite list; else NO
 */
- (BOOL)isMyFavorite:(NSDictionary *)description{
	BOOL isMyFavorite = NO;
	NSString *code;
	NSNumber *numIsEquity;
	BOOL isEquity;
	
	code = [description objectForKey:@"code"];
	numIsEquity = [description objectForKey:@"isEquity"];
	isEquity = [numIsEquity boolValue];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:@"mystock.plist"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:filename]) {
		filename = [[NSBundle mainBundle] pathForResource:@"mystock" ofType:@"plist"];
	}
	
	NSDictionary *favoriteDict;
	NSArray *equityArray;
	NSDictionary *favoriteEquity;
	
	favoriteDict = [[NSDictionary alloc] initWithContentsOfFile:filename];
	equityArray = [favoriteDict objectForKey:@"EquityList"];
	for (favoriteEquity in equityArray){
		NSString *c;
		NSNumber *i;
		
		c = [favoriteEquity objectForKey:@"code"];
		i = [favoriteEquity objectForKey:@"isEquity"];
		if ([code isEqualToString:c] && isEquity == [i boolValue]) {
			isMyFavorite = YES;
			break;
		}
	}
	[favoriteDict release];
	return isMyFavorite;
}

/*
 * It adds the current equity/fund/bond to the favorite list
 *
 * @param:	dictionary with code, name and isEqutiy to be saved locally
 * @return:	none
 */
- (void)addMyFavorite:(NSDictionary *)description {
	[_myStockNavigatorController addNewFavoerite:description];
	/*
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:@"mystock.plist"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:filename]) {
		filename = [[NSBundle mainBundle] pathForResource:@"mystock" ofType:@"plist"];
	}
	NSMutableDictionary *favoriteDict;
	NSMutableArray *favoriteEquityArray;
	
	favoriteDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
	favoriteEquityArray = [[NSMutableArray alloc] initWithCapacity:1];
	[favoriteEquityArray addObjectsFromArray:[favoriteDict objectForKey:@"EquityList"]];
	[favoriteEquityArray addObject:description];
	
	// sort favoriteEuqityArray
	// spilit the array into two arrays: index and equity
	NSDictionary *equityDict;
	NSMutableArray *indexArray, *equityArray;
	BOOL isEquity;
	
	indexArray = [[NSMutableArray alloc] initWithCapacity:1];
	equityArray = [[NSMutableArray alloc] initWithCapacity:1];
	
	for (equityDict in favoriteEquityArray) {
		isEquity = [[equityDict objectForKey:@"isEquity"] boolValue];
		if (isEquity) {
			[equityArray addObject:equityDict];
		} else {
			[indexArray addObject:equityDict];
		}
	}
	
	// sort arrays
	NSSortDescriptor *sortDescByCode;
	NSSortDescriptor *sortDescByName;
	
	sortDescByCode = [[NSSortDescriptor alloc] initWithKey:@"code" ascending:YES];
	sortDescByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[indexArray sortUsingDescriptors:[NSMutableArray arrayWithObject:sortDescByName]];
	[equityArray sortUsingDescriptors:[NSMutableArray arrayWithObject:sortDescByCode]];
	[sortDescByCode release];
	[sortDescByName release];
	
	[favoriteEquityArray removeAllObjects];
	[favoriteEquityArray addObjectsFromArray:indexArray];
	[favoriteEquityArray addObjectsFromArray:equityArray];
	[indexArray release];
	[equityArray release];
	
	[favoriteDict setObject:favoriteEquityArray forKey:@"EquityList"];
	[favoriteDict writeToFile:filename atomically:YES];
	 */
}

/*
 * It reads the data of intraday every a time span
 */
- (void)updateIntradayChart:(NSTimer *)timer {
	NSDictionary *userInfo;
	NSString *code;
	NSNumber *numIsEquity;
	
	userInfo = [timer userInfo];
	code = [userInfo objectForKey:@"code"];
	numIsEquity = [userInfo objectForKey:@"isEquity"];
	
	NSLog(@"Timer interval:%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"refresh"]);
	
	[_stockChartView defineSymbolName:code timeFrame:StockDataIntraDay];
}

/*
 * It starts the updating of intraday
 */
- (void)startIntradayChart:(NSDictionary *)userInfo {
    NSTimer *timer;
	
	if (_intradayChartTimer && [_intradayChartTimer isValid]) {
		[_intradayChartTimer invalidate];
	}
	timer = [NSTimer scheduledTimerWithTimeInterval:60*[[NSUserDefaults standardUserDefaults] integerForKey:@"refresh"]
											 target:self selector:@selector(updateIntradayChart:)
										   userInfo:userInfo repeats:YES];
    self._intradayChartTimer = timer;
}

/*
 * It stops the updating of intraday
 */
- (void)stopIntradayChart {
	[_intradayChartTimer invalidate];
	self._intradayChartTimer = nil;
}

- (void)updateIntradayDetail:(NSTimer *)timer {
	NSDictionary *userInfo;
	NSString *code;
	NSNumber *numIsEquity;
	
	userInfo = [timer userInfo];
	code = [userInfo objectForKey:@"code"];
	numIsEquity = [userInfo objectForKey:@"isEquity"];
	if (YES == [numIsEquity boolValue]) {
		NSMutableDictionary *compDict = [[NSMutableDictionary alloc] init];
		[compDict setObject:userInfo forKey:@"data"];
		[compDict setObject:[NSNumber numberWithBool:YES] forKey:@"isIntraday"];
		[NSThread detachNewThreadSelector:@selector(loadEquityDetail:) toTarget:self withObject:compDict];
		[compDict release];
	} else {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setValue:userInfo forKey:@"data"];
		[dict setValue:[NSNumber numberWithBool:YES] forKey:@"isIntraday"];
		[NSThread detachNewThreadSelector:@selector(loadCompositeIndexDetail:) toTarget:self withObject:dict];
		[dict release];
	}
	
	// FIXME
	// it is weird to put navigation methods here, for it doesn't follow the principle of software
	// modeling. However, the updating requires to be synchronized between navigation and detail.
	[NSThread detachNewThreadSelector:@selector(loadStockList) toTarget:_myStockNavigatorController withObject:nil];
}

- (void)startIntradayDetail:(NSDictionary *)userInfo {
	NSTimer *timer;
	
	if (_intradayDetailTimer && [_intradayDetailTimer isValid]) {
		[_intradayDetailTimer invalidate];
	}
	timer = [NSTimer scheduledTimerWithTimeInterval:60*[[NSUserDefaults standardUserDefaults] integerForKey:@"refresh"]
											 target:self selector:@selector(updateIntradayDetail:)
										   userInfo:userInfo repeats:YES];
    self._intradayDetailTimer = timer;
}

- (void)stopIntradayDetail {
	[_intradayDetailTimer invalidate];
	self._intradayDetailTimer = nil;
}

- (BOOL)shouldBuyService {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	BOOL shouldBuyLevel1, shouldBuyLevel2;
	static NSString *level1Title = @"Level1";
	static NSString *level2Title = @"Level2";
	shouldBuyLevel1 = NO;
	shouldBuyLevel2 = NO;
	
	shouldBuyLevel1 = [MKStoreManager isFeaturePurchased:CVIntradayServiceLevel1Id];
	shouldBuyLevel2 = [MKStoreManager isFeaturePurchased:CVIntradayServiceLevel2Id];
	if (!shouldBuyLevel1 || !shouldBuyLevel2) {
		UIActionSheet *actionSheet;
		
		actionSheet = [[UIActionSheet alloc] initWithTitle:[langSetting localizedString:@"Buy Service:"]
												  delegate:self 
										 cancelButtonTitle:nil
									destructiveButtonTitle:nil 
										 otherButtonTitles:nil];
		
		if (NO == shouldBuyLevel1) {
			[actionSheet addButtonWithTitle:level1Title];
		}
		if (NO == shouldBuyLevel2) {
			[actionSheet addButtonWithTitle:level2Title];
		}
		[actionSheet addButtonWithTitle:[langSetting localizedString:@"Cancel"]];
		
		[actionSheet showInView:self.view];
		[actionSheet release];
	}
	
	return YES;
}

- (void)showDefaultData{
	_labelCode.text = @"--";
	_labelTitle.text = @"--";
	_labelClass.text = @"---";
	
	[_indexDetailInfoController showDefault];
	
	[_detailInfoController showDefault];
	
	[_stockChartView clearData];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSDictionary *objInfo;
	MKStoreManager *manager;
	
	switch (buttonIndex) {
		case 0:
		{
			manager = [MKStoreManager sharedManager];
			objInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"level1", @"service", nil];
			[manager buyFeature:CVIntradayServiceLevel1Id];
			[objInfo release];
			break;
		}
			
		case 1:
		{
			manager = [MKStoreManager sharedManager];
			objInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"level2", @"service", nil];
			[manager buyFeature:CVIntradayServiceLevel2Id];
			[objInfo release];
			break;
		}
			
		case 2:
		{
			[_stockChartView defineSymbolName:[_dictCurrentElement objectForKey:@"code"] timeFrame:StockDataIntraDay];
			[self startIntradayChart:_dictCurrentElement];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark CVPeriodSegmentControlDelegate
- (void)touchSegmentAtIndex:(NSUInteger)index {
	_segmentControl.userInteractionEnabled = NO;
	switch (index) {
		case 0:
		{
#ifdef ENABLE_IN_APP_PURCHASE
			if (NO == [self shouldBuyService]) {
#endif
				[_stockChartView defineSymbolName:[_dictCurrentElement objectForKey:@"code"] timeFrame:StockDataIntraDay];
				[self startIntradayChart:_dictCurrentElement];
#ifdef ENABLE_IN_APP_PURCHASE
			}
#endif
			break;
		}
		case 1:
			_stockChartView.timeFrame = StockDataOneWeek;
			[self stopIntradayChart];
			break;
		case 2:
			_stockChartView.timeFrame = StockDataOneMonth;
			[self stopIntradayChart];
			break;
		case 3:
			_stockChartView.timeFrame = StockDataThreeMonths;
			[self stopIntradayChart];
			break;
		case 4:
			_stockChartView.timeFrame = StockDataOneYear;
			[self stopIntradayChart];
			break;
		case 5:
			_stockChartView.timeFrame = StockDataTwoYears;
			[self stopIntradayChart];
			break;
			
		default:
			break;
	}
}

#pragma mark -
#pragma mark StockChartDataSourceDelegate
- (NSArray *)ChartGetRecordsByName:(NSString *)name Period:(StockDataTimeFrame_e)timeFrame {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	ifChartLoading = YES;
	
	u_int32_t currentKey = _randomKey;
	
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	
	NSDictionary *dict = nil;
	NSDictionary *param;
	NSDate *today;
	NSInteger month, period;
	NSNumber *days;
	
	today = [NSDate date];
	
	month = 22;
	switch (timeFrame) {
		case StockDataIntraDay:
			period = 1;
			break;
		case StockDataOneWeek:
			period = 5;
			break;
		case StockDataOneMonth:
			period = month;
			break;
		case StockDataThreeMonths:
			period = 3 * month;
			break;
		case StockDataOneYear:
			period = 12 * month;
			break;
		case StockDataTwoYears:
			period = 2 * 12 * month;
			break;
			
		default:
			period = 5;
			break;
	}

	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	
	days = [[NSNumber alloc] initWithInteger:period];
	param = [[NSDictionary alloc] initWithObjectsAndKeys:days, @"days", name, @"code", nil];
	[days release];
	
	paramInfo.minutes = 5;
	paramInfo.parameters = param;
	
	
	if (StockDataIntraDay == timeFrame) {
		if ([[_dictCurrentElement objectForKey:@"isEquity"] boolValue]) {
			dict = [dp GetChartData:CVDataProviderChartTypeEquityIntraday withParams:paramInfo];
		} else {
			dict = [dp GetChartData:CVDataProviderChartTypeEquityIndexIntraday withParams:paramInfo];
		}
	} else {
		if ([[_dictCurrentElement objectForKey:@"isEquity"] boolValue]) {
			dict = [dp GetDoubleCacheDataForChart:CVDataProviderChartTypeStock withParams:paramInfo andRefresh:NO];
		} else {
			dict = [dp GetDoubleCacheDataForChart:CVDataProviderChartTypeEquityIndices withParams:paramInfo andRefresh:NO];
		}
	}
	
	[paramInfo release];
	[param release];
	
	if (currentKey != _randomKey) {
		[pool release];
		ifChartLoading = NO;
		return nil;
	}
	
	// convert arrray to recognizable array for chart
	NSMutableArray *newArray;
	NSMutableDictionary *oldDict, *newDict;
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:1];
	[tempArray addObjectsFromArray:[dict objectForKey:@"data"]];
	if (nil != [dict objectForKey:@"data"]) {
		newArray = [[NSMutableArray alloc] initWithCapacity:1];
	} else {
		newArray = nil;
	}

	//  the keys and values of an element of array
	//	CJJE = "348044000.0";
	//	CJL = "35062900.0";
	//	FSRQ = "2010-08-25 00:00:00";
	//	"ROUND(R.KPJ/1000,2)" = "10.06";
	//	"ROUND(R.SPJ/1000,2)" = "9.77";
	//	"ROUND(R.ZDJ/1000,2)" = "9.75";
	//	"ROUND(R.ZGJ/1000,2)" = "10.15";
	
	//add space value for stock that has not enough data
	if (StockDataIntraDay != timeFrame && [tempArray count] > 0) {
		
		NSDictionary *lastDictionary = [[dict objectForKey:@"data"] lastObject];
		NSString *strLastDate = [lastDictionary objectForKey:@"FSRQ"];
		if (!strLastDate)
			strLastDate = [lastDictionary objectForKey:@"time"];
		
		NSTimeZone *zone;
		zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone:zone];
		if ([[_dictCurrentElement objectForKey:@"isEquity"] boolValue]) {
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		} else {
			[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		}

		
		NSDate *lastDate = [dateFormatter dateFromString:strLastDate];
		[dateFormatter release];
		
		NSTimeInterval lastTimeInterval = [lastDate timeIntervalSince1970];//GMT +8
		NSInteger numAdded = period - [[dict objectForKey:@"data"] count];
		
		NSDate *tempDate;
		for (int i = 0; i < numAdded; i++) {
			while (YES) {
				lastTimeInterval -= 24*60*60;
				tempDate = [NSDate dateWithTimeIntervalSince1970:lastTimeInterval];
				NSCalendar *calendar = [NSCalendar currentCalendar];
				NSDateComponents *dComponents = [calendar components:NSWeekdayCalendarUnit fromDate:tempDate];
				int weekday = [dComponents weekday];
				if (weekday != 0 && weekday !=7) {
					break;
				}
			}
			
			NSTimeZone *zone;
			zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setTimeZone:zone];
			if ([[_dictCurrentElement objectForKey:@"isEquity"] boolValue]) {
				[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			} else {
				[dateFormatter setDateFormat:@"yyyy-MM-dd"];
			}
			NSString *strTempDate = [dateFormatter stringFromDate:tempDate];
			[dateFormatter release];
			
			NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
			[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"CJJE"];
			[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"CJL"];
			[tempDic setValue:strTempDate forKey:@"FSRQ"];
			[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"ROUND(R.KPJ/1000,2)"];
			[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"ROUND(R.SPJ/1000,2)"];
			[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"ROUND(R.ZDJ/1000,2)"];
			[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"ROUND(R.ZGJ/1000,2)"];
			[tempArray addObject:tempDic];
			[tempDic release];
		}
		self._stockChartView.nonIntraInvalidNum = numAdded;
		self._stockChartView.intrayInvalidNum = 0;
	}else {
		if (dict != nil && [dict count] > 0) {
			NSDictionary *firstDictionary = [[dict objectForKey:@"data"] objectAtIndex:0];
			NSString *strFirstDate = [firstDictionary objectForKey:@"FSRQ"];
			if (!strFirstDate)
				strFirstDate = [firstDictionary objectForKey:@"time"];
			
			NSTimeZone *zone;
			zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[dateFormatter setTimeZone:zone];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			
			NSDate *firstDate = [dateFormatter dateFromString:strFirstDate];
			
			NSArray *strs = [strFirstDate componentsSeparatedByString:@" "];
			NSString *strTodayDate = strFirstDate;
			if ([strs count] > 0) {
				strTodayDate = [strs objectAtIndex:0];
			}
			
			NSDate *defaultFirstDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 09:30:00",strTodayDate]];
			
			NSTimeInterval firstTimeInterval = [firstDate timeIntervalSince1970];
			NSTimeInterval defaultFirstTimeInterval = [defaultFirstDate timeIntervalSince1970];
			
			NSTimeInterval interval = firstTimeInterval - defaultFirstTimeInterval;
			
			int numAdd = interval/60;
			if (numAdd > 120) {
				numAdd -= 90;
			}
			
			//add reduced number empty data in the head of array
			NSDate *tempDate = defaultFirstDate;
			for (int i = 0; i < numAdd; i++) {
				
				tempDate = [NSDate dateWithTimeIntervalSince1970:firstTimeInterval-(i+1)*60];
				
				NSString *strTempDate = [dateFormatter stringFromDate:tempDate];
				
				NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
				[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"CJJE"];
				[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"CJL"];
				[tempDic setValue:strTempDate forKey:@"FSRQ"];
				[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"ROUND(R.KPJ/1000,2)"];
				[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"ROUND(R.SPJ/1000,2)"];
				[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"ROUND(R.ZDJ/1000,2)"];
				[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"ROUND(R.ZGJ/1000,2)"];
				[tempArray insertObject:tempDic atIndex:0];
				[tempDic release];
			}
			
			self._stockChartView.intrayInvalidNum = numAdd;
			
			//caculate the number of data should be
			//check if the data is not full filled 
			//for some entity is paused in the center of day
			//from 9:30 - last date
			NSDictionary *lastDictionary = [[dict objectForKey:@"data"] lastObject];
			NSString *strLastDate = [lastDictionary objectForKey:@"FSRQ"];
			if (!strLastDate)
				strLastDate = [lastDictionary objectForKey:@"time"];
			NSDate *lastDate = [dateFormatter dateFromString:strLastDate];
			NSTimeInterval lastInterval = [lastDate timeIntervalSince1970];
			//from 9:30 to current time
			NSTimeInterval totalInterval = lastInterval - defaultFirstTimeInterval;
			int totalNum = totalInterval / 60;
			//if last time is between 11:30-13:00
			if (totalNum > 120 && totalNum < 210) {
				totalNum = 120;
			}
			//if last time is bigger than 13:00
			if (totalNum > 210) {
				totalNum -= 90;
			}
			
			//if the data is not full filled then insert empty data in the specify position
			NSDate *centerLeftDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 11:30:00",strTodayDate]];
			NSDate *centerRightDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 13:00:00",strTodayDate]];
			
			int count = [tempArray count];
			NSDictionary *previousDic = nil;
			NSDate *previousDate = nil;
			NSDate *currentDate = nil;
			NSString *strPreviousDate = nil;
			
			if (totalNum - count > 0) {
				int numNeedInsert = totalNum - count;
				int hasInserted = 0;
				NSDictionary *currentDic = nil;
				
				for (int i = 0; i < totalNum; i++) {
					currentDic = [tempArray objectAtIndex:i];
					NSString *strCurrentDate = [currentDic objectForKey:@"FSRQ"];
					if (!strCurrentDate)
						strCurrentDate = [currentDic objectForKey:@"time"];
					currentDate = [dateFormatter dateFromString:strCurrentDate];
					
					if (previousDic != nil) {
						strPreviousDate = [previousDic objectForKey:@"FSRQ"];
						if (!strPreviousDate)
							strPreviousDate = [previousDic objectForKey:@"time"];
						previousDate = [dateFormatter dateFromString:strPreviousDate];
						
						int interval = [currentDate timeIntervalSince1970] - [previousDate timeIntervalSince1970];
						int numAddThis = interval/60 -1;
						//if the dates are between 11:30 and 13:00
						if (numAddThis > 0) {
							if ([centerLeftDate timeIntervalSince1970] - [previousDate timeIntervalSince1970] >= 0 &&
								[currentDate timeIntervalSince1970] - [centerRightDate timeIntervalSince1970] >= 0) {
								numAddThis -= 90;
							}
						}
						//add empty data between the two
						for (int j = 0; j < numAddThis; j++) {
							
							tempDate = [NSDate dateWithTimeIntervalSince1970:[currentDate timeIntervalSince1970]-(j+1)*60];
							
							NSString *strTempDate = [dateFormatter stringFromDate:tempDate];
							
							NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
							[tempDic setValue:[previousDic objectForKey:@"CJJE"] forKey:@"CJJE"];
							[tempDic setValue:[NSNumber numberWithFloat:0.0] forKey:@"CJL"];
							[tempDic setValue:strTempDate forKey:@"FSRQ"];
							[tempDic setValue:[previousDic objectForKey:@"CJJE"] forKey:@"ROUND(R.KPJ/1000,2)"];
							[tempDic setValue:[previousDic objectForKey:@"CJJE"] forKey:@"ROUND(R.SPJ/1000,2)"];
							[tempDic setValue:[previousDic objectForKey:@"CJJE"] forKey:@"ROUND(R.ZDJ/1000,2)"];
							[tempDic setValue:[previousDic objectForKey:@"CJJE"] forKey:@"ROUND(R.ZGJ/1000,2)"];
							[tempArray insertObject:tempDic atIndex:i];
							[tempDic release];
						}
						//auto add i,other wise the array will out of bound
						i += numAddThis;
						hasInserted += numAddThis;
						if (hasInserted == numNeedInsert) {
							break;
						}
					}
					
					previousDic = currentDic;
				}
			}
		}
		self._stockChartView.nonIntraInvalidNum = 0;
	}

	
	for (oldDict in tempArray) {
		NSNumber *numberValue;
		NSDate *dateValue;
		NSString *strValue;
		double doubleValue;
		
		newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
		// intraday?
		if (StockDataIntraDay == timeFrame) {
			[newDict setObject:[NSNumber numberWithBool:YES] forKey:@"isIntraday"];
		} else {
			[newDict setObject:[NSNumber numberWithBool:NO] forKey:@"isIntraday"];
		}
		// date
		strValue = [oldDict objectForKey:@"FSRQ"];
		if (!strValue)
			strValue = [oldDict objectForKey:@"time"];
		if (strValue != nil) {
			NSTimeZone *zone;
			NSDateFormatter *formatter;
			
			zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
			formatter = [[NSDateFormatter alloc] init];
			if ([[_dictCurrentElement objectForKey:@"isEquity"] boolValue]) {
				if (StockDataIntraDay != timeFrame) {
					[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				} else {
					[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				}
			} else {
				if (StockDataIntraDay != timeFrame) {
					[formatter setDateFormat:@"yyyy-MM-dd"];
				} else {
					[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				}
			}
			
			[formatter setTimeZone:zone];
			dateValue = [formatter dateFromString:strValue];
			[formatter release];
			if (dateValue) {
				[newDict setObject:dateValue forKey:@"date"];
			} else {
				[newDict setObject:@"" forKey:@"date"];
			}

		}
		// open
		strValue = [oldDict objectForKey:@"ROUND(R.KPJ/1000,2)"];
		if (strValue != nil) {
			doubleValue = [strValue doubleValue];
			numberValue = [NSNumber numberWithDouble:doubleValue];
			[newDict setObject:numberValue forKey:@"open"];
		}
		// high
		strValue = [oldDict objectForKey:@"ROUND(R.ZGJ/1000,2)"];
		if (strValue != nil) {
			doubleValue = [strValue doubleValue];
			numberValue = [NSNumber numberWithDouble:doubleValue];
			[newDict setObject:numberValue forKey:@"high"];
		}
		// low
		strValue = [oldDict objectForKey:@"ROUND(R.ZDJ/1000,2)"];
		if (strValue != nil) {
			doubleValue = [strValue doubleValue];
			numberValue = [NSNumber numberWithDouble:doubleValue];
			[newDict setObject:numberValue forKey:@"low"];
		}
		// close
		strValue = [oldDict objectForKey:@"ROUND(R.SPJ/1000,2)"];
		if (strValue != nil) {
			doubleValue = [strValue doubleValue];
			numberValue = [NSNumber numberWithDouble:doubleValue];
			[newDict setObject:numberValue forKey:@"close"];
		}
		// volume
		strValue = [oldDict objectForKey:@"CJL"];
		if (strValue != nil) {
			doubleValue = [strValue doubleValue];
			if([[_dictCurrentElement objectForKey:@"isEquity"] boolValue] && StockDataIntraDay != timeFrame){
				//divide 100 for volumn
				doubleValue = doubleValue/100;
			}
			numberValue = [NSNumber numberWithDouble:doubleValue];
			[newDict setObject:numberValue forKey:@"volume"];
		}
		
		[newArray addObject:newDict];
		[newDict release];
	}
	
	
	[tempArray release];
	
	self._stockDataArray = newArray;
	
	[newArray release];
	
	if (currentKey != _randomKey) {
		[pool release];
		ifChartLoading = NO;
		return nil;
	}
	//update navigator and detail info panel while get latest intro day data
	if (StockDataIntraDay == timeFrame) {
		BOOL isEquity = [[_dictCurrentElement objectForKey:@"isEquity"] boolValue];
		if ([self._stockDataArray count] > 0) {
			NSDictionary *dicc = [self._stockDataArray lastObject];
			[self syncIntroDayFromChart:dicc andCode:name];
		} else {
			if (isEquity) {
				[_detailInfoController performSelectorOnMainThread:@selector(showWhileNoIntradayChart) withObject:nil waitUntilDone:NO];
			} else {
				[_indexDetailInfoController performSelectorOnMainThread:@selector(showWhileNoIntradayChart) withObject:nil waitUntilDone:NO];
			}
			[self syncWhileNoIntroDayChartWithCode:name];
		}
		if (isEquity) {
			[_detailInfoController performSelectorOnMainThread:@selector(showData) withObject:nil waitUntilDone:NO];
		} else {
			[_indexDetailInfoController performSelectorOnMainThread:@selector(showData) withObject:nil waitUntilDone:NO];
		}
		
	}
	[pool release];
	ifChartLoading = NO;
	return _stockDataArray;
}


- (IBAction)clickAddButton:(id)sender {
	if (_dictCurrentElement) {
		BOOL isMyFavorite = NO;
		
		isMyFavorite = [self isMyFavorite:_dictCurrentElement];
		if (NO == isMyFavorite) {
			NSString *pathx = [[NSBundle mainBundle] pathForResource:@"detail_add_normal_button.png" ofType:nil];
			UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
			[_buttonAdd setBackgroundImage:image forState:UIControlStateNormal];
			[image release];
			pathx = [[NSBundle mainBundle] pathForResource:@"detail_show_normal_button.png" ofType:nil];
			image = [[UIImage alloc] initWithContentsOfFile:pathx];
			[_buttonShow setBackgroundImage:image forState:UIControlStateNormal];
			[image release];
			
			// 
			NSMutableDictionary *favDict;
			NSNumber *numIsEquity;
			favDict = [[NSMutableDictionary alloc] initWithDictionary:_dictCurrentElement];
			numIsEquity = [_dictCurrentElement objectForKey:@"isEquity"];
			if (YES == [numIsEquity boolValue]) {
				if (_detailInfoController._labelLatest.text) {
					[favDict setObject:_detailInfoController._labelLatest.text forKey:@"close"];
				}
				if (_detailInfoController._labelChange.text) {
					[favDict setObject:_detailInfoController._labelChange.text forKey:@"change"];
				}
				
				if (_detailInfoController._labelChangePercent.text) {
					NSArray *ary = [_detailInfoController._labelChangePercent.text componentsSeparatedByString:@"%"];
					if (ary && [ary count] > 0) {
						[favDict setObject:[ary objectAtIndex:0] forKey:@"change%"];
					}
				}
			} else {
				if (_indexDetailInfoController.latestValue.text) {
					[favDict setObject:[_indexDetailInfoController.latestValue.text deFormartNumber] forKey:@"close"];
				}
				if (_indexDetailInfoController.changeValue.text) {
					[favDict setObject:_indexDetailInfoController.changeValue.text forKey:@"change"];
				}
				if (_indexDetailInfoController.changeRatioValue.text) {
					NSArray *ary = [_indexDetailInfoController.changeRatioValue.text componentsSeparatedByString:@"%"];
					if (ary && [ary count] > 0) {
						[favDict setObject:[ary objectAtIndex:0] forKey:@"change%"];
					}
				}
			}
			[self addMyFavorite:favDict];
			[favDict release];
			
			//[NSThread detachNewThreadSelector:@selector(loadStockList) toTarget:_myStockNavigatorController withObject:nil];
		}
	}
}

-(void)clickRefreshButton{
	if (_dictCurrentElement && ifLoaded && !ifChartLoading) {
		
		ifLoaded = NO;
		
		_detailIndicator.hidden = NO;
		[_detailIndicator startAnimating];
		
		[self stopIntradayChart];
		_segmentControl.userInteractionEnabled = NO;
		_segmentControl.index = 0;
		
		[self showDefaultData];
		
		[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:_dictCurrentElement];
		[self dismissRotationView];
		[self setButtonImage];
		
//		NSString *code = [_dictCurrentElement objectForKey:@"code"];
//		NSNumber *nIsEquity = [_dictCurrentElement objectForKey:@"isEquity"];
//		BOOL isEquity = [nIsEquity boolValue];
//		if (isEquity) {
//			[NSThread detachNewThreadSelector:@selector(updateStock:) toTarget:_myStockNavigatorController withObject:code];
//		} else {
//			[NSThread detachNewThreadSelector:@selector(updateIndex:) toTarget:_myStockNavigatorController withObject:code];
//		}
	}
}

/*
 * It will happen while getting realtime chart data back
 */
-(void)syncIntroDayFromChart:(NSDictionary *)dict andCode:(NSString *)name{
	NSString *code = name;
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [langSetting localizedString:@"LangCode"];
	
	NSMutableDictionary *mudicc;
	NSMutableDictionary *postDict;
	if ([[_dictCurrentElement objectForKey:@"isEquity"] boolValue]) {
		
		mudicc = [[NSMutableDictionary alloc] init];
		
		NSString *strTemp;
		double doubleTemp;
		double priorCloseValue;
		double closeValue;
		NSString *strClose;
		NSString *strChange;
		NSString *strChangePercent;
		
		//priorCloseValue
		strTemp = [_detailInfoController getPriorCloseValue];
		priorCloseValue = [[strTemp deFormartNumber] doubleValue];
		
		//time
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		NSDate *date = [dict objectForKey:@"date"];
		NSString *strTime = [formatter stringFromDate:date];
		[formatter release];
		
		_detailInfoController.lblRealTime.text = strTime;
		
		//close
		closeValue = [[dict objectForKey:@"close"] floatValue];
		strClose = [NSString stringWithFormat:@"%.2f",closeValue];
		_detailInfoController._labelLatest.text = strClose;
		
		UIColor *posColor = [langSetting getColor:@"GainersRate"];
		UIColor *negColor = [langSetting getColor:@"LosersRate"];
		
		//zd
		doubleTemp = closeValue - priorCloseValue;
		strChange = [NSString stringWithFormat:@"%.2lf",doubleTemp];
		_detailInfoController._labelChange.text = [NSString stringWithFormat:@"%.2lf",doubleTemp];
		
		//zdf
		doubleTemp = (closeValue - priorCloseValue)/priorCloseValue;
		strChangePercent = [NSString stringWithFormat:@"%.2lf",doubleTemp*100];
		_detailInfoController._labelChangePercent.text = [NSString stringWithFormat:@"%.2lf%%",doubleTemp*100];
		
		if (closeValue - priorCloseValue>0) {
			_detailInfoController._labelChange.textColor = posColor;
			_detailInfoController._labelChangePercent.textColor = posColor;
		}
		else if (closeValue - priorCloseValue < 0){
			_detailInfoController._labelChange.textColor = negColor;
			_detailInfoController._labelChangePercent.textColor = negColor;
		}
		else {
			_detailInfoController._labelChange.textColor = [UIColor grayColor];
			_detailInfoController._labelChangePercent.textColor = [UIColor grayColor];
		}
		
		
		//post notification to sync intra day stock
		
		postDict = [[[NSMutableDictionary alloc] init] autorelease];
		
		[postDict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
		[postDict setObject:code forKey:@"code"];
		[postDict setObject:strClose forKey:@"close"];
		[postDict setObject:strChange forKey:@"change"];
		[postDict setObject:strChangePercent forKey:@"change%"];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateStock object:postDict userInfo:nil];
		[mudicc release];
	} else {
		mudicc = [[NSMutableDictionary alloc] init];
		
		NSString *strTemp;
		double doubleTemp;
		double priorCloseValue;
		double closeValue;
		NSString *strClose;
		NSString *strChange;
		NSString *strChangePercent;
		
		//priorCloseValue
		strTemp = [_indexDetailInfoController getPriorCloseValue];
		priorCloseValue = [[strTemp deFormartNumber] doubleValue];
		
		//time
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		NSDate *date = [dict objectForKey:@"date"];
		NSString *strTime = [formatter stringFromDate:date];
		[formatter release];
		
		_indexDetailInfoController.lblRealTime.text = strTime;
		
		//close
		closeValue = [[dict objectForKey:@"close"] floatValue];
		strClose = [NSString stringWithFormat:@"%.0f",closeValue];
		
		NSString *showStrClose = [NSString stringWithFormat:@"%.0lf",closeValue];
		if ([_langCode isEqualToString:@"en"]) {
			showStrClose = [showStrClose formatToEnNumber];
		}
		_indexDetailInfoController.latestValue.text = showStrClose;
		
		UIColor *posColor = [langSetting getColor:@"GainersRate"];
		UIColor *negColor = [langSetting getColor:@"LosersRate"];
		
		//zd
		doubleTemp = closeValue - priorCloseValue;
		strChange = [NSString stringWithFormat:@"%.2lf",doubleTemp];
		_indexDetailInfoController.changeValue.text = strChange;
		
		//zdf
		doubleTemp = (closeValue - priorCloseValue)/priorCloseValue;
		strChangePercent = [NSString stringWithFormat:@"%.2lf",doubleTemp*100];
		_indexDetailInfoController.changeRatioValue.text = [NSString stringWithFormat:@"%.2lf%%",doubleTemp*100];
		
		if (closeValue - priorCloseValue>0) {
			_indexDetailInfoController.changeValue.textColor = posColor;
			_indexDetailInfoController.changeRatioValue.textColor = posColor;
		}
		else if (closeValue - priorCloseValue < 0){
			_indexDetailInfoController.changeValue.textColor = negColor;
			_indexDetailInfoController.changeRatioValue.textColor = negColor;
		}
		else {
			_indexDetailInfoController.changeValue.textColor = [UIColor grayColor];
			_indexDetailInfoController.changeRatioValue.textColor = [UIColor grayColor];
		}
		
		//post notification to sync intra day stock
		
		postDict = [[[NSMutableDictionary alloc] init] autorelease];
		
		[postDict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
		[postDict setObject:code forKey:@"code"];
		[postDict setObject:[NSString stringWithFormat:@"%.2f",closeValue] forKey:@"close"];
		[postDict setObject:strChange forKey:@"change"];
		[postDict setObject:strChangePercent forKey:@"change%"];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateIndex object:postDict userInfo:nil];
		[mudicc release];
	}
}

/*
 * It will be called while no realtime chart data back
 */
-(void)syncWhileNoIntroDayChartWithCode:(NSString *)name{
	NSString *code = name;
	
	NSMutableDictionary *mudicc;
	NSMutableDictionary *postDict;
	if ([[_dictCurrentElement objectForKey:@"isEquity"] boolValue]) {
		
		mudicc = [[NSMutableDictionary alloc] init];
		
		NSString *strTemp;
		double doubleTemp;
		double priorCloseValue;
		double closeValue;
		NSString *strClose;
		NSString *strChange;
		NSString *strChangePercent;
		
		//priorCloseValue
		strTemp = [_detailInfoController getPriorCloseValue];
		priorCloseValue = [[strTemp deFormartNumber] doubleValue];
		
		//close
		closeValue = [[_detailInfoController getLatestValue] floatValue];
		strClose = [NSString stringWithFormat:@"%.2f",closeValue];
		
		//zd
		doubleTemp = closeValue - priorCloseValue;
		strChange = [NSString stringWithFormat:@"%.2lf",doubleTemp];
		
		//zdf
		doubleTemp = (closeValue - priorCloseValue)/priorCloseValue;
		strChangePercent = [NSString stringWithFormat:@"%.2lf",doubleTemp*100];
		
		//post notification to sync intra day stock
		
		postDict = [[[NSMutableDictionary alloc] init] autorelease];
		
		[postDict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
		[postDict setObject:code forKey:@"code"];
		[postDict setObject:strClose forKey:@"close"];
		[postDict setObject:strChange forKey:@"change"];
		[postDict setObject:strChangePercent forKey:@"change%"];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateStock object:postDict userInfo:nil];
		[mudicc release];
	} else {
		mudicc = [[NSMutableDictionary alloc] init];
		
		NSString *strTemp;
		double doubleTemp;
		double priorCloseValue;
		double closeValue;
		NSString *strClose;
		NSString *strChange;
		NSString *strChangePercent;
		
		//priorCloseValue
		strTemp = [_indexDetailInfoController getPriorCloseValue];
		priorCloseValue = [[strTemp deFormartNumber] doubleValue];
		
		//close
		closeValue = [[_indexDetailInfoController getLatestValue] floatValue];
		strClose = [NSString stringWithFormat:@"%.0f",closeValue];
		
		//zd
		doubleTemp = closeValue - priorCloseValue;
		strChange = [NSString stringWithFormat:@"%.2lf",doubleTemp];
		
		//zdf
		doubleTemp = (closeValue - priorCloseValue)/priorCloseValue;
		strChangePercent = [NSString stringWithFormat:@"%.2lf",doubleTemp*100];
		
		//post notification to sync intra day stock
		
		postDict = [[[NSMutableDictionary alloc] init] autorelease];
		
		[postDict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
		[postDict setObject:code forKey:@"code"];
		[postDict setObject:[NSString stringWithFormat:@"%.2f",closeValue] forKey:@"close"];
		[postDict setObject:strChange forKey:@"change"];
		[postDict setObject:strChangePercent forKey:@"change%"];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateIndex object:postDict userInfo:nil];
		[mudicc release];
	}
}

-(void)loadDataFromHome:(NSDictionary *)dict{
	_detailIndicator.hidden = NO;
	[_detailIndicator startAnimating];
	_segmentControl.userInteractionEnabled = NO;
	_segmentControl.index = 0;
	
	[self showDefaultData];
	
	[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:dict];
	[self dismissRotationView];
	[self setButtonImage];
	
//	NSString *code = [dict objectForKey:@"code"];
//	NSNumber *nIsEquity = [dict objectForKey:@"isEquity"];
//	BOOL isEquity = [nIsEquity boolValue];
//	if (isEquity) {
//		[NSThread detachNewThreadSelector:@selector(updateStock:) toTarget:_myStockNavigatorController withObject:code];
//	} else {
//		[NSThread detachNewThreadSelector:@selector(updateIndex:) toTarget:_myStockNavigatorController withObject:code];
//	}
}

-(void)reloadData{
	[self clickRefreshButton];
}

#pragma mark -
#pragma mark CVLoadNewsDelegate method

-(NSMutableArray *)attachNewsAtPage:(NSInteger)pageNumber{
	NSMutableArray *ary = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
	CVDataProvider *dp;
	NSDictionary *dict;
	NSString *code;
	dp = [CVDataProvider sharedInstance];
	NSString *pageCurrent = [NSString stringWithFormat:@"%d",pageNumber];
	NSString *pageCapacity = [NSString stringWithFormat:@"%d",CV_NEWS_PAGECAPACITY];
	
	code = [_dictCurrentElement objectForKey:@"code"];
	if (code) {
		NSMutableString *arg1;
		arg1 = [[NSMutableString alloc] init];
		[arg1 appendFormat:@"\""];
		[arg1 appendString:code];
		[arg1 appendFormat:@"\""];
		NSArray *array = [[NSArray alloc] initWithObjects:arg1,pageCurrent,pageCapacity,nil];
		[arg1 release];
		dict = [dp GetNewsList:CVDataProviderNewsListTypeStock withParams:array forceRefresh:NO];
		[array release];
		NSMutableArray *arrayData = [dict valueForKey:@"data"];
		if (arrayData)
			
			ary = arrayData;

		
	}
	[_newsrelatedView performSelectorOnMainThread:@selector(changeIndicator:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
	return ary;
}

#pragma mark -
- (void)clickNewsButton {
//	if (!stockRelatedNews){
//		stockRelatedNews = [[CVStockRelatedNews alloc] initWithFrame:CGRectMake(43, 71, 938, 626)];
//		stockRelatedNews.opaque = NO;
//		[self.view.superview.superview.superview addSubview:stockRelatedNews];
//		[stockRelatedNews loadData:[NSDictionary dictionaryWithObject:@"000002" forKey:@"code"]];
//	}
//	else {
//		[stockRelatedNews removeFromSuperview];
//		[stockRelatedNews  release];
//	}
//	
//	return;
	
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]){
		[NoConnectionAlert alert];
		return;
	}
	[NSThread detachNewThreadSelector:@selector(changeIndicator:) toTarget:_newsrelatedView withObject:[NSNumber numberWithBool:YES]];
	for (id btn in [_imageBackground subviews])
	{
		UIButton *button = btn;
		if ([button isKindOfClass:[UIButton class]]) {
			if (button.tag != 0) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
			if (button.tag == 1) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_highlight_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
		}
	}
	if (!_newsrelatedView) {
		[self dismissRotationView];
		_newsrelatedView = [[CVNewsrelatedView alloc] initWithFrame:CGRectMake(
																			   _imageBackground.frame.origin.x + _imageBackground.frame.size.width/2 - 285,
																			   _imageBackground.frame.size.height - 461 + 20, 571, 461)];
		[_newsrelatedView setDelegate:self];
		[self.view addSubview:_newsrelatedView];
	}
	else
	{
		[self setButtonImage];
		[self dismissRotationView];
	}
	_newsrelatedView.rotationInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
	_newsrelatedView.labelTitle.text = [langSetting localizedString:@"News"];
	_newsrelatedView.newsClass = CVClassMystock;
	[_newsrelatedView startRotationView];

	[_newsrelatedView setHidden:NO];
}

- (void)clickBalanceButton {
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]){
		[NoConnectionAlert alert];
		return;
	}
	for (id btn in [_imageBackground subviews])
	{
		UIButton *button = btn;
		if ([button isKindOfClass:[UIButton class]]) {
			if (button.tag != 0) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
			if (button.tag == 2) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_highlight_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
		}
	}
	
	if (nil == _balanceSheetController) {
		[self dismissRotationView];
		CVBlanceSheetViewController *aController;
		aController = [[CVBlanceSheetViewController alloc] init];
		aController.view.frame = CGRectMake(
											_imageBackground.frame.origin.x + _imageBackground.frame.size.width/2 - 285,
											_imageBackground.frame.size.height - 461 + 20, 571, 461);

		self._balanceSheetController = aController;
		[aController release];
		[self.view addSubview:_balanceSheetController.view];
		NSString *code;
		code = [_dictCurrentElement objectForKey:@"code"];
		_balanceSheetController.code = code;

		[_balanceSheetController startRotationView];
	} else {
		[self setButtonImage];
		[self dismissRotationView];
	}
}

- (void)clickIncomeStatementButton{
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]){
		[NoConnectionAlert alert];
		return;
	}
	[NSThread detachNewThreadSelector:@selector(changeIndicator:) toTarget:_incomeStatementController withObject:[NSNumber numberWithBool:YES]];
	for (id btn in [_imageBackground subviews])
	{
		UIButton *button = btn;
		if ([button isKindOfClass:[UIButton class]]) {
			if (button.tag != 0) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
			if (button.tag == 3) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_highlight_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
		}
	}
	
	if (nil == _incomeStatementController) {
		[self dismissRotationView];
		CVIncomeStatementViewController *aController;
		aController = [[CVIncomeStatementViewController alloc] init];
		aController.view.frame = CGRectMake(
											_imageBackground.frame.origin.x + _imageBackground.frame.size.width/2 - 285,
											_imageBackground.frame.size.height - 461 + 20, 571, 461);
		
		self._incomeStatementController = aController;
		[aController release];
		[self.view addSubview:_incomeStatementController.view];
		NSString *code;
		code = [_dictCurrentElement objectForKey:@"code"];
		_incomeStatementController.code = code;
		
		[_incomeStatementController startRotationView];
		
	} else {
		[self setButtonImage];
		[self dismissRotationView];
	}
}

- (void)clickCashFlowButton{
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]){
		[NoConnectionAlert alert];
		return;
	}
	for (id btn in [_imageBackground subviews])
	{
		UIButton *button = btn;
		if ([button isKindOfClass:[UIButton class]]) {
			if (button.tag != 0) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
			if (button.tag == 4) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_highlight_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
		}
	}
	
	if (nil == _cashFlowController) {
		[self dismissRotationView];
		CVCashFlowViewController *aController;
		aController = [[CVCashFlowViewController alloc] init];
		aController.view.frame = CGRectMake(
											_imageBackground.frame.origin.x + _imageBackground.frame.size.width/2 - 285,
											_imageBackground.frame.size.height - 461 + 20, 571, 461);
		
		self._cashFlowController = aController;
		[aController release];
		[self.view addSubview:_cashFlowController.view];
		NSString *code;
		code = [_dictCurrentElement objectForKey:@"code"];
		_cashFlowController.code = code;
		
		[_cashFlowController startRotationView];
	} else {
		[self setButtonImage];
		[self dismissRotationView];
	}
}

- (IBAction)clickInfoButton:(id)sender {
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]){
		[NoConnectionAlert alert];
		return;
	}
	for (id btn in [_imageBackground subviews])
	{
		UIButton *button = btn;
		if ([button isKindOfClass:[UIButton class]]) {
			if (button.tag != 0) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
			if (button.tag == 5) {
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_highlight_button.png" ofType:nil];
				UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
				[button setBackgroundImage:imgx forState:UIControlStateNormal];
				[imgx release];
			}
		}
	}
	
	NSString *code;
	BOOL isEquity;
	code = [_dictCurrentElement objectForKey:@"code"];
	isEquity = [[_dictCurrentElement objectForKey:@"isEquity"] boolValue];
	if (isEquity) {
		if (nil == _companyProfileController) {
			[self dismissRotationView];
			CVCompanyProfileViewController *aController;
			aController = [[CVCompanyProfileViewController alloc] init];
			aController.view.frame = CGRectMake(
												_imageBackground.frame.origin.x + _imageBackground.frame.size.width/2 - 285,
												_imageBackground.frame.size.height - 461 + 20, 571, 461);
			self._companyProfileController = aController;
			[aController release];
			[self.view addSubview:_companyProfileController.view];
			_companyProfileController.code = code;
		
			[_companyProfileController startRotationView];
		} else {
			[self setButtonImage];
			[self dismissRotationView];
		}
	} else {
		if (nil == _compositeProfileController) {
			[self dismissRotationView];
			CVCompositeIndexProfileViewController *aController;
			aController = [[CVCompositeIndexProfileViewController alloc] init];
			aController.view.frame = CGRectMake(
												_imageBackground.frame.origin.x + _imageBackground.frame.size.width/2 - 285,
												_imageBackground.frame.size.height - 461 + 20, 571, 461);
			
			self._compositeProfileController = aController;
			[aController release];
			[self.view addSubview:_compositeProfileController.view];
			_compositeProfileController.code = code;
			
			[_compositeProfileController startRotationView];
		} else {
			[self setButtonImage];
			[self dismissRotationView];
		}
	}
}


- (void)dismissRotationView{
	if (_newsrelatedView) 
	{
		[_newsrelatedView removeFromSuperview];
		[_newsrelatedView release];
		_newsrelatedView = nil;
	}
	
	if (_balanceSheetController) {
		[_balanceSheetController.view removeFromSuperview];
		[_balanceSheetController release];
		_balanceSheetController = nil;
	}
	
	if (_incomeStatementController) {
		[_incomeStatementController.view removeFromSuperview];
		[_incomeStatementController release];
		_incomeStatementController = nil;
	}
	
	if (_cashFlowController) {
		[_cashFlowController.view removeFromSuperview];
		[_cashFlowController release];
		_cashFlowController = nil;
	}
	
	if (_companyProfileController) {
		[_companyProfileController.view removeFromSuperview];
		[_companyProfileController release];
		_companyProfileController = nil;
	}
	
	if (_compositeProfileController) {
		[_compositeProfileController.view removeFromSuperview];
		[_compositeProfileController release];
		_compositeProfileController = nil;
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self dismissRotationView];
	[self setButtonImage];
}


#pragma mark -
#pragma mark CVNavigatorDetailControllerDelegate
- (BOOL)navigatorDetailController:(CVNavigatorDetailController *)ndc allowPopOverByButton:(id)button {
	return YES;
}

- (void)navigatorDetailController:(CVNavigatorDetailController*)ndc 
				popoverController:(UIPopoverController*)pc 
		willPresentViewController:(UIViewController *)aViewController {
}

- (void)navigatorDetailController:(CVNavigatorDetailController*)ndc 
		   willHideViewController:(UIViewController *)aViewController
			 forPopoverController:(UIPopoverController*)pc {
	detailOrientation = ndc.orientation;
	[_imageBackground setFrame:CGRectMake(0, 0, 727, 911)];
	[self dismissRotationView];
	[buttonNews setCenter:CGPointMake(_imageBackground.frame.size.width/2-165-15-40, _imageBackground.frame.size.height-28)];
	[buttonBalanceSheet setCenter:CGPointMake(_imageBackground.frame.size.width/2-55-15-40, _imageBackground.frame.size.height-28)];
	[buttonIncomeStatement setCenter:CGPointMake(_imageBackground.frame.size.width/2+55-15-40, _imageBackground.frame.size.height-28)];
	[buttonCashFlow setCenter:CGPointMake(_imageBackground.frame.size.width/2+165-15-40, _imageBackground.frame.size.height-28)];
	[buttonInfo setCenter:CGPointMake(_imageBackground.frame.size.width/2+275-15-40, _imageBackground.frame.size.height-28)];
	
	[_buttonAdd setFrame:[self addDetailButtonFrame:detailOrientation]];
	[_myStockNavigatorController.view addSubview:_buttonAdd];
	[_buttonShow setFrame:[self showDetailButtonFrame:detailOrientation]];
	_buttonShow.hidden = NO;
	[_btnRefresh setFrame:[self refreshButtonFrame:detailOrientation]];
	[_labelClass setFrame:[self classLabelFrame:detailOrientation]];
	_imageBackground.image = _imgPortrait;
	[_stockChartView resize:[self stockChartViewFrame:UIInterfaceOrientationPortrait]];
	[_detailInfoController.view setFrame:[self detailInfoControllerFrame:UIInterfaceOrientationPortrait]];
	[_indexDetailInfoController.view setFrame:[self detailInfoControllerFrame:UIInterfaceOrientationPortrait]];
	_segmentControl.frame = [self segmentControlFrame:UIInterfaceOrientationPortrait];
	_detailIndicator.frame = [self detailIndicatorFrame:UIInterfaceOrientationPortrait];
}

- (void)navigatorDetailController:(CVNavigatorDetailController*)ndc 
		   willShowViewController:(UIViewController *)aViewController 
			 forPopoverController:(UIPopoverController*)pc {
	detailOrientation = ndc.orientation;
	[_imageBackground setFrame:CGRectMake(0, 0, 683, 655)];
	[self dismissRotationView];
	[buttonNews setCenter:CGPointMake(_imageBackground.frame.size.width/2-165-15-44, _imageBackground.frame.size.height-28)];
	[buttonBalanceSheet setCenter:CGPointMake(_imageBackground.frame.size.width/2-55-15-44, _imageBackground.frame.size.height-28)];
	[buttonIncomeStatement setCenter:CGPointMake(_imageBackground.frame.size.width/2+55-15-44, _imageBackground.frame.size.height-28)];
	[buttonCashFlow setCenter:CGPointMake(_imageBackground.frame.size.width/2+165-15-44, _imageBackground.frame.size.height-28)];
	[buttonInfo setCenter:CGPointMake(_imageBackground.frame.size.width/2+275-15-44, _imageBackground.frame.size.height-28)];
	
	[_buttonAdd setFrame:[self addDetailButtonFrame:detailOrientation]];
	[self.view addSubview:_buttonAdd];
	[_buttonShow setFrame:[self showDetailButtonFrame:detailOrientation]];
	_buttonShow.hidden = YES;
	[_btnRefresh setFrame:[self refreshButtonFrame:detailOrientation]];
	[_labelClass setFrame:[self classLabelFrame:detailOrientation]];
	_imageBackground.image = _imgLandscape;
	[_stockChartView resize:[self stockChartViewFrame:UIInterfaceOrientationLandscapeLeft]];
	[_detailInfoController.view setFrame:[self detailInfoControllerFrame:UIInterfaceOrientationLandscapeLeft]];
	[_indexDetailInfoController.view setFrame:[self detailInfoControllerFrame:UIInterfaceOrientationLandscapeLeft]];
	_segmentControl.frame = [self segmentControlFrame:UIInterfaceOrientationLandscapeLeft];
	_detailIndicator.frame = [self detailIndicatorFrame:UIInterfaceOrientationLandscapeLeft];
}

#pragma mark -
#pragma mark CVMyStockNavigatorControllerDelegate

-(void)didSelectItemAtIndexPath:(NSDictionary *)dict {
	_detailIndicator.hidden = NO;
	[_detailIndicator startAnimating];
	
	// stop previous timer
	[self stopIntradayChart];
	
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"detail_add_button.png" ofType:nil];
	UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
	[_buttonAdd setBackgroundImage:imgx forState:UIControlStateNormal];
	[imgx release];
	_segmentControl.userInteractionEnabled = NO;
	_segmentControl.index = 0;
	
	[self showDefaultData];
	
	[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:dict];
	[self dismissRotationView];
	[self setButtonImage];
	
//	NSString *code;
//	NSNumber *numIsEquity;
//	BOOL isEquity;
//	code = [dict objectForKey:@"code"];
//	numIsEquity = [dict objectForKey:@"isEquity"];
//	isEquity = [numIsEquity boolValue];
//	if (isEquity) {
//		[NSThread detachNewThreadSelector:@selector(updateStock:) toTarget:_myStockNavigatorController withObject:code];
//	} else {
//		[NSThread detachNewThreadSelector:@selector(updateIndex:) toTarget:_myStockNavigatorController withObject:code];
//	}
}


#pragma mark -
#pragma mark Dream's Code Begins here
- (void) setButtonImage
{
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonNews setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonBalanceSheet setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonIncomeStatement setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonCashFlow setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonInfo setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
}


-(void)chartLoaded{
	_segmentControl.userInteractionEnabled = YES;
}
@end
