//
//  CVDataProvider.h
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVDatacache.h"
#import "CVParamInfo.h"
#import "CVLocalizationSetting.h"
typedef enum {
	CVDataProviderNewsListTypeTodayNews,
	CVDataProviderNewsListTypeSectorTodayNews,
	CVDataProviderNewsListTypeHeadlineNews,
	CVDataProviderNewsListTypeLatestNews,
	CVDataProviderNewsListTypeMacroNews,
	CVDataProviderNewsListTypeDiscretionaryNews,
	CVDataProviderNewsListTypeStaplesNews,
	CVDataProviderNewsListTypeFinancialsNews,
	CVDataProviderNewsListTypeHealthCareNews,
	CVDataProviderNewsListTypeIndustrialsNews,
	CVDataProviderNewsListTypeMaterialsNews,
	CVDataProviderNewsListTypeEnergyNews,
	CVDataProviderNewsListTypeTelecomNews,
	CVDataProviderNewsListTypeUtilitiesNews,
	CVDataProviderNewsListTypeITNews,
	CVDataProviderNewsListTypeRelative,       //relative news
	CVDataProviderNewsListTypeStockRelated,
	CVDataProviderNewsListTypeNewsRelated,
	CVDataProviderNewsListTypeColumn,
	CVDataProviderNewsListTypeStock,
	CVDataProviderNewsListTypeInvalid
} CVDataProviderNewsListType;

typedef enum {
	CVDataProviderMyStockDetailTypeStock,
	CVDataProviderMyStockDetailTypeMinuteStock,
	CVDataProviderMyStockDetailTypeMinuteComposite,
	CVDataProviderMyStockDetailTypeMinuteMultipleStock,
	CVDataProviderMyStockDetailTypeMinuteMultipleComposite,
	CVDataProviderMyStockDetailTypeFund,
	CVDataProviderMyStockDetailTypeBond,
	CVDataProviderMyStockDetailTypeInvalid
} CVDataProviderMyStockDetailType;

typedef enum {
	CVDataProviderStockListTypeAll,
	CVDataProviderStockListTypeNewsRelated,
	CVDataProviderStockListTypeTopMovingSecruties,
	CVDataProviderStockListTypeMostActive,
	CVDataProviderStockListTypeTopMarketCapital,
	CVDataProviderStockListTypeSectorTopGainer,
	CVDataProviderStockListTypeSectorTopDecliner,
	CVDataProviderStockListTypeFavorite,
	CVDataProviderStockListTypeInvalid
} CVDataProviderStockListType;

typedef enum {
	CVDataProviderFundListTypeAll,
	CVDataProviderFundListTypeDailySummary,
	CVDataProviderFundListTypeTopMovingSecruties,
	CVDataProviderFundListTypeFavorite,
	CVDataProviderFundListTypeInvalid
} CVDataProviderFundListType;

typedef enum {
	CVDataProviderBondListTypeAll,
	CVDataProviderBondListTypeDailySummary,
	CVDataProviderBondListTypeTopMovingSecruties,
	CVDataProviderBondListTypeFavorite,
	CVDataProviderBondListTypeInvalid
} CVDataProviderBondListType;

typedef enum {
	CVDataProviderCompositeIndexTypeDaily,
	CVDataProviderCompositeIndexTypeSummary,
	CVDataProviderCompositeIndexTypeInvalid
} CVDataProviderCompositeIndexType;

typedef enum {
	CVDataProviderChartTypeStock,
	CVDataProviderChartTypeFund,
	CVDataProviderChartTypeBond,
	CVDataProviderChartTypeEquityIndices,
	CVDataProviderChartTypeFundIndices,
	CVDataProviderChartTypeBondIndices,
	CVDataProviderChartTypeMacroIndex,
	CVDataProviderChartTypeMultipleIndex,
	CVDataProviderChartTypeEquityIntraday,
	CVDataProviderChartTypeEquityIndexIntraday,
	CVDataProviderChartTypeInvalid
} CVDataProviderChartType;

typedef enum {
	CVDataProviderBenchmarkTypeTopAShare,
	CVDataProviderBenchmarkTypeTopBlueChips,
	CVDataProviderBenchmarkTypeInvalid
} CVDataProviderBenchmarkType;

@interface CVDataProvider : NSObject {

}

+ (CVDataProvider *)sharedInstance;

/*
 * It set the identifier for data and its expire interval.
 *
 * @param:	identifier -  the identifier of a data block
 *			minutes - lifecycle
 * @return:	none
 */
- (void)setDataIdentifier:(NSString *)identifer lifecycle:(NSInteger)minutes;

/*
 * It checks whether the data blcok of identifier expires
 *
 * @param:	identifier -  the identifier of a data block
 * @return:	none
 */
- (BOOL)isDataExpired:(NSString *)identifier;

/*
 *	Set all cache time expired , for the cache file removed by user
 *	
 */
- (void)setAllDataExpired;

/*
 * Check if the data needs to update
 *
 * @param:	identifier -  the identifier of a data block
 *
 * @return none
 */
- (BOOL)isNeedUpdate:(NSString *)identifier;


/*
 * Get the news api's token
 *
 *
 */
-(NSString *)GetNewsToken:(CVDataProviderNewsListType)type withParams:(NSArray *)obj;

/*
 * It gets the news list of the specified type
 *
 * @param:	type - news list type
 *			obj - paramters
 *			needRefresh - if needs getting data from server
 * @return: dictionary
 */
-(NSDictionary *)GetNewsList:(CVDataProviderNewsListType)type withParams:(id)obj forceRefresh:(BOOL)needRefresh;

/*
 * It gets news article
 *
 * @param:	postid - news id
 * @return:	news article content
 */
-(NSDictionary *)GetNewsDetail:(NSString *)postid;

-(NSString *)getStockInNewsToken:(CVDataProviderStockListType)type withParams:(CVParamInfo *)paramInfo;

/*
 * It gets the stock list of the specified type.
 *
 * @param:	type - stock list type
 *			obj - parameters
 * @return:	dictionary
 */
-(NSDictionary *)GetStockList:(CVDataProviderStockListType)type withParams:(CVParamInfo *)paramInfo;

/*
 * It gets the stock list of the specified type from server.
 *
 * @param:	type - stock list type
 *			obj - parameters
 * @return:	dictionary
 */
-(NSDictionary *)ReGetStockList:(CVDataProviderStockListType)type withParams:(CVParamInfo *)paramInfo;

/*
 * It gets the profile of a given stock
 *
 * @param:	code - stock code
 * @return:	NSDictionary
 */
-(NSDictionary *)GetStockProfile:(CVParamInfo *)paramInfo;

-(NSDictionary *)GetMyStockDetail:(CVDataProviderMyStockDetailType)type withParams:(CVParamInfo *)paramInfo;

/*
 * Refresh stock detail from server,for just CVDataProviderMyStockDetailTypeStock
 */
-(NSDictionary *)ReGetMyStockDetail:(CVDataProviderMyStockDetailType)type withParams:(CVParamInfo *)paramInfo;

/*
 * It gets the data of chart
 *
 * @param:	type - chart type
 *			paramInfo - lifecycle and parameter
 * @return:	chart data
 */
-(NSDictionary *)GetChartData:(CVDataProviderChartType)type withParams:(CVParamInfo *)paramInfo;

/*
 *	Double cache level for chart data,
 *
 *	first check 22*24 days cache file,
 *	then return the special number of chart data,
 *	from the large chart data for request
 *
 */
-(NSDictionary *)GetDoubleCacheDataForChart:(CVDataProviderChartType)type withParams:(CVParamInfo *)paramInfo  andRefresh:(BOOL)isRefresh;

/*
 * It gets the data of chart from server anyway
 *
 * @param:	type - chart type
 *			paramInfo - lifecycle and parameter
 * @return:	chart data
 */
-(NSDictionary *)ReGetChartData:(CVDataProviderChartType)type withParams:(CVParamInfo *)paramInfo;

-(NSDictionary *)GetCompositeIndexList:(CVDataProviderCompositeIndexType)type withParams:(id)obj;

-(NSDictionary *)ReGetCompositeIndexList:(CVDataProviderCompositeIndexType)type withParams:(id)obj;

/*
 * It gets the profile of a givein composite index
 *
 * @param:	code - code of composite index
 * @return:	NSDictionary
 */
-(NSDictionary *)GetIndexProfile:(CVParamInfo *)paramInfo;

/*
 * It gets the latest status of a given composite index
 * 
 * @param: code - code of composite index
 * @return: NSDictionary
 */
-(NSDictionary *)GetIndexLatestPrice:(CVParamInfo *)paramInfo;

/*
 * It gets the securities of fund
 *
 * @param:	type - list type
 *			paramInfo -  lifecycle and parameter
 * @reutnr:	an array consisting of securities
 */
-(NSDictionary *)GetFundList:(CVDataProviderFundListType)type withParams:(CVParamInfo *)paramInfo;

-(NSDictionary *)GetFundSummary:(CVParamInfo *)paramInfo;

/*
 * It gets the securities of bond
 *
 * @param:	type - list type
 *			paramInfo -  lifecycle and parameter
 * @reutnr:	an array consisting of securities
 */
-(NSDictionary *)GetBondList:(CVDataProviderBondListType)type withParams:(id)obj;

/*
 * It gets the sectors with its basic information, including sector name,
 * number of stocks of a sector, number of gainers as well as number of losers.
 *
 * @param: none
 * @return: dictionary
 */
- (NSDictionary *)GetSectorList:(CVParamInfo *)paramInfo;

/*
 * It refresh the sectors with its basic information, including sector name,
 * number of stocks of a sector, number of gainers as well as number of losers.
 *
 * @param: none
 * @return: dictionary
 */
- (NSDictionary *)RefreshSectorList:(CVParamInfo *)paramInfo;

/*
 * It gets the top gainers and top decliners of a sector.
 *
 * @param: sectorId - the id of a sector.
 *							Sector					Id
 *						Energy						10
 *						Materials					15
 *						Industrials					20
 *						Consumer Discretionary		25
 *						Consumer Staples			30
 *						Health Care					35
 *						Financials					40
 *						Information Technology		45
 *						Telecommunication Services	50
 *						Utilities					55
 *
 * @return:	a dictionary has an array of gainers and an array of decliners.
 *			The dictionary has a key "gainers" for object of gainers array, 
 *			and a key "decliners" for object of decliners array.
 */
- (NSDictionary *)GetSectorTopGainersDecliners:(CVParamInfo *)paramInfo;
-(NSDictionary *)GetSectorAll;
-(NSDictionary *)GetSectorSummaryAtId:(CVParamInfo *)paramInfo;
-(NSDictionary *)GetSectorTurnoverAtId:(CVParamInfo *)paramInfo;
-(NSDictionary *)GetSectorVolumeAtId:(CVParamInfo *)paramInfo;
-(NSDictionary *)GetSectorTotalCapitalAtId:(CVParamInfo *)paramInfo;
-(NSDictionary *)GetSectorTradableCapitalAtId:(CVParamInfo *)paramInfo;

-(NSDictionary *)ReGetSectorSummaryAtId:(CVParamInfo *)paramInfo;
-(NSDictionary *)ReGetSectorTurnoverAtId:(CVParamInfo *)paramInfo;
-(NSDictionary *)ReGetSectorVolumeAtId:(CVParamInfo *)paramInfo;
-(NSDictionary *)ReGetSectorTotalCapitalAtId:(CVParamInfo *)paramInfo;
-(NSDictionary *)ReGetSectorTradableCapitalAtId:(CVParamInfo *)paramInfo;


-(NSArray *)GetMacroList;

/*
 * It retrieves the history data of an index of macro.
 *
 * @param:	leftAxis - the first parameter for retrieving the data, it shall not be nil.
 *			rightAxis - the second parameter for retrieving the data, it could be nil.
 * @return:	NSDcitionary-typed value. The dictionary has two objects with keys "head" and
 *			"data". Object of head is an array, element of which has the structure - name
 *			and value. Name is the key that exists in each NSDictionary-typed element of 
 *			object of data, and value is the readable title corresponding to key which
 *			can be shown on UI. Object of data is also an array carries elements holding keys
 *			that is defined in object of head, you can get the value by request for key 
 *			"DATE", "ZBZ_2" and "ZBZ" (ZBZ_2 - Growth, ZBZ - Value).
 */
-(NSDictionary *)GetMacroIndexData:(NSString *)leftAxis andArg:(NSString *)rightAxis;

/*
 * It gets the balance statistics of an equity
 *
 * @param:	paramInfo - equity code and lifecycle
 * @return:	balance statistics
 */
-(NSDictionary *)GetStockBlance:(CVParamInfo *)paramInfo;

-(NSDictionary *)GetStockIncomeStatement:(CVParamInfo *)paramInfo;
-(NSDictionary *)GetStockCashFlow:(CVParamInfo *)paramInfo;


-(BOOL)IsCodeAvailable:(NSString *)code;
-(BOOL)IsNameAvailable:(NSString *)code;
-(NSUInteger)AddFavorite:(id)obj;


-(NSDictionary *)GetMostActivatedTurnover:(CVParamInfo *)paramInfo;
-(NSDictionary *)GetMostActivatedMarketCap:(CVParamInfo *)paramInfo;
-(NSDictionary *)GetMostActivatedTopGainer:(CVParamInfo *)paramInfo;

-(NSDictionary *)RegetMostActivatedTurnover:(CVParamInfo *)paramInfo;
-(NSDictionary *)RegetMostActivatedMarketCap:(CVParamInfo *)paramInfo;
-(NSDictionary *)RegetMostActivatedTopGainer:(CVParamInfo *)paramInfo;


/*
 * Get the benchmark info
 * @param	paraminfo - allmost, limit number
 * @param	dataType - datatype of the request
 *
 * @return	dict of the benchmark
 */
-(NSDictionary *)GetBenchmark:(CVDataProviderBenchmarkType)dataType WithParamInfo:(CVParamInfo *)paramInfo;

/*
 * it retrieves the company log
 *
 * @param:	code -  company code
 * @reutrn:	the NSString-typed adress of the logo
 */
-(NSString *)GetCompanyLogo:(NSString *)code;

/*
 * it start a thread which updates the local cached data
 * at a given time span.
 */
-(void)startScheduledProcess;

-(NSDictionary *)GetDailyBoardStatistics;
-(NSDictionary *)GetDailyMarketStatistics;


@end
