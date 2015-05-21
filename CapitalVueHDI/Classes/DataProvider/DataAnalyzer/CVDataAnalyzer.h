//
//  CVDataAnalyzer.h
//  CapitalVueHD
//
//  Created by jishen on 8/25/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	CVDataTypeNewsDetail,
	CVDataTypeRelativeNewsList,
	CVDataTypeTodayNewsList,
	CVDataTypeHeadlineNewsList,
	CVDataTypeLatestNewsList,
	CVDataTypeMacroNewsList,
	CVDataTypeDiscretionaryNewsList,
	CVDataTypeStaplesNewsList,
	CVDataTypeFinancialsNewsList,
	CVDataTypeHealthCareNewsList,
	CVDataTypeIndustrialsNewsList,
	CVDataTypeMaterialsNewsList,
	CVDataTypeEnergyNewsList,
	CVDataTypeTelecomNewsList,
	CVDataTypeUtilitiesNewsList,
	CVDataTypeITNewsList,
	CVDataTypeIndustryNewsList,
	CVDataTypeStockNewsList,
	CVDataTypeCompositeIndexList,
	CVDataTypeCompositeIndexSummary,
	CVDataTypeStockCodeList,
	CVDataTypeEquityProfile,
	CVDataTypeIndexProfile,
	CVDataTypeIndexLatestPrice,
	CVDataTypeStockTopMovingSecurites,
	CVDataTypeStockInTheNews,
	CVDataTypeStockMostActive,
	CVDataTypeStockTopMarketCapital,
	CVDataTypeFundTopMovingSecurites,
	CVDataTypeBondTopMovingSecurites,
	CVDataTypeStockChart,
	CVDataTypeFundChart,
	CVDataTypeBondChart,
	CVDataTypeStockDetail,   //leon changed
	CVDataTypeFundDetail,
	CVDataTypeBondDetail,
	CVDataTypeSectorList,
	CVDataTypeSectorTopGainerDecliner,
	CVDataTypeSectorTurnover,
	CVDataTypeSectorVolume,
	CVDataTypeSectorTotalCap,
	CVDataTypeSectorTradableCap,
	CVDataTypeSectorSummary,
	CVDataTypeMacroData,
	CVDataTypeEquityBalanceSheet,
	CVDataTypeEquityIncomeStatement,
	CVDataTypeEquityCashFlow,
	CVDataTypeMostActivatedMarketCap,
	CVDataTypeBenchmarkTopAShare,
	CVDataTypeBenchmarkTopBlueChips,
	CVDataTypeInvalid
} CVDataType;

@interface CVDataAnalyzer : NSObject {

}

+ (id) analyze:(CVDataType)type data:(NSDictionary *)rawData;

@end
