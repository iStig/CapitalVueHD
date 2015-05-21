    //
//  CVStockSnapShotViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/7/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVStockSnapShotViewController.h"

#import "CVSetting.h"
#import "CVDataProvider.h"

#import "CVPortal.h"

@interface CVStockSnapShotViewController()

@property (nonatomic, retain) NSDictionary *dictFromServer;
@property (nonatomic, retain) NSArray *arrayDataSource;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (void)loadData;

@end

@implementation CVStockSnapShotViewController

@synthesize charView;
@synthesize code;
@synthesize symbol;
@synthesize price;
@synthesize desc;
@synthesize previousPrice;
@synthesize currentPrice;
@synthesize priceIndicator;
@synthesize goStockButton;
@synthesize goNewsButton;
@synthesize chartBackground;

@synthesize stockCode;
@synthesize strPostID;
@synthesize dictFromServer;
@synthesize arrayDataSource;
@synthesize activityIndicator;
@synthesize isNeedRefresh;

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
	NSString *cfgFilePath = [[NSBundle mainBundle] pathForResource:@"StockInTheNewsChart" ofType:@"plist"];
	UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 130)];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"stock_snapshot_background" ofType:@"png"];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	[imgv setImage:img];
	[img release];
	[self.view addSubview:imgv];
	self.chartBackground = imgv;
	[imgv release];
	
	UILabel *lblSymbol = [[UILabel alloc] initWithFrame:CGRectMake(7, 133, 222, 21)];
	lblSymbol.font = [UIFont systemFontOfSize:18];
	[self.view addSubview:lblSymbol];
	self.symbol = lblSymbol;
	[lblSymbol release];
	
	UILabel *lblCode = [[UILabel alloc] initWithFrame:CGRectMake(7, 153, 110, 21)];
	lblCode.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:lblCode];
	self.code = lblCode;
	[lblCode release];
	
	UILabel *lblClose = [[UILabel alloc] initWithFrame:CGRectMake(178, 152, 51, 21)];
	lblClose.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:lblClose];
	self.price = lblClose;
	[lblClose release];
	
	UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(7, 171, 233, 45)];
	lblDesc.numberOfLines = 2;
	lblDesc.font = [UIFont systemFontOfSize:12];
	[self.view addSubview:lblDesc];
	self.desc = lblDesc;
	[lblDesc release];

	
	cvChartView *cvchch = [[cvChartView alloc] initWithFrame:CGRectMake(5, 5, 0, 0) FormatFile:cfgFilePath];
	[imgv addSubview:cvchch];
	cvchch.dataProvider = self;
	self.charView = cvchch;
	[cvchch release];
	
	UIImageView *indi = [[UIImageView alloc] initWithFrame:CGRectMake(165, 156, 8, 14)];
	indi.image = nil;
	[self.view addSubview:indi];
	self.priceIndicator = indi;
	[indi release];

	
//	[self.view insertSubview:charView atIndex:1];
	
	
	self.goNewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	goNewsButton.frame = CGRectMake(10, 170, 220, 35);
	goNewsButton.backgroundColor = [UIColor clearColor];
	[goNewsButton addTarget:self action:@selector(goNews) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:goNewsButton];
	
	self.goStockButton = [UIButton buttonWithType:UIButtonTypeCustom];
	goStockButton.frame = CGRectMake(10, 10, 220, 160);
	goStockButton.backgroundColor = [UIColor clearColor];
	[goStockButton addTarget:self action:@selector(goMyStock) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:goStockButton];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 5,
										 self.view.frame.size.height / 2 - 35,
										 activityIndicator.frame.size.width, 
										 activityIndicator.frame.size.height);
	[self.view addSubview:activityIndicator];
	[activityIndicator release];
	[activityIndicator startAnimating];
	activityIndicator.hidden = NO;
	
	
	[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    [super viewDidLoad];
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
	charView.dataProvider = nil;
	[charView release];
	[code release];
	[symbol release];
	[price release];
	[desc release];
	[priceIndicator release];
	
	[goStockButton removeFromSuperview];
	[goStockButton release];
	[goNewsButton removeFromSuperview];
	[goNewsButton release];
	[chartBackground release];
	
	[stockCode release];
	[strPostID release];
	[dictFromServer release];
	[arrayDataSource release];
    [super dealloc];
}

#pragma mark private methods
- (void)loadData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	assert(stockCode!=nil);
	
	CVSetting *s;
	CVDataProvider *dp;
	
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	NSMutableDictionary *param;
	NSNumber *days;
	
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	
	days = [[NSNumber alloc] initWithInteger:22];
	param = [[NSMutableDictionary alloc] init];
	[param setObject:days forKey:@"days"];
	[param setObject:self.stockCode forKey:@"code"];
	[days release];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingHomeStockInTheNews];
	paramInfo.parameters = param;
	
	if (isNeedRefresh) {
		dict = [dp ReGetChartData:CVDataProviderChartTypeStock withParams:paramInfo];
	}else {
		dict = [dp GetChartData:CVDataProviderChartTypeStock withParams:paramInfo];
	}
	
	self.dictFromServer = dict;
	[paramInfo release];
	[param release];
	
	// convert arrray to recognizable array for chart
	NSArray *oldArray;
	NSMutableArray *newArray;
	NSMutableDictionary *oldDict, *newDict;
	
	oldArray = [dictFromServer objectForKey:@"data"];
	newArray = [[NSMutableArray alloc] initWithCapacity:1];
	//  the keys and values of an element of array
	//	CJJE = "348044000.0";
	//	CJL = "35062900.0";
	//	FSRQ = "2010-08-25 00:00:00";
	//	"ROUND(R.KPJ/1000,2)" = "10.06";
	//	"ROUND(R.SPJ/1000,2)" = "9.77";
	//	"ROUND(R.ZDJ/1000,2)" = "9.75";
	//	"ROUND(R.ZGJ/1000,2)" = "10.15";
	
	//add space value for stock that has not enough data
	if ([oldArray count] > 0){
		NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:1];
		[temp addObjectsFromArray:oldArray];
		
		NSDictionary *lastDictionary = [oldArray lastObject];
		NSString *strLastDate = [lastDictionary objectForKey:@"FSRQ"];
		
		NSTimeZone *zone;
		zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone:zone];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSDate *lastDate = [dateFormatter dateFromString:strLastDate];
		[dateFormatter release];
		
		NSTimeInterval lastTimeInterval = [lastDate timeIntervalSince1970];//GMT +8
		NSInteger numAdded = 22 - [oldArray count];
		
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
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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
			[temp addObject:tempDic];
			[tempDic release];
		}
		oldArray = [NSArray arrayWithArray:temp];
		[temp release];
		self.charView.nonIntraInvalidNum = numAdded;
	}else {
		self.charView.nonIntraInvalidNum = 0;
	}
	
	
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
			[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			
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
		strValue = [oldDict objectForKey:@"CJL"];
		if (strValue != nil) {
			doubleValue = [strValue doubleValue];
			numberValue = [NSNumber numberWithDouble:doubleValue];
			[newDict setObject:numberValue forKey:@"volume"];
		}
		
		[newArray addObject:newDict];
		[newDict release];
	}
	self.arrayDataSource = newArray;
	[newArray release];
	if (0 != [arrayDataSource count]) {
		[self performSelectorOnMainThread:@selector(showChart) withObject:nil waitUntilDone:NO];
	}
	[activityIndicator stopAnimating];
	activityIndicator.hidden = YES;
	
	[pool release];
}

-(void)showChart{
	[charView defineSymbolName:symbol.text timeFrame:StockDataOneMonth] ;
}

-(void)adjustDescLabel{
	NSString *theText = desc.text;
	CGSize labelSize = desc.frame.size;
	CGSize theStringSize = [theText sizeWithFont:desc.font constrainedToSize:labelSize lineBreakMode:desc.lineBreakMode];
	desc.frame = CGRectMake(desc.frame.origin.x, desc.frame.origin.y, theStringSize.width, theStringSize.height);
	desc.text = theText;
}

#pragma mark StockChartDataSourceDelegate
- (NSArray *)ChartGetRecordsByName:(NSString *)name Period:(StockDataTimeFrame_e)timeFrame {
//	NSLog(@"%@", arrayDataSource);
	return arrayDataSource;
}

/*
 * It responds the tapping and switches to the portalset of my stock
 * where detail of stock is shown.
 *
 * @param: sender - the obj recieves the event of tap. Here is the goMyStockButton.
 * @return: none
 */
- (void)goMyStock{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:stockCode forKey:@"code"];
	[dict setObject:[NSNumber numberWithInt:5] forKey:@"Number"];
	[dict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];

	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
	[dict release];
}

/*
 * It responds the tapping and switches to the portalset of news
 * where detail of stock is shown.
 *
 * @param: sender - the obj recieves the event of tap. Here is the goNewsButton.
 * @return: none
 */
- (void)goNews{
	CVDataProvider *dp;
	NSDictionary *dictNews;
	
	dp = [CVDataProvider sharedInstance];
	dictNews = [dp GetNewsDetail:strPostID];
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[NSNumber numberWithInt:4] forKey:@"Number"];
	if (dictNews) {
		[dict setObject:dictNews forKey:@"dictContent"];
	}
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict/*[NSNumber numberWithInt:4]*/];
	[dict release];
}

@end
