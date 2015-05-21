//
//  cvChartFormatterPeriodSelector.m
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cvChartFormatterPeriodSelector.h"


#pragma mark -
#pragma mark Configurations for Period Selector (Button/Elements)

@implementation cvChartFormatterButton

@synthesize Width, Height, BackgroundColor, BackgroundColorSelected;
@synthesize BorderColor, BorderWidth, CornerRadius, TextFont, TextColor, TextSize, TextColorSelected;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
        
        self.Width = [dict objectForKey:@"Width"];
        self.Height = [dict objectForKey:@"Height"];
        bgColor = [[dict objectForKey:@"BackgroundColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        self.BackgroundColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
        bgColor = [[dict objectForKey:@"BackgroundColorSelected"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        self.BackgroundColorSelected = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
        bgColor = [[dict objectForKey:@"BorderColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        self.BorderColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
		self.BorderWidth = [dict objectForKey:@"BorderWidth"];
        self.CornerRadius = [dict objectForKey:@"CornerRadius"];
        
        self.TextFont = [dict objectForKey:@"TextFont"];
        self.TextSize = [dict objectForKey:@"TextSize"];
        
        bgColor = [[dict objectForKey:@"TextColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        self.TextColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
        bgColor = [[dict objectForKey:@"TextColorSelected"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        self.TextColorSelected = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
    }
    
    return self;
}

- (void)dealloc
{
    [Width release];
    [Height release];
    [BackgroundColor release];
    [BackgroundColorSelected release];
    [BorderColor release];
    [BorderWidth release];
    [CornerRadius release];
    
    [TextFont release];
    [TextColor release];
    [TextColorSelected release];
    [TextSize release];

    [super dealloc];
}

@end

@implementation cvChartFormatterPeriodSelectorElement

@synthesize Title, Period, Enabled;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        self.Title = [dict objectForKey:@"Title"];
        self.Period = [dict objectForKey:@"Period"];
        Enabled = [[dict objectForKey:@"Enabled"] boolValue];
        //NSLog(@"Specified Element(%@):%d %@", Title, [Period integerValue], (YES==Enabled)?@"Enabled":@"Disbaled");
    }
    
    return self;
}

- (void)dealloc
{
    [Title release];
    [Period release];
    

    [super dealloc];
}

@end

@implementation cvChartFormatterPeriodSelector

@synthesize X, Y, Width, Height, Margin, BackgroundColor, BackgroundOpacity;
@synthesize BorderColor, BorderOpacity, BorderWidth, CornerRadius, TextFont, TextColor, TextSize;
@synthesize Button, Items;

-(void)initializePeriodArray:(NSDictionary *)dict
{
    NSMutableArray *rwArray = [[NSMutableArray alloc] init];
    int i = 0;
    cvChartFormatterPeriodSelectorElement *element = nil;
    for(i=1; i<=[dict count]; i++){
        NSString *keyName = [NSString stringWithFormat:@"Item %d",i];
        element = [[cvChartFormatterPeriodSelectorElement alloc] initWithDictionary:[dict objectForKey:keyName]];
        if (nil != element){
            [rwArray addObject:element];
            [element release];
        }
    }
    self.Items = [NSArray arrayWithArray:rwArray];
    [rwArray release];
}

-(id)initWithDictionary:(NSDictionary *)dict Defaults:(cvChartFormatterGeneral *)general;
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
            blueColor = (bgColor & 0x000000FF)/255.0;
            greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
            redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
            alpha = [BorderOpacity floatValue]/255.0;
            self.BorderColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        }
        if (nil == [dict objectForKey:@"BorderWidth"]) self.BorderWidth = general.BorderWidth;
        else self.BorderWidth = [dict objectForKey:@"BorderWidth"];
        
        if (nil == [dict objectForKey:@"CornerRadius"]) self.CornerRadius = general.CornerRadius;
        else self.CornerRadius = [dict objectForKey:@"CornerRadius"];
        
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
        
        //
        cvChartFormatterButton *aButton = [[cvChartFormatterButton alloc] initWithDictionary:[dict objectForKey:@"Button"]];
		self.Button = aButton;
		[aButton release];
        //Items array
        [self initializePeriodArray:[dict objectForKey:@"PeriodElements"]];
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
    
    [Button release];
	[Items release];
    

    [super dealloc];
}

@end