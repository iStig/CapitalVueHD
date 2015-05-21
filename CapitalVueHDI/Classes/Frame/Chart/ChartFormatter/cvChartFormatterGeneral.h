//
//  cvChartFormatterGeneral.h
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface cvChartFormatterPlotArea : NSObject {
    NSNumber *X;
    NSNumber *Y;
    NSNumber *Width;
    NSNumber *Height;
    UIColor *BackgroundColor;
    NSNumber *BackgroundOpacity;
    UIColor *BorderColor;
    NSNumber *BorderOpacity;
    NSNumber *CornerRadius;
}

@property (nonatomic, retain) NSNumber *X;
@property (nonatomic, retain) NSNumber *Y;
@property (nonatomic, retain) NSNumber *Width;
@property (nonatomic, retain) NSNumber *Height;
@property (nonatomic, retain) UIColor *BackgroundColor;
@property (nonatomic, retain) NSNumber *BackgroundOpacity;
@property (nonatomic, retain) UIColor *BorderColor;
@property (nonatomic, retain) NSNumber *BorderOpacity;
@property (nonatomic, retain) NSNumber *CornerRadius;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface cvChartFormatterGeneral : NSObject {
    NSNumber *Width;
    NSNumber *Height;
    NSNumber *Margin;
    UIColor *BackgroundColor;
    NSNumber *BackgroundOpacity;
    UIColor *BorderColor;
    NSNumber *BorderOpacity;
    NSNumber *BorderWidth;
    NSNumber *CornerRadius;
    NSString *TextFont;
    UIColor *TextColor;
    NSNumber *TextSize;
    BOOL Resize;
    BOOL PreLoaderEnable;
    BOOL DataCachingEnable;
    BOOL HeaderEnable;
    BOOL LegendEnable;
    BOOL PeriodSelectorEnable;
    cvChartFormatterPlotArea *PlotArea;
}

@property (nonatomic, retain) NSNumber *Width;
@property (nonatomic, retain) NSNumber *Height;
@property (nonatomic, retain) NSNumber *Margin;
@property (nonatomic, retain) UIColor *BackgroundColor;
@property (nonatomic, retain) NSNumber *BackgroundOpacity;
@property (nonatomic, retain) UIColor *BorderColor;
@property (nonatomic, retain) NSNumber *BorderOpacity;
@property (nonatomic, retain) NSNumber *BorderWidth;
@property (nonatomic, retain) NSNumber *CornerRadius;
@property (nonatomic, retain) NSString *TextFont;
@property (nonatomic, retain) UIColor *TextColor;
@property (nonatomic, retain) NSNumber *TextSize;
@property (nonatomic, retain) cvChartFormatterPlotArea *PlotArea;

@property (nonatomic, assign) BOOL Resize;
@property (nonatomic, assign) BOOL PreLoaderEnable;
@property (nonatomic, assign) BOOL DataCachingEnable;
@property (nonatomic, assign) BOOL HeaderEnable;
@property (nonatomic, assign) BOOL LegendEnable;
@property (nonatomic, assign) BOOL PeriodSelectorEnable;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
