//
//  cvChartFormatterLegend.h
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cvChartFormatterGeneral.h"

@interface cvChartFormatterLegendItem : NSObject
{
    NSString *Title;
    NSNumber *X;
    NSNumber *Y;
    NSString *ValueKey;
    NSNumber *DigitsAfterDecimal;
}

@property (nonatomic, retain) NSNumber *X;
@property (nonatomic, retain) NSNumber *Y;
@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSString *ValueKey;
@property (nonatomic, retain) NSNumber *DigitsAfterDecimal;

-(id)initWithDictionary:(NSDictionary *)dict;

@end


@interface cvChartFormatterLegend : NSObject {
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
    UIColor *ValueColor;
    UIColor *PositiveColor;
    UIColor *NegativeColor;
    NSArray *Items;
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
@property (nonatomic, retain) UIColor *ValueColor;
@property (nonatomic, retain) UIColor *PositiveColor;
@property (nonatomic, retain) UIColor *NegativeColor;
@property (nonatomic, retain) NSArray *Items;

-(id)initWithDictionary:(NSDictionary *)dict Defaults:(cvChartFormatterGeneral *)general;
-(void)initializeItemsArray:(NSDictionary *)dict;
-(void)setTitles:(NSArray *)titleArray;

@end
