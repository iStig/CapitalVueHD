//
//  cvChartFormatterHeader.m
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cvChartFormatterHeader.h"


#pragma mark -
#pragma mark Configurations for Chart Header

@implementation cvChartFormatterHeader

@synthesize X, Y, Width, Height, Margin, BackgroundColor, BackgroundOpacity;
@synthesize BorderColor, BorderOpacity, BorderWidth, CornerRadius, TextFont, TextColor, TextSize;

-(id)initWithDictionary:(NSDictionary *)dict Defaults:(cvChartFormatterGeneral *)general
{
    if ((self = [super init]) && (nil != dict)){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
        
        self.X = [dict objectForKey:@"X"];
        self.Y = [dict objectForKey:@"Y"];
        
        if (nil == [dict objectForKey:@"Width"]) self.Width = general.Width;
        else self.Width = [dict objectForKey:@"Width"];
        if (nil == [dict objectForKey:@"Height"]) self.Height = general.Height;
        else self.Height = [dict objectForKey:@"Height"];
        
        if (nil == [dict objectForKey:@"Margin"]) self.Margin = general.Margin;
        else self.Margin = [dict objectForKey:@"Margin"];
        
        if (nil == [dict objectForKey:@"BackgroundOpacity"]) self.BackgroundOpacity = general.BackgroundOpacity;
        else self.BackgroundOpacity = [dict objectForKey:@"BackgroundOpacity"];
        if (nil == [dict objectForKey:@"BackgroundColor"]){
            self.BackgroundColor = general.BackgroundColor;
        }else {
            bgColor = [[dict objectForKey:@"BackgroundColor"] integerValue];
            blueColor = (bgColor & 0x000000FF)/255.0;
            greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
            redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
            alpha = [BackgroundOpacity floatValue]/255.0;
            self.BackgroundColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        }
        
        if (nil == [dict objectForKey:@"BorderOpacity"]) self.BorderOpacity = general.BorderOpacity;
        else self.BorderOpacity = [dict objectForKey:@"BorderOpacity"];
        if (nil == [dict objectForKey:@"BorderColor"]){
            self.BorderColor = general.BorderColor;
        }else {
            bgColor = [[dict objectForKey:@"BorderColor"] integerValue];
            bgColor |= ([BorderOpacity integerValue])<<24;
            blueColor = (bgColor & 0x000000FF)/255.0;
            greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
            redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
            alpha = [BorderOpacity floatValue]/255.0;
            self.BorderColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        }
        
        
        if (nil == [dict objectForKey:@"BorderWidth"]) self.BorderWidth = general.BorderWidth;
        else self.BorderWidth = [dict objectForKey:@"BorderWidth"];
        if (nil == [dict objectForKey:@"CornerRadius"]) self.CornerRadius = general.CornerRadius;
        else self.CornerRadius = [dict objectForKey:@"CornerRaius"];
        
        if (nil == [dict objectForKey:@"TextFont"]) self.TextFont = general.TextFont;
        else self.TextFont = [dict objectForKey:@"TextFont"];
        if (nil == [dict objectForKey:@"TextColor"]){
            self.TextColor = general.TextColor;
        }else {
            bgColor = [[dict objectForKey:@"TextColor"] integerValue];
            blueColor = (bgColor & 0x000000FF)/255.0;
            greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
            redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
            alpha = ((bgColor & 0xFF000000)>>24)/255.0;
            self.TextColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        }
        
        if (nil == [dict objectForKey:@"TextSize"]) self.TextSize = general.TextSize;
        else self.TextSize = [dict objectForKey:@"TextSize"];
    }
    
    return self;
}

- (void)dealloc
{
    [X release];
    [Y release];
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
    

    [super dealloc];
}

@end
