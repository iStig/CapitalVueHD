//
//  CVDataMacroChartSample.h
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CVDataMacroChartSample : NSObject {
	NSDate *date;
	double growth;
	double value;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic) double growth;
@property (nonatomic) double value;

@end
