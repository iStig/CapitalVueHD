//
//  CVSetting.m
//  CapitalVueHD
//
//  Created by jishen on 9/13/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVSetting.h"
#import "Reachability.h"

@interface CVSetting()

@property (nonatomic, retain) NSString *_plistPath;
@property (nonatomic, retain) NSMutableDictionary *_dictSetting;

@end

@implementation CVSetting

@synthesize _dictSetting;
@synthesize _plistPath;

static CVSetting *sharedInstance = nil;


#define CVSettingPlistName @"CVSetting"

/*
 * It get the instance handler
 * @param:	none
 * @return:	none
 */
+ (CVSetting *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
}

- (id)autorelease {
    return self;
}

- (id)init {
    if ((self = [super init])) {
        // Initialization code
		NSString *plistPath;
		NSMutableDictionary *dict;
		plistPath = [[NSBundle mainBundle] pathForResource:CVSettingPlistName ofType:@"plist"];
		self._plistPath = plistPath;
		
		dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
		self._dictSetting = dict;
    }
    return self;
}

/*
 * It gets the the language
 *
 * @param:	none
 * @return:	language code
 */
- (NSString *)cvLanguage {
	NSDictionary *dict;
	NSString *code;
	
	dict = [_dictSetting objectForKey:@"Application"];
	code = [dict objectForKey:@"Language"];
	
	return code;
}

/*
 * It sets the language
 *
 * @param:	language code;
 * @return: none
 */
- (void)cvSetLanguage:(NSString *)code {
	NSMutableDictionary *dict;
	
	if (code) {
		dict = [_dictSetting objectForKey:@"Application"];
		[dict setObject:code forKey:@"Lanaguage"];
		[_dictSetting writeToFile:_plistPath atomically:YES];
	}
}

- (NSInteger)_lifecycle:(NSDictionary *)dictionary portlet:(NSString *)portlet {
	NSNumber *numLifecycle;
	NSInteger minutes;
	
	numLifecycle = [dictionary objectForKey:portlet];
	minutes = [numLifecycle integerValue];
	
	return minutes;
}

/*
 * It gets the lifecycle of cached data.
 *
 * @param:	none
 * @return:	the lifecycle of cached data in minute
 */
- (NSInteger)cvCachedDataLifecycle:(CVSettingPortlet)portlet {
	NSInteger minutes;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	minutes = [[defaults objectForKey:@"cache"] intValue];

//	dict = [_dictSetting objectForKey:@"Cache"];
//	dict = [dict objectForKey:@"CachedDataLifecycle"];
//	
//	switch (portlet) {
//		case CVSettingHomeStockInTheNews:
//		{
//			dict = [dict objectForKey:@"Home"];
//			minutes = [self _lifecycle:dict portlet:@"StockInTheNews"];
//			break;
//		}
//		case CVSettingHomeFinancialSummary:
//		{
//			dict = [dict objectForKey:@"Home"];
//			minutes = [self _lifecycle:dict portlet:@"FinancialSummary"];
//			break;
//		}
//		case CVSettingMarketCompositeIndex:
//		{
//			dict = [dict objectForKey:@"Market"];
//			minutes = [self _lifecycle:dict portlet:@"CompositeIndex"];
//			break;
//		}
//		case CVSettingMarketMostActive:
//		{
//			dict = [dict objectForKey:@"Market"];
//			minutes = [self _lifecycle:dict portlet:@"MostActive"];
//			break;
//		}
//		case CVSettingMarketStock:
//		{
//			dict = [dict objectForKey:@"Market"];
//			minutes = [self _lifecycle:dict portlet:@"Stock"];
//			break;
//		}
//		case CVSettingIndustrialGainerLoser: 
//		{
//			dict = [dict objectForKey:@"Industrial"];
//			minutes = [self _lifecycle:dict portlet:@"GainerLoser"];
//			break;
//		}
//		case CVSettingIndustrialMarketStatistics:
//		{
//			dict = [dict objectForKey:@"Industrial"];
//			minutes = [self _lifecycle:dict portlet:@"Statistics"];
//			break;
//		}
//		case CVSettingNewsSnapshot:
//		{
//			dict = [dict objectForKey:@"News"];
//			minutes = [self _lifecycle:dict portlet:@"Snapshot"];
//			break;
//		}
//		default:
//			break;
//	}
	
	return minutes;
}

/*
 * It sets the lifecycle of cached data.
 */
- (void)cvSetCachedDataLifecycle:(NSInteger)minutes portlet:(CVSettingPortlet)portlet {
	NSMutableDictionary *dict;
	
	dict = [_dictSetting objectForKey:@"Cache"];
	[dict setObject:[NSNumber numberWithInt:minutes] forKey:@"CachedDataLifecycle"];
	[_dictSetting writeToFile:_plistPath atomically:YES];
}

/*
 * It get the categories of today's news
 * @param:	none
 * @return:	an array of category
 */
- (NSArray *)settingTodayNewsCategory {
	NSDictionary *dict;
	NSArray *array;
	
	dict = [_dictSetting objectForKey:@"Home"];
	array = [dict objectForKey:@"TodayNewsCategory"];
	
	return array;
}

/*
 * It accepts the selection of a category. If the category is
 * selected in the database, deselect it. If it is not, select 
 * it.
 *
 * @param:	index - the index of the category
 * @return:	none
 */
- (void)settingTodayNewsSelect:(NSUInteger)index {
	NSDictionary *dict;
	NSArray *array;
	
	dict = [_dictSetting objectForKey:@"Home"];
	array = [dict objectForKey:@"TodayNewsCategory"];
	
	if (index < [array count]) {
		NSDictionary *item;
		NSNumber *number;
		Boolean isSelected;
		
		item = [array objectAtIndex:index];
		number = [item valueForKey:@"select"];
		isSelected = [number boolValue];
		isSelected = !isSelected;
		[item setValue:[NSNumber numberWithBool:isSelected] forKey:@"select"];
		
		// write the setting
		[_dictSetting writeToFile:_plistPath atomically:NO];
	}
}

/*
 * It get the category of stock in the news
 * @param:	none
 * @return:	an array of category
 */
- (NSArray *)settingStockInTheNewsCategory {
	NSDictionary *dict;
	NSArray *array;
	
	dict = [_dictSetting objectForKey:@"Home"];
	array = [dict objectForKey:@"StockInTheNewsCategory"];
	
	return array;
}

/*
 * It accepts the selection of a category. If the category is
 * selected in the database, deselect it. If it is not, select 
 * it.
 *
 * @param:	index - the index of the category
 * @return:	none
 */
- (void)settingStockInTheNewsSelect:(NSUInteger)index {
	NSDictionary *dict;
	NSArray *array;
	
	dict = [_dictSetting objectForKey:@"Home"];
	array = [dict objectForKey:@"StockInTheNewsCategory"];
	
	if (index < [array count]) {
		NSDictionary *item;
		NSNumber *number;
		Boolean isSelected;
		
		item = [array objectAtIndex:index];
		number = [item valueForKey:@"select"];
		isSelected = [number boolValue];
		isSelected = !isSelected;
		[item setValue:[NSNumber numberWithBool:isSelected] forKey:@"select"];
		
		// write the setting
		[_dictSetting writeToFile:_plistPath atomically:NO];
	}
}

/*
 * It get the category of most active of Market
 * @param:	none
 * @return:	an array of category
 */
- (NSArray *)settingMostActiveCategory {
	NSDictionary *dict;
	NSArray *array;
	
	dict = [_dictSetting objectForKey:@"Market"];
	array = [dict objectForKey:@"MostActiveCategory"];
	
	return array;
}

/*
 * It accepts the selection of a category. If the category is
 * selected in the database, deselect it. If it is not, select 
 * it.
 *
 * @param:	index - the index of the category
 * @return:	none
 */
- (void)settingMostActiveSelect:(NSUInteger)index {
	NSDictionary *dict;
	NSArray *array;
	
	dict = [_dictSetting objectForKey:@"Market"];
	array = [dict objectForKey:@"MostActiveCategory"];
	
	if (index < [array count]) {
		NSDictionary *item;
		NSNumber *number;
		Boolean isSelected;
		
		item = [array objectAtIndex:index];
		number = [item valueForKey:@"select"];
		isSelected = [number boolValue];
		isSelected = !isSelected;
		[item setValue:[NSNumber numberWithBool:isSelected] forKey:@"select"];
		
		// write the setting
		[_dictSetting writeToFile:_plistPath atomically:NO];
	}
}

- (void)dealloc {
	[_dictSetting release];
	[super dealloc];
}

-(BOOL)isReachable{
	
	
	Reachability *reachability = [Reachability reachabilityWithHostName:@"www.capitalvue.com"];
	NetworkStatus status = [reachability currentReachabilityStatus];
	
	if (NotReachable==status)
		return NO;
	else
		return YES;
}

@end
