//
//  cvChartFormatterChart.m
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cvChartFormatterChart.h"


#pragma mark -
#pragma mark Configurations for ChartGraph/X-Axis/Y-Axis

@implementation cvChartFormatterChartXAxisGrid

@synthesize Enable, Lines, Color, Opacity;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
        
        Enable = [[dict objectForKey:@"Enable"] boolValue];
        self.Lines = [dict objectForKey:@"Lines"];        
        self.Opacity = [dict objectForKey:@"Opacity"];
        bgColor = [[dict objectForKey:@"Color"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = [Opacity floatValue]/255.0;
        self.Color = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
    }
    
    return self;
}

- (void)dealloc
{
    [Lines release];
    [Color release];
    [Opacity release];
    

    [super dealloc];
}

@end

@implementation cvChartFormatterChartXAxisValue

@synthesize Enable, TextSize, TextColor;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
        
        Enable = [[dict objectForKey:@"Enable"] boolValue];
        self.TextSize = [dict objectForKey:@"TextSize"];
        
        bgColor = [[dict objectForKey:@"TextColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        self.TextColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
    }
    
    return self;
}

- (void)dealloc
{
    [TextSize release];
    [TextColor release];
    

    [super dealloc];
}

@end

@implementation cvChartFormatterChartXAxis

@synthesize Grid, Value;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
		cvChartFormatterChartXAxisGrid *aGrid = [[cvChartFormatterChartXAxisGrid alloc] initWithDictionary:[dict objectForKey:@"Grid"]];
        self.Grid = aGrid;
		[aGrid release];
		cvChartFormatterChartXAxisValue *aValue = [[cvChartFormatterChartXAxisValue alloc] initWithDictionary:[dict objectForKey:@"Value"]];
        self.Value = aValue;
		[aValue release];
    }
    
    return self;
}

- (void)dealloc
{
    [Grid release];
    [Value release];
    

    [super dealloc];
}

@end

@implementation cvChartFormatterChartYAxisGrid

@synthesize Enable, Color, Opacity;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
        
        Enable = [[dict objectForKey:@"Enable"] boolValue];
        
        self.Opacity = [dict objectForKey:@"Opacity"];
        bgColor = [[dict objectForKey:@"Color"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = [Opacity floatValue]/255.0;
        self.Color = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
    }
    
    return self;
}

- (void)dealloc
{
    [Color release];
    [Opacity release];

    [super dealloc];
}

@end

@implementation cvChartFormatterChartYAxisValue

@synthesize Enable, TextColor, TextSize, ValueKey;
@synthesize Unit, UnitPosition, DigitsAfterDecimal;
@synthesize RegularNumber, PercentageNumber;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
        
        Enable = [[dict objectForKey:@"Enable"] boolValue];
        self.TextSize = [dict objectForKey:@"TextSize"];
        
        bgColor = [[dict objectForKey:@"TextColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        self.TextColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
        self.ValueKey = [dict objectForKey:@"ValueKey"];
        
        self.Unit = [dict objectForKey:@"Unit"];
        self.UnitPosition = [dict objectForKey:@"UnitPosition"];
        
        self.DigitsAfterDecimal = [dict objectForKey:@"DigitsAfterDecimal"];       
        
        RegularNumber = [[dict objectForKey:@"RegularNumber"] boolValue];
        PercentageNumber = [[dict objectForKey:@"PercentageNumber"] boolValue];
    }
    
    return self;
}

- (void)dealloc
{
    [TextSize release];
    [TextColor release];
    [ValueKey release];
    [Unit release];
    [UnitPosition release];
    [DigitsAfterDecimal release];
    

    [super dealloc];
}

@end

@implementation cvChartFormatterChartYAxis

@synthesize Grid, Value;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
		cvChartFormatterChartYAxisGrid *aGrid = [[cvChartFormatterChartYAxisGrid alloc] initWithDictionary:[dict objectForKey:@"Grid"]];
        self.Grid = aGrid;
		[aGrid release];
		cvChartFormatterChartYAxisValue *aValue = [[cvChartFormatterChartYAxisValue alloc] initWithDictionary:[dict objectForKey:@"Value"]];
        self.Value = aValue;
		[aValue release];
    }
    
    return self;
}

- (void)dealloc
{
    [Grid release];
    [Value release];
    

    [super dealloc];
}

@end

@implementation cvChartFormatterChartGraph

@synthesize ID, Title, Type, ValueKey, StrokeSize;
@synthesize Color, FillOpacity, PositiveColor, NegativeColor;
@synthesize Smoothed, Shadowed;

-(id)initWithDictionary:(NSDictionary *)dict
{
    if ((self = [super init])){
        int bgColor;
        float redColor, greenColor, blueColor, alpha;
        
        self.ID = [dict objectForKey:@"ID"];
        self.Type = [dict objectForKey:@"Type"];
        self.Title = [dict objectForKey:@"Title"];
        self.ValueKey = [dict objectForKey:@"ValueKey"];
        
        self.StrokeSize = [dict objectForKey:@"StrokeSize"];
        
        self.FillOpacity = [dict objectForKey:@"FillOpacity"];
        bgColor = [[dict objectForKey:@"Color"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = [FillOpacity floatValue]/255.0;
        self.Color = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
        bgColor = [[dict objectForKey:@"PositiveColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        self.PositiveColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
        bgColor = [[dict objectForKey:@"NegativeColor"] integerValue];
        blueColor = (bgColor & 0x000000FF)/255.0;
        greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
        redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
        alpha = ((bgColor & 0xFF000000)>>24)/255.0;
        self.NegativeColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        
        Smoothed = [[dict objectForKey:@"Smoothed"] boolValue];
        Shadowed = [[dict objectForKey:@"Shadowed"] boolValue];
    }
    
    return self;
}

- (void)dealloc
{
    [ID release];
    [Title release];
    [Type release];
	[ValueKey release];
    [StrokeSize release];
    
    [Color release];
    [FillOpacity release];
    [PositiveColor release];
    [NegativeColor release];
    

    [super dealloc];
}

@end


@implementation cvChartFormatterChart

@synthesize X, Y, Width, Height, Margin, BackgroundColor, BackgroundOpacity;
@synthesize BorderColor, BorderOpacity, BorderWidth, CornerRadius, TextFont, TextColor, TextSize;
@synthesize GraphAreaX, GraphAreaY, GraphAreaWidth, GraphAreaHeight;
@synthesize ChartID, Columns, Rows;
@synthesize BulletType, BulletColor, BulletSize, InteractEnable;
@synthesize XAxis, YLeftAxis, YRightAxis, XValueType, Graphs;

-(void)initializeGraphsArray:(NSDictionary *)dict
{
    NSMutableArray *rwArray = [[NSMutableArray alloc] init];
    int i = 0;
    cvChartFormatterChartGraph *element = nil;
    for(i=1; i<=[dict count]; i++){
        NSString *keyName = [NSString stringWithFormat:@"Graph%d",i];
        element = [[cvChartFormatterChartGraph alloc] initWithDictionary:[dict objectForKey:keyName]];
        if (nil != element)
            [rwArray addObject:element];
		[element release];
    }
     
	NSArray *arr = [[NSArray alloc] initWithArray:rwArray];
	self.Graphs = arr;
	[arr release];
    [rwArray release];
}

-(id)initWithDictionary:(NSDictionary *)dict Defaults:(cvChartFormatterGeneral *)general;
{
    if ((self = [super init])){
        
		self.X = [dict objectForKey:@"X"];
		self.Y = [dict objectForKey:@"Y"];
		int bgColor;
		float blueColor,greenColor,redColor,alpha;

        if (nil == [dict objectForKey:@"Width"]) self.Width = general.Width;
        else self.Width = [dict objectForKey:@"Width"];
        if (nil == [dict objectForKey:@"Height"]) self.Height = general.Height;
        else self.Height = [dict objectForKey:@"Height"];

        if (nil == [dict objectForKey:@"Margin"]) self.Margin = general.Margin;
        else self.Margin = [dict objectForKey:@"Margin"];
        
        if (nil == [dict objectForKey:@"BackgroundOpacity"]) self.BackgroundOpacity = general.BackgroundOpacity;
        else self.BackgroundOpacity = [dict objectForKey:@"BackgroundOpacity"];
        if (nil == [dict objectForKey:@"BackgroundColor"])
            self.BackgroundColor = general.BackgroundColor;
        else {
			bgColor = [[dict objectForKey:@"BackgroundColor"] integerValue];
			blueColor = (bgColor & 0x000000FF)/255.0;
			greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
			redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
			alpha = [BackgroundOpacity floatValue]/255.0;
			self.BackgroundColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
		}
        
        if (nil == BorderOpacity) self.BorderOpacity = general.BorderOpacity;
        else self.BorderOpacity = [dict objectForKey:@"BorderOpacity"];
        if (nil == [dict objectForKey:@"BorderColor"]) self.BorderColor = general.BorderColor;
		else {
			bgColor = [[dict objectForKey:@"BorderColor"] integerValue];
			blueColor = (bgColor & 0x000000FF)/255.0;
			greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
			redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
			alpha = [BorderOpacity floatValue]/255.0;
			self.BorderColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
		}          
        if (nil == BorderWidth) self.BorderWidth = general.BorderWidth;
        else self.BorderWidth = [dict objectForKey:@"BorderWidth"];
        if (nil == CornerRadius) self.CornerRadius = general.CornerRadius;
        else self.CornerRadius = [dict objectForKey:@"CornderRadius"];
        
        if (nil == [dict objectForKey:@"TextFont"]) self.TextFont = general.TextFont;
        else self.TextFont = [dict objectForKey:@"TextFont"];
        if (nil == [dict objectForKey:@"TextColor"]) self.TextColor = general.TextColor;
		else {
			bgColor = [[dict objectForKey:@"TextColor"] integerValue];
			blueColor = (bgColor & 0x000000FF)/255.0;
			greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
			redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
			alpha = ((bgColor & 0xFF000000)>>24)/255.0;
			self.TextColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
		}
        if (nil == [dict objectForKey:@"TextSize"]) self.TextSize = general.TextSize;
        else self.TextSize = [dict objectForKey:@"TextSize"];
        
        self.GraphAreaX = [dict objectForKey:@"GraphAreaX"];
        self.GraphAreaY = [dict objectForKey:@"GraphAreaY"];
        self.GraphAreaWidth = [dict objectForKey:@"GraphAreaWidth"];
        self.GraphAreaHeight =[dict objectForKey:@"GraphAreaHeight"];
        
        self.Columns = [dict objectForKey:@"Columns"];
        self.Rows = [dict objectForKey:@"Rows"];
        
        self.BulletType = [dict objectForKey:@"BulletType"];
        bgColor = [[dict objectForKey:@"BulletColor"] integerValue];
		blueColor = (bgColor & 0x000000FF)/255.0;
		greenColor = ((bgColor & 0x0000FF00)>>8)/255.0;
		redColor = ((bgColor & 0x00FF0000)>>16)/255.0;
		alpha = ((bgColor & 0xFF000000)>>24)/255.0;
		self.BulletColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
        self.BulletSize = [dict objectForKey:@"BulletSize"];
        self.InteractEnable = [[dict objectForKey:@"InteractEnable"] boolValue];
        
		cvChartFormatterChartXAxis *aXAxis = [[cvChartFormatterChartXAxis alloc] initWithDictionary:[dict objectForKey:@"XAxis"]];
		cvChartFormatterChartYAxis *aYLeftAxis = [[cvChartFormatterChartYAxis alloc] initWithDictionary:[dict objectForKey:@"YLeftAxis"]];
		cvChartFormatterChartYAxis *aYRightAxis = [[cvChartFormatterChartYAxis alloc] initWithDictionary:[dict objectForKey:@"YRightAxis"]];
		self.XAxis = aXAxis;
		self.YLeftAxis = aYLeftAxis;
		self.YRightAxis = aYRightAxis;
		[aXAxis release];
		[aYLeftAxis release];
		[aYRightAxis release];
		
		self.XValueType = cvChartXValueTypeMonth;
		NSNumber *numXValueType;
		numXValueType = [dict objectForKey:@"XValueType"];
		if (nil != numXValueType)
			self.XValueType = [numXValueType integerValue];
		
        [self initializeGraphsArray:[dict objectForKey:@"Graphs"]];
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
    
    [GraphAreaX release];
    [GraphAreaY release];
    [GraphAreaWidth release];
    [GraphAreaHeight release];
    
    [Columns release];
    [Rows release];
    [BulletSize release];
    [BulletType release];
    [BulletColor release];
    
    [XAxis release];
    [YLeftAxis release];
    [YRightAxis release];
    [Graphs release];
    self.ChartID = nil;
    [super dealloc];
}

@end
