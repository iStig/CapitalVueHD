    //
//  CVCompositeIndexPortletViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/13/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVCompositeIndexPortletViewController.h"

#import "CVDataProvider.h"
#import "CVSetting.h"

#import "CVCompositeIndexItemView.h"

#import "BMVITranslator.h"
#import "CVPortal.h"

@interface CVCompositeIndexPortletViewController()

@property (nonatomic, retain) AFOpenFlowView *_openFlowView;
@property (nonatomic, retain) UILabel *_currentIndexLabel;
@property (nonatomic, retain) UIActivityIndicatorView *_activityIndicator;

/*
 * an array carries summary of each composite index, of which are 
 * name, country, colose index, turnover, date, abbreviation,
 * volume, change, range, index code, latest data date and oldest data date.
 */
@property (nonatomic, retain) NSArray *_indexSummaryArray;
@property (nonatomic, retain) NSDictionary *_indexSummaryKeys;

/*
 * it loads the data of index summary
 *
 * @param: none
 * @return: none
 */
- (void)loadData;

/*
 * it returns the size of open cover flow in accordance with the device orientation
 *
 * @param: orientaion - the device orientation
 * @return: the size
 */
- (CGRect)openCoverFlowSize:(UIInterfaceOrientation)orientation;

/*
 * it configure the properties of the cover flow
 *
 * @param: array - composite index summary array, each of which corresponds
 *                 to an item of the cover flow.
 * @return: none
 */
- (void)setFlowArray:(NSArray *)array;

/*
 * it loads the chart data of all composite index
 */
- (void)loadChartData;

/**
 * After load data
 *
 */
- (void)afterLoadData;

@end

#define COVER_FLOW_INITAL_PAGE 5

@implementation CVCompositeIndexPortletViewController

@synthesize delegate;

@synthesize _openFlowView;
@synthesize _currentIndexLabel;
@synthesize _activityIndicator;

@synthesize _indexSummaryArray;
@synthesize _indexSummaryKeys;

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
    [super viewDidLoad];
	_hasLoaded = YES;
	_loadingViewLock = [[NSLock alloc] init];
	
	_currentIndex = COVER_FLOW_INITAL_PAGE;//当前显示的openflow页
	
	CGRect rect;
	AFOpenFlowView *flowView;
	
	rect = [self openCoverFlowSize:[[UIApplication sharedApplication] statusBarOrientation]];
	flowView = [[AFOpenFlowView alloc] initWithFrame:rect];
	flowView.dataSource = self;
	flowView.viewDelegate = self;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"portlet_cover_default_background.png" ofType:nil];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	flowView.defaultImage = img;
	[img release];
	self._openFlowView = flowView;
	[self.view addSubview:_openFlowView];
	[flowView release];
	
	_indexDict = [NSMutableDictionary new];
		
	UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activity.frame = CGRectMake(rect.size.width / 2 - 7, 
								rect.size.height / 2 - 7, 
								activity.frame.size.width, 
								activity.frame.size.height);
	self._activityIndicator = activity;
	_activityIndicator.hidesWhenStopped = YES;
	[self.view addSubview:_activityIndicator];
	[activity release];
	
	//[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:NO];
	
	CVSetting *s;
	CVDataProvider *dp;
	dp = [CVDataProvider sharedInstance];
	s = [CVSetting sharedInstance];
	[dp setDataIdentifier:@"MarketCompositeIndex" lifecycle:[s cvCachedDataLifecycle:CVSettingMarketCompositeIndex]];
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
	[_loadingViewLock release];
	[_openFlowView release];
	[_activityIndicator release];
	
	[_indexSummaryArray release];
	[_indexSummaryKeys release];
	
	[_loadingViewLock release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark private method
/*
 * it loads the data of index summary
 *
 * @param: none
 * @return: none
 */
- (void)loadData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_hasLoaded = NO;
	
	CVSetting *s;
	CVDataProvider *dp;
	NSDictionary *dictionary;
	CVParamInfo *paramInfo;
	
	s = [CVSetting sharedInstance];
	
	dp = [CVDataProvider sharedInstance];
	
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingMarketCompositeIndex];
	dictionary = [dp ReGetCompositeIndexList:CVDataProviderCompositeIndexTypeSummary withParams:paramInfo];
	[paramInfo release];
	
	self._indexSummaryKeys = [dictionary objectForKey:@"head"];
	self._indexSummaryArray = [dictionary objectForKey:@"data"];
	if (self._indexSummaryArray && [self._indexSummaryArray count]>0) {
		_valuedData = YES;
	} else {
		_valuedData = NO;
	}

	[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];


	[pool release];
}

- (void)afterLoadData{
	[self setFlowArray:_indexSummaryArray];
	[self loadChartData];
	
	[_activityIndicator stopAnimating];
	_activityIndicator.hidden = YES;
	
	_openFlowView.hidden = NO;
	
	_hasLoaded = YES;
}


/*
 * it loads the chart data of all composite index
 */
- (void)loadChartData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CVSetting *s;
	
	CVDataProvider *dataProvider;
	CVParamInfo *paramInfo;
	NSArray *multipleIndexChartDataArray;
	NSDictionary *charData;
	NSDictionary *summary;
	NSMutableString *strCodes;
	NSUInteger i, count;
	
	s = [CVSetting sharedInstance];
	
	strCodes = [[[NSMutableString alloc] init] autorelease];
	count = [_indexSummaryArray count];
	for (i = 0; i < count; i++) {
		NSString *code;
		summary = [_indexSummaryArray objectAtIndex:i];
		code = [summary objectForKey:@"指数代码"];
		if ((count - 1) == i) {
			[strCodes appendFormat:@"%@", code];
		} else {
			[strCodes appendFormat:@"%@,", code];
		}
	}
	
	NSDictionary *parameters = [[[NSDictionary alloc] initWithObjectsAndKeys:strCodes, @"code", @"5", @"days",nil] autorelease];
	
	dataProvider = [CVDataProvider sharedInstance];
	paramInfo = [[[CVParamInfo alloc] init] autorelease];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingMarketCompositeIndex];
	paramInfo.parameters = parameters;
	charData = [dataProvider GetChartData:CVDataProviderChartTypeMultipleIndex withParams:paramInfo];
	
	multipleIndexChartDataArray = [charData objectForKey:@"data"];
	
	CVCompositeIndexItemView *itemView;
	
	for (i = 0; i < count; i++) {
		NSString *code;
		NSDictionary *charDataDict;
		NSMutableArray *array;
		
		summary = [_indexSummaryArray objectAtIndex:i];
		code = [summary objectForKey:@"指数代码"];
		array = [[NSMutableArray alloc] initWithCapacity:1];
		for (charDataDict in multipleIndexChartDataArray) {
			NSString *dictCode;
			dictCode = [charDataDict objectForKey:@"ZSDM"];
			if ([code isEqualToString:dictCode]) {
				[array addObject:charDataDict];
			}
		}
		
		// arrange the data array for a composite index
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CVCompositeIndexItemView" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[CVCompositeIndexItemView class]]) {
				itemView =  (CVCompositeIndexItemView *) currentObject;
				itemView.autoresizesSubviews = NO;
				itemView.autoresizingMask = UIViewAutoresizingNone;
				break;
			}
		}
			
		// set the labels of view
		itemView.backgroundColor = [UIColor clearColor];
			
		// modify the string contains "INDEX", which shall be
		// remvoed
		NSMutableString *dictIndexName;
		dictIndexName = [summary objectForKey:@"指数简称"];
		
		itemView.nameLabel.text = dictIndexName;
		itemView.dateValueLabel.text = [summary objectForKey:@"当日日期"];
		NSString *change = [summary objectForKey:@"当日涨跌幅"];
		itemView.changeValueLabel.text = change;
		CGFloat x = [change floatValue];
		if (x > 0.00f) {
			itemView.isGainer = YES;
			NSString *path = [[NSBundle mainBundle] pathForResource:@"coverflow_snapshot_arrow_upward.png" ofType:nil];
			UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
			itemView.arrowImageView.image = img;
			[img release];
		} else {
			itemView.isGainer = NO;
			NSString *path = [[NSBundle mainBundle] pathForResource:@"coverflow_snapshot_arrow_downward.png" ofType:nil];
			UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
			itemView.arrowImageView.image = img;
			[img release];
		}
		
		itemView.closeLabel.text = [_indexSummaryKeys objectForKey:@"最新收盘价"];
		itemView.closeValueLabel.text = [summary objectForKey:@"最新收盘价"];
		itemView.volumenLabel.text = [_indexSummaryKeys objectForKey:@"最新成交量"];
		itemView.volumenValueLabel.text = [summary objectForKey:@"最新成交量"];
		itemView.rangeLabel.text = [_indexSummaryKeys objectForKey:@"日波动"];
		itemView.rangeValueLabel.text = [summary objectForKey:@"日波动"];
		itemView.turnoverLabel.text = [_indexSummaryKeys objectForKey:@"最新成交额"];
		itemView.turnoverValueLabel.text = [summary objectForKey:@"最新成交额"];
			
			
		// draw the chart and generate the image
		UIImage *chartView;
		BMVITranslator *viConv;
		if (nil == array || 0 == [array count]) {
			NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_cover_default_background.png" ofType:nil];
			chartView = [[UIImage alloc] initWithContentsOfFile:pathx];
			[_openFlowView setImage:chartView forIndex:i];
			[chartView release];
		} else {
			itemView.indexArray = array;
			viConv = [[BMVITranslator alloc] init];
			chartView = [viConv imageFromView:itemView];
			[_openFlowView setImage:chartView forIndex:i];
			[viConv release];
		}
		[array release];
	}
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]){
		for (i=0;i<10;i++){
				NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_cover_default_background.png" ofType:nil];
				UIImage *chartView = [[UIImage alloc] initWithContentsOfFile:pathx];
				[_openFlowView setImage:chartView forIndex:i];
				[chartView release];
			}
	}
	
	[pool release];
}

/*
 * it returns the size of open cover flow in accordance with the device orientation
 *
 * @param: orientaion - the device orientation
 * @return: the size
 */
- (CGRect)openCoverFlowSize:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(0, 0, CVPORTALET_MARKET_COMPOSITE_INDEX_PORTRAIT_WIDTH, CVPORTALET_MARKET_COMPOSITE_INDEX_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(0, 0, CVPORTALET_MARKET_COMPOSITE_INDEX_LANDSCAPE_WIDTH, CVPORTALET_MARKET_COMPOSITE_INDEX_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}


/*
 * it configure the properties of the cover flow
 *
 * @param: array - composite index summary array, each of which corresponds
 *                 to an item of the cover flow.
 * @return: none
 */
- (void)setFlowArray:(NSArray *)array {
	
	[_openFlowView setNumberOfImages:[array count]];
	
	if (array && [array count] > 0 )
	{
		_currentIndex = MIN([array count] - 1, _currentIndex);
		NSDictionary *summary = [array objectAtIndex:_currentIndex];
		if (summary != nil) {
			_currentIndexLabel.text = [summary objectForKey:@"指数简称"];
			NSMutableDictionary *titleOfMostActive;
			NSString *value;
			
			titleOfMostActive = [[NSMutableDictionary alloc] initWithCapacity:1];
			
			value = [summary objectForKey:@"指数简称"];
			if (nil != value)
				[titleOfMostActive setObject:value forKey:@"NAME"];
			value = [summary objectForKey:@"指数代码"];
			if (nil != value)
				[titleOfMostActive setObject:value forKey:@"INDEX"];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"MarketCoverflowCodeChanged" object:nil userInfo:titleOfMostActive];
			[delegate didCompositeIndexChanged:titleOfMostActive];
			[titleOfMostActive release];
		} else  {
			_currentIndexLabel.text = @"";
			[[NSNotificationCenter defaultCenter] postNotificationName:@"MarketCoverflowCodeChanged" object:nil userInfo:nil];
			[delegate didCompositeIndexChanged:nil];
		}
		[_openFlowView setSelectedCover:_currentIndex];
		[_openFlowView centerOnSelectedCover:NO];
	} else {
		[_openFlowView setNumberOfImages:13];
		[_openFlowView setSelectedCover:6];
		[_openFlowView centerOnSelectedCover:NO];
		_currentIndexLabel.text = @"";
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MarketCoverflowCodeChanged" object:nil userInfo:nil];
		[delegate didCompositeIndexChanged:nil];
	}
	
}


#pragma mark -
#pragma mark AFOpenFlowViewDelegate
- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {
	NSDictionary *summary = [_indexSummaryArray objectAtIndex:index];
	_currentIndex = index;
	if (summary != nil) {
        
        NSLog(@"%@",[summary objectForKey:@"指数简称"]);
		_currentIndexLabel.text = [summary objectForKey:@"指数简称"];//没什么用；
		
		NSMutableDictionary *titleOfMostActive;
		NSString *value;
		titleOfMostActive = [[NSMutableDictionary alloc] initWithCapacity:1];
		
		value = [summary objectForKey:@"指数名称"];
        NSLog(@"%@",[summary objectForKey:@"指数名称"]);
		if (nil != value)
			[titleOfMostActive setObject:value forKey:@"NAME"];
		value = [summary objectForKey:@"指数代码"];
		if (nil != value)
			[titleOfMostActive setObject:value forKey:@"INDEX"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MarketCoverflowCodeChanged" object:nil userInfo:titleOfMostActive];
		[delegate didCompositeIndexChanged:titleOfMostActive];
		[titleOfMostActive release];
	} else  {
		_currentIndexLabel.text = @"";
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MarketCoverflowCodeChanged" object:nil userInfo:nil];
		[delegate didCompositeIndexChanged:nil];
	}
}


- (void)openFlowView:(AFOpenFlowView *)openFlowView didWannaCheckIndex:(int)index {


	// none
	NSMutableDictionary *notificationDict;
	notificationDict = [[NSMutableDictionary alloc] initWithCapacity:1];
	[notificationDict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
	
	// get the code
	NSDictionary *summary = [_indexSummaryArray objectAtIndex:index];
	if (!summary){
		[notificationDict release];
		return;
	}
		
	NSString *code;
	NSString *name;
	
	code = [summary objectForKey:@"指数代码"];
	name = [summary objectForKey:@"指数简称"];
	if (code) 
		[notificationDict setObject:code forKey:@"code"];
	if (name)
		[notificationDict setObject:name forKey:@"name"];
	[notificationDict setObject:[NSNumber numberWithBool:NO] forKey:@"isEquity"];
	
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:[notificationDict autorelease]];
}


#pragma mark -
#pragma mark AFOpenFlowViewDataSource

- (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index {
    
}

- (UIImage *)defaultImage {
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_cover_default_background.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	return [image autorelease];
}

#pragma mark -
#pragma mark CVChartDataCache delegate
- (void)didRecievedData:(NSDictionary *)dictionary forIdentifier:(NSString *)identifier {
	int index;
	CVCompositeIndexItemView *itemView;
	NSDictionary *summary;
	
	index = [[_indexDict objectForKey:identifier] intValue];
	[_indexDict removeObjectForKey:identifier];
	
	summary = [_indexSummaryArray objectAtIndex:index];
	// allocate a snap view of news
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CVCompositeIndexItemView" owner:self options:nil];
	
	for (id currentObject in topLevelObjects){
		if ([currentObject isKindOfClass:[CVCompositeIndexItemView class]]) {
			itemView =  (CVCompositeIndexItemView *) currentObject;
			itemView.autoresizesSubviews = NO;
			itemView.autoresizingMask = UIViewAutoresizingNone;
			break;
		}
	}
	
	// set the labels of view
	itemView.backgroundColor = [UIColor clearColor];
	
	// modify the string contains "INDEX", which shall be
	// remvoed
	NSMutableString *dictIndexName, *labelIndexName;
	dictIndexName = [summary objectForKey:@"指数简称"];
	labelIndexName = [[NSMutableString alloc] initWithCapacity:1];
	
	itemView.nameLabel.text = dictIndexName;
	[labelIndexName release];
	
	itemView.dateValueLabel.text = [summary objectForKey:@"当日日期"];
	NSString *change = [summary objectForKey:@"当日涨跌幅"];
	itemView.changeValueLabel.text = change;
	
	CGFloat x = [change floatValue];
	if (x > 0.00f) {
		itemView.isGainer = YES;
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"coverflow_snapshot_arrow_upward.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		itemView.arrowImageView.image = imgx;
		[imgx release];
	} else {
		itemView.isGainer = NO;
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"coverflow_snapshot_arrow_downward.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		itemView.arrowImageView.image = imgx;
		[imgx release];
	}
	
	itemView.closeLabel.text = [_indexSummaryKeys objectForKey:@"最新收盘价"];
	itemView.closeValueLabel.text = [summary objectForKey:@"最新收盘价"];
	itemView.volumenLabel.text = [_indexSummaryKeys objectForKey:@"最新成交量"];
	itemView.volumenValueLabel.text = [summary objectForKey:@"最新成交量"];
	itemView.rangeLabel.text = [_indexSummaryKeys objectForKey:@"日波动"];
	itemView.rangeValueLabel.text = [summary objectForKey:@"日波动"];
	itemView.turnoverLabel.text = [_indexSummaryKeys objectForKey:@"最新成交额"];
	itemView.turnoverValueLabel.text = [summary objectForKey:@"最新成交额"];
	
	NSArray *array;
	array = [dictionary objectForKey:@"data"];
	BMVITranslator *viConv;
	UIImage *chartView;
	
	if (nil == array || 0 == [array count]) {
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_cover_default_background.png" ofType:nil];
		chartView = [[UIImage alloc] initWithContentsOfFile:pathx];
	} else {
		itemView.indexArray = [dictionary objectForKey:@"data"];
		viConv = [[BMVITranslator alloc] init];
		chartView = [[viConv imageFromView:itemView] retain];
		[viConv release];
	}
	[_loadingViewLock lock];
	[_openFlowView setImage:chartView forIndex:index];
	[chartView release];
	[_loadingViewLock unlock];
}

- (void)didRunIntoError:(NSError *)error forIdentifier:(NSString *)identifier {
	//nothing to do here
}

#pragma mark -
#pragma mark public method
- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	rect = [self openCoverFlowSize:orientation];
	_openFlowView.frame = rect;
	_openFlowView.bounds = rect;
	_activityIndicator.frame = CGRectMake(rect.size.width / 2 - 7, 
								rect.size.height / 2 - 7, 
								_activityIndicator.frame.size.width, 
								_activityIndicator.frame.size.height);
}

- (void)reloadData {
	if (!_hasLoaded) {
		return;
	}
	BOOL isReachAble = [[CVSetting sharedInstance] isReachable];
	if (!isReachAble) {
		//if there has valued data , but network is not Reachable,so remain the original status
		//if no valued data,so show default images
		if (!_valuedData) {
			[self setFlowArray:nil];
		}
		return;
	}
	
	CVDataProvider *dp;
	dp = [CVDataProvider sharedInstance];
	BOOL isNeedReGet = NO;
	
	if (_valuedData) {
		if ([dp isDataExpired:@"MarketCompositeIndex"]) {
			isNeedReGet = YES;
		}
	}else {
		isNeedReGet = YES;
	}

	if (isNeedReGet) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kReloadMarketData object:nil userInfo:nil];
		[_activityIndicator startAnimating];
		_activityIndicator.hidden = NO;
		_openFlowView.hidden = YES;
		[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
	}
}

@end
