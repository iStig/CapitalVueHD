    //
//  CVFinancialSummaryIndicesViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVFinancialSummaryIndicesViewController.h"

#import "CVSetting.h"
#import "CVDataProvider.h"
#import "CVFinancialSummary.h"

@interface CVFinancialSummaryIndicesViewController()

@property (nonatomic, retain) NSDictionary *dictFromServer;
@property (nonatomic, retain) NSArray *arrayDataSource;
//@property (nonatomic, retain) UIButton *equityButton;
//@property (nonatomic, retain) UIButton *fundButton;
//@property (nonatomic, retain) UIButton *bondButton;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (void)loadData;

- (CGPoint)indicatorCenter:(UIInterfaceOrientation)orientation;

@end

@implementation CVFinancialSummaryIndicesViewController

@synthesize symbol;
@synthesize code;
@synthesize indicesType;
@synthesize chartView;

@synthesize dictFromServer;
@synthesize arrayDataSource;
@synthesize activityIndicator;
@synthesize valuedData = _valuedData;

- (id)init{
	
	if (self = [super init]) {
		_ifLoaded = YES;
		_valuedData = NO;
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	NSString *cfgFilePath;
	
    cfgFilePath = [[NSBundle mainBundle] pathForResource:@"LeadingIndicesChartConfig" ofType:@"plist"];
    chartView = [[cvChartView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) FormatFile:cfgFilePath];
    chartView.dataProvider = self;
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	
	// FIXME, the position of activity indicator should be caculated instead of be manually defined
	[self.view addSubview:activityIndicator];
	activityIndicator.center = [self indicatorCenter:[[UIApplication sharedApplication] statusBarOrientation]];
	activityIndicator.hidden = YES;
	
    [super viewDidLoad];
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
	[symbol release];
	[code release];
	[chartView release];
	[dictFromServer release];
	[arrayDataSource release];
    [super dealloc];
}

#pragma mark private methods
- (void)loadData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CVSetting *s;
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	NSDictionary *param;
	NSNumber *days;
	
	days = [[NSNumber alloc] initWithInteger:66];
	
	chartView.timeFrame = StockDataThreeMonths;
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	param = [[NSDictionary alloc] initWithObjectsAndKeys:days, @"days", code, @"code", nil];
	[days release];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingHomeFinancialSummary];
	paramInfo.parameters = param;
	if (CVFinancialSummaryTypeEquity == indicesType) {
		dict = [dp GetChartData:CVDataProviderChartTypeEquityIndices withParams:paramInfo];
	} else if (CVFinancialSummaryTypeFund == indicesType) {
		dict = [dp GetChartData:CVDataProviderChartTypeFundIndices withParams:paramInfo];
	} else {
		dict = [dp GetChartData:CVDataProviderChartTypeBondIndices withParams:paramInfo];
	}
	[paramInfo release];
	self.dictFromServer = dict;
	[param release];
	
	// convert arrray to recognizable array for chart
	NSArray *oldArray;
	NSMutableArray *newArray;
	NSMutableDictionary *oldDict, *newDict;
	
	oldArray = [dictFromServer objectForKey:@"data"];
	if (0 != [oldArray count]) {
		newArray = [[NSMutableArray alloc] initWithCapacity:1];
		//  the keys and values of an element of array
		//	CJJE = "348044000.0";
		//	CJL = "35062900.0";
		//	FSRQ = "2010-08-25 00:00:00";
		//	"ROUND(R.KPJ/1000,2)" = "10.06";
		//	"ROUND(R.SPJ/1000,2)" = "9.77";
		//	"ROUND(R.ZDJ/1000,2)" = "9.75";
		//	"ROUND(R.ZGJ/1000,2)" = "10.15";
		for (oldDict in oldArray) {
			NSNumber *numberValue;
			NSDate *dateValue;
			NSString *strValue;
			double doubleValue;
		
			newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
			// date
			strValue = [oldDict objectForKey:@"FSRQ"];
			if (strValue != nil) {
				NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
				[formatter setDateFormat:@"yyyy-MM-dd"];
			
				dateValue = [formatter dateFromString:strValue];
			
				[newDict setObject:dateValue forKey:@"date"];
				[formatter release];
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
			strValue = [oldDict objectForKey:@"ROUND(R.SPJ/1000,2)"];
			if (strValue != nil) {
				doubleValue = [strValue doubleValue];
				numberValue = [NSNumber numberWithDouble:doubleValue];
				[newDict setObject:numberValue forKey:@"CJL"];
			}
		
			[newArray addObject:newDict];
			[newDict release];
		}
		self.arrayDataSource = newArray;
		[newArray release];
		chartView.symbolName = symbol;
	}
	
	[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];
	
	[pool release];
}

-(void)afterLoadData{
	[activityIndicator stopAnimating];
	activityIndicator.hidden = YES;
	
	[self.view addSubview:chartView];
	[chartView.busyIndicator stopAnimating];
	[self adjustChartView:[[UIApplication sharedApplication] statusBarOrientation]];
	_ifLoaded = YES;
	if (self.arrayDataSource && [self.arrayDataSource count]>0) {
		_valuedData = YES;
	} else {
		_valuedData = NO;
	}
}

#pragma mark StockChartDataSourceDelegate
- (NSArray *)ChartGetRecordsByName:(NSString *)name Period:(StockDataTimeFrame_e)timeFrame {
	return arrayDataSource;
}

#pragma mark private methods
- (void)adjustChartView:(UIInterfaceOrientation)orientation {
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		[chartView resize:CGRectMake(0, 0, 356, 165)];
		activityIndicator.frame = CGRectMake((chartView.frame.size.width - activityIndicator.frame.size.width) / 2 , 
											 (chartView.frame.size.height - activityIndicator.frame.size.height) / 2 ,
											 activityIndicator.frame.size.width,
											 activityIndicator.frame.size.height);
	} else {
		[chartView resize:CGRectMake(0, 0, 445, 190)];
		activityIndicator.frame = CGRectMake((chartView.frame.size.width - activityIndicator.frame.size.width) / 2 , 
											 (chartView.frame.size.height - activityIndicator.frame.size.height) / 2 ,
											 activityIndicator.frame.size.width,
											 activityIndicator.frame.size.height);
	}
	
	activityIndicator.center = [self indicatorCenter:orientation];
}

- (void)reloadData {
	if (!_ifLoaded) {
		return;
	}
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		if (_valuedData) {
			return;
		}
	}
	_ifLoaded = NO;
	activityIndicator.hidden = NO;
	[activityIndicator startAnimating];
	[chartView removeFromSuperview];
	[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (CGPoint)indicatorCenter:(UIInterfaceOrientation)orientation{
	CGPoint point;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		point = CGPointMake(CVPORTLET_FINANCE_SUMMARY_PORTRAIT_WIDTH/2, CVPORTLET_FINANCE_SUMMARY_PORTRAIT_HEIGHT/2);
	} else {
		point = CGPointMake(CVPORTLET_FINANCE_SUMMARY_LANDSCAPE_WIDTH/2, CVPORTLET_FINANCE_SUMMARY_LANDSCAPE_HEIGHT/2);
	}
	return point;
}

@end
