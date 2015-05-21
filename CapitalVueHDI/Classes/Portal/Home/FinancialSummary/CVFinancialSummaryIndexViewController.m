    //
//  CVFinancialSummaryIndexViewController.m
//  CapitalVueHD
//
//  Created by ANNA on 10-8-29.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVFinancialSummaryIndexViewController.h"
#import "CVIndexFormView.h"
#import "CVLabelStyle.h"

#import "CVSetting.h"
#import "CVDataProvider.h"

#import "CVPortal.h"

#import "NSString+Number.h"

@interface CVFinancialSummaryIndexViewController()

@property (nonatomic, retain) UIImageView *_line1;
@property (nonatomic, retain) UIImageView *_line2;
@property (nonatomic, retain) NSArray *_compositeArray;
@property (nonatomic, retain) NSMutableArray *_headArray;
@property (nonatomic, retain) NSMutableArray *_dataArray;

@property (nonatomic, retain) CVFinancialSummaryCompositeIndexFormView *_macroView;

- (void)loadData;

- (CGPoint)indicatorCenter:(UIInterfaceOrientation)orientation;

@end

static int columnsOfForm = 0;

@implementation CVFinancialSummaryIndexViewController

@synthesize indexType;

@synthesize _line1;
@synthesize _line2;

@synthesize _macroView;

@synthesize _compositeArray;
@synthesize _headArray;
@synthesize _dataArray;
@synthesize valuedData = _valuedData;

- (id)init{
	
	if (self = [super init]) {
		_ifLoaded = YES;
		_valuedData = NO;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.autoresizingMask = UIViewAutoresizingNone;
	self.view.autoresizesSubviews = NO;
	
	// create a form
	CVFinancialSummaryCompositeIndexFormView *aFormView;
	aFormView = [[CVFinancialSummaryCompositeIndexFormView alloc] initWithFrame:CGRectMake(0, 0, 400, 166)];
	self._macroView = aFormView;
	[aFormView release];
	_macroView.formDelegate = self;
	_macroView.autoresizesSubviews = NO;
	_macroView.autoresizingMask = UIViewAutoresizingNone;
	
	
	UIImageView *imageView;
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 322, 1)];
	self._line1 = imageView;
	[imageView release];
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_Home_tableV_line.png" ofType:nil];
	UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
	_line1.image = imgx;
	[imgx release];
	[self.view addSubview:_line1];
	
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 75, 322, 1)];
	self._line2 = imageView;
	[imageView release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_Home_tableV_line.png" ofType:nil];
	imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
	_line2.image = imgx;
	[imgx release];
	[self.view addSubview:_line2];
	
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[self.view addSubview:_indicator];
	_indicator.center = [self indicatorCenter:[[UIApplication sharedApplication] statusBarOrientation]];
	_indicator.hidesWhenStopped = YES;
	_indicator.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[_macroView illustrateAll];
}

- (void)dealloc 
{
	[_compositeArray release];
	[_headArray release];
	[_dataArray release];
	[_macroView release];
	[_indicator release];
    [super dealloc];
}

- (CGPoint)indicatorCenter:(UIInterfaceOrientation)orientation{
	CGPoint point;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		point = CGPointMake(PORTLET_FINANCE_SUMMARY_COMPOSIT_PORTRAIT_WIDTH/2, PORTLET_FINANCE_SUMMARY_COMPOSIT_PORTRAIT_HEIGHT/2);
	} else {
		point = CGPointMake(PORTLET_FINANCE_SUMMARY_COMPOSIT_LANDSCAPE_WIDTH/2, PORTLET_FINANCE_SUMMARY_COMPOSIT_LANDSCAPE_HEIGHT/2);
	}
	return point;
}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		NSMutableArray *widthArray;
		widthArray = [[NSMutableArray alloc] initWithObjects:
					  [NSNumber numberWithFloat:170],
					  [NSNumber numberWithFloat:83],
					  [NSNumber numberWithFloat:70],
					  nil];
		NSMutableArray *spaceArray;
		if (_isEmptyData) {
			spaceArray = [[NSMutableArray alloc] initWithObjects:
						  [NSNumber numberWithFloat:0],
						  [NSNumber numberWithFloat:32],
						  [NSNumber numberWithFloat:25],
						  nil];
		}else {
			spaceArray = [[NSMutableArray alloc] initWithObjects:
						  [NSNumber numberWithFloat:0],
						  [NSNumber numberWithFloat:20],
						  [NSNumber numberWithFloat:10],
						  nil];
		}

		_macroView.headerHeight = 25;
		_macroView.rowHeight = 25;
		_macroView.widthArray = widthArray;
		_macroView.spaceArray = spaceArray;
		
		[widthArray release];
		[spaceArray release];
		
		[_line1 setFrame:CGRectMake(0, 50, 322, 1)];
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_Home_tableV_line.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		_line1.image = imgx;
		[imgx release];
		
		[_line2 setFrame:CGRectMake(0, 75, 322, 1)];
		pathx = [[NSBundle mainBundle] pathForResource:@"cv_Home_tableV_line.png" ofType:nil];
		imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		_line2.image = imgx;
		[imgx release];
	} else {
		NSMutableArray *widthArray;
		widthArray = [[NSMutableArray alloc] initWithObjects:
					  [NSNumber numberWithFloat:167],
					  [NSNumber numberWithFloat:156],
					  [NSNumber numberWithFloat:112],
					  nil];
		NSMutableArray *spaceArray;
		if (_isEmptyData) {
			spaceArray = [[NSMutableArray alloc] initWithObjects:
						  [NSNumber numberWithFloat:0],
						  [NSNumber numberWithFloat:69],
						  [NSNumber numberWithFloat:47],
						  nil];
		}else {
			spaceArray = [[NSMutableArray alloc] initWithObjects:
						  [NSNumber numberWithFloat:0],
						  [NSNumber numberWithFloat:50],
						  [NSNumber numberWithFloat:30],
						  nil];
		}

		_macroView.headerHeight = 30;
		_macroView.rowHeight = 30;
		_macroView.widthArray = widthArray;
		_macroView.spaceArray = spaceArray;
		
		[widthArray release];
		[spaceArray release];
		
		[_line1 setFrame:CGRectMake(0, 60, 435, 1)];
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_Home_tableH_line.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		_line1.image = imgx;
		[imgx release];
		
		[_line2 setFrame:CGRectMake(0, 90, 435, 1)];
		pathx = [[NSBundle mainBundle] pathForResource:@"cv_Home_tableH_line.png" ofType:nil];
		imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		_line2.image = imgx;
		[imgx release];
	}
	
	if (_headArray && _dataArray && _macroView.headerStyleArray && [_macroView.headerStyleArray count]>0) {
		[_macroView illustrateAll];
	}
	
	_indicator.center = [self indicatorCenter:orientation];
	[pool release];
}

#pragma mark -
#pragma mark private method
- (void)loadData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CVSetting *s;
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	
	NSDictionary *dict;
	NSDictionary *titleDict, *valueDict;
	NSArray *dataArray;
	
	NSMutableArray *heads, *rows;
	
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	
	heads = nil;
	rows = nil;
	
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [local localizedString:@"LangCode"];
	
	if (CVFinancialSummaryTypeEquity == indexType) {		
		paramInfo = [[CVParamInfo alloc] init];
		paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingHomeFinancialSummary];
		dict = [dp GetCompositeIndexList:CVDataProviderCompositeIndexTypeDaily withParams:paramInfo];
		[paramInfo release];
		
		titleDict = [dict objectForKey:@"head"];
		dataArray = [dict objectForKey:@"data"];
		
		self._compositeArray = dataArray;
	
		// construct the head array and value array for form
		if (titleDict && dataArray) {
			heads = [[NSMutableArray alloc] initWithCapacity:1];
			rows = [[NSMutableArray alloc] initWithCapacity:1];
		
			NSArray *keys;
			NSMutableArray *aRow;
			NSString *key, *strTemp;
		
			keys = [[NSArray alloc] initWithObjects:@"指数名称", @"当日收盘价", @"当日涨跌幅", nil];
		
			//construct head
			if ([dataArray count] > 0) {
				strTemp = [[dataArray objectAtIndex:0] objectForKey:@"RQ"];
				if (strTemp) {
					[heads addObject:strTemp];
				} else {
					[heads addObject:@""];
				}

			}
			strTemp = [titleDict objectForKey:@"当日收盘价"];
			if (strTemp) {
				[heads addObject:strTemp];
			} else {
				[heads addObject:@""];
			}

			strTemp = [titleDict objectForKey:@"当日涨跌幅"];
			if (strTemp) {
				[heads addObject:strTemp];
			} else {
				[heads addObject:@""];
			}
			
			// construct the rows
			NSRange range;
			for (valueDict in dataArray) {
				aRow = [[NSMutableArray alloc] initWithCapacity:1];
				for (key in keys) {
					strTemp = [valueDict objectForKey:key];
					if ([key isEqualToString:@"当日涨跌幅"]) {
						strTemp = [NSString stringWithFormat:@"%@%%",strTemp];
					}
					if ([key isEqualToString:@"当日收盘价"]) {
						if ([_langCode isEqualToString:@"en"]) {
							strTemp = [strTemp formatToEnNumber];
						}
					}
					range = [strTemp rangeOfString:@"Index"];
					if (range.location != NSNotFound) {
						strTemp = [strTemp substringToIndex:range.location];
					}
					if (strTemp) {
						[aRow addObject:strTemp];
					} else {
						[aRow addObject:@""];
					}

				}
				[rows addObject:aRow];
				[aRow release];
			}
			[keys release];
		}
	} else if (CVFinancialSummaryTypeFund == indexType) {
		paramInfo = [[CVParamInfo alloc] init];
		paramInfo.minutes = 15;
		dict = [dp GetFundList:CVDataProviderFundListTypeDailySummary withParams:paramInfo];
		[paramInfo release];
		
		titleDict = [dict objectForKey:@"head"];
		dataArray = [dict objectForKey:@"data"];
		
		// construct the head array and value array for form
		if (titleDict && dataArray) {
			heads = [[NSMutableArray alloc] initWithCapacity:1];
			rows = [[NSMutableArray alloc] initWithCapacity:1];
			
			NSArray *keys;
			NSMutableArray *aRow;
			NSString *key, *strTemp;
			
			keys = [[NSArray alloc] initWithObjects:@"指数名称", @"最新收盘价",@"当日涨跌幅", nil];
			
			//construct head
			if ([dataArray count] > 0) {
				strTemp = [[dataArray objectAtIndex:0] objectForKey:@"当日日期"];
				if (strTemp) {
					[heads addObject:strTemp];
				} else {
					[heads addObject:@""];
				}
				
			}
			strTemp = [titleDict objectForKey:@"最新收盘价"];
			if (strTemp) {
				[heads addObject:strTemp];
			} else {
				[heads addObject:@""];
			}
			
			strTemp = [titleDict objectForKey:@"当日涨跌幅"];
			if (strTemp) {
				[heads addObject:strTemp];
			} else {
				[heads addObject:@""];
			}
			
			// construct the rows
			NSRange range;
			for (valueDict in dataArray) {
				aRow = [[NSMutableArray alloc] initWithCapacity:1];
				for (key in keys) {
					strTemp = [valueDict objectForKey:key];
					if ([key isEqualToString:@"当日涨跌幅"]) {
						strTemp = [NSString stringWithFormat:@"%@%%",strTemp];
					}
					if ([key isEqualToString:@"当日收盘价"]) {
						if ([_langCode isEqualToString:@"en"]) {
							strTemp = [strTemp formatToEnNumber];
						}
					}
					range = [strTemp rangeOfString:@"Index"];
					if (range.location != NSNotFound) {
						strTemp = [strTemp substringToIndex:range.location];
					}
					if (strTemp) {
						[aRow addObject:strTemp];
					} else {
						[aRow addObject:@""];
					}
					
				}
				[rows addObject:aRow];
				[aRow release];
			}
			[keys release];
		}
	} else if (CVFinancialSummaryTypeBond == indexType) {
		dict = [dp GetBondList:CVDataProviderBondListTypeDailySummary withParams:nil];
		titleDict = [dict objectForKey:@"head"];
		dataArray = [dict objectForKey:@"data"];
		
		// construct the head array and value array for form
		if (titleDict && dataArray) {
			heads = [[NSMutableArray alloc] initWithCapacity:1];
			rows = [[NSMutableArray alloc] initWithCapacity:1];
			
			NSArray *keys;
			NSMutableArray *aRow;
			NSString *key, *strTemp;
			
			keys = [[NSArray alloc] initWithObjects:@"指数名称", @"最新收盘价",@"当日涨跌幅", nil];
			
			//construct head
			if ([dataArray count] > 0) {
				strTemp = [[dataArray objectAtIndex:0] objectForKey:@"当日日期"];
				if (strTemp) {
					[heads addObject:strTemp];
				} else {
					[heads addObject:@""];
				}
				
			}
			strTemp = [titleDict objectForKey:@"最新收盘价"];
			if (strTemp) {
				[heads addObject:strTemp];
			} else {
				[heads addObject:@""];
			}
			
			strTemp = [titleDict objectForKey:@"当日涨跌幅"];
			if (strTemp) {
				[heads addObject:strTemp];
			} else {
				[heads addObject:@""];
			}
			
			// construct the rows
			NSRange range;
			for (valueDict in dataArray) {
				aRow = [[NSMutableArray alloc] initWithCapacity:1];
				for (key in keys) {
					strTemp = [valueDict objectForKey:key];
					if ([key isEqualToString:@"当日涨跌幅"]) {
						strTemp = [NSString stringWithFormat:@"%@%%",strTemp];
					}
					if ([key isEqualToString:@"当日收盘价"]) {
						if ([_langCode isEqualToString:@"en"]) {
							strTemp = [strTemp formatToEnNumber];
						}
					}
					range = [strTemp rangeOfString:@"Index"];
					if (range.location != NSNotFound) {
						strTemp = [strTemp substringToIndex:range.location];
					}
					if (strTemp) {
						[aRow addObject:strTemp];
					} else {
						[aRow addObject:@""];
					}
					
				}
				[rows addObject:aRow];
				[aRow release];
			}
			[keys release];
		}
	}
	
	self._headArray = heads;
	self._dataArray = rows;
	[heads release];
	[rows release];
	
	// create for portrait
	if (0 != [_headArray count] && 0 != [_dataArray count])
	{
		_isEmptyData = NO;
		// configure form's head and data
		_macroView.headerArray = _headArray;
		_macroView.dataArray = _dataArray;
		
		NSMutableArray *compareArray;
		NSArray *element;
		
		compareArray = [[NSMutableArray alloc] initWithCapacity:1];
		for (element in _dataArray) {
			NSString *change;
			
			change = [element lastObject];
			[compareArray addObject:change];
		}
		_macroView.compareArray = compareArray;
		[compareArray release];
		
		columnsOfForm = [_headArray count];		
		NSMutableArray* styleArray = [NSMutableArray new];
		for (int i = 0; i < columnsOfForm; ++i) {
			CVLabelStyle* labelStyle = [[CVLabelStyle alloc] init];
			labelStyle.font = [UIFont boldSystemFontOfSize:13.0];
			if (i == 0) {
				labelStyle.textAlign = UITextAlignmentLeft;
			}else {
				labelStyle.textAlign = UITextAlignmentCenter;
			}
			
			if (0 == i) {
				labelStyle.foreColor = [UIColor orangeColor];
			} else {
				labelStyle.foreColor = [UIColor whiteColor];
			}
			[styleArray addObject:labelStyle];
			[labelStyle release];
		}
		_macroView.headerStyleArray = styleArray;
		[styleArray release];
	}else {
		_isEmptyData = YES;
		heads = [[NSMutableArray alloc] initWithObjects:nil];
		for (int i = 0; i < 3; i++) {
			[heads addObject:@"----"];
		}
		rows = [[NSMutableArray alloc] initWithObjects:nil];
		for (int i = 0; i < 3; i++) {
			NSMutableArray *arow = [[NSMutableArray alloc] initWithObjects:nil];
			for (int j = 0; j < 3; j++) {
				[arow addObject:@"----"];
			}
			[rows addObject:arow];
			[arow release];
		}
		self._headArray = heads;
		self._dataArray = rows;
		_macroView.headerArray = heads;
		_macroView.dataArray = rows;
		[heads release];
		[rows release];
		
		columnsOfForm = [_headArray count];		
		NSMutableArray* styleArray = [NSMutableArray new];
		for (int i = 0; i < columnsOfForm; ++i) {
			CVLabelStyle* labelStyle = [[CVLabelStyle alloc] init];
			labelStyle.font = [UIFont boldSystemFontOfSize:13.0];
			if (i == 0) {
				labelStyle.textAlign = UITextAlignmentLeft;
			}else {
				labelStyle.textAlign = UITextAlignmentCenter;
			}
			
			if (0 == i) {
				labelStyle.foreColor = [UIColor orangeColor];
			} else {
				labelStyle.foreColor = [UIColor whiteColor];
			}
			[styleArray addObject:labelStyle];
			[labelStyle release];
		}
		_macroView.headerStyleArray = styleArray;
		[styleArray release];
	}
	[pool release];
	
	[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];
}

-(void)afterLoadData{
	
	_ifLoaded = YES;
	
	_macroView.selfAdjust = NO;
	_macroView.backgroundColor = [UIColor clearColor];
	
	[self adjustSubviews:[[UIApplication sharedApplication] statusBarOrientation]];
	
	[self.view addSubview:_macroView];
	if (self._dataArray && [self._dataArray count]>0 && !_isEmptyData) {
		_valuedData = YES;
	} else {
		_valuedData = NO;
	}
	
	[_indicator stopAnimating];
}

#pragma mark -
#pragma mark CVFormViewDelegate
- (void)didSelectRow:(int)row {
	NSDictionary *selectRowData;
	NSInteger selectIndex;
	NSArray *dataArray;
	
	dataArray = _compositeArray;
	
	selectIndex = row;
	if (selectIndex < [dataArray count] && CVFinancialSummaryTypeEquity == indexType) {
		NSMutableDictionary *notificationDict;
		notificationDict = [[NSMutableDictionary alloc] initWithCapacity:1];
		[notificationDict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
		
		
		// get the code
		selectRowData = [dataArray objectAtIndex:selectIndex];
		NSDictionary *code;
		NSDictionary *name;
		
		code = [selectRowData objectForKey:@"指数代码"];
		name = [selectRowData objectForKey:@"指数名称"];
		if (code)
			[notificationDict setObject:code forKey:@"code"];
		if (name)
			[notificationDict setObject:name forKey:@"name"];
		[notificationDict setObject:[NSNumber numberWithBool:NO] forKey:@"isEquity"];
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:CVPortalSwitchPortalSetNotification object:[notificationDict autorelease]];
	}
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
	[_macroView removeFromSuperview];
	_indicator.hidden = NO;
	[_indicator startAnimating];
	[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

@end
