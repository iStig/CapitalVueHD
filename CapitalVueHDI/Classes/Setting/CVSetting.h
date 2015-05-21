//
//  CVSetting.h
//  CapitalVueHD
//
//  Created by jishen on 9/13/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
	CVSettingHomeStockInTheNews,
	CVSettingHomeFinancialSummary,
	CVSettingMarketCompositeIndex,
	CVSettingMarketMostActive,
	CVSettingMarketStock,
	CVSettingIndustrialGainerLoser,
	CVSettingIndustrialMarketStatistics,
	CVSettingNewsSnapshot,
	CVSettingMacro,
	CVSettingBenchmarkTitans,
	CVSettingBenchmarkBlueChips,
	CVSettingPortletInvalid
} CVSettingPortlet;

@interface CVSetting : NSObject {
@private
	NSMutableDictionary *_dictSetting;
	NSString *_plistPath;
}

/*
 * It get the instance handler
 * @param:	none
 * @return:	none
 */
+ (CVSetting *)sharedInstance;

/*
 * It gets the the language
 *
 * @param:	none
 * @return:	language code
 */
- (NSString *)cvLanguage;

/*
 * It sets the language
 *
 * @param:	language code;
 * @return: none
 */
- (void)cvSetLanguage:(NSString *)code;

/*
 * It gets the lifecycle of cached data for specified portlet.
 *
 * @param:	portlet - the portlet
 * @return:	the lifecycle of cached data in minute
 */
- (NSInteger)cvCachedDataLifecycle:(CVSettingPortlet)portlet;

/*
 * It sets the lifecycle of cached data for specififed portlet
 *
 * @param:	minutes - the lifecyle of cached data
 *			portlet - the portlet
 * @return:	none
 */
- (void)cvSetCachedDataLifecycle:(NSInteger)minutes portlet:(CVSettingPortlet)portlet;

/*
 * It get the categories of today's news
 * @param:	none
 * @return:	an array of category
 */
- (NSArray *)settingTodayNewsCategory;

/*
 * It accepts the selection of a category. If the category is
 * selected in the database, deselect it. If it is not, select 
 * it.
 *
 * @param:	index - the index of the category
 * @return:	none
 */
- (void)settingTodayNewsSelect:(NSUInteger)index;

/*
 * It get the category of stock in the news
 * @param:	none
 * @return:	an array of category
 */
- (NSArray *)settingStockInTheNewsCategory;

/*
 * It accepts the selection of a category. If the category is
 * selected in the database, deselect it. If it is not, select 
 * it.
 *
 * @param:	index - the index of the category
 * @return:	none
 */
- (void)settingStockInTheNewsSelect:(NSUInteger)index;

/*
 * It get the category of most active of Market
 * @param:	none
 * @return:	an array of category
 */
- (NSArray *)settingMostActiveCategory;

/*
 * It accepts the selection of a category. If the category is
 * selected in the database, deselect it. If it is not, select 
 * it.
 *
 * @param:	index - the index of the category
 * @return:	none
 */
- (void)settingMostActiveSelect:(NSUInteger)index;

/**
 *	determine whether if network is reachable
 */
- (BOOL)isReachable;

@end
