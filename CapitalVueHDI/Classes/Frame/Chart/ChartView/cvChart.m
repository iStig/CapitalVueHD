//
//  cvChart.m
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "cvChart.h"

@implementation cvChart

@synthesize financialData, timeFrame, chartCfg, isPercent;
@synthesize nonIntraInvalidNum = _nonIntraInvalidNum;
@synthesize intrayInvalidNum = _intrayInvalidNum;

- (id)initWithConfig:(cvChartFormatterChart *)cfg{
    if (self && cfg) {
        // Initialization code
        self.frame = CGRectMake([cfg.X floatValue], [cfg.Y floatValue], [cfg.Width floatValue], [cfg.Height floatValue]);
        self.backgroundColor = [cfg.BackgroundColor CGColor];
        self.borderColor = [cfg.BorderColor CGColor];
        self.borderWidth = [cfg.BorderWidth integerValue];
        self.cornerRadius = [cfg.CornerRadius integerValue];
        highest = 0.0f;
        lowest = 0.0f;
        
		timeFrame = StockDataOneMonth;
        self.chartCfg = cfg;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {    
    [financialData release];
    [chartCfg release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark data process 
- (void)processData:(NSString *)key
{
    // traverse to find highest and lowest value
    highest = 0.0f;
    lowest = 100000000.0f;
    for (int i=_intrayInvalidNum; i<[financialData count]-_nonIntraInvalidNum; i++) {
        NSDictionary *currentFinancial = [financialData objectAtIndex:i];
        NSNumber *currVal = [currentFinancial objectForKey:key];
		
        if ( lowest > [currVal floatValue] )  {
            lowest = [currVal floatValue];
        }
        if ( highest < [currVal floatValue] ) {
            highest = [currVal floatValue];
        }
    }
    //NSLog(@"highest: %.3f, lowest: %.3f", highest, lowest);
}

- (void)calculateXSteps:(CGContextRef)context
{    
    
}

- (void)calculateYSteps:(CGContextRef)context
{    
    // calc steps
    //NSLog(@"highest:%.3f lowest:%.3f",[highest floatValue], [lowest floatValue]);
    _valueStep = (highest - lowest)/[chartCfg.Rows integerValue];
    //NSLog(@"YL-step: %.3f", _valueStep);
	if (0 == _valueStep) {
		// for quotation that stops in the exchange
		_valueStep = 0.1f;
	}
    /*
	 * disalbed ...
	 * FIXME, it shall follow the general fomat of chart design
	 * that is utilized by most financial business
    if (_valueStep <1.0f) _valueStep = 0.1f;
    else if (_valueStep <10.0f) _valueStep = 1.0f;
    else if (_valueStep <100.0f) _valueStep = 10.0f;
    else if (_valueStep <1000.0f) _valueStep = 100.0f;
    else _valueStep = 1000.0f;*/
    //NSLog(@"adjusted step: %.3f", _valueStep);
    
    _YMax = ((int)(highest/_valueStep + 0.5f))*_valueStep;
    _YMin = ((int)(lowest/_valueStep - 0.0f))*_valueStep;
    //NSLog(@"yMin: %.3f yMax:%.3f", _YMin, _YMax);
    float tmpStep = _valueStep;
    while (highest > (_YMin + [chartCfg.Rows integerValue]*_valueStep)){
        _valueStep += tmpStep/2;
    }
    _YMax = _YMin + [chartCfg.Rows integerValue]*_valueStep;
    //NSLog(@"After yMin: %.3f yMax:%.3f", _YMin, _YMax);
    
    _YStep = (_YMax - _YMin)/([chartCfg.GraphAreaHeight floatValue]);
    //NSLog(@"XStep: %.3f YStep: %.3f", _XStep, _YStep);
}


#pragma mark -
#pragma mark graph drawing 
- (void)drawLineGraphInContext:(CGContextRef)context withConfig:(cvChartFormatterChartGraph *)graphCfg
{
    // prepare data
    [self processData:graphCfg.ValueKey];
    [self calculateYSteps:context];
	
	if (0 == [financialData count])
		return;
    
    // draw line
	CGMutablePathRef _path;
    NSDictionary *dayData;
    float xpos, ypos;
    
	if (StockDataIntraDay == timeFrame) {
		// 9:30~10:30 and 13:00~14:00 are 240 minutes
		_XStep = [chartCfg.GraphAreaWidth floatValue] / 239;
	} else {
		_XStep = [chartCfg.GraphAreaWidth floatValue]/([financialData count]-1);
	}
    
	_path = CGPathCreateMutable();
	CGFloat xLeftest = [chartCfg.GraphAreaX floatValue];
	
	if (StockDataIntraDay == timeFrame) {
		dayData = [financialData objectAtIndex:0];
		ypos = [[dayData objectForKey:graphCfg.ValueKey] floatValue] - _YMin;
		ypos = [chartCfg.GraphAreaHeight floatValue] + [chartCfg.GraphAreaY floatValue] - (ypos/_YStep);
		
		CGPathMoveToPoint(_path, NULL, [chartCfg.GraphAreaX floatValue], ypos);
		BOOL startDraw = YES;
		for (int i = 0; i < [financialData count]; i++)
		{
			xpos = [chartCfg.GraphAreaX floatValue] + i * _XStep;
			dayData = [financialData objectAtIndex:i];
			ypos = [[dayData objectForKey:graphCfg.ValueKey] floatValue] - _YMin;        
			ypos = [chartCfg.GraphAreaHeight floatValue] + [chartCfg.GraphAreaY floatValue] - (ypos/_YStep);
			if (i < _intrayInvalidNum) {
				CGPathMoveToPoint(_path, NULL, xpos, ypos);
				startDraw = NO;
			}else {
				if (startDraw) {
					CGPathAddLineToPoint(_path, NULL, xpos, ypos);
				}else {
					CGPathMoveToPoint(_path, NULL, xpos, ypos);
					startDraw = YES;
					xLeftest = xpos;
				}
				
			}
			//NSLog(@"plot at (%.3f, %.3f)", xpos, ypos);
			CGPathAddLineToPoint(_path, NULL, xpos, ypos);
		}
	} else {
		dayData = [financialData objectAtIndex:([financialData count] - 1)];
		ypos = [[dayData objectForKey:graphCfg.ValueKey] floatValue] - _YMin;
		ypos = [chartCfg.GraphAreaHeight floatValue] + [chartCfg.GraphAreaY floatValue] - (ypos/_YStep);
		
		CGPathMoveToPoint(_path, NULL, [chartCfg.GraphAreaX floatValue], ypos);
		BOOL startDraw = YES;
		for (int i = [financialData count]-2; i>=0; i--)
		{
			xpos = [chartCfg.GraphAreaX floatValue] + ([financialData count]-i-1)*_XStep;
			dayData = [financialData objectAtIndex:i];
			ypos = [[dayData objectForKey:graphCfg.ValueKey] floatValue] - _YMin;        
			ypos = [chartCfg.GraphAreaHeight floatValue] + [chartCfg.GraphAreaY floatValue] - (ypos/_YStep);
			//NSLog(@"plot at (%.3f, %.3f)", xpos, ypos);
			if (i > [financialData count]-1-_nonIntraInvalidNum) {
				CGPathMoveToPoint(_path, NULL, xpos, ypos);
				startDraw = NO;
			}else {
				if (startDraw) {
					CGPathAddLineToPoint(_path, NULL, xpos, ypos);
				}else {
					CGPathMoveToPoint(_path, NULL, xpos, ypos);
					startDraw = YES;
					xLeftest = xpos;
				}

			}
		}
	}
	CGContextSetStrokeColorWithColor(context, [graphCfg.Color CGColor]);
	CGContextSetLineWidth(context, [graphCfg.StrokeSize floatValue]);
	CGContextAddPath(context, _path);
	CGContextStrokePath(context);
	
    // draw gradient
    if (YES == graphCfg.Shadowed){
        CGGradientRef	_gradient;
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        float colors[] = {1.0, 0.9, 0.0, 1.0,
            0.8, 0.8, 0.7, 0.0};
        _gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4) );
        
        //CGPathAddLineToPoint(_path, NULL, [chartCfg.GraphAreaWidth floatValue]+[chartCfg.GraphAreaX floatValue], 
		CGPathAddLineToPoint(_path, NULL, xpos /*+ [chartCfg.GraphAreaX floatValue]*/,
                             [chartCfg.GraphAreaHeight floatValue]+[chartCfg.GraphAreaY floatValue]);
        CGPathAddLineToPoint(_path, NULL, xLeftest,
                             [chartCfg.GraphAreaHeight floatValue]+[chartCfg.GraphAreaY floatValue]);
        CGPathCloseSubpath(_path);
        CGContextAddPath(context, _path);
        
        CGContextSaveGState(context);
        CGContextClip(context);
        
		CGPoint start, end;
		start = CGPointMake([chartCfg.GraphAreaX floatValue], [chartCfg.GraphAreaY floatValue]);
		end = CGPointMake([chartCfg.GraphAreaX floatValue], [chartCfg.GraphAreaY floatValue]+[chartCfg.GraphAreaHeight floatValue]);
		
        CGContextDrawLinearGradient(context, _gradient, start, end, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        CGGradientRelease(_gradient);
        CGColorSpaceRelease(rgb);
    }
    CGPathRelease(_path);
}

- (void)drawColumnGraphInContext:(CGContextRef)context withConfig:(cvChartFormatterChartGraph *)graphCfg
{
	
    // prepare data
    [self processData:graphCfg.ValueKey];
    
    // define lowest vol
	// why (6 * lowest - hightest) / 5 before?
    float startVol = 0;// lowest;// (6*lowest-highest)/5;
    //NSLog(@"startVol: %.3f", startVol);
    
    CGMutablePathRef _path;
    _path = CGPathCreateMutable();
    CGContextSetStrokeColorWithColor(context, [graphCfg.Color CGColor]);
	CGContextSetLineWidth(context, [graphCfg.StrokeSize floatValue]);
    
    NSDictionary *dayData;
    int i;
    float xpos, ypos, xstep, ystep, bottomY;
	if (StockDataIntraDay == timeFrame) {
		// 9:30~10:30 and 13:00~14:00 are 240 minutes
		xstep = [chartCfg.GraphAreaWidth floatValue] / 239;
		ystep = (highest - startVol)/[chartCfg.GraphAreaHeight floatValue];
		bottomY = [chartCfg.GraphAreaHeight floatValue] + [chartCfg.GraphAreaY floatValue];
		float total = 0;
		for (i = 0; i < [financialData count]; i++){
			// read currVol
			dayData = [financialData objectAtIndex:i];
			float currVol = [[dayData objectForKey:graphCfg.ValueKey] floatValue];
			total += currVol;
			// set point
			xpos = [chartCfg.GraphAreaX floatValue] + i * xstep + xstep / 2;
			ypos = bottomY - (currVol-startVol)/ystep;
			//draw
			CGPathMoveToPoint(_path, NULL, xpos, bottomY);
			CGPathAddLineToPoint(_path, NULL, xpos, ypos);
			CGContextAddPath(context, _path);
			CGContextStrokePath(context);
		}
	} else {
		xstep = [chartCfg.GraphAreaWidth floatValue]/[financialData count];
		// recaculate the max y value for the next instruction
		[self calculateYSteps:context];
		ystep = [chartCfg.GraphAreaHeight floatValue] / (_YMax - _YMin);
		bottomY = [chartCfg.GraphAreaHeight floatValue] + [chartCfg.GraphAreaY floatValue];
		float total = 0;
		for (i=[financialData count]-1; i>=0; i--){
			// read currVol
			dayData = [financialData objectAtIndex:i];
			float currVol = [[dayData objectForKey:graphCfg.ValueKey] floatValue];
			total += currVol;
			
			// set point
			xpos = [chartCfg.GraphAreaX floatValue] + ([financialData count]- 1 -i)*xstep + xstep/2;
			ypos = bottomY - (currVol-_YMin) * ystep;
			
			//draw
			CGPathMoveToPoint(_path, NULL, xpos, bottomY);
			CGPathAddLineToPoint(_path, NULL, xpos, ypos);
			CGContextAddPath(context, _path);
			CGContextStrokePath(context);
		}
	}
    CGPathRelease(_path);
    
    // draw average vol
    /*
    total /= [financialData count];
    
    float r, g, b, a;
    float *textcolor = (float *)CGColorGetComponents([chartCfg.TextColor CGColor]);
    
    r = textcolor[0]; g = textcolor[1];
    b = textcolor[2]; a = textcolor[3];
    CGContextSetRGBFillColor(context, r, g, b, a);
    CGContextSelectFont(context, [chartCfg.TextFont UTF8String], [chartCfg.TextSize floatValue], kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGAffineTransform myTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 60);
    CGContextSetTextMatrix(context, myTransform);
    
    NSString *value = [NSString stringWithFormat:@"Average Volume: %.0f", total];

    xpos = [chartCfg.GraphAreaX floatValue] + 4;
    ypos = [chartCfg.GraphAreaY floatValue]+[chartCfg.GraphAreaHeight floatValue] + 15;
    CGContextShowTextAtPoint(context, xpos, ypos, [value UTF8String], strlen([value UTF8String]));
    */
}


#pragma mark -
#pragma mark axis drawing
- (void)drawXValues:(CGContextRef)context
{
    // setup text properties
    float r, g, b, a;
    float *textcolor = (float *)CGColorGetComponents([chartCfg.XAxis.Value.TextColor CGColor]);
    
    r = textcolor[0]; g = textcolor[1];
    b = textcolor[2]; a = textcolor[3];
    UIFont *font = [UIFont fontWithName:chartCfg.TextFont size:[chartCfg.XAxis.Value.TextSize floatValue]];
    CGContextSetRGBFillColor(context, r, g, b, a);
    CGContextSelectFont(context, [chartCfg.TextFont UTF8String], [chartCfg.XAxis.Value.TextSize floatValue], kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGAffineTransform myTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 60);
    CGContextSetTextMatrix(context, myTransform);
    
    // generate text and draw them
    int columns = [chartCfg.Columns integerValue];
    float columnValueStep = [financialData count]/(columns);
    float columnW = [chartCfg.GraphAreaWidth floatValue]/columns;
    NSDictionary *dayData;
    NSString *currDateStr;
    CGSize textSize;
    NSDate *currDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	if (StockDataIntraDay == timeFrame) {
		[dateFormatter setDateFormat:@"HH:mm"];
	} else if (StockDataOneWeek <= timeFrame && timeFrame <= StockDataOneMonth) {
		[dateFormatter setDateFormat:@"MM/dd"];
	} else if (StockDataOneMonth < timeFrame && timeFrame <= StockDataThreeYears) {
		[dateFormatter setDateFormat:@"yyyy/MM"];
	} else if (timeFrame > StockDataThreeYears){
		[dateFormatter setDateFormat:@"yyyy"];
	}
    
    float xpos, ypos;
    int i, index;
	if (StockDataIntraDay == timeFrame) {
		// intraday
		NSArray *timeArray;
		timeArray = [[NSArray alloc] initWithObjects:
					 @"9:30", @"10:30", @"11:30/13:00", @"14:00", @"15:00",
					 nil];
		columnW = [chartCfg.GraphAreaWidth floatValue] / 4;
		for (i = 0; i < 5; i ++) {
			currDateStr = [timeArray objectAtIndex:i];
			textSize = [currDateStr sizeWithFont:font];
			xpos = [chartCfg.GraphAreaX floatValue] + i * columnW;
			if (i > 0 && i < 4) {
				xpos -= textSize.width / 2;
			} else if (4 == i) {
				xpos -= textSize.width;
			}
			ypos = [chartCfg.GraphAreaY floatValue]+[chartCfg.GraphAreaHeight floatValue]+textSize.height + 2;
			//NSLog(@"(%.3f, %.3f)", xpos, ypos);
			CGContextShowTextAtPoint(context, xpos, ypos, [currDateStr UTF8String], strlen([currDateStr UTF8String]));
		}
		[timeArray release];
	} else {
		for (i=0; i<columns; i++){
			// generate text
			index = [financialData count] - (int)(i*columnValueStep) -1;
			//NSLog(@"read index:%d", index);
			if (index < [financialData count]) {
				dayData = [financialData objectAtIndex:index];
				currDate = [dayData objectForKey:@"date"];
				currDateStr = [dateFormatter stringFromDate:currDate];
        
				// draw
				textSize = [currDateStr sizeWithFont:font];
				xpos = [chartCfg.GraphAreaX floatValue] + 5 + i*columnW;
				ypos = [chartCfg.GraphAreaY floatValue]+[chartCfg.GraphAreaHeight floatValue]+textSize.height + 2;
				//NSLog(@"(%.3f, %.3f)", xpos, ypos);
				if (currDateStr) {
					CGContextShowTextAtPoint(context, xpos, ypos, [currDateStr UTF8String], strlen([currDateStr UTF8String]));
				}
			}
		}
	}
    // draw last value
    // it dosen't show the last date
	//currDate = [[financialData objectAtIndex:(0)] objectForKey:@"date"];
    //currDateStr = [dateFormatter stringFromDate:currDate];
    //NSLog(@"%@", currDateStr);
    
    //xpos = [chartCfg.GraphAreaX floatValue]+ [chartCfg.GraphAreaWidth floatValue] - textSize.width;
    //ypos = [chartCfg.GraphAreaY floatValue]+[chartCfg.GraphAreaHeight floatValue]+textSize.height + 2;
    //CGContextShowTextAtPoint(context, xpos, ypos, [currDateStr UTF8String], strlen([currDateStr UTF8String]));
    
    [dateFormatter release];
}

- (void)drawYLeftValues:(CGContextRef)context
{
    // load data for Y-Left axis
    [self processData:chartCfg.YLeftAxis.Value.ValueKey];
    [self calculateYSteps:context];

    // setup text properties
    float r, g, b, a;
    float *textcolor = (float *)CGColorGetComponents([chartCfg.YLeftAxis.Value.TextColor CGColor]);
    
    r = textcolor[0]; g = textcolor[1];
    b = textcolor[2]; a = textcolor[3];
    UIFont *font = [UIFont fontWithName:chartCfg.TextFont size:[chartCfg.YLeftAxis.Value.TextSize floatValue]];
    CGContextSetRGBFillColor(context, r, g, b, a);
    CGContextSelectFont(context, [chartCfg.TextFont UTF8String], [chartCfg.YLeftAxis.Value.TextSize floatValue], kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGAffineTransform myTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 60);
    CGContextSetTextMatrix(context, myTransform);
    
    // generate text and draw them
    CGSize textSize;
    int lines = [chartCfg.XAxis.Grid.Lines integerValue];
    for (int i=0; i<lines; i++){
        //float step = (_YMax-_YMin)/[chartCfg.Rows integerValue];
        float curVal = _YMin + i*_valueStep;
        NSString *value;
        if (_valueStep < 1.0f){
            value = [NSString stringWithFormat:@"%@%.2f", chartCfg.YLeftAxis.Value.Unit, curVal];
        }else if (_valueStep < 10.0f) {
            value = [NSString stringWithFormat:@"%@%.1f", chartCfg.YLeftAxis.Value.Unit, curVal];
        }else{
            value = [NSString stringWithFormat:@"%@%.0f", chartCfg.YLeftAxis.Value.Unit, curVal];
        }
        //NSLog(@"axis value %@", value);
        
        // draw
        float xpos, ypos;
        textSize = [value sizeWithFont:font];
        xpos = [chartCfg.GraphAreaX floatValue] - textSize.width - 4;
		// FIXME sometime xpos is less than 0, it means that part of the text is drawn out of the view and
		// is invisible. So, you have to readjust the with of the graph area.
		// I shall be considered in an overall view.
		if (xpos < 0) {
			CGFloat width, origin_x;
			NSNumber *number;
			origin_x = [chartCfg.GraphAreaX floatValue];
			width = [chartCfg.GraphAreaWidth floatValue];
			origin_x -= xpos;
			width += xpos;
			number = [[NSNumber alloc] initWithFloat:origin_x];
			chartCfg.GraphAreaX = number;
			[number release];
			number = [[NSNumber alloc] initWithFloat:width];
			chartCfg.GraphAreaWidth = number;
			[number release];
			xpos = 0;
		}
        ypos = [chartCfg.GraphAreaY floatValue]+[chartCfg.GraphAreaHeight floatValue] + textSize.height/4;
        ypos -= ([chartCfg.GraphAreaHeight floatValue]/[chartCfg.Rows floatValue])*i;
        if (i == [chartCfg.Rows integerValue]) ypos += textSize.height/4;
        CGContextShowTextAtPoint(context, xpos, ypos, [value UTF8String], strlen([value UTF8String]));
    }
}

- (void)drawYRightValues:(CGContextRef)context
{
    // load data for Y-Left axis
    [self processData:chartCfg.YRightAxis.Value.ValueKey];
    [self calculateYSteps:context];
    
    // setup text properties
    float r, g, b, a;
    float *textcolor = (float *)CGColorGetComponents([chartCfg.YRightAxis.Value.TextColor CGColor]);
    
    r = textcolor[0]; g = textcolor[1];
    b = textcolor[2]; a = textcolor[3];
    UIFont *font = [UIFont fontWithName:chartCfg.TextFont size:[chartCfg.YRightAxis.Value.TextSize floatValue]];
    CGContextSetRGBFillColor(context, r, g, b, a);
    CGContextSelectFont(context, [chartCfg.TextFont UTF8String], [chartCfg.YRightAxis.Value.TextSize floatValue], kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGAffineTransform myTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 60);
    CGContextSetTextMatrix(context, myTransform);
    
    // generate text and draw them
    CGSize textSize;
    int lines = [chartCfg.XAxis.Grid.Lines integerValue];
    for (int i=0; i<lines; i++){
		float curVal = _YMin + i*_valueStep;
        NSString *value;
        //value = [NSString stringWithFormat:@"%d%@", (100-(lines-1)*10 + i*10), chartCfg.YRightAxis.Value.Unit];
        //NSLog(@"axis value %@", value);
		if (_valueStep < 1.0f){
			if (isPercent)
				value = [NSString stringWithFormat:@"%@%.2f%%", chartCfg.YLeftAxis.Value.Unit, curVal];
			else
				value = [NSString stringWithFormat:@"%@%.2f", chartCfg.YLeftAxis.Value.Unit, curVal];
        }else if (_valueStep < 10.0f) {
			if (isPercent)
				value = [NSString stringWithFormat:@"%@%.1f%%", chartCfg.YLeftAxis.Value.Unit, curVal];
			else
				value = [NSString stringWithFormat:@"%@%.1f", chartCfg.YLeftAxis.Value.Unit, curVal];
        }else{
			if (isPercent)
				value = [NSString stringWithFormat:@"%@%.0f%%", chartCfg.YLeftAxis.Value.Unit, curVal];
			else
				value = [NSString stringWithFormat:@"%@%.0f", chartCfg.YLeftAxis.Value.Unit, curVal];
        }
        
        // draw
        float xpos, ypos;
        textSize = [value sizeWithFont:font];
        xpos = [chartCfg.GraphAreaX floatValue] + [chartCfg.GraphAreaWidth floatValue]+4;
        ypos = [chartCfg.GraphAreaY floatValue]+[chartCfg.GraphAreaHeight floatValue] + textSize.height/4;
        ypos -= ([chartCfg.GraphAreaHeight floatValue]/[chartCfg.Rows floatValue])*i;
        if (i == [chartCfg.Rows integerValue]) ypos += textSize.height/4;
        CGContextShowTextAtPoint(context, xpos, ypos, [value UTF8String], strlen([value UTF8String]));
    }
}

- (void)drawXAxisInContext:(CGContextRef)context
{
    int i, lines;
    lines = [chartCfg.XAxis.Grid.Lines integerValue];
    
    // draw horizontal lines
    CGRect bounds = CGRectMake([chartCfg.GraphAreaX floatValue], 
                               [chartCfg.GraphAreaY floatValue], 
                               [chartCfg.GraphAreaWidth floatValue], 
                               [chartCfg.GraphAreaHeight floatValue]);
    CGFloat startX = CGRectGetMinX(bounds);
    CGFloat startY = CGRectGetMaxY(bounds);
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat step = (bounds.size.height) / ([chartCfg.Rows floatValue]);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    
    for (i=0; i<lines; i++) {
        CGFloat currY = startY - (step*i); 
        CGContextMoveToPoint(context, startX, currY);
        CGContextAddLineToPoint(context, startX+width, currY);
        if (0==i) CGContextSetLineWidth(context, 3.0);
        else CGContextSetLineWidth(context, 1.0);
        CGContextAddLineToPoint(context, startX+width, currY);
        CGContextStrokePath(context);
    }
}


#pragma mark -
#pragma mark layer draw entry
-(void)drawInContext:(CGContextRef)context
{
    // draw graphs
    if (nil != financialData){
        // draw Y-L value
        if (YES == chartCfg.YLeftAxis.Value.Enable){
            [self drawYLeftValues:context];
        }
        // draw Y-R value if needed
        if (YES == chartCfg.YRightAxis.Value.Enable){
            [self drawYRightValues:context];
        }
		if (YES == chartCfg.XAxis.Grid.Enable){
			[self drawXAxisInContext:context];
		}
        // draw x axis value
        if (YES == chartCfg.XAxis.Value.Enable){
			[self drawXValues:context];
		}
            
        int i;
        for (i=0; i<[chartCfg.Graphs count]; i++) {
            cvChartFormatterChartGraph *currGraph = [chartCfg.Graphs objectAtIndex:i];
            if (YES == [currGraph.Type isEqualToString:@"Line"]){
                [self drawLineGraphInContext:context withConfig:currGraph];
            }
            if (YES == [currGraph.Type isEqualToString:@"Column"]) {
                [self drawColumnGraphInContext:context withConfig:currGraph];
            }
        }
    }
}

@end
