//
//  CVCompositeIndexItemView.m
//  CapitalVueHD
//
//  Created by jishen on 9/16/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVCompositeIndexItemView.h"
#import "CVLocalizationSetting.h"
@interface CVCompositeIndexItemView()

@property (nonatomic, retain) NSArray *chartDataSource;

@end

#define CVCOMPOSITE_INDEX_ITEM_BAR_HEIGHT 43

@implementation CVCompositeIndexItemView

@synthesize backgroundView;
@synthesize chartBackground;

@synthesize nameLabel;

@synthesize dateValueLabel;
@synthesize arrowImageView;
@synthesize changeValueLabel;
@synthesize percentageLabel;

@synthesize closeLabel;
@synthesize volumenLabel;
@synthesize rangeLabel;
@synthesize turnoverLabel;

@synthesize closeValueLabel;
@synthesize volumenValueLabel;
@synthesize rangeValueLabel;
@synthesize turnoverValueLabel;

@synthesize indexArray;

@synthesize chartDataSource;

@synthesize isGainer;
@synthesize loadingFinished;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[backgroundView release];
	[chartBackground release];
	
	[nameLabel release];
	
	[dateValueLabel release];
	[arrowImageView release];
	[changeValueLabel release];
	[percentageLabel release];
	
	[closeLabel release];
	[volumenLabel release];
	[rangeLabel release];
	[turnoverLabel release];
	
	[closeValueLabel release];
	[volumenValueLabel release];
	[rangeValueLabel release];
	[turnoverValueLabel release];
	
	[indexArray release];
	[chartDataSource release];
	
    [super dealloc];
}

#define CHART_VIEW_WIDTH 224
#define CHART_VIEW_HEIGHT 123

- (void)setIndexArray:(NSArray *)array {
	cvChartView *chartView;
	NSString *cfgFilePath = [[NSBundle mainBundle] pathForResource:@"CompositeIndexSnap" ofType:@"plist"];
	
	loadingFinished = NO;
	chartView = [[cvChartView alloc] initWithFrame:CGRectMake(11, 80, 0, 0) FormatFile:cfgFilePath];
	chartView.dataProvider = self;
	
	// convert arrray to recognizable array for chart
	NSArray *oldArray;
	NSMutableArray *newArray;
	NSMutableDictionary *oldDict, *newDict;
	
	oldArray = array;
	newArray = [[NSMutableArray alloc] initWithCapacity:1];
	//  the keys and values of an element of array
	// <node name="ZG">3001.85</node>
	// <node name="CJL">0.0</node>
	// <node name="FSRQ">2010-11-08 00:00:00</node>
	// <node name="ZD">3001.85</node>
	// <node name="SP">3001.85</node>
	// <node name="ZSDM">000001</node>
	// <node name="CJJE">0.0</node>
	// <node name="KP">3001.85</node>
	
	for (oldDict in oldArray) {
		NSNumber *numberValue;
		NSDate *dateValue;
		NSString *strValue;
		NSInteger integerValue;
		
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
		strValue = [oldDict objectForKey:@"KP"];
		if (strValue != nil) {
			integerValue = [strValue integerValue];
			numberValue = [NSNumber numberWithInteger:integerValue];
			[newDict setObject:numberValue forKey:@"open"];
		}
		// high
		strValue = [oldDict objectForKey:@"ZG"];
		if (strValue != nil) {
			integerValue = [strValue integerValue];
			numberValue = [NSNumber numberWithInteger:integerValue];
			[newDict setObject:numberValue forKey:@"high"];
		}
		// low
		strValue = [oldDict objectForKey:@"ZD"];
		if (strValue != nil) {
			integerValue = [strValue integerValue];
			numberValue = [NSNumber numberWithInteger:integerValue];
			[newDict setObject:numberValue forKey:@"low"];
		}
		// close
		strValue = [oldDict objectForKey:@"SP"];
		if (strValue != nil) {
			integerValue = [strValue integerValue];
			numberValue = [NSNumber numberWithInteger:integerValue];
			[newDict setObject:numberValue forKey:@"close"];
		}
		// volume
		strValue = [oldDict objectForKey:@"CJL"];
		if (strValue != nil) {
			integerValue = [strValue integerValue];
			numberValue = [NSNumber numberWithInteger:integerValue];
			[newDict setObject:numberValue forKey:@"volume"];
		}
		// turnover
		strValue = [oldDict objectForKey:@"CJJE"];
		if (strValue != nil) {
			integerValue = [strValue integerValue];
			numberValue = [NSNumber numberWithInteger:integerValue];
			[newDict setObject:numberValue forKey:@"turnover"];
		}
		
		[newArray addObject:newDict];
		[newDict release];
	}
	self.chartDataSource = newArray;
	[newArray release];
	if (0 != [chartDataSource count]) {
		[chartView drawChart:self.nameLabel.text timeFrame:StockDataOneWeek];
	}

	[self addSubview:chartView];
	[chartView release];
}

- (void)setIsGainer:(BOOL)b {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *lanCode = [langSetting localizedString:@"LangCode"];
	NSString *path1 = [[NSBundle mainBundle] pathForResource:@"portlet_cover_green_background.png" ofType:nil];
	UIImage *img1 = [[UIImage alloc] initWithContentsOfFile:path1];
	NSString *path2 = [[NSBundle mainBundle] pathForResource:@"portlet_cover_red_background.png" ofType:nil];
	UIImage *img2 = [[UIImage alloc] initWithContentsOfFile:path2];

	if ([lanCode isEqualToString:@"cn"]){
		if (YES == b )
			backgroundView.image = img2;
		else 
			backgroundView.image = img1;

	}
	else {
		if (YES == b )
			backgroundView.image = img1;
		else 
			backgroundView.image = img2;
	}

	[img1 release];
	[img2 release];
}

#pragma mark StockChartDataSourceDelegate
- (NSArray *)ChartGetRecordsByName:(NSString *)name Period:(StockDataTimeFrame_e)timeFrame {
	loadingFinished = YES;
	return chartDataSource;
}

@end
