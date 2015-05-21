    //
//  CVMostActivePortletViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/14/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMostActivePortletViewController.h"
#import "CVMostActiveFormView.h"

#import "CVDataProvider.h"

#import "CVLabelStyle.h"

#import "CVSetting.h"
#import "CVMenuItem.h"

#import "CVPortal.h"

@interface CVMostActivePortletViewController ()

@property (nonatomic, retain) CVScrollPageViewController *_scrollPageController;

/*
 * It loads the settings of a form, including its portrait settings 
 * as well as landscape settings.
 *
 *
 */
- (void)loadFormSettings:(NSString *)fileName;

/*
 * it loads the data of most active ones within
 * a composite index
 *
 * @param:	none
 * @return:	none
 */
- (void)loadData;

/*
 * it returns the origin point and size of scroll page frame
 * corresponding to the device orientation
 */
- (CGRect)scrollPageFrame:(UIInterfaceOrientation)orientation;
-(void)sectionBGFrame:(UIInterfaceOrientation)orientation;
/*
 * it inserts the data into the _mostActiveDictionary
 *
 * @param:	data - the data of most active stock of a composite index
 *			code - the code of a composite index
 * @return:	none
 */
- (void)insertMostActiveList:(NSDictionary *)data ofIndex:(NSString *)code;

- (void)loadThread;

-(void)afterLoadData;

@end

@implementation CVMostActivePortletViewController

@synthesize indexCode = _indexCode;
@synthesize indexSymbol;
@synthesize headArray = _headArray;
@synthesize dataArray = _dataArray;

@synthesize _scrollPageController;

#define STOCK_FORM_CONTENT_ROW 5

- (id)init {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	if ((self = [super init])) {
		_headArray = [[NSMutableArray alloc] init];
		_dataArray = [[NSMutableArray alloc] init];
		[self loadFormSettings:[NSString stringWithFormat:@"MostActiveFormConf_%@",[langSetting localizedString:@"LangCode"]]];
	}
	
	return self;
}

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
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	//self.style = CVPortletViewStyleRefresh | CVPortletViewStyleSetting | CVPortletViewStyleBarVisible;
	self.style = CVPortletViewStyleRefresh | CVPortletViewStyleBarVisible;

	// fill the menu of setting
	CVSetting *setting;
	NSArray *settingArray;
	NSMutableArray *array;
	NSDictionary *element;
	CVMenuItem *item;
	setting = [CVSetting sharedInstance];
	settingArray = [setting settingMostActiveCategory];
	array = [[NSMutableArray alloc] initWithCapacity:1];
	for (element in settingArray) {
		NSNumber *number;
		item = [[CVMenuItem alloc] init];
		item.title = [element objectForKey:@"title"];
		item.name = [element objectForKey:@"categoryname"];
		number = [element valueForKey:@"select"];
		item.select = [number boolValue];
		[array addObject:item];
		[item release];
	}
	self.menuItems = array;
	[array release];
	
    [super viewDidLoad];
	
	imgvSectBG = [[UIImageView alloc] init];
	[self scrollPageFrame:[UIApplication sharedApplication].statusBarOrientation];
	
	imgvSectBG.hidden = YES;
	[self.view addSubview:imgvSectBG];
	
	CVScrollPageViewController *controller;
	controller = [[CVScrollPageViewController alloc] init];
	controller.indicatorStyle = CVScrollPageIndicatorStyleHigh;
	controller.frame = [self scrollPageFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	controller.pageControlFrame = CGRectMake((controller.frame.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2, 
											 controller.frame.size.height - 20, 
											 CVSCROLLPAGE_INDICTOR_WIDTH,
											 CVSCROLLPAGE_INDICTOR_HEIGHT);
	[controller setDelegate:self];
	self._scrollPageController = controller;
	[self.view addSubview:_scrollPageController.view];
	[controller release];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//	_activityIndicator.hidden = YES;
	_activityIndicator.frame = CGRectMake((self.view.frame.size.width - _activityIndicator.frame.size.width) / 2,
							   (self.view.frame.size.height - _activityIndicator.frame.size.height) / 2, 
							   _activityIndicator.frame.size.width, 
							   _activityIndicator.frame.size.height);
	_activityIndicator.hidesWhenStopped = YES;
	[self.view addSubview:_activityIndicator];
	[_activityIndicator startAnimating];
	
	lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
	lbl.numberOfLines = 2;
	lbl.font = [UIFont systemFontOfSize:13];
	lbl.center = _activityIndicator.center;
	lbl.textColor = [UIColor darkGrayColor];
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textAlignment = UITextAlignmentCenter;
	lbl.text = [langSetting localizedString:@"NetworkFailedMessage"];
	[self.view addSubview:lbl];
	lbl.hidden = YES;
	
	_loadingDataLock = [[NSLock alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waitForCoverFlowLoading:) name:kReloadMarketData object:nil];
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
	[imgvSectBG release];
	[_loadingDataLock release];
	[_scrollPageController release];
	[_settingDictionary release];
	
	[_portraitCellWidthArray release];
	[_landscapeCellWidthArray release];
	
	[_portraitCellSpaceArray release];
	[_landscapeCellSpaceArray release];
	[lbl release];
	
	[_headArray release];
	[_dataArray release];
	[_keysArray release];
	[super dealloc];
}

#pragma mark -
#pragma mark private method

/*
 * It reads the settings of a form from a file, including its portrait settings 
 * as well as landscape settings.
 *
 * @param:	fileName - the name of a plist-format file, excluding the suffix.
 *						e.g. fileName of "abc.plist" is "abc".
 * @return:	none
 */
- (void)loadFormSettings:(NSString *)fileName {
	NSString *filePath;
	NSDictionary *landscapeDict, *portraitDict;
	NSNumber *tempNumber;
	
	filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
	_settingDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	
	portraitDict = [_settingDictionary objectForKey:@"portrait"];
	landscapeDict = [_settingDictionary objectForKey:@"landscape"];
	
	tempNumber = [portraitDict objectForKey:@"x"];
	_portraitX = [tempNumber floatValue];
	tempNumber = [portraitDict objectForKey:@"y"];
	_portraitY = [tempNumber floatValue];
	tempNumber = [portraitDict objectForKey:@"width"];
	_portraitWidth = [tempNumber floatValue];
	tempNumber = [portraitDict objectForKey:@"height"];
	_portraitHeight = [tempNumber floatValue];
	_portraitCellWidthArray = [portraitDict objectForKey:@"cellswidth"];
	_portraitCellSpaceArray = [portraitDict objectForKey:@"cellspace"];
	
	tempNumber = [landscapeDict objectForKey:@"x"];
	_landscapeX = [tempNumber floatValue];
	tempNumber = [landscapeDict objectForKey:@"y"];
	_landscapeY = [tempNumber floatValue];
	tempNumber = [landscapeDict objectForKey:@"width"];
	_landscapeWidth = [tempNumber floatValue];
	tempNumber = [landscapeDict objectForKey:@"height"];
	_landscapeHeight = [tempNumber floatValue];
	_landscapeCellWidthArray = [landscapeDict objectForKey:@"cellswidth"];
	_landscapeCellSpaceArray = [landscapeDict objectForKey:@"cellspace"];
}

/*
 * it loads the data of most active ones within
 * a composite index
 *
 * @param:	none
 * @return:	none
 */
- (void)loadData {
	if (_indexCode == nil) {
		return;
	}
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	imgvSectBG.hidden = YES;
	NSString *tempCode = [[_indexCode copy] autorelease];
	
	CVSetting *s;
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *data;
	
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[[CVParamInfo alloc] init] autorelease];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingMarketMostActive];
	paramInfo.parameters = tempCode;
	
	data = [dp GetStockList:CVDataProviderStockListTypeMostActive withParams:paramInfo];
	
	if ([tempCode isEqualToString:_indexCode]) {
		NSArray *array;
		if (nil != data) {
			[self insertMostActiveList:data ofIndex:_indexCode];
			
			array = [data objectForKey:@"data"];
			
			if (array == nil || 0==[array count]){
				_valuedData = NO;
			} else{
				_valuedData = YES;
			}
		} else {
			_valuedData = NO;
		}
		
		[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];
	}
	
	[pool release];
}

- (void)refreshData {
	_ifLoaded = NO;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	imgvSectBG.hidden = YES;
	NSString *tempCode = [[_indexCode copy] autorelease];
	CVSetting *s;
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *data;
	
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[[CVParamInfo alloc] init] autorelease];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingMarketMostActive];
	paramInfo.parameters = tempCode;
	
	data = [dp ReGetStockList:CVDataProviderStockListTypeMostActive withParams:paramInfo];
	
	if ([tempCode isEqualToString:_indexCode]) {
		
		NSArray *array;
		if (nil != data) {
			[self insertMostActiveList:data ofIndex:_indexCode];
			array = [data objectForKey:@"data"];
			
			if (array == nil || 0==[array count]){
				_valuedData = NO;
			} else{
				_valuedData = YES;
			}
		} else {
			_valuedData = NO;
		}
		
		[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];
	}
	
	[pool release];
}

-(void)afterLoadData{
	if (_valuedData) {
		_scrollPageController.view.hidden = NO;
		lbl.hidden = YES;
		
		if ([self.dataArray count] > 0) {
			// cacualate the number of pages
			// total items are divided by (5 items/page)
			_scrollPageController.pageCount = [self.dataArray count] / STOCK_FORM_CONTENT_ROW;
		}
	} else {
		_scrollPageController.view.hidden = YES;
		lbl.hidden = NO;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:_scrollPageController];
	[_scrollPageController reloadData];
	
	[_activityIndicator stopAnimating];
	
	[self sectionBGFrame:[UIApplication sharedApplication].statusBarOrientation];
	imgvSectBG.hidden = NO;
	_ifLoaded = YES;
}

-(void)waitForCoverFlowLoading:(NSNotification *)notification{
	_scrollPageController.view.hidden = YES;
	lbl.hidden = YES;
	_activityIndicator.frame = CGRectMake((self.view.frame.size.width - _activityIndicator.frame.size.width) / 2,
										  (self.view.frame.size.height - _activityIndicator.frame.size.height) / 2, 
										  _activityIndicator.frame.size.width, 
										  _activityIndicator.frame.size.height);
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
		rect = CGRectMake(_portraitX, CVPORTLET_BAR_HEIGHT + _portraitY, _portraitWidth, _portraitHeight);
	} else {
		rect = CGRectMake(_landscapeX, CVPORTLET_BAR_HEIGHT + _landscapeY, _landscapeWidth, _landscapeHeight);
	}
	
	return rect;
}

-(void)sectionBGFrame:(UIInterfaceOrientation)orientation{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CGRect rect;
	UIImage *img = nil;
	NSString *path = nil;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(0, CVPORTLET_BAR_HEIGHT, 726, 197);
		path = [[NSBundle mainBundle] pathForResource:@"CV_iPad_market_BG_P" ofType:@"png"];
		
	} else {
		rect = CGRectMake(0, CVPORTLET_BAR_HEIGHT, 475, 196);
		path = [[NSBundle mainBundle] pathForResource:@"CV_iPad_market_BG_P" ofType:@"png"];
	}
	img = [[UIImage alloc] initWithContentsOfFile:path];
	
	[imgvSectBG setFrame:rect];
	[imgvSectBG setImage:img];
	
	
	[img release];
	[pool release];
}
/*
 *
 * @param:	data - the data of most active stock of a composite index
 *			code - the code of a composite index
 * @return:	none
 */
- (void)insertMostActiveList:(NSDictionary *)data ofIndex:(NSString *)code {
	
	// and code of a composite index.
	// Object of "keys" is unique and is used by this method to retrive values of stock from
	// data.
	// Object of "head" is also unique. It is the head of a form.
	// Object of code is multiple, e.g. Object of "000001" carries the stocks of Shanghai Composite 
	// Index, Object of "399001" carries the stocks of Shenzhen Composite Index.
	// Object of code has a two-dimensional array, which has structure as stock and its information
	// for each row. e.g.
	//	stock	information (one-to-one mapping to the object of "head")
	//	1		"19.58","23.59","94.99",200869,"95.03","16.75","23,913,000","2010-09-17","257,100","16,954,221,757","91.20","4.16","90.00","0.14","Changyu Wine (B)","39.74","91.20"
	//	2		 "7.07","16.77","9.66",200002,"9.79","2.67","14,178,000","2010-09-17","1,463,800","12,702,469,821","9.70","-0.41","9.51","0.11","Vanke (B)","18.94","9.51"
	
	if (nil == _keysArray) {
		_keysArray = [[NSArray alloc] initWithObjects:@"股票代码", @"股票名称", @"当日收盘价", @"日涨跌幅", @"日换手率", @"成交金额", @"日流通市值", nil];
	}
	
	NSDictionary *tempDict = [data objectForKey:@"head"];
		
	[_headArray removeAllObjects];
	NSString *key;
	for (key in _keysArray) {
		NSString *value;
		value = [tempDict objectForKey:key];
			
		if (value) {
			[_headArray addObject:value];
		} else {
			[_headArray addObject:@""];
		}

	}
	
	//set the first element of head to be date
	NSArray *tempArray = [data objectForKey:@"data"];
	
	if ([tempArray count] > 1) {
		NSString *strDate = [[tempArray objectAtIndex:0] objectForKey:@"当日日期"];
		if (strDate && [_headArray count] > 1) {
			[_headArray replaceObjectAtIndex:0 withObject:strDate];
			[_headArray replaceObjectAtIndex:1 withObject:strDate];
		}
	}
	
	NSMutableArray *rowCells;
	NSMutableArray *rowsOfCompositeIndex;
	rowsOfCompositeIndex = [[NSMutableArray alloc] initWithCapacity:1];
	for (NSDictionary *tempDict in tempArray) {
		NSString *key;
		NSString *value;
		rowCells = [[NSMutableArray alloc] initWithCapacity:1];
		for (key in _keysArray) {
			value = [tempDict objectForKey:key];
			if ([key isEqualToString:@"日涨跌幅"]) {
				value = [NSString stringWithFormat:@"%@%%",value];
			}
			if ([key isEqualToString:@"日换手率"]) {
				value = [NSString stringWithFormat:@"%@%%",value];
			}
			// sometimes the key's value doesn't
			// exist in the data.
			if (value) {
				[rowCells addObject:value];
			} else {
				[rowCells addObject:@""];
			}
		}
		[rowsOfCompositeIndex addObject:rowCells];
		[rowCells release];
	}
	self.dataArray = rowsOfCompositeIndex;
	[rowsOfCompositeIndex release];
}

#pragma mark -
#pragma mark CVPortletViewController

- (void)actionMenuDidDismiss {
	_activityIndicator.frame = CGRectMake((self.view.frame.size.width - _activityIndicator.frame.size.width) / 2,
										  (self.view.frame.size.height - _activityIndicator.frame.size.height) / 2, 
										  _activityIndicator.frame.size.width, 
										  _activityIndicator.frame.size.height);
	[_activityIndicator startAnimating];
	_activityIndicator.hidden = NO;
	
	[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)clickFresh:(id)sender {
	if (!_ifLoaded) {
		return;
	}
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		if (!_valuedData) {
			[_activityIndicator stopAnimating];
			_scrollPageController.view.hidden = YES;
			lbl.hidden = NO;
		}
		return;
	}else {
		_scrollPageController.view.hidden = YES;
		lbl.hidden = YES;
		imgvSectBG.hidden = YES;
	}
	_activityIndicator.frame = CGRectMake((self.view.frame.size.width - _activityIndicator.frame.size.width) / 2,
										  (self.view.frame.size.height - _activityIndicator.frame.size.height) / 2, 
										  _activityIndicator.frame.size.width, 
										  _activityIndicator.frame.size.height);
	[_activityIndicator startAnimating];
	_activityIndicator.hidden = NO;
	
	[self performSelector:@selector(refreshData) withObject:nil afterDelay:0.2];
}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	int pageIndex = _scrollPageController.scrollView.contentOffset.x/_scrollPageController.frame.size.width;
	_scrollPageController.frame = [self scrollPageFrame:orientation];
	CGPoint offset = CGPointMake(pageIndex*_scrollPageController.frame.size.width, 0);
	[_scrollPageController.scrollView setContentOffset:offset];
	[self sectionBGFrame:orientation];
	_scrollPageController.pageControlFrame = CGRectMake((_scrollPageController.frame.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2, 
											 _scrollPageController.frame.size.height - 20, 
											 CVSCROLLPAGE_INDICTOR_WIDTH,
											 CVSCROLLPAGE_INDICTOR_HEIGHT);
	_activityIndicator.center = _scrollPageController.view.center;
	lbl.center = _activityIndicator.center;
	[_scrollPageController reloadData];
}

#pragma mark -
#pragma mark public method
- (void)setIndexCode:(NSString *)indexCode {
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		[_activityIndicator stopAnimating];
		_scrollPageController.view.hidden = YES;
		lbl.hidden = NO;
		return;
	}else {
		_scrollPageController.view.hidden = YES;
		lbl.hidden = YES;
	}
	
	if (indexCode) {
		[_indexCode release];
		_indexCode = [indexCode retain];
		
		// if array is nil, it means that the most active stock of this index
		// has not been downloaed yet.
		_activityIndicator.hidden = NO;
		[_activityIndicator startAnimating];
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[NSObject cancelPreviousPerformRequestsWithTarget:_scrollPageController];
		[self loadThread];
		
		_scrollPageController.pageControl.hidden = NO;
	}
	else
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[NSObject cancelPreviousPerformRequestsWithTarget:_scrollPageController];
		_scrollPageController.pageCount = 1;//[array count] / STOCK_FORM_CONTENT_ROW;
		[self loadThread];
		_scrollPageController.pageControl.hidden = YES;
	}

}

- (void)setIndexSymbol:(NSString *)symbol {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	if (nil != symbol) {
		NSMutableString *t;
		
		t = [[NSMutableString alloc] initWithString:symbol];
		
		[t appendString:[langSetting localizedString:@"Most Active"]];
		self.portletTitle = t;
		[t release];
	}
}

#pragma mark -
#pragma mark CVScrollPageViewDelegate

- (NSUInteger)numberOfPagesInScrollPageView {
	return 0;
}

- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	CVMostActiveFormView *stockFormView;
	
	stockFormView = [[CVMostActiveFormView alloc] initWithFrame:CGRectMake(0, 0, 400, 233)];
	stockFormView.formDelegate = self;
	
	stockFormView.headerHeight = 30;
	stockFormView.rowHeight = 30;
		
	// point to the object of "head" in _mostActiveDictionary
	// point to the object of a composite index  in _mostActiveDictionary
	
	NSMutableArray *dispalyDataArray;
	
	// create an mutable array for head of form view 
	stockFormView.headerArray = _headArray;
	
	// create an mutable array for rows of form view
	dispalyDataArray = [[NSMutableArray alloc] init];
	NSUInteger stockCount = [_dataArray count], i;
	for (i = index * STOCK_FORM_CONTENT_ROW; (i < (index + 1) * STOCK_FORM_CONTENT_ROW) && i < stockCount; i++) {
			[dispalyDataArray addObject:[_dataArray objectAtIndex:i]];
	}
	stockFormView.dataArray = dispalyDataArray;
	[dispalyDataArray release];
	
	NSArray* filterArray;
	BOOL isEnglish;
	NSString *lanCode = [langSetting localizedString:@"LangCode"];
	isEnglish = [lanCode isEqualToString:@"en"];
	if (isEnglish) {
		filterArray = [NSArray arrayWithObjects:
					   [NSNumber numberWithFloat:0],
					   [NSNumber numberWithFloat:2],
					   [NSNumber numberWithFloat:3],
					   [NSNumber numberWithFloat:4],
					   [NSNumber numberWithFloat:5],
					   [NSNumber numberWithFloat:6],
					   nil];
	} else {
		filterArray = [NSArray arrayWithObjects:
					   [NSNumber numberWithFloat:1],
					   [NSNumber numberWithFloat:2],
					   [NSNumber numberWithFloat:3],
					   [NSNumber numberWithFloat:4],
					   [NSNumber numberWithFloat:5],
					   [NSNumber numberWithFloat:6],
					   nil];
	}

	
	stockFormView.filterArray = filterArray;
	
	// label style used to set the style of head
	CVLabelStyle* labelStyle = [[CVLabelStyle alloc] init];
	
	// create width array to define width of each cell of form
	NSMutableArray *widthArray;
	NSMutableArray *spaceArray;
	if (UIInterfaceOrientationPortrait == portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == portalInterfaceOrientation) {
		labelStyle.font = [UIFont boldSystemFontOfSize:14.0];
		labelStyle.foreColor = [UIColor blackColor];
		widthArray = [[NSMutableArray alloc] initWithArray:_portraitCellWidthArray];
		spaceArray = [[NSMutableArray alloc] initWithArray:_portraitCellSpaceArray];
	} else {
		labelStyle.font = [UIFont boldSystemFontOfSize:11.0];
		labelStyle.foreColor = [UIColor blackColor];
		widthArray = [[NSMutableArray alloc] initWithArray:_landscapeCellWidthArray];
		spaceArray = [[NSMutableArray alloc] initWithArray:_landscapeCellSpaceArray];
	}
	
	NSMutableArray* styleArray = [NSMutableArray new];
	
	for (int i = 0; i < [filterArray count]; ++i)
	{
		if (!isEnglish) {
			if (i ==0) {
				labelStyle.textAlign = UITextAlignmentLeft;
			}else {
				labelStyle.textAlign = UITextAlignmentCenter;
			}

		}
		CVLabelStyle *currentStyle = [labelStyle cloneOne];
		[styleArray addObject:currentStyle];
		[currentStyle release];
	}
	
	stockFormView.widthArray = widthArray;
	stockFormView.spaceArray = spaceArray;
	stockFormView.headerStyleArray = styleArray;
	[widthArray release];
	[spaceArray release];
	[styleArray release];
	[labelStyle release];
	
	//stockFormView.selfAdjust = YES;
	stockFormView.backgroundColor = [UIColor clearColor];
	// avoid drawing form with no data
	// FIXME controller of form shall check the data and determine whether
	//       it is 
	if (0 != [stockFormView.headerArray count] &&
		0 != [stockFormView.dataArray count])
	{
		[stockFormView illustrateAll];
	}
	
	return [stockFormView autorelease];
}

- (void)didScrollToPageAtIndex:(NSUInteger)index {
}

#pragma mark -
#pragma mark CVFormViewDelegate

- (void)didSelectRow:(int)row {
	NSArray *selectRowData;
	NSInteger selectIndex;
	
	selectIndex = _scrollPageController.pageControl.currentPage * STOCK_FORM_CONTENT_ROW + row;
	if (selectIndex < [_dataArray count]) {
		NSMutableDictionary *notificationDict;
		notificationDict = [[NSMutableDictionary alloc] initWithCapacity:1];
		[notificationDict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
		
		// get the code
		selectRowData = [_dataArray objectAtIndex:selectIndex];
		NSString *code;
		code = [selectRowData objectAtIndex:0];
		[notificationDict setObject:code forKey:@"code"];
		[notificationDict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
		
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:CVPortalSwitchPortalSetNotification object:[notificationDict autorelease]];
	}
}

#pragma mark -
#pragma mark CVCompositeIndexPortletViewDelegate


- (void)didCompositeIndexChanged:(NSDictionary *)compositeIndex {
	self.indexCode = [compositeIndex objectForKey:@"INDEX"];
	self.indexSymbol = [compositeIndex objectForKey:@"NAME"];
}
		

-(void)loadThread{
	//[self loadData];
	[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}
@end
