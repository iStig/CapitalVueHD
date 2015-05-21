//
//  cvChartFormatterChart.h
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cvChartFormatterGeneral.h"


@interface cvChartFormatterChartXAxisGrid : NSObject {
    BOOL Enable;
    NSNumber *Lines;
    UIColor *Color;
    NSNumber *Opacity;
}

@property (nonatomic, retain) NSNumber *Lines;
@property (nonatomic, retain) UIColor *Color;
@property (nonatomic, retain) NSNumber *Opacity;
@property (nonatomic, assign) BOOL Enable;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface cvChartFormatterChartXAxisValue : NSObject {
    BOOL Enable;
    NSNumber *TextSize;
    UIColor *TextColor;
}

@property (nonatomic, retain) NSNumber *TextSize;
@property (nonatomic, retain) UIColor *TextColor;
@property (nonatomic, assign) BOOL Enable;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface cvChartFormatterChartXAxis : NSObject {
    cvChartFormatterChartXAxisGrid *Grid;
    cvChartFormatterChartXAxisValue *Value;
}

@property (nonatomic, retain) cvChartFormatterChartXAxisGrid *Grid;
@property (nonatomic, retain) cvChartFormatterChartXAxisValue *Value;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface cvChartFormatterChartYAxisGrid : NSObject {
    BOOL Enable;
    UIColor *Color;
    NSNumber *Opacity;
}

@property (nonatomic, retain) UIColor *Color;
@property (nonatomic, retain) NSNumber *Opacity;
@property (nonatomic, assign) BOOL Enable;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface cvChartFormatterChartYAxisValue : NSObject {
    BOOL Enable;
    UIColor *TextColor;
    NSNumber *TextSize;
    NSString *ValueKey;
    NSString *Unit;
    NSString *UnitPosition;
    NSNumber *DigitsAfterDecimal;
    BOOL RegularNumber;
    BOOL PercentageNumber;
}

@property (nonatomic, retain) UIColor *TextColor;
@property (nonatomic, retain) NSNumber *TextSize;
@property (nonatomic, retain) NSString *ValueKey;
@property (nonatomic, retain) NSString *Unit;
@property (nonatomic, retain) NSString *UnitPosition;
@property (nonatomic, retain) NSNumber *DigitsAfterDecimal;
@property (nonatomic, assign) BOOL Enable;
@property (nonatomic, assign) BOOL RegularNumber;
@property (nonatomic, assign) BOOL PercentageNumber;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface cvChartFormatterChartYAxis : NSObject {
    cvChartFormatterChartYAxisGrid *Grid;
    cvChartFormatterChartYAxisValue *Value;
}

@property (nonatomic, retain) cvChartFormatterChartYAxisGrid *Grid;
@property (nonatomic, retain) cvChartFormatterChartYAxisValue *Value;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface cvChartFormatterChartGraph : NSObject {
    NSString *ID;
    NSString *Title;
    NSString *Type;
    NSString *ValueKey;
    NSNumber *StrokeSize;
    UIColor *Color;
    NSNumber *FillOpacity;
    UIColor *PositiveColor;
    UIColor *NegativeColor;
    BOOL Smoothed;
    BOOL Shadowed;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSString *Type;
@property (nonatomic, retain) NSString *ValueKey;
@property (nonatomic, retain) NSNumber *StrokeSize;
@property (nonatomic, retain) UIColor *Color;
@property (nonatomic, retain) NSNumber *FillOpacity;
@property (nonatomic, retain) UIColor *PositiveColor;
@property (nonatomic, retain) UIColor *NegativeColor;
@property (nonatomic, assign) BOOL Smoothed;
@property (nonatomic, assign) BOOL Shadowed;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

typedef enum {
	cvChartXValueTypeDay,
	cvChartXValueTypeMonth,
	cvChartXValueTypeYear,
	cvChartXValueTypeInvalid
} cvChartXValueType;

@interface cvChartFormatterChart : NSObject {
    NSNumber *X;
    NSNumber *Y;
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
    NSNumber *GraphAreaX;
    NSNumber *GraphAreaY;
    NSNumber *GraphAreaWidth;
    NSNumber *GraphAreaHeight;
    NSString *ChartID;
    NSNumber *Columns;
    NSNumber *Rows;
    NSString *BulletType;
    UIColor *BulletColor;
    NSNumber *BulletSize;
    BOOL InteractEnable;
    cvChartFormatterChartXAxis *XAxis;
    cvChartFormatterChartYAxis *YLeftAxis;
    cvChartFormatterChartYAxis *YRightAxis;
	cvChartXValueType XValueType;
    NSArray *Graphs;
}

@property (nonatomic, retain) NSNumber *X;
@property (nonatomic, retain) NSNumber *Y;
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
@property (nonatomic, retain) NSNumber *GraphAreaX;
@property (nonatomic, retain) NSNumber *GraphAreaY;
@property (nonatomic, retain) NSNumber *GraphAreaWidth;
@property (nonatomic, retain) NSNumber *GraphAreaHeight;
@property (nonatomic, retain) NSString *ChartID;
@property (nonatomic, retain) NSNumber *Columns;
@property (nonatomic, retain) NSNumber *Rows;
@property (nonatomic, retain) NSString *BulletType;
@property (nonatomic, retain) UIColor *BulletColor;
@property (nonatomic, retain) NSNumber *BulletSize;
@property (nonatomic, assign) BOOL InteractEnable;

@property (nonatomic, retain) cvChartFormatterChartXAxis *XAxis;
@property (nonatomic, retain) cvChartFormatterChartYAxis *YLeftAxis;
@property (nonatomic, retain) cvChartFormatterChartYAxis *YRightAxis;
@property (nonatomic, assign) cvChartXValueType XValueType;
@property (nonatomic, retain) NSArray *Graphs;


-(id)initWithDictionary:(NSDictionary *)dict Defaults:(cvChartFormatterGeneral *)general;

@end
