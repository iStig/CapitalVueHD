//
//  stockChartDataSource.h
//  cvChart
//
//  Created by He Jun on 10-7-27.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

typedef enum {
    StockDataIntraDay = 0,
    StockDataOneWeek,
    StockDataThreeWeeks,
    StockDataOneMonth,
    StockDataThreeMonths,
    StockDataSixMonths,
    StockDataOneYear,
    StockDataTwoYears,
    StockDataThreeYears,
    StockDataFiveYears,
    StockDataMax,
}StockDataTimeFrame_e;

@protocol StockChartDataSource

@required

- (NSArray *)ChartGetRecordsByName:(NSString *)name Period:(StockDataTimeFrame_e)timeFrame;

@end
