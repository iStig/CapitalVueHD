//
//  CVSnapshotContentView.m
//  CapitalVueHD
//
//  Created by leon on 10-10-20.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVSnapshotContentView.h"
#import "CVPortal.h"

#import "CVSetting.h"
#import "CVDataProvider.h"

@interface CVSnapshotContentView ()

- (void)loadChartData;
- (void)changeIndicator:(NSNumber *)action;

@end

@implementation CVSnapshotContentView

@synthesize labelCode;
@synthesize labelCompany;
@synthesize labelOpen;
@synthesize labelOpenValue;
@synthesize labelHigh;
@synthesize labelHighValue;
@synthesize labelPriorClose;
@synthesize labelPriorCloseValue;
@synthesize labelLow;
@synthesize labelLowValue;
@synthesize labelPETTM;
@synthesize labelPETTMValue;
@synthesize labelPELastyr;
@synthesize labelPELastyrValue;
@synthesize labelPBMRQ;
@synthesize labelPBMRQValue;
@synthesize labelTotalAShares;
@synthesize labelTotalASharesValue;
@synthesize labelVolume;
@synthesize labelVolumeValue;
@synthesize labelTurnover;
@synthesize labelTurnoverValue;
@synthesize labelLatest;
@synthesize labelLatestValue;
@synthesize labelChange;
@synthesize labelChangeValue;
@synthesize labelChangePercent;
@synthesize labelChangePercentValue;

@synthesize chartBackground;
@synthesize goMyStockButton;

@synthesize strCode = _strCode;
@synthesize arrayDataSource = _arrayDataSource;
@synthesize dictFromServer = _dictFromServer;

#define NEWS_SNAPSHOT_DEFAULT_CODE @"000300"

-(void)createLabel {
	NSString *cfgFilePath = [[NSBundle mainBundle] pathForResource:@"SnapshotChart" ofType:@"plist"];
	
	charView = [[cvChartView alloc] initWithFrame:CGRectMake(24, 68, 0, 0) FormatFile:cfgFilePath];
	charView.dataProvider = self;
	
	[self addSubview:charView];
	
	[self performSelector:@selector(loadData) withObject:nil afterDelay:0.4];
	[self bringSubviewToFront:goMyStockButton];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityIndicator setHidesWhenStopped:YES];
	CGRect activityFrame = CGRectMake(self.frame.size.width/2-20, 
									  self.frame.size.height/2- 20, 
									  40, 40);
	activityIndicator.frame = activityFrame;
	[self addSubview:activityIndicator];
	[activityIndicator startAnimating];
}


- (IBAction)clickCode:(id)sender {
	if ([labelCode.text isEqualToString:@"-- --"])
		return;
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[NSNumber numberWithInt:5] forKey:@"Number"];
	if ([labelCode.text isEqualToString:@"CSI 300"]) {
		[dict setObject:labelCode.text forKey:@"name"];
		[dict setObject:NEWS_SNAPSHOT_DEFAULT_CODE forKey:@"code"];
		[dict setObject:[NSNumber numberWithBool:NO] forKey:@"isEquity"];
	} else {
		[dict setObject:labelCode.text forKey:@"code"];
		[dict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
	}

	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setButtonImage" object:nil];
		
	[dict release];
}

-(void)loadData{
	CVSetting *s;
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	if (!_strCode) {
		NSDictionary *titleDict, *valueDict;
		NSArray *dataArray;
		
		paramInfo = [[CVParamInfo alloc] init];
		paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingNewsSnapshot];
		paramInfo.parameters = NEWS_SNAPSHOT_DEFAULT_CODE;
		dict = [dp GetIndexLatestPrice:paramInfo];
		[paramInfo release];
		
		titleDict = [dict objectForKey:@"head"];
		dataArray = [dict objectForKey:@"data"];
		if ([dataArray count] > 0) {
			valueDict = [dataArray objectAtIndex:0];
		} else {
			valueDict = nil;
			return;
		}
		
		NSString *strTemp;
		double doubleTemp;
		
		labelLatest.text = [titleDict objectForKey:@"SPJ"];
		strTemp = [valueDict objectForKey:@"SPJ"];
		strTemp = [[NSString alloc] initWithFormat:@"%ld", [strTemp integerValue]/1000];
		labelLatestValue.text = strTemp;
		[strTemp release];
		
		NSString *colorPath = [[NSBundle mainBundle] pathForResource:@"IndustryColorDefine.plist" ofType:nil];
		NSDictionary *colorDict = [[NSDictionary alloc] initWithContentsOfFile:colorPath];
		NSArray *upArray = [[colorDict objectForKey:@"GainersRateLabelColor"] componentsSeparatedByString:@","];
		NSArray *downArray = [[colorDict objectForKey:@"LosersRateLabelColor"] componentsSeparatedByString:@","];
		
		UIColor *posColor = [UIColor colorWithRed:[[upArray objectAtIndex:0] floatValue] green:[[upArray objectAtIndex:1] floatValue] blue:[[upArray objectAtIndex:2] floatValue] alpha:[[upArray objectAtIndex:3] floatValue]];
		UIColor *negColor = [UIColor colorWithRed:[[downArray objectAtIndex:0] floatValue] green:[[downArray objectAtIndex:1] floatValue] blue:[[downArray objectAtIndex:2] floatValue] alpha:[[downArray objectAtIndex:3] floatValue]];
		
		
		
		strTemp = [valueDict objectForKey:@"CHANGE"];
		doubleTemp = [strTemp doubleValue];
		if (doubleTemp > 0.0) {
			labelChangeValue.textColor = posColor;
			labelChangePercentValue.textColor = posColor;
		} else if (doubleTemp == 0.0) {
			labelChangeValue.textColor = [UIColor whiteColor];
			labelChangePercentValue.textColor = [UIColor whiteColor];
		} else {
			labelChangeValue.textColor = negColor;
			labelChangePercentValue.textColor = negColor;
		}
		[colorDict release];
		labelChange.text = [titleDict objectForKey:@"CHANGE"];
		if (doubleTemp > 0) {
			strTemp = [[NSString alloc] initWithFormat:@"%.2lf", doubleTemp / 1000];
		} else {
			strTemp = [[NSString alloc] initWithFormat:@"%.2lf", doubleTemp / 1000];
		}
		labelChangeValue.text = strTemp;
		[strTemp release];
		
		strTemp = [valueDict objectForKey:@"CHANGE_PERCENT"];
		if ([strTemp floatValue] > 0) {
			strTemp = [[NSString alloc] initWithFormat:@"%@%%", strTemp];
		} else {
			strTemp = [[NSString alloc] initWithFormat:@"%@%%", strTemp];
		}
		labelChangePercent.text = [titleDict objectForKey:@"CHANGE_PERCENT"];
		labelChangePercentValue.text = strTemp;
		[strTemp release];
		
		labelOpen.text = [titleDict objectForKey:@"KPJ"];
		strTemp = [valueDict objectForKey:@"KPJ"];
		doubleTemp = [strTemp doubleValue];
		strTemp = [[NSString alloc] initWithFormat:@"%.2lf", doubleTemp / 1000];
		labelOpenValue.text = strTemp;
		[strTemp release];
		
		labelPriorClose.text = [titleDict objectForKey:@"ZSP"];
		strTemp = [valueDict objectForKey:@"ZSP"];
		doubleTemp = [strTemp doubleValue];
		strTemp = [[NSString alloc] initWithFormat:@"%.2lf", doubleTemp / 1000];
		labelPriorCloseValue.text = strTemp;
		[strTemp release];
		
		labelHigh.text = [titleDict objectForKey:@"ZGJ"];
		strTemp = [valueDict objectForKey:@"ZGJ"];
		doubleTemp = [strTemp doubleValue];
		strTemp = [[NSString alloc] initWithFormat:@"%.2lf", doubleTemp / 1000];
		labelHighValue.text = strTemp;
		[strTemp release];
		
		labelLow.text = [titleDict objectForKey:@"ZDJ"];
		strTemp = [valueDict objectForKey:@"ZDJ"];
		doubleTemp = [strTemp doubleValue];
		strTemp = [[NSString alloc] initWithFormat:@"%.2lf", doubleTemp / 1000];
		labelLowValue.text = strTemp;
		[strTemp release];
		
		labelVolume.text = [titleDict objectForKey:@"CJL"];
		strTemp = [valueDict objectForKey:@"CJL"];
		labelVolumeValue.text = [NSString stringWithFormat:@"%ld", [strTemp intValue]];
		labelTurnover.text = [titleDict objectForKey:@"CJJE"];
		strTemp = [valueDict objectForKey:@"CJJE"];
		labelTurnoverValue.text = [NSString stringWithFormat:@"%ld", [strTemp intValue]];
		
		labelCode.text = @"CSI 300";
		labelCompany.text = nil;
	} else {
		NSMutableString *param = [[NSMutableString alloc] init];
		[param appendString:_strCode];
		
		paramInfo = [[CVParamInfo alloc] init];
		paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingNewsSnapshot];
		paramInfo.parameters = param;
	
		dict = [dp GetMyStockDetail:CVDataProviderMyStockDetailTypeStock withParams:paramInfo];
		[self getData:dict];
		
		[param release];
		[paramInfo release];
	}
	
	[self loadChartData];
	[self changeIndicator:[NSNumber numberWithFloat:NO]];
}

/*
 * it fills the view of equity
 *
 * 
 */
-(void)getData:(NSDictionary *)dict {
	NSDictionary *titleDict, *valueDict;
	NSArray *dataArray;
	titleDict = [dict objectForKey:@"head"];
	
	dataArray = [dict objectForKey:@"data"];
	if ([dataArray count] > 0) {
		valueDict = [dataArray objectAtIndex:0];
	} else {
		valueDict = nil;
		return;
	}
	
	NSString *Code = [valueDict valueForKey:@"GPDM"];
	NSString *Latest = [valueDict valueForKey:@"SP"];
	NSString *Change = [valueDict valueForKey:@"ZF"];
	NSString *ChangePercent = [valueDict valueForKey:@"ZDF"];
	NSString *Open = [valueDict valueForKey:@"KP"];
	NSString *High = [valueDict valueForKey:@"ZG"];
	NSString *PETTM = [valueDict valueForKey:@"TTM"];
	NSString *PELastyr = [valueDict valueForKey:@"LYR"];
	NSString *Volumn = [valueDict valueForKey:@"CJL"];
	NSString *PriorClose = [valueDict valueForKey:@"ZS"];
	NSString *Low = [valueDict valueForKey:@"ZD"];
	NSString *PBMRQ = [valueDict valueForKey:@"MRQ"];
	NSString *TradableShares = [valueDict valueForKey:@"SJLTGB"];
	NSString *Turnover = [valueDict valueForKey:@"CJ"];
	NSString *Name = [valueDict valueForKey:@"GPJC"];
	
	float change = [Change floatValue];
	float changePercent = [ChangePercent floatValue];
	NSString *colorPath = [[NSBundle mainBundle] pathForResource:@"IndustryColorDefine.plist" ofType:nil];
	NSDictionary *colorDict = [[NSDictionary alloc] initWithContentsOfFile:colorPath];
	NSArray *upArray = [[colorDict objectForKey:@"GainersRateLabelColor"] componentsSeparatedByString:@","];
	NSArray *downArray = [[colorDict objectForKey:@"LosersRateLabelColor"] componentsSeparatedByString:@","];
	
	UIColor *posColor = [UIColor colorWithRed:[[upArray objectAtIndex:0] floatValue] green:[[upArray objectAtIndex:1] floatValue] blue:[[upArray objectAtIndex:2] floatValue] alpha:[[upArray objectAtIndex:3] floatValue]];
	UIColor *negColor = [UIColor colorWithRed:[[downArray objectAtIndex:0] floatValue] green:[[downArray objectAtIndex:1] floatValue] blue:[[downArray objectAtIndex:2] floatValue] alpha:[[downArray objectAtIndex:3] floatValue]];
	
	
	if (change > 0) {
		ChangePercent = [NSString stringWithFormat:@"%.2f%%",changePercent];
		labelChangeValue.textColor = posColor;
		labelChangePercentValue.textColor = posColor;
	} else if (change < 0) {
		Change = [NSString stringWithFormat:@"%.2f",change];
		ChangePercent = [NSString stringWithFormat:@"%.2f%%",changePercent];
		labelChangeValue.textColor = negColor;
		labelChangePercentValue.textColor = negColor;
	} else {
		labelChangeValue.textColor = [UIColor grayColor];
		labelChangePercentValue.textColor = [UIColor grayColor];
	}
	[colorDict release];
	labelCode.text = Code;
	labelCompany.text = Name;
	labelLatest.text = [titleDict objectForKey:@"SP"];
	labelLatestValue.text = Latest;
	labelChange.text = [titleDict objectForKey:@"ZF"];
	labelChangeValue.text = Change;
	labelChangePercent.text = [titleDict objectForKey:@"ZDF"];
	labelChangePercentValue.text = ChangePercent;
	labelOpen.text = [titleDict objectForKey:@"KP"];
	labelOpenValue.text = Open;
	labelHigh.text = [titleDict objectForKey:@"ZG"];
	labelHighValue.text = High;
	labelPETTM.text = [titleDict objectForKey:@"TTM"];
	labelPETTMValue.text = PETTM;
	labelPELastyr.text = [titleDict objectForKey:@"LYR"];
	labelPELastyrValue.text = PELastyr;
	labelVolume.text = [titleDict objectForKey:@"CJL"];
	labelVolumeValue.text = Volumn;
	labelPriorClose.text = [titleDict objectForKey:@"ZS"];
	labelPriorCloseValue.text = PriorClose;
	labelLow.text = [titleDict objectForKey:@"ZD"];
	labelLowValue.text = Low;
	labelPBMRQ.text = [titleDict objectForKey:@"MRQ"];
	labelPBMRQValue.text = PBMRQ;
	labelTotalAShares.text = [titleDict objectForKey:@"SJLTGB"];
	labelTotalASharesValue.text = TradableShares;
	labelTurnover.text = [titleDict objectForKey:@"CJ"];
	labelTurnoverValue.text = Turnover;
}

- (void)loadChartData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CVSetting *s;
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	
	NSDictionary *dict;
	NSDictionary *param;
	NSNumber *days;
	
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingNewsSnapshot];
	if (nil == _strCode) {
		days = [[NSNumber alloc] initWithInteger:22];
		param = [[NSDictionary alloc] initWithObjectsAndKeys:days, @"days", NEWS_SNAPSHOT_DEFAULT_CODE, @"code", nil];
		[days release];
		paramInfo.parameters = param;
		dict = [dp GetChartData:CVDataProviderChartTypeEquityIndices withParams:paramInfo];
	} else {
		days = [[NSNumber alloc] initWithInteger:22];
		param = [[NSDictionary alloc] initWithObjectsAndKeys:days, @"days", _strCode, @"code", nil];
		[days release];
		paramInfo.parameters = param;
		dict = [dp GetChartData:CVDataProviderChartTypeStock withParams:paramInfo];
	}
	self.dictFromServer = dict;
	[param release];
	[paramInfo release];
	
	// convert arrray to recognizable array for chart
	NSArray *oldArray;
	NSMutableArray *newArray;
	NSMutableDictionary *oldDict, *newDict;
	
	oldArray = [_dictFromServer objectForKey:@"data"];
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
			if (dateValue == nil) {
				[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				dateValue = [formatter dateFromString:strValue];
			}
			
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
	if (0 != [_arrayDataSource count]) {
		if (_strCode)
			// equity chart
			[charView defineSymbolName:_strCode timeFrame:StockDataOneMonth];
		else
			// CSI 300 chart
			[charView defineSymbolName:NEWS_SNAPSHOT_DEFAULT_CODE timeFrame:StockDataOneMonth];
	}
	
	[pool release];
}


- (void)changeIndicator:(NSNumber *)action
{
	BOOL bAnimate = [action boolValue];
	if(bAnimate)
	{
		[activityIndicator startAnimating];
		activityIndicator.hidden = NO;
	}
	else
	{
		[activityIndicator stopAnimating];
		activityIndicator.hidden = YES;
	}
}

#pragma mark StockChartDataSourceDelegate
- (NSArray *)ChartGetRecordsByName:(NSString *)name Period:(StockDataTimeFrame_e)timeFrame {
	return self.arrayDataSource;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[charView release];
	[ labelCode release];
	[ labelCompany release];
	[ labelOpen release];
	[ labelOpenValue release];
	[ labelHigh release];
	[ labelHighValue release];
	[ labelPriorClose release];
	[ labelPriorCloseValue release];
	[ labelLow release];
	[ labelLowValue release];
	[ labelPETTM release];
	[ labelPETTMValue release];
	[ labelPELastyr release];
	[ labelPELastyrValue release];
	[ labelPBMRQ release];
	[ labelPBMRQValue release];
	[ labelTotalAShares release];
	[ labelTotalASharesValue release];
	[ labelVolume release];
	[ labelVolumeValue release];
	[ labelTurnover release];
	[ labelTurnoverValue release];
	[ labelLatest release];
	[ labelLatestValue release];
	[ labelChange release];
	[ labelChangeValue release];
	[ labelChangePercent release];
	[ labelChangePercentValue release];
	
	[_strCode release];
	[_arrayDataSource release];
	[_dictFromServer release];
	[chartBackground release];
	[goMyStockButton release];
	[activityIndicator release];
    [super dealloc];
}

@end
