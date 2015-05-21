//
//  cvChartFormatterPeriodSelector.h
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cvChartFormatterGeneral.h"


@interface cvChartFormatterButton : NSObject {
    NSNumber *Width;
    NSNumber *Height;
    UIColor *BackgroundColor;
    UIColor *BackgroundColorSelected;
    UIColor *BorderColor;
    NSNumber *BorderWidth;
    NSNumber *CornerRadius;
    NSString *TextFont;
    NSNumber *TextSize;
    UIColor *TextColor;
    UIColor *TextColorSelected;
}

@property (nonatomic, retain) NSNumber *Width;
@property (nonatomic, retain) NSNumber *Height;
@property (nonatomic, retain) UIColor *BackgroundColor;
@property (nonatomic, retain) UIColor *BackgroundColorSelected;
@property (nonatomic, retain) UIColor *BorderColor;
@property (nonatomic, retain) NSNumber *BorderWidth;
@property (nonatomic, retain) NSNumber *CornerRadius;
@property (nonatomic, retain) NSString *TextFont;
@property (nonatomic, retain) NSNumber *TextSize;
@property (nonatomic, retain) UIColor *TextColor;
@property (nonatomic, retain) UIColor *TextColorSelected;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface cvChartFormatterPeriodSelectorElement : NSObject {
    NSString *Title;
    NSNumber *Period;
    BOOL Enabled;
}
@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSNumber *Period;
@property (nonatomic, assign) BOOL Enabled;

-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface cvChartFormatterPeriodSelector : NSObject {
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
    cvChartFormatterButton *Button;
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
@property (nonatomic, retain) cvChartFormatterButton *Button;
@property (nonatomic, retain) NSArray *Items;

-(id)initWithDictionary:(NSDictionary *)dict Defaults:(cvChartFormatterGeneral *)general;
-(void)initializePeriodArray:(NSDictionary *)dict;

@end
