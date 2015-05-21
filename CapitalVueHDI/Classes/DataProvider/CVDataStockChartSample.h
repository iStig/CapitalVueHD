//
//  CVDataStockChartSample.h
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CVDataStockChartSample : NSObject {
	NSDate *date;
	double cjl;
	double cjlRZdj;
	double cjlRSpj;
	double cjje;
	double cjjeRKpj;
	double cjjeRZgj;
}

@property(nonatomic, retain) NSDate *date;
@property(nonatomic) double cjl;
@property(nonatomic) double cjlRZdj;
@property(nonatomic) double cjlRSpj;
@property(nonatomic) double cjje;
@property(nonatomic) double cjjeRKpj;
@property(nonatomic) double cjjeRZgj;

@end
