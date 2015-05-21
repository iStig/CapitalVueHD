    //
//  CVFinancialSummaryTopMovingSecurityViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVFinancialSummaryTopMovingSecurityViewController.h"

#import "CVSetting.h"
#import "CVDataProvider.h"

#import "CVFinancialSummaryTopMovingFormView.h"
#import "CVLabelStyle.h"
#import "CVMacroFormView.h"

#import "CVPortal.h"

#import "NSString+Number.h"

@interface CVFinancialSummaryTopMovingSecurityViewController()

@property (nonatomic, retain) CVScrollPageViewController *scrollPageController;
@property (nonatomic, retain) NSDictionary *securityData;

/*
 * It loads the data of top moving securities of equity/fund/bond
 *
 * @param:	obj - parameters
 * @return:	none
 */
- (void)loadData;

/*
 * It return the scroll page view's position and size in accordance with
 * the device orientation
 *
 * @param:	orientation - the device orientation
 * @return:	CGRect-typed value indicating the origin and size
 */
- (CGRect)scrollPageFrame:(UIInterfaceOrientation)orientation;


- (CGPoint)indicatorCenter:(UIInterfaceOrientation)orientation;

@end

@implementation CVFinancialSummaryTopMovingSecurityViewController

@synthesize topMovingType;
@synthesize portalInterfaceOrientation;
@synthesize formView;

@synthesize scrollPageController;
@synthesize securityData;
@synthesize valuedData = _valuedData;

#define CVPORTLET_FINANCIAL_SUMMARY_SECURITIES_ELEMENT 5

- (id)init{
	
	if (self = [super init]) {
		_ifLoaded = YES;
		_valuedData = NO;
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self.view.autoresizingMask = UIViewAutoresizingNone;
	self.view.autoresizesSubviews = NO;
    [super viewDidLoad];
	
	UILabel *label;
	label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 21)];
	label.autoresizesSubviews = NO;
	label.autoresizingMask = UIViewAutoresizingNone;
	label.font = [UIFont boldSystemFontOfSize:16.0];
	label.textColor = [UIColor orangeColor];
	label.backgroundColor = [UIColor clearColor];
	label.text = [langSetting localizedString:@"TOP MOVING SECURITES"];
	[self.view addSubview:label];
	[label release];
	
	CVScrollPageViewController *controller;
	controller = [[CVScrollPageViewController alloc] init];
	controller.frame = [self scrollPageFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	controller.pageControlFrame = CGRectMake((controller.frame.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2, 
											 controller.frame.size.height - CVSCROLLPAGE_INDICTOR_HEIGHT - 20, 
											 CVSCROLLPAGE_INDICTOR_WIDTH,
											 CVSCROLLPAGE_INDICTOR_HEIGHT);
	[controller setDelegate:self];
	self.scrollPageController = controller;
	[controller release];
	
	// load the data of top moving securities in a seperate thread
	
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[self.view addSubview:_indicator];
	_indicator.hidesWhenStopped = YES;
	_indicator.center = [self indicatorCenter:[[UIApplication sharedApplication] statusBarOrientation]];
	_indicator.hidden = YES;
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
	[formView release];
	
	[scrollPageController release];
	[securityData release];
	[_indicator release];
    [super dealloc];
}

#pragma mark -
#pragma mark private methods
/*
 * It loads the data of top moving securities of equity/fund/bond
 *
 * @param:	obj - parameters
 * @return:	none
 */
- (void)loadData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CVSetting *s;
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingHomeFinancialSummary];
	if (CVFinancialSummaryTypeEquity == topMovingType) {
		dict = [dp GetStockList:CVDataProviderStockListTypeTopMovingSecruties withParams:paramInfo];
		self.securityData = dict;
	} else if (CVFinancialSummaryTypeFund == topMovingType) {
		dict = [dp GetFundList:CVDataProviderFundListTypeTopMovingSecruties withParams:paramInfo];
		self.securityData = dict;
	} else if (CVFinancialSummaryTypeBond == topMovingType) {
		dict = [dp GetBondList:CVDataProviderBondListTypeTopMovingSecruties withParams:paramInfo];
		self.securityData = dict;
	}
	
	[paramInfo release];
	
	NSArray *array = [securityData objectForKey:@"data"];
	if (0 != [array count]) {
		_isEmptyData = NO;
		scrollPageController.pageCount = [array count] / CVPORTLET_FINANCIAL_SUMMARY_SECURITIES_ELEMENT;
		scrollPageController.pageCount += ([array count] % CVPORTLET_FINANCIAL_SUMMARY_SECURITIES_ELEMENT) == 0?0:1;
		[scrollPageController performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
	}else {
		_isEmptyData = YES;
		NSMutableArray *data = [[NSMutableArray alloc] init];
		for (int i = 0; i < 5; i++) {
			NSMutableDictionary *arow = [[NSMutableDictionary alloc] init];
			for (int i = 0; i < 4; i++) {
				[arow setValue:@"--" forKey:@"ZD"];
			}
			[data addObject:arow];
			[arow release];
		}
		[securityData setValue:data forKey:@"data"];
		[data release];
		scrollPageController.pageCount = 1;
	}

	[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];
	[pool release];
}

-(void)afterLoadData{
	
	[self.view addSubview:scrollPageController.view];
	
	[scrollPageController reloadData];
	_ifLoaded = YES;
	if (self.securityData && [self.securityData count]>0  && !_isEmptyData) {
		_valuedData = YES;
	} else {
		_valuedData = NO;
	}

	[_indicator stopAnimating];
}

/*
 * It return the scroll page view's position and size in accordance with
 * the device orientation
 *
 * @param:	orientation - the device orientation
 * @return:	CGRect-typed value indicating the origin and size
 */
- (CGRect)scrollPageFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(0, 30, 333, 227);
	} else {
		rect = CGRectMake(0, 30, 435, 223);
	}
	return rect;
}

- (CGPoint)indicatorCenter:(UIInterfaceOrientation)orientation{
	CGPoint point;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		point = CGPointMake(CVPORTLET_TOP_MOVING_PORTRAIT_WIDTH/2, CVPORTLET_TOP_MOVING_PORTRAIT_HEIGHT/2);
	} else {
		point = CGPointMake(CVPORTLET_TOP_MOVING_LANDSCAPE_WIDTH/2, CVPORTLET_TOP_MOVING_LANDSCAPE_HEIGHT/2);
	}
	return point;
}

#pragma mark -
#pragma mark CVScrollPageViewDeleage

- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	CVFinancialSummaryTopMovingFormView *stockFormView;
	
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [local localizedString:@"LangCode"];
	
	NSArray *keysArray;
	NSDictionary *dictHead;
	NSArray *dictDataArray;
	NSMutableArray *headArray;
	NSMutableArray *displayArray;
	NSArray *filterArray;
	
	headArray = [[NSMutableArray alloc] init];
	displayArray = [[NSMutableArray alloc] init];
	NSUInteger stockCount, i;
	
	if (CVFinancialSummaryTypeEquity == topMovingType) {
		keysArray = [[NSArray alloc] initWithObjects:@"GPDM", @"GPJC", @"SPJ", @"CJJE", @"ZD", nil];
	} else if (CVFinancialSummaryTypeFund == topMovingType) {
		keysArray = [[NSArray alloc] initWithObjects:@"BZDM", @"BZDM", @"DWJZ", @"LJJZ", @"ZD", nil];
	} else {
		keysArray = [[NSArray alloc] initWithObjects:@"ZQDM", @"ZQDM", @"SPJ", @"CJJE", @"ZD", nil];
	}
	
	dictHead = [securityData objectForKey:@"head"];
	dictDataArray = [securityData objectForKey:@"data"];
	// construct head array
	NSString *key, *value;
	for (key in keysArray) {
		value = [dictHead objectForKey:key];
		if (value) {
			[headArray addObject:value];
		} else {
			[headArray addObject:@"--"];
		}
	}
	stockCount = [dictDataArray count];
	for (i = index * CVPORTLET_FINANCIAL_SUMMARY_SECURITIES_ELEMENT; (i < (index + 1) * 5) && i < stockCount; i++) {
		NSDictionary *dictData;
		NSMutableArray *aRow;
		aRow = [[NSMutableArray alloc] initWithCapacity:1];
		dictData = [dictDataArray objectAtIndex:i];
		for (key in keysArray) {
			value = [dictData objectForKey:key];
			if ([key isEqualToString:@"ZD"] && ![value isEqualToString:@"--"]) {
				value = [NSString stringWithFormat:@"%@%%",value];
			}
			if ([_langCode isEqualToString:@"en"]) {
				if ([key isEqualToString:@"CJJE"] && ![value isEqualToString:@"--"]) {
					value = [value formatToEnNumber];
				}
			}
			
			if (value) {
				[aRow addObject:value];
			} else {
				[aRow addObject:@"--"];
			}
		}
		[displayArray addObject:aRow];
		[aRow release];
	}
	if (stockCount == 0) {
		for (int i =0; i < 5; i++) {
			NSMutableArray *aRow;
			aRow = [[NSMutableArray alloc] initWithCapacity:1];
			for (key in keysArray) {
				[aRow addObject:@"--"];
			}
			[displayArray addObject:aRow];
			[aRow release];
		}
	}
	
	NSString *lanCode = [langSetting localizedString:@"LangCode"];
	BOOL isEnglish = [lanCode isEqualToString:@"en"];
	if (isEnglish) {
		filterArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],
					   [NSNumber numberWithInt:2],
					   [NSNumber numberWithInt:3],
					   [NSNumber numberWithInt:4],nil];
	} else {
		filterArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
					   [NSNumber numberWithInt:2],
					   [NSNumber numberWithInt:3],
					   [NSNumber numberWithInt:4],nil];
	}

	if (UIInterfaceOrientationPortrait == portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == portalInterfaceOrientation) {
		// create an instance of form view
		stockFormView = [[CVFinancialSummaryTopMovingFormView alloc] initWithFrame:CGRectMake(0, 0, 400, 300)];
		stockFormView.formDelegate = self;
		stockFormView.headerHeight = 30;
		stockFormView.rowHeight = 30;
			
		stockFormView.headerArray = headArray;
		stockFormView.dataArray = displayArray;
		stockFormView.filterArray = filterArray;
		
		// set the from style
		CVLabelStyle* labelStyle = [[CVLabelStyle alloc] init];
		labelStyle.font = [UIFont boldSystemFontOfSize:15.0];
		labelStyle.foreColor = [UIColor whiteColor];
		labelStyle.textAlign = UITextAlignmentCenter;
		NSMutableArray* styleArray = [NSMutableArray new];
		for (int i = 0; i < [filterArray count]; ++i)
		{
			[styleArray addObject:labelStyle];
		}
		NSMutableArray *widthArray;
		widthArray = [[NSMutableArray alloc] initWithObjects:
					  [NSNumber numberWithFloat:75],
					  [NSNumber numberWithFloat:75],
					  [NSNumber numberWithFloat:110],
					  [NSNumber numberWithFloat:70],
					  nil];
		NSMutableArray *spaceArray;
		if (_isEmptyData) {
			spaceArray = [[NSMutableArray alloc] initWithObjects:
						  [NSNumber numberWithFloat:0],
						  [NSNumber numberWithFloat:35],
						  [NSNumber numberWithFloat:50],
						  [NSNumber numberWithFloat:30],
						  nil];
		}else {
			CGFloat spaceForThird = 12;
			if (CVFinancialSummaryTypeEquity == topMovingType) {
				spaceForThird = 12;
			} else if (CVFinancialSummaryTypeFund == topMovingType) {
				spaceForThird = 42;
			} else {
				spaceForThird = 42;
			}
			spaceArray = [[NSMutableArray alloc] initWithObjects:
						  [NSNumber numberWithFloat:0],
						  [NSNumber numberWithFloat:20],
						  [NSNumber numberWithFloat:spaceForThird],
						  [NSNumber numberWithFloat:10],
						  nil];
		}

		stockFormView.headerStyleArray = styleArray;
		stockFormView.widthArray = widthArray;
		stockFormView.spaceArray = spaceArray;
		[widthArray release];
		[spaceArray release];
		[styleArray release];
		[labelStyle release];
		
		stockFormView.selfAdjust = NO;
		stockFormView.backgroundColor = [UIColor clearColor];
		[stockFormView illustrateAll];

		for (NSInteger i = 0; i<4; i++) {
			UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30*i+60, 322, 1)];
			NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_Home_tableV_line.png" ofType:nil];
			UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
			line.image = imgx;
			[imgx release];
			[stockFormView addSubview:line];
			[line release];
		}
	} else {
		// create an instance of form view
		stockFormView = [[CVFinancialSummaryTopMovingFormView alloc] initWithFrame:CGRectMake(0, 0, 425, 187)];
		stockFormView.formDelegate = self;
		stockFormView.headerHeight = 30;
		stockFormView.rowHeight = 30;
		
		stockFormView.headerArray = headArray;
		stockFormView.dataArray = displayArray;
		stockFormView.filterArray = filterArray;
		
		// set the from style
		CVLabelStyle* labelStyle = [[CVLabelStyle alloc] init];
		labelStyle.textAlign = UITextAlignmentCenter;
		labelStyle.font = [UIFont boldSystemFontOfSize:15.0];
		labelStyle.foreColor = [UIColor whiteColor];
		NSMutableArray* styleArray = [NSMutableArray new];
		for (int i = 0; i < [filterArray count]; ++i)
		{
			[styleArray addObject:labelStyle];
		}
		
		NSMutableArray *widthArray;
		widthArray = [[NSMutableArray alloc] initWithObjects:
						[NSNumber numberWithFloat:80],
						[NSNumber numberWithFloat:120],
						[NSNumber numberWithFloat:120],
						[NSNumber numberWithFloat:110],
						nil];
		CGFloat spaceForThird = 10;
		if (CVFinancialSummaryTypeEquity == topMovingType) {
			spaceForThird = 12;
		} else if (CVFinancialSummaryTypeFund == topMovingType) {
			spaceForThird = 42;
		} else {
			spaceForThird = 42;
		}
		NSMutableArray *spaceArray;
		if (_isEmptyData) {
			spaceArray = [[NSMutableArray alloc] initWithObjects:
						  [NSNumber numberWithFloat:0],
						  [NSNumber numberWithFloat:54],
						  [NSNumber numberWithFloat:54],
						  [NSNumber numberWithFloat:49],
						  nil];
		}else {
			spaceArray = [[NSMutableArray alloc] initWithObjects:
						  [NSNumber numberWithFloat:0],
						  [NSNumber numberWithFloat:40],
						  [NSNumber numberWithFloat:spaceForThird],
						  [NSNumber numberWithFloat:30],
						  nil];
		}
		stockFormView.headerStyleArray = styleArray;
		stockFormView.widthArray = widthArray;
		stockFormView.spaceArray = spaceArray;
		[widthArray release];
		[spaceArray release];
		[styleArray release];
		[labelStyle release];
		
		stockFormView.selfAdjust = NO;
		stockFormView.backgroundColor = [UIColor clearColor];
		[stockFormView illustrateAll];
		
		for (NSInteger i = 0; i<4; i++) {
			UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30*i+60, 435, 1)];
			NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_Home_tableH_line.png" ofType:nil];
			UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
			line.image = imgx;
			[imgx release];
			[stockFormView addSubview:line];
			[line release];
		}
	}
	
	[headArray release];
	[keysArray release];
	[displayArray release];

	
	return [stockFormView autorelease];
}

- (void)didScrollToPageAtIndex:(NSUInteger)index {
}

- (NSUInteger)numberOfPagesInScrollPageView {
	return 0;
}

#pragma mark -
#pragma mark CVFormViewDelegate

- (void)didSelectRow:(int)row {
	NSDictionary *selectRowData;
	NSInteger selectIndex;
	NSArray *dataArray;
	
	dataArray = [securityData objectForKey:@"data"];
	if (CVFinancialSummaryTypeEquity == topMovingType) {
		selectIndex = scrollPageController.pageControl.currentPage * CVPORTLET_FINANCIAL_SUMMARY_SECURITIES_ELEMENT + row;
		if (selectIndex < [dataArray count]) {
			selectRowData = [dataArray objectAtIndex:selectIndex];
			
			NSString *code;
			code = [selectRowData objectForKey:@"GPDM"];
			if (code ) {
				NSMutableDictionary *notificationDict;
				notificationDict = [[NSMutableDictionary alloc] initWithCapacity:1];
				[notificationDict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
				
				// get the code
				[notificationDict setObject:code forKey:@"code"];
				[notificationDict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
				
				[[NSNotificationCenter defaultCenter]
				 postNotificationName:CVPortalSwitchPortalSetNotification object:[notificationDict autorelease]];
			}
		}
	}
}


#pragma mark -
#pragma mark public method
/*
 * It adjusts the width of columns in accordance with the device orientation
 * 
 * @param:	orientation - the device orientation
 * @return:	none
 */
- (void)adjustFormView:(UIInterfaceOrientation)orientation {
	int index = scrollPageController.scrollView.contentOffset.x/scrollPageController.frame.size.width;
	portalInterfaceOrientation = orientation;
	_indicator.center = [self indicatorCenter:orientation];
	scrollPageController.frame = [self scrollPageFrame:orientation];
	scrollPageController.scrollView.contentOffset = CGPointMake(index*scrollPageController.frame.size.width, 0);
	scrollPageController.pageControlFrame = CGRectMake((scrollPageController.frame.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2, 
											 scrollPageController.frame.size.height - CVSCROLLPAGE_INDICTOR_HEIGHT - 20, 
											 CVSCROLLPAGE_INDICTOR_WIDTH,
											 CVSCROLLPAGE_INDICTOR_HEIGHT);
	[scrollPageController reloadData];
}

- (void)reloadData {
	if (!_ifLoaded) {
		return;
	}
	_ifLoaded = NO;
	[scrollPageController.view removeFromSuperview];
	_indicator.hidden = NO;
	[_indicator startAnimating];
	[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

@end
