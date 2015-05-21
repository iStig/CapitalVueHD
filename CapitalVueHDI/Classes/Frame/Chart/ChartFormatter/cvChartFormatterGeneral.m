//
//  cvChartFormatterGeneral.m
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cvChartFormatterGeneral.h"


#pragma mark -
#pragma mark General Plotarea Configurations for Chart

@implementation cvChartFormatterPlotArea

@synthesize X, Y, Width, Height, BackgroundColor, BackgroundOpacity;
@synthesize BorderColor, BorderOpacity, CornerRadius;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
        
        self.X = [dict objectForKey:@"X"];
        self.Y = [dict objectForKey:@"Y"];
        self.Width = [dict objectForKey:@"Width"];
        self.Height = [dict objectForKey:@"Height"];
        
        self.BackgroundOpacity = [dict objectForKey:@"BackgroundOpacity"];
        bgColor = [[dict objectForKey:@"BackgroundColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = [BackgroundOpacity floatValue]/255.0;
        self.BackgroundColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
        self.BorderOpacity = [dict objectForKey:@"BorderOpacity"];
        bgColor = [[dict objectForKey:@"BorderColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = [BorderOpacity floatValue]/255.0;
        self.BorderColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        self.CornerRadius = [dict objectForKey:@"CornerRaius"];
    }
    
    return self;
}

- (void)dealloc
{
    [X release];
    [Y release];
    [Width release];
    [Height release];
    
    [BackgroundColor release];
    [BackgroundOpacity release];
    [BorderColor release];
    [BorderOpacity release];
    
    [CornerRadius release];
    [super dealloc];
}

@end


#pragma mark -
#pragma mark General Configurations for Chart
@implementation cvChartFormatterGeneral

@synthesize Width, Height, Margin, BackgroundColor, BackgroundOpacity;
@synthesize BorderColor, BorderOpacity, BorderWidth, CornerRadius, TextFont, TextColor, TextSize;
@synthesize PlotArea, Resize, PreLoaderEnable, DataCachingEnable, HeaderEnable, LegendEnable, PeriodSelectorEnable;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
        
        Width = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"Width"] integerValue]];
        Height = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"Height"] integerValue]];
        Margin = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"Margin"] integerValue]];
        
        BackgroundOpacity = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"BackgroundOpacity"] integerValue]];
        bgColor = [[dict objectForKey:@"BackgroundColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ([BackgroundOpacity integerValue])/255.0;
        BackgroundColor = [[UIColor alloc] initWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
        BorderOpacity = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"BorderOpacity"] integerValue]];
        bgColor = [[dict objectForKey:@"BorderColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = [BorderOpacity floatValue]/255.0;
        BorderColor = [[UIColor alloc] initWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        BorderWidth = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"BorderWidth"] integerValue]];
        CornerRadius = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"CornerRadius"] integerValue]];
        
        TextFont = [[NSString alloc] initWithString:[dict objectForKey:@"TextFont"]];
        bgColor = [[dict objectForKey:@"TextColor"] integerValue];
        bgColor |= 0xFF000000;
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        TextColor = [[UIColor alloc] initWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        TextSize = [[NSNumber alloc] initWithInt:[[dict objectForKey:@"TextSize"] integerValue]];
        
        Resize = [[dict objectForKey:@"Resize"] boolValue];
        PreLoaderEnable = [[dict objectForKey:@"PreLoaderEnable"] boolValue];
        DataCachingEnable = [[dict objectForKey:@"DataChcingEnable"] boolValue];
        HeaderEnable = [[dict objectForKey:@"HeaderEnable"] boolValue];
        LegendEnable = [[dict objectForKey:@"LegendEnable"] boolValue];
        PeriodSelectorEnable = [[dict objectForKey:@"PeriodSelectorEnable"] boolValue];
        
        PlotArea = [[cvChartFormatterPlotArea alloc] initWithDictionary:[dict objectForKey:@"PlotArea"]];
    }
    
    return self;
}

- (void)dealloc
{
    [Width release];
    [Height release];
    [Margin release];
    [BackgroundColor release];
    [BackgroundOpacity release];
    [BorderColor release];
    [BorderOpacity release];
    [BorderWidth release];
    [CornerRadius release];
    
    [TextFont release];
    [TextColor release];
    [TextSize release];
    
    [PlotArea release];
    
    [super dealloc];
}

@end