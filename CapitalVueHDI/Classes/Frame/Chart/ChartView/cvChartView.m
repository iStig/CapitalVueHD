//
//  cvChartView.m
//  cvChart
//
//  Created by He Jun on 10-8-20.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "cvChartView.h"

#import "cvChart.h"

#pragma mark -
#pragma mark cvChartView 

@interface cvChartView()




@property (nonatomic, retain) CALayer *plotAreaLayer;
@property (nonatomic, retain) cvChartLegend *legend;
@property (nonatomic, retain) cvChartPeriodSelector *periodControl;
@property (nonatomic, retain) NSString *targetSymbol;
@property (nonatomic, retain) UIImageView *errView;
@property (nonatomic, assign) StockDataTimeFrame_e targetTime; 
@property (nonatomic, assign) BOOL loadingData;


- (void)applyGeneralConfigs:(cvChartFormatterGeneral *)generalCfg;
- (id)createChart:(cvChartFormatterChart *)chartCfg;
- (void)initializeChartsArray:(NSArray *)chartsArray;

@end

@implementation cvChartView

@synthesize symbolName;

@synthesize formatter, _focusline, plotAreaLayer, legend, periodControl;
@synthesize charts, dataProvider, financialData;
@synthesize busyIndicator, loadingData, targetTime, targetSymbol, errView;
@synthesize nonIntraInvalidNum = _nonIntraInvalidNum;
@synthesize intrayInvalidNum = _intrayInvalidNum;
@synthesize dream_delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		_nonIntraInvalidNum = 0;
		_intrayInvalidNum = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame FormatFile:(NSString *)file{
    if ((self = [super initWithFrame:frame])) {
		_nonIntraInvalidNum = 0;
		_intrayInvalidNum = 0;
        // parse configurations
		cvChartFormatter *fff = [[cvChartFormatter alloc] initWithConfigFile:file];
        self.formatter = fff;
		[fff release];
		//       [formatter initWithConfigFile:file];
		//       NSLog(@"format file is loaded");
        
        loadingData = NO;
        busyIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [busyIndicator setHidesWhenStopped:YES];
        CGRect centeralFrame = CGRectMake([formatter.General.Width floatValue]/2-25, 
										  [formatter.General.Height floatValue]/2-25, 
										  50, 50);
        busyIndicator.frame = centeralFrame;
        [self addSubview:busyIndicator];
        
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"err.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
        errView = [[UIImageView alloc] initWithImage:imgx];
		[imgx release];
        errView.frame = CGRectZero;
        [self addSubview:errView];
        
        financialData = nil;
        
        // apply general properties
        [self applyGeneralConfigs:formatter.General];
        
        _focusline = [[CVLineView alloc] initWithFrame:CGRectZero];
		[self addSubview:_focusline];
        
        timeFrame = StockDataThreeMonths;
        self.targetSymbol = [[NSString alloc] init];
		[targetSymbol release];
        self.targetTime = timeFrame;
        
        // create Header
        if (YES == formatter.General.HeaderEnable){
            //[self createHeader:formatter.Header];
        }
        // create Legend
        if (YES == formatter.General.LegendEnable){
            legend = [[cvChartLegend alloc] init];
            [legend initWithConfig:formatter.Legend];
            legend.focusIndex = 0;
            legend.financialData = financialData;
            [self.layer addSublayer:legend];
        }
        // create Period Selector
        if (YES == formatter.General.PeriodSelectorEnable){
            periodControl = [[cvChartPeriodSelector alloc] initWithFrame:CGRectZero];
            [periodControl initWithConfig:formatter.PeriodSelector];
            [periodControl addTarget:self action:@selector(periodControlAction:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:periodControl];
			
        }
        
        // create charts 
        [self initializeChartsArray:formatter.Charts];
    }
    return self;
}

-(void)setTitles:(NSArray *)titleArray{
	[self.formatter setTitles:titleArray];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [plotAreaLayer setNeedsDisplay];
    
    if (YES == formatter.General.HeaderEnable) {
        
    }
    
    if (YES == formatter.General.LegendEnable) {
        [legend setNeedsDisplay];
    }
    
    if (YES == formatter.General.PeriodSelectorEnable) {
        [periodControl setNeedsDisplay];
    }
    
    for(int i=0;i<[charts count]; i++){
        cvChart *currLayer = [charts objectAtIndex:i];
        [currLayer setNeedsDisplay];
    }
}


- (void)dealloc {
	self.dataProvider = nil;
    [plotAreaLayer release];
    [busyIndicator release];
    [targetSymbol release];
    [errView release];
    
    
    [charts release];
    [_focusline release];
    [legend release];
    [periodControl release];
    [symbolName release];
    
    [formatter release];
    
    [super dealloc];
}

- (void)resize:(CGRect)newSize
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	float scaleX, scaleY;
	scaleX = newSize.size.width/[self.formatter.General.Width floatValue];
	scaleY = newSize.size.height/[self.formatter.General.Height floatValue];
	
	formatter.General.Width = [NSNumber numberWithFloat:([formatter.General.Width floatValue]*scaleX)];
	formatter.General.Height = [NSNumber numberWithFloat:([formatter.General.Height floatValue]*scaleY)];
	self.frame = newSize;
	
	formatter.General.PlotArea.X = [NSNumber numberWithFloat:([formatter.General.PlotArea.X floatValue]*scaleX)];
	formatter.General.PlotArea.Y = [NSNumber numberWithFloat:([formatter.General.PlotArea.Y floatValue]*scaleY)];
	formatter.General.PlotArea.Width = [NSNumber numberWithFloat:([formatter.General.PlotArea.Width floatValue]*scaleX)];
	formatter.General.PlotArea.Height = [NSNumber numberWithFloat:([formatter.General.PlotArea.Height floatValue]*scaleY)];
	plotAreaLayer.frame = CGRectMake([formatter.General.PlotArea.X floatValue],
									 [formatter.General.PlotArea.Y floatValue], 
									 [formatter.General.PlotArea.Width floatValue], 
									 [formatter.General.PlotArea.Height floatValue]);
	
	formatter.Legend.X = [NSNumber numberWithFloat:([formatter.Legend.X floatValue]*scaleX)];
	formatter.Legend.Y = [NSNumber numberWithFloat:([formatter.Legend.Y floatValue]*scaleY)];
	formatter.Legend.Width = [NSNumber numberWithFloat:([formatter.Legend.Width floatValue]*scaleX)];
	formatter.Legend.Height = [NSNumber numberWithFloat:([formatter.Legend.Height floatValue]*scaleY)];
	legend.frame = CGRectMake([formatter.Legend.X floatValue], 
							  [formatter.Legend.Y floatValue], 
							  [formatter.Legend.Width floatValue], 
							  [formatter.Legend.Height floatValue]);
	
	formatter.PeriodSelector.X = [NSNumber numberWithFloat:([formatter.PeriodSelector.X floatValue]*scaleX)];
	formatter.PeriodSelector.Y = [NSNumber numberWithFloat:([formatter.PeriodSelector.Y floatValue]*scaleY)];
	formatter.PeriodSelector.Width = [NSNumber numberWithFloat:([formatter.PeriodSelector.Width floatValue]*scaleX)];
	formatter.PeriodSelector.Height = [NSNumber numberWithFloat:([formatter.PeriodSelector.Height floatValue]*scaleY)];
	periodControl.frame = CGRectMake([formatter.PeriodSelector.X floatValue], 
									 [formatter.PeriodSelector.Y floatValue], 
									 [formatter.PeriodSelector.Width floatValue], 
									 [formatter.PeriodSelector.Height floatValue]);
	
	cvChartFormatterChart *currChartCfg = nil;
	cvChart *currChart = nil;
	int i = 0;
	for(i=0; i<[formatter.Charts count]; i++){
		currChartCfg = [formatter.Charts objectAtIndex:i];
		currChartCfg.X = [NSNumber numberWithFloat:([currChartCfg.X floatValue]*scaleX)];
		currChartCfg.Y = [NSNumber numberWithFloat:([currChartCfg.Y floatValue]*scaleY)];
		currChartCfg.Width = [NSNumber numberWithFloat:([currChartCfg.Width floatValue]*scaleX)];
		currChartCfg.Height = [NSNumber numberWithFloat:([currChartCfg.Height floatValue]*scaleY)];
		currChartCfg.GraphAreaX = [NSNumber numberWithFloat:([currChartCfg.GraphAreaX floatValue]*scaleX)];
		currChartCfg.GraphAreaY = [NSNumber numberWithFloat:([currChartCfg.GraphAreaY floatValue]*scaleY)];
		currChartCfg.GraphAreaWidth = [NSNumber numberWithFloat:([currChartCfg.GraphAreaWidth floatValue]*scaleX)];
		currChartCfg.GraphAreaHeight = [NSNumber numberWithFloat:([currChartCfg.GraphAreaHeight floatValue]*scaleY)];
		
		currChart = [charts objectAtIndex:i];
		currChart.frame = CGRectMake([currChartCfg.X floatValue], 
									 [currChartCfg.Y floatValue], 
									 [currChartCfg.Width floatValue], 
									 [currChartCfg.Height floatValue]);
	}
	
	[self setNeedsDisplay];
	[pool release];
}

- (void)clearData{
	financialData = nil;
	NSLog(@"data clear");
	
	legend.financialData = financialData;
	int i;
	for (i=0; i<[charts count]; i++){
		cvChart *chart = [charts objectAtIndex:i];
		chart.financialData = financialData;
		chart.nonIntraInvalidNum = self.nonIntraInvalidNum;
		chart.intrayInvalidNum = self.intrayInvalidNum;
	}
	
	// setNeedsDisplay whatever the returned data are
	[self setNeedsDisplay];
}

- (void)loadDataByName
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//    NSLog(@"loadDataByName[%@] thread", targetSymbol);
    NSArray *data = [dataProvider ChartGetRecordsByName:targetSymbol Period:targetTime];
    
    [symbolName release];
    symbolName = [[NSString alloc] initWithString:targetSymbol];
    if (nil != data){
        financialData = data;
		if (StockDataIntraDay == timeFrame) {
			legend.focusIndex = [financialData count] - 1;
		} else {
			legend.focusIndex = 0;
		}
        legend.financialData = financialData;
        
        int i;
        for (i=0; i<[charts count]; i++){
            cvChart *chart = [charts objectAtIndex:i];
            chart.financialData = financialData;
			chart.nonIntraInvalidNum = self.nonIntraInvalidNum;
			chart.intrayInvalidNum = self.intrayInvalidNum;
        }
    }else {
        NSLog(@"data invalid");
        // no data
        // just draw error icon
        CGRect centeralFrame = CGRectMake([formatter.General.Width floatValue]/2-25, 
                                          [formatter.General.Height floatValue]/2-25, 
                                          50, 50);
        errView.frame = centeralFrame;
    }
    // setNeedsDisplay whatever the returned data are
	[self setNeedsDisplay];
    [self.busyIndicator stopAnimating];
    //[self performSelectorOnMainThread:@selector(setNeedsDisplay) 
    //                       withObject:self
    //                    waitUntilDone:false];
    loadingData = NO;
	if (dream_delegate)
		[dream_delegate chartLoaded];
    [pool release];
    
}

- (void)loadDataByTime
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"loadDataByTime[%d] thread", targetTime);
    NSArray *data = [dataProvider ChartGetRecordsByName:symbolName Period:targetTime];
    if (nil != data){
        financialData = data;
        timeFrame = targetTime;
		if (StockDataIntraDay == timeFrame) {
			legend.focusIndex = [financialData count] - 1;
		} else {
			legend.focusIndex = 0;
		}
        legend.financialData = financialData;
        
        int i;
        for (i=0; i<[charts count]; i++){
            cvChart *chart = [charts objectAtIndex:i];
			chart.timeFrame = targetTime;
            chart.financialData = financialData;
			chart.nonIntraInvalidNum = self.nonIntraInvalidNum;
			chart.intrayInvalidNum = self.intrayInvalidNum;
        }
    }else {
        NSLog(@"data invalid");
        // no data
        // just draw error icon
        CGRect centeralFrame = CGRectMake([formatter.General.Width floatValue]/2-25, 
                                          [formatter.General.Height floatValue]/2-25, 
                                          50, 50);
        errView.frame = centeralFrame;
    }
    // setNeedsDisplay whatever the returned data are
	[self setNeedsDisplay];
    [self.busyIndicator stopAnimating];
    loadingData = NO;
	if (dream_delegate)
		[dream_delegate chartLoaded];
    [pool release];
}

- (void)setSymbolName:(NSString *)name
{
    if (YES == loadingData) {
		return;
	}
	
    //if (targetSymbol != name){
	self.targetSymbol = name;
	loadingData = YES;
	
	financialData = nil;
	legend.financialData = financialData;
	for(int i=0; i<[charts count]; i++){
		cvChart *currChart = [charts objectAtIndex:i];
		currChart.financialData = financialData;
		currChart.nonIntraInvalidNum = self.nonIntraInvalidNum;
		currChart.intrayInvalidNum = self.intrayInvalidNum;
		currChart.timeFrame = targetTime;
	}
	errView.frame = CGRectZero;
	[self.busyIndicator startAnimating];
	// create seperate task to load data
	[NSThread detachNewThreadSelector:@selector(loadDataByName) 
							 toTarget:self 
						   withObject:nil];
    //}
}

- (id)symbolName{
    return symbolName;
}

- (StockDataTimeFrame_e)timeFrame{
    return timeFrame;
}

- (void)setTimeFrame:(StockDataTimeFrame_e)newTimeFrame
{
    if (timeFrame != newTimeFrame){
        
		if (NO == loadingData) {
			targetTime = newTimeFrame;
			loadingData = YES;
			financialData = nil;
			errView.frame = CGRectZero;
			[busyIndicator startAnimating];
			// create seperate task to load data
			[NSThread detachNewThreadSelector:@selector(loadDataByTime) 
									 toTarget:self 
								   withObject:nil];
		}
    }
	else
		[dream_delegate chartLoaded];
}

- (void)defineSymbolName:(NSString *)name timeFrame:(StockDataTimeFrame_e)newTimeFrame {
	if (timeFrame != newTimeFrame) {
		timeFrame = newTimeFrame;
        targetTime = newTimeFrame;
	}
	
	[self setSymbolName:name];
}

- (void)drawChart:(NSString *)name timeFrame:(StockDataTimeFrame_e)newTimeFrame {
	if (timeFrame != newTimeFrame) {
        targetTime = newTimeFrame;
	}
	
	if (YES == loadingData) {
		return;
	}
	
    if (targetSymbol != name){
        self.targetSymbol = name;
        loadingData = YES;
        
        financialData = nil;
        legend.financialData = financialData;
        for(int i=0; i<[charts count]; i++){
            cvChart *currChart = [charts objectAtIndex:i];
            currChart.financialData = financialData;
			currChart.nonIntraInvalidNum = self.nonIntraInvalidNum;
			currChart.intrayInvalidNum = self.intrayInvalidNum;
			currChart.timeFrame = targetTime;
        }
        errView.frame = CGRectZero;
        [self.busyIndicator startAnimating];
        // create seperate task to load data
        [self loadDataByName];
    }
}


#pragma mark -
#pragma mark Chart view helpers
- (void)applyGeneralConfigs:(cvChartFormatterGeneral *)generalCfg
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 
                            [generalCfg.Width floatValue], [generalCfg.Height floatValue]);
    
    CALayer *layer = [self layer];
    self.backgroundColor = [UIColor clearColor];
    layer.backgroundColor = [generalCfg.BackgroundColor CGColor];
    
    layer.borderColor = [generalCfg.BorderColor CGColor];
    layer.borderWidth = [generalCfg.BorderWidth floatValue];
    layer.cornerRadius = [generalCfg.CornerRadius floatValue];
    layer.shadowOpacity = 0.0f;
    layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    
    // apply plot area properties
    plotAreaLayer = [[CALayer alloc] init];
    cvChartFormatterPlotArea *plotCfg = generalCfg.PlotArea;
    plotAreaLayer.frame = CGRectMake([plotCfg.X integerValue],
                                     [plotCfg.Y integerValue],
                                     [plotCfg.Width integerValue],
                                     [plotCfg.Height integerValue]);
    plotAreaLayer.backgroundColor = [plotCfg.BackgroundColor CGColor];
    plotAreaLayer.cornerRadius = [plotCfg.CornerRadius floatValue];
    plotAreaLayer.shadowOpacity = 0.0f;
    
    [[self layer] addSublayer:plotAreaLayer];
}


- (id)createChart:(cvChartFormatterChart *)chartCfg
{
    cvChart *chartLayer = [[cvChart alloc] init];
    
    // setup basic chart properties
    if (chartLayer != nil){
        [chartLayer initWithConfig:chartCfg];
    }
    
    [self.layer insertSublayer:chartLayer above:self.plotAreaLayer];
	
    return chartLayer;
}

- (void)initializeChartsArray:(NSArray *)chartsArray
{
    NSMutableArray *rwArray = [[NSMutableArray alloc] init];
    
    cvChartFormatterChart *chartCfg = nil;
    cvChart *newChartLayer = nil;
    for(int i=0; i<[chartsArray count]; i++){
        chartCfg = [chartsArray objectAtIndex:i];
        newChartLayer = [self createChart:chartCfg];
		newChartLayer.timeFrame = timeFrame;
        if (nil != newChartLayer){
            newChartLayer.financialData = financialData;
			newChartLayer.nonIntraInvalidNum = self.nonIntraInvalidNum;
			newChartLayer.intrayInvalidNum = self.intrayInvalidNum;
            [rwArray addObject:newChartLayer];
            [newChartLayer release];
        }
    }
	NSArray *array = [[NSArray alloc] initWithArray:rwArray];
    self.charts = array;
	[array release];
    [rwArray release];
}


#pragma mark -
#pragma mark Period Selector event
- (void)periodControlAction:(id)sender
{
    if (sender == periodControl){
        cvChartFormatterPeriodSelectorElement *currEle = [formatter.PeriodSelector.Items objectAtIndex:[sender selectedIndex]];
        NSLog(@"User selected time(%@) %d", currEle.Title, [currEle.Period integerValue]);
        self.timeFrame = StockDataOneMonth;
    }
}

#pragma mark -
#pragma mark Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (loadingData) {
		return;
	}
	UITouch* touch = [touches anyObject];
	CGPoint pos = [touch locationInView:self];
    
    int i;
    for (i=0; i<[charts count]; i++) {
        cvChart *currChart = [charts objectAtIndex:i];
        if (YES == currChart.chartCfg.InteractEnable){
            CGRect grapArea = CGRectMake([currChart.chartCfg.X floatValue]+[currChart.chartCfg.GraphAreaX floatValue], 
                                         [currChart.chartCfg.Y floatValue]+[currChart.chartCfg.GraphAreaY floatValue], 
                                         [currChart.chartCfg.GraphAreaWidth floatValue], 
                                         [currChart.chartCfg.GraphAreaHeight floatValue]);
            if (CGRectContainsPoint(grapArea, pos)) {
                float xStep;
				
				if (StockDataIntraDay == timeFrame) {
					xStep = [currChart.chartCfg.GraphAreaWidth floatValue]/239;
					legend.focusIndex = (pos.x - [currChart.chartCfg.GraphAreaX floatValue]-[currChart.chartCfg.X floatValue])/xStep;
					if (legend.focusIndex > [legend.financialData count]-1) {
						legend.focusIndex = [legend.financialData count]-1;
						pos = CGPointMake(legend.focusIndex*xStep+[currChart.chartCfg.GraphAreaX floatValue]+[currChart.chartCfg.X floatValue], pos.y);
					}
					if (legend.focusIndex < _intrayInvalidNum) {
						legend.focusIndex = _intrayInvalidNum;
						pos = CGPointMake(legend.focusIndex*xStep+[currChart.chartCfg.GraphAreaX floatValue]+[currChart.chartCfg.X floatValue], pos.y);
					}
				} else {
					xStep = [currChart.chartCfg.GraphAreaWidth floatValue]/([legend.financialData count]);
					legend.focusIndex = [legend.financialData count]-1;
					legend.focusIndex -= (pos.x - [currChart.chartCfg.GraphAreaX floatValue]-[currChart.chartCfg.X floatValue])/xStep - 1;
					if ([legend.financialData count]-1-legend.focusIndex < _nonIntraInvalidNum) {
						legend.focusIndex = [legend.financialData count]-1-_nonIntraInvalidNum;
						pos = CGPointMake(_nonIntraInvalidNum*xStep+[currChart.chartCfg.GraphAreaX floatValue]+[currChart.chartCfg.X floatValue], pos.y);
					}
                }
				//NSLog(@"total: %d curIdx: %d", [legend.financialData count], legend.focusIndex);
                if (legend.focusIndex <0) legend.focusIndex = 0;
                if (legend.focusIndex>=[legend.financialData count])
					legend.focusIndex = [legend.financialData count]-1;
                [legend setNeedsDisplay];
                
                _focusline.frame = CGRectMake(pos.x, [currChart.chartCfg.Y floatValue]+[currChart.chartCfg.GraphAreaY floatValue], 
                                              [currChart.chartCfg.BulletSize floatValue], [currChart.chartCfg.GraphAreaHeight floatValue]);
                _focusline.fillColor = currChart.chartCfg.BulletColor;
                [_focusline setNeedsDisplay];
                
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (loadingData) {
		return;
	}
	UITouch* touch = [touches anyObject];
	CGPoint pos = [touch locationInView:self]; 
    
    int i;
    for (i=0; i<[charts count]; i++) {
        cvChart *currChart = [charts objectAtIndex:i];
        if (YES == currChart.chartCfg.InteractEnable){
            CGRect grapArea = CGRectMake([currChart.chartCfg.X floatValue]+[currChart.chartCfg.GraphAreaX floatValue], 
                                         [currChart.chartCfg.Y floatValue]+[currChart.chartCfg.GraphAreaY floatValue], 
                                         [currChart.chartCfg.GraphAreaWidth floatValue], 
                                         [currChart.chartCfg.GraphAreaHeight floatValue]);
            if (CGRectContainsPoint(grapArea, pos)) {
                float xStep;
				if (StockDataIntraDay == timeFrame) {
					xStep = [currChart.chartCfg.GraphAreaWidth floatValue]/239;
					legend.focusIndex = (pos.x - [currChart.chartCfg.GraphAreaX floatValue]-[currChart.chartCfg.X floatValue])/xStep;
					if (legend.focusIndex > [legend.financialData count]-1) {
						legend.focusIndex = [legend.financialData count]-1;
						pos = CGPointMake(legend.focusIndex*xStep+[currChart.chartCfg.GraphAreaX floatValue]+[currChart.chartCfg.X floatValue], pos.y);
					}
					if (legend.focusIndex < _intrayInvalidNum) {
						legend.focusIndex = _intrayInvalidNum;
						pos = CGPointMake(legend.focusIndex*xStep+[currChart.chartCfg.GraphAreaX floatValue]+[currChart.chartCfg.X floatValue], pos.y);
					}
				} else {
					xStep = [currChart.chartCfg.GraphAreaWidth floatValue]/([legend.financialData count]);
					legend.focusIndex = [legend.financialData count]-1;
					legend.focusIndex -= (pos.x - [currChart.chartCfg.GraphAreaX floatValue]-[currChart.chartCfg.X floatValue])/xStep - 1;
					if ([legend.financialData count]-1-legend.focusIndex < _nonIntraInvalidNum) {
						legend.focusIndex = [legend.financialData count]-1-_nonIntraInvalidNum;
						pos = CGPointMake(_nonIntraInvalidNum*xStep+[currChart.chartCfg.GraphAreaX floatValue]+[currChart.chartCfg.X floatValue], pos.y);
					}
				}
                //NSLog(@"total: %d curIdx: %d   pos.x : %f", [legend.financialData count], legend.focusIndex ,pos.x);
                if (legend.focusIndex <0) legend.focusIndex = 0;
                if (legend.focusIndex>=[legend.financialData count]) 
					legend.focusIndex = [legend.financialData count]-1;
                [legend setNeedsDisplay];
                
                _focusline.frame = CGRectMake(pos.x, [currChart.chartCfg.Y floatValue]+[currChart.chartCfg.GraphAreaY floatValue], 
                                              [currChart.chartCfg.BulletSize floatValue], [currChart.chartCfg.GraphAreaHeight floatValue]);
                _focusline.fillColor = currChart.chartCfg.BulletColor;
                [_focusline setNeedsDisplay];
                
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (loadingData) {
		return;
	}
	if (StockDataIntraDay == timeFrame) {
		legend.focusIndex = [legend.financialData count]-1;
	}else {
		legend.focusIndex = 0;
	}
	
	
    [legend setNeedsDisplay];
	_focusline.frame = CGRectZero;
	[_focusline setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (loadingData) {
		return;
	}
    if (StockDataIntraDay == timeFrame) {
		legend.focusIndex = [legend.financialData count]-1;
	}else {
		legend.focusIndex = 0;
	}
    [legend setNeedsDisplay];
	_focusline.frame = CGRectZero;
	[_focusline setNeedsDisplay];
}



@end
