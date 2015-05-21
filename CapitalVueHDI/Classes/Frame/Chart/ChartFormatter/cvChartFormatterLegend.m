//
//  cvChartFormatterLegend.m
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cvChartFormatterLegend.h"


#pragma mark -
#pragma mark Configurations for Chart Legend

@implementation cvChartFormatterLegendItem

@synthesize Title, X, Y;
@synthesize ValueKey, DigitsAfterDecimal;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        self.Title = [dict objectForKey:@"Title"];
        self.X = [dict objectForKey:@"X"];
        self.Y = [dict objectForKey:@"Y"];
        self.ValueKey = [dict objectForKey:@"ValueKey"];
        self.DigitsAfterDecimal = [dict objectForKey:@"DigitsAfterDecimal"];
        //NSLog(@"Specified Legend item(%@):%d %d using key:%@", Title, [X integerValue],[Y integerValue], ValueKey);
    }
    
    return self;
}

-(void)dealloc{
	[Title release];
	[X release];
	[Y release];
	[ValueKey release];
	[DigitsAfterDecimal release];
	
	[super dealloc];
}

@end


@implementation cvChartFormatterLegend

@synthesize X, Y, Width, Height, Margin, BackgroundColor, BackgroundOpacity;
@synthesize BorderColor, BorderOpacity, BorderWidth, CornerRadius, TextFont, TextColor, TextSize;
@synthesize ValueColor, PositiveColor, NegativeColor, Items;

//@synthesize properties, Items;

-(void)initializeItemsArray:(NSDictionary *)dict
{
    if (nil == dict) return;
    NSMutableArray *rwArray = [[NSMutableArray alloc] init];
    int i = 0;
    cvChartFormatterLegendItem *element = nil;
    for(i=1; i<=[dict count]; i++){
        NSString *keyName = [NSString stringWithFormat:@"Item%d",i];
        element = [[cvChartFormatterLegendItem alloc] initWithDictionary:[dict objectForKey:keyName]];
        if (nil != element){
            [rwArray addObject:element];
            [element release];
        }
    }
    self.Items = [NSArray arrayWithArray:rwArray];
    [rwArray release];
}

-(void)setTitles:(NSArray *)titleArray{
	cvChartFormatterLegendItem *element = nil;
	for(int i=0; i<[titleArray count]; i++){
        NSString *titleName = [titleArray objectAtIndex:i];
        element = [self.Items objectAtIndex:i];
        element.Title = titleName;
    }
}


-(id)initWithDictionary:(NSDictionary *)dict Defaults:(cvChartFormatterGeneral *)general;
{
    if ((self = [super init]) && (nil != dict)){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
      
        self.X = [dict objectForKey:@"X"];
        self.Y = [dict objectForKey:@"Y"];

        if (nil == [dict objectForKey:@"Width"]){
			self.Width = general.Width;
		}
        else{
			self.Width = [dict objectForKey:@"Width"];
		} 
				  
        if (nil == [dict objectForKey:@"Height"]){
			self.Height = general.Height;
		} 
        else{
			self.Height = [dict objectForKey:@"Height"];
		} 

        if (nil == [dict objectForKey:@"Margin"]){
			self.Margin = general.Margin;
		}
        else{
			self.Margin = [dict objectForKey:@"Margin"];
		} 
        
        if (nil == [dict objectForKey:@"BackgroundOpacity"]){
			self.BackgroundOpacity = general.BackgroundOpacity;
		} 
        else{
			self.BackgroundOpacity = [dict objectForKey:@"BackgroundOpacity"];
		} 
		
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
        
        if (nil == [dict objectForKey:@"BorderOpacity"]){
			self.BorderOpacity = general.BorderOpacity;
		} 
        else{
			self.BorderOpacity = [dict objectForKey:@"BorderOpacity"];
		} 
		
        if (nil == [dict objectForKey:@"BorderColor"]){
            self.BorderColor = general.BorderColor;
        }else {
            bgColor = [[dict objectForKey:@"BorderColor"] integerValue];
            blueColor = (bgColor & 0x000000FF)/255.0;
            greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
            redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
            alpha = ([BorderOpacity floatValue])/255.0;
            BorderColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        }
        
        if (nil == [dict objectForKey:@"BorderWidth"]){
			self.BorderWidth = general.BorderWidth;
		} 
        else{
			self.BorderWidth = [dict objectForKey:@"BorderWidth"];
		} 
        
        if (nil == [dict objectForKey:@"CornerRadius"]){
			self.CornerRadius = general.CornerRadius;
		} 
        else{
			self.CornerRadius = [dict objectForKey:@"CornerRaius"];
		} 
        
        if (nil != [dict objectForKey:@"TextFont"]) {
			self.TextFont = [dict objectForKey:@"TextFont"];
		}
        else{
			self.TextFont = general.TextFont;
		} 
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
        
        if (nil == [dict objectForKey:@"TextSize"]){
			self.TextSize = general.TextSize;
		} 
        else{
			self.TextSize = [dict objectForKey:@"TextSize"];
		} 
        
        if (nil == [dict objectForKey:@"ValueColor"]){
            self.ValueColor = [UIColor whiteColor];
        }else {
            bgColor = [[dict objectForKey:@"ValueColor"] integerValue];
            blueColor = (bgColor & 0x000000FF)/255.0;
            greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
            redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
            alpha = ((bgColor & 0xFF000000)>>24)/255.0;
            self.ValueColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        }
        
        if (nil == [dict objectForKey:@"PositiveColor"]){
            self.PositiveColor = [UIColor greenColor];
        }else {
            bgColor = [[dict objectForKey:@"PositiveColor"] integerValue];
            blueColor = (bgColor & 0x000000FF)/255.0;
            greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
            redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
            alpha = ((bgColor & 0xFF000000)>>24)/255.0;
            self.PositiveColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        }
        
        if (nil == [dict objectForKey:@"NegativeColor"]){
            self.NegativeColor = [UIColor redColor];
        }else {
            bgColor = [[dict objectForKey:@"NegativeColor"] integerValue];
            blueColor = (bgColor & 0x000000FF)/255.0;
            greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
            redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
            alpha = ((bgColor & 0xFF000000)>>24)/255.0;
            self.NegativeColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        }
        // load Items array
        [self initializeItemsArray:[dict objectForKey:@"Items"]];
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
    
    [ValueColor release];
    [PositiveColor release];
    [NegativeColor release];

    [Items release];
    

    [super dealloc];
}

@end
