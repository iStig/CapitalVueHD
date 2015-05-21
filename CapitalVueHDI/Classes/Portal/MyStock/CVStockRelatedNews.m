//
//  CVStockRelatedNews.m
//  CapitalVueHD
//
//  Created by Stan on 11-2-28.
//  Copyright 2011 CapitalVue. All rights reserved.
//

#import "CVStockRelatedNews.h"
#import "CVDataProvider.h"
#import "CVShareInfo.h"
#import "CVSetting.h"
#import "CVLocalizationSetting.h"

@implementation CVStockRelatedNews

@synthesize lblCode = _lblCode;
@synthesize lblName = _lblName;
@synthesize chartSnapshot = _chartSnapshot;
@synthesize imgvChartBG = _imgvChartBG;
@synthesize lblChange = _lblChange;
@synthesize lblLatest = _lblLatest;
@synthesize lblChangePercent = _lblChangePercent;
@synthesize lblChangeValue = _lblChangeValue;
@synthesize lblLatestValue = _lblLatestValue;
@synthesize lblChangePercentValue = _lblChangePercentValue;
@synthesize tvRelatedNews = _tvRelatedNews;
@synthesize wvNewsContent = _wvNewsContent;
@synthesize btnBack = _btnBack;

@synthesize chartData = _chartData;
@synthesize newsList = _newsList;
@synthesize newsContent = _newsContent;
@synthesize stockInfo = _stockInfo;

@synthesize indicator = _indicator;




- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		//背景图片
		NSString *bgPath = [[NSBundle mainBundle] pathForResource:@"StockRelatedNewsBG" ofType:@"png"];
		UIImage *imgBG = [[UIImage alloc] initWithContentsOfFile:bgPath];
		self.backgroundColor = [UIColor colorWithPatternImage:imgBG];
		[imgBG release];
		
		
		//Chart 和 Chart的背景
		NSString *cbgPath = [[NSBundle mainBundle] pathForResource:@"stock_snapshot_background" ofType:@"png"];
		UIImage *imgCBG = [[UIImage alloc] initWithContentsOfFile:cbgPath];
		UIImageView *imgvCBG = [[UIImageView alloc] initWithFrame:kChartBGRectL];
		[imgvCBG setImage:imgCBG];
		[imgCBG release];
		[self addSubview:imgvCBG];
		self.imgvChartBG = imgvCBG;
		[imgvCBG release];
		
		NSString *cfgPath = [[NSBundle mainBundle] pathForResource:@"StockRelatedNewsChart" ofType:@"plist"];
		cvChartView *chart = [[cvChartView alloc] initWithFrame:kChartRectL FormatFile:cfgPath];
		chart.dataProvider = self;
		self.chartSnapshot = chart;
		[chart release];
		[self addSubview:chart];
		
		
		//8 Labels
		UILabel *lbl = [[UILabel alloc] initWithFrame:kLabelCodeRectL];
		lbl.textColor = [UIColor blackColor];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentLeft;
		lbl.font = [UIFont boldSystemFontOfSize:15];
		[self addSubview:lbl];
		self.lblCode = lbl;
		[lbl release];
		
		lbl = [[UILabel alloc] initWithFrame:kLabelNameRectL];
		lbl.textColor = [UIColor blackColor];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentLeft;
		lbl.font = [UIFont boldSystemFontOfSize:15];
		[self addSubview:lbl];
		self.lblName = lbl;
		[lbl release];
		
		lbl = [[UILabel alloc] initWithFrame:kLabelLatestRectL];
		lbl.textColor = [UIColor darkGrayColor];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentLeft;
		lbl.font = [UIFont boldSystemFontOfSize:12];
		[self addSubview:lbl];
		self.lblLatest = lbl;
		[lbl release];
		
		lbl = [[UILabel alloc] initWithFrame:kLabelChangeRectL];
		lbl.textColor = [UIColor darkGrayColor];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentLeft;
		lbl.font = [UIFont boldSystemFontOfSize:12];
		[self addSubview:lbl];
		self.lblChange = lbl;
		[lbl release];
		
		lbl = [[UILabel alloc] initWithFrame:kLabelChangePercentRectL];
		lbl.textColor = [UIColor darkGrayColor];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentLeft;
		lbl.font = [UIFont boldSystemFontOfSize:12];
		[self addSubview:lbl];
		self.lblChangePercent = lbl;
		[lbl release];
		
		lbl = [[UILabel alloc] initWithFrame:kLabelLatestVRectL];
		lbl.textColor = [UIColor blackColor];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentLeft;
		lbl.font = [UIFont boldSystemFontOfSize:14];
		[self addSubview:lbl];
		self.lblLatestValue = lbl;
		[lbl release];
		
		lbl = [[UILabel alloc] initWithFrame:kLabelChangeVRectL];
		lbl.textColor = [UIColor darkGrayColor];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentLeft;
		lbl.font = [UIFont boldSystemFontOfSize:14];
		[self addSubview:lbl];
		self.lblChangeValue = lbl;
		[lbl release];
		
		lbl = [[UILabel alloc] initWithFrame:kLabelChangePercentVRectL];
		lbl.textColor = [UIColor darkGrayColor];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentLeft;
		lbl.font = [UIFont boldSystemFontOfSize:14];
		[self addSubview:lbl];
		self.lblChangePercentValue = lbl;
		[lbl release];
		
		
		//TableView
		UITableView *tableView = [[UITableView alloc] initWithFrame:kTableRectL];
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		tableView.backgroundColor = [UIColor clearColor];
		tableView.delegate = self;
		tableView.dataSource = self;
		[self addSubview:tableView];
		self.tvRelatedNews = tableView;
		[tableView release];
		
		
		//Webview
		UIWebView *wv = [[UIWebView alloc] initWithFrame:kWebRectL];
		wv.backgroundColor = [UIColor clearColor];
		wv.opaque = NO;
		wv.delegate = self;
		[self addSubview:wv];
		self.wvNewsContent = wv;
		for (UIView *view in wv.subviews) {
			if ([view isKindOfClass:[UIView class]]) {

				view.backgroundColor = [UIColor clearColor];
			}
		}
		[wv release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
	self.lblCode = nil;
	self.lblName = nil;
	self.imgvChartBG = nil;
	self.chartSnapshot = nil;
	self.lblLatest = nil;
	self.lblChange = nil;
	self.lblChangePercent = nil;
	self.lblLatestValue = nil;
	self.lblChangeValue = nil;
	self.lblChangePercentValue = nil;
	self.tvRelatedNews = nil;
	self.wvNewsContent = nil;
	self.btnBack = nil;
	
	self.chartData = nil;
	self.newsList = nil;
	self.newsContent = nil;
	self.stockInfo = nil;
	
	self.indicator = nil;
	
}

#pragma mark -
#pragma mark Custom Code
//load data
-(void)loadData:(NSDictionary *)infoDict{
	[NSThread detachNewThreadSelector:@selector(loadStockData:) toTarget:self withObject:infoDict];
	[NSThread detachNewThreadSelector:@selector(loadNewsData:) toTarget:self withObject:infoDict];
	[NSThread detachNewThreadSelector:@selector(loadChartData:) toTarget:self withObject:infoDict];
}

-(void)loadChartData:(NSDictionary *)infoDict{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *code = [infoDict objectForKey:@"code"];
	
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
	if (nil == code) {
		days = [[NSNumber alloc] initWithInteger:22];
		param = [[NSDictionary alloc] initWithObjectsAndKeys:days, @"days", NEWS_SNAPSHOT_DEFAULT_CODE, @"code", nil];
		[days release];
		paramInfo.parameters = param;
		dict = [dp GetChartData:CVDataProviderChartTypeEquityIndices withParams:paramInfo];
	} else {
		days = [[NSNumber alloc] initWithInteger:22];
		param = [[NSDictionary alloc] initWithObjectsAndKeys:days, @"days", code, @"code", nil];
		[days release];
		paramInfo.parameters = param;
		dict = [dp GetChartData:CVDataProviderChartTypeStock withParams:paramInfo];
	}

	[param release];
	[paramInfo release];
	
	// convert arrray to recognizable array for chart
	NSArray *oldArray;
	NSMutableArray *newArray;
	NSMutableDictionary *oldDict, *newDict;
	
	oldArray = [dict objectForKey:@"data"];
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
	self.chartData = newArray;
	[newArray release];
	if (0 != [_chartData count]) {
		if (code)
			// equity chart
			[_chartSnapshot defineSymbolName:code timeFrame:StockDataOneMonth];
		else
			// CSI 300 chart
			[_chartSnapshot defineSymbolName:NEWS_SNAPSHOT_DEFAULT_CODE timeFrame:StockDataOneMonth];
	}
	
	[pool release];
}

-(void)loadNewsData:(NSDictionary *)infoDict{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *code = [infoDict objectForKey:@"code"];
	//	BOOL isEquity = [[dict objectForKey:@"isEquity"] boolValue];
	//	NSString *name = [dict objectForKey:@"name"];
	NSDictionary *dict;
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	
	
	int pageNumber = 0;
	
	NSString *pageCurrent = [NSString stringWithFormat:@"%d",pageNumber];				//第几页新闻
	NSString *pageCapacity = [NSString stringWithFormat:@"%d",kNewsPerPage];  //每页多少新闻
	
	
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
		self.newsList = [dict objectForKey:@"data"];
		[self.tvRelatedNews reloadData];
		
		[self loadWebContent:[_newsList objectAtIndex:0]];
	}
	
	
	[pool release];
}

-(void)loadStockData:(NSDictionary *)infoDict{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *code = [infoDict objectForKey:@"code"];
	
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	CVSetting *s = [CVSetting sharedInstance];
	
	NSMutableString *param = [[NSMutableString alloc] init];
	[param appendString:code];
	
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingNewsSnapshot];
	paramInfo.parameters = param;
	
	dict = [dp GetMyStockDetail:CVDataProviderMyStockDetailTypeStock withParams:paramInfo];
	
	if (dict)
		[self performSelectorOnMainThread:@selector(showStockInfo:) withObject:dict waitUntilDone:NO];
	
	[param release];
	[paramInfo release];
	
	[pool release];
}

-(void)showStockInfo:(NSDictionary *)infoDict{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	
	UIColor *pos = [langSetting getColor:@"GainersRate"];
	UIColor *neg = [langSetting getColor:@"LosersRate"];
	
	NSDictionary *head = [infoDict objectForKey:@"head"];
	NSDictionary *data = [[infoDict objectForKey:@"data"] objectAtIndex:0];
	
	self.lblCode.text = [data objectForKey:@"GPDM"];
	self.lblName.text = [data objectForKey:@"GPJC"];
	self.lblLatest.text = [head objectForKey:@"SP"];
	self.lblChange.text = [head	objectForKey:@"ZF"];
	self.lblChangePercent.text = [head objectForKey:@"ZDF"];
	self.lblLatestValue.text = [data objectForKey:@"SP"];
	self.lblChangeValue.text = [data objectForKey:@"ZF"];
	self.lblChangePercentValue.text = [data objectForKey:@"ZDF"];
	
	float growth = [[data objectForKey:@"ZF"] floatValue];
	if (growth>0){
		self.lblChangeValue.textColor = pos;
		self.lblChangePercentValue.textColor = pos;
	}
	else  if(growth<0){
		self.lblChangeValue.textColor = neg;
		self.lblChangePercentValue.textColor = neg;
	}
	else {
		self.lblChangeValue.textColor = [UIColor darkGrayColor];;
		self.lblChangePercentValue.textColor = [UIColor darkGrayColor];
	}


	
}

-(void)adjustSubviews:(UIInterfaceOrientation)orientation{
	
}

//change timestamp to date
- (NSString *)stampchangetime:(NSString *)timestamp isDetail:(BOOL)isDetail{
	NSTimeInterval seconds = [timestamp intValue];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	NSString *str;
	if (isDetail == YES) {
		[formatter setDateFormat:@"EEEE yyyy-MM-dd HH:mm"];
		str = [formatter stringFromDate:date];
	}
	else {
		
		[formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
		str = [formatter stringFromDate:date];
	}
	
	return str;
}


- (void)loadWebContent:(NSDictionary *)dict{
	
	NSString *strTitle = [dict valueForKey:@"title"];
	NSString *strTimeStamp  = [dict valueForKey:@"t_stamp"];
	NSString *strBody  = [dict valueForKey:@"body"];
	if (strBody) {
		strBody = [self addImageUrl:strBody];
	}
	
	NSString *strTime = [self stampchangetime:strTimeStamp isDetail:YES];
	
	NSMutableString *strContent = [[NSMutableString alloc] init];
	
	[strContent appendFormat:@"<script language=\"javascript\">document.ontouchstart=function()"];
	[strContent appendFormat:@"{document.location=\"myweb:touch:start\";  }; document.ontouchend=function()"];
	[strContent appendFormat:@"{document.location=\"myweb:touch:end\";  }; document.ontouchmove=function(){"];
	[strContent appendFormat:@"document.location=\"myweb:touch:move\";  }  </script>"];
	
	[strContent appendFormat:@"<div align = \"left\">"];
	[strContent appendFormat:@"<font size = \"5\" style=\"font-weight:bold\" face = \"Arial\">"];
	[strContent appendString:strTitle];
	[strContent appendFormat:@"</font></br></div>"];
	
	NSArray *array = [strTime componentsSeparatedByString:@" "];
	if ([array count]>=3) {
		NSString *week = [array objectAtIndex:0];
		NSString *day  = [array objectAtIndex:1];
		NSString *time = [array objectAtIndex:2];
		
		[strContent appendFormat:@"<div align = \"left\">"];
		[strContent appendFormat:@"<font size = \"2\" face = \"Arial\" style=\"font-weight:bold\" color = \"gray\">"];
		[strContent appendString:week];
		[strContent appendFormat:@"</font>"];
		
		[strContent appendFormat:@"<font size = \"2\" face = \"Arial\" color = \"gray\">"];
		[strContent appendString:@"   "];
		[strContent appendString:day];
		[strContent appendFormat:@"</font>"];
		
		[strContent appendFormat:@"<font size = \"2\" face = \"Arial\" color = \"gray\">"];
		[strContent appendString:@"   "];
		[strContent appendString:time];
		[strContent appendFormat:@"</font>"];
		
		[strContent appendFormat:@"</div>"];
	}
	else {
		[strContent appendFormat:@"<div align = \"left\">"];
		[strContent appendFormat:@"<font size = \"2\" face = \"Arial\" color = \"gray\">"];
		[strContent appendString:strTime];
		[strContent appendFormat:@"</font>"];
		[strContent appendFormat:@"</div>"];
	}
	
	
	if (strBody) {
		[strContent appendString:@"<font size = \""];
		[strContent appendString:fontsize];
		[strContent appendString:@"\" face = \"Arial\" color = \"#4D4D4D\">"];
		[strContent appendString:strBody];
		[strContent appendString:@"</font>"];
	}
	
	NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];//release this in loadHTMLByDict:
	
	NSString *htmStr = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">body{background-color:transparent;} *{-webkit-touch-callout:none;-webkit-user-select:none;}</style></head><body>%@</body></html>",[strContent stringByReplacingOccurrencesOfString:@"justify" withString:@"left"]];
	
	[dicc setObject:htmStr forKey:@"strContent"];
	[dicc setObject:[NSURL URLWithString:@"http://data.capitalvue.com"] forKey:@"url"];
	
	[self performSelectorOnMainThread:@selector(loadHTMLByDict:) withObject:dicc waitUntilDone:NO];
	
	[strContent release];
}

-(void)loadHTMLByDict:(NSMutableDictionary *)dicc{
	NSMutableString *strContent = [dicc objectForKey:@"strContent"];
	NSURL *url = [dicc objectForKey:@"url"];
	[_wvNewsContent loadHTMLString:strContent baseURL:url];
	[dicc release];
}


//因为图片地址为相对地址，所有图片地址加上头http://www.capitalvue.com
- (NSString *)addImageUrl:(NSString *)strContent{
	if (!strContent) {
		return nil;
	}
	NSRange xRange = [strContent rangeOfString:@"<img src=\""];
	NSInteger length = strContent.length;
	if (xRange.location>length || xRange.location<0) {
		return strContent;
	}
	else {
		NSInteger local = xRange.location+xRange.length;
		NSString *strPre = [strContent substringWithRange:NSMakeRange(0,local)];
		NSString *strEnd = [strContent substringWithRange:NSMakeRange(local,length-local)];
		NSMutableString *strResult = [[[NSMutableString alloc] init] autorelease];
		[strResult appendString:strPre];
		[strResult appendFormat:@"http://www.capitalvue.com"];
		[strResult appendString:strEnd];
		return strResult;
	}
}


#pragma mark -
#pragma mark Stock Chart Data Source
-(NSArray *)ChartGetRecordsByName:(NSString *)name Period:(StockDataTimeFrame_e)timeFrame{
	return self.chartData;
}

#pragma mark -
#pragma mark TableView Delegate and DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"NewsList";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (!cell){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
		CALayer *line = [[CALayer alloc] init];
		line.frame = CGRectMake(0, 69, cell.frame.size.width, 1);
		line.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor;
		[cell.contentView.layer addSublayer:line];
		[line release];
		cell.textLabel.numberOfLines = 2;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
	}
	
	NSDictionary *news = [_newsList objectAtIndex:[indexPath row]];
	cell.textLabel.text = [news objectForKey:@"title"];
	cell.detailTextLabel.text = [self stampchangetime:[news objectForKey:@"t_stamp"] isDetail:NO];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.newsList?[_newsList count]:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self loadWebContent:[_newsList objectAtIndex:[indexPath row]]];
}

#pragma mark -
#pragma mark Webview Delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	if (UIWebViewNavigationTypeLinkClicked==navigationType)
		return NO;
	else
		return YES;
}

@end
