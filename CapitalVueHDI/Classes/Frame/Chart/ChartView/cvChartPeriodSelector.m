//
//  cvChartPeriodSelector.m
//  cvChart
//
//  Created by He Jun on 10-8-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cvChartPeriodSelector.h"

@interface cvChartPeriodSelector ()



@property (nonatomic, retain) NSMutableArray *paths;

- (void)createFirstButtonPath;
- (void)createNormalButtonPath:(int)index;
- (void)createLastButtonPath;

@end

@implementation cvChartPeriodSelector

@synthesize selectedIndex, numberOfSegments;
@synthesize periodCfg, paths;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawInContext:(CGContextRef)context;
{
    // Drawing code
    // draw background
    // draw buttons
    float r, g, b, a;
    float *textcolor = (float *)CGColorGetComponents([periodCfg.Button.BackgroundColor CGColor]);
    
    r = textcolor[0]; g = textcolor[1];
    b = textcolor[2]; a = textcolor[3];
    CGContextSetRGBFillColor(context, r, g, b, a);
    CGContextSetStrokeColorWithColor(context, [periodCfg.Button.BorderColor CGColor]);
    
    CGContextSetLineWidth(context, [periodCfg.Button.BorderWidth floatValue]);
    CGMutablePathRef currPath;
    for (int i = 0; i<[periodCfg.Items count]; i++){
        currPath = (CGMutablePathRef)[paths objectAtIndex:i];
        if (i==selectedIndex) continue;
        CGContextAddPath(context, currPath);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    if ((selectedIndex >=0) && (selectedIndex < [periodCfg.Items count])) {
        currPath = (CGMutablePathRef)[paths objectAtIndex:selectedIndex];
        textcolor = (float *)CGColorGetComponents([periodCfg.Button.BackgroundColorSelected CGColor]);
        
        r = textcolor[0]; g = textcolor[1];
        b = textcolor[2]; a = textcolor[3];
        CGContextSetRGBFillColor(context, r, g, b, a);
        CGContextAddPath(context, currPath);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    // draw text
    UILabel *label = [[UILabel alloc] init];
    UIFont *font = [UIFont fontWithName:periodCfg.Button.TextFont size:[periodCfg.Button.TextSize floatValue]];
    
    label.font = font;
    label.textColor = periodCfg.Button.TextColor;
    label.textAlignment = UITextAlignmentCenter;
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(-0.2f, -0.9f);
    
    float bW = [periodCfg.Width floatValue]/[periodCfg.Items count];
    for (int i = 0; i<[periodCfg.Items count]; i++) {
        cvChartFormatterPeriodSelectorElement *ele = [periodCfg.Items objectAtIndex:i];
        label.text = ele.Title;
        CGRect txtRect = CGRectMake(i*bW, 0.0, bW, [periodCfg.Button.Height floatValue]);
        [label drawTextInRect:txtRect];
    }
    if ((selectedIndex >=0) && (selectedIndex < [periodCfg.Items count])) {
        cvChartFormatterPeriodSelectorElement *ele = [periodCfg.Items objectAtIndex:selectedIndex];
        label.text = ele.Title;
        label.textColor = periodCfg.Button.TextColorSelected;
        CGRect txtRect = CGRectMake(selectedIndex*bW, 0.0, bW, [periodCfg.Button.Height floatValue]);
        [label drawTextInRect:txtRect];
    }
    [label release];
}

#pragma mark -
#pragma mark Button path helpers
- (void)createFirstButtonPath
{
    CGMutablePathRef _path;
    
    _path = CGPathCreateMutable();
    
    CGRect rrect = CGRectMake(0.0, 0.0, [periodCfg.Width floatValue]/[periodCfg.Items count], [periodCfg.Button.Height floatValue]);
	float radius = [periodCfg.Button.CornerRadius floatValue];
    float minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	float miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    // Start at 1
    CGPathMoveToPoint(_path, NULL, minx, midy);

    CGPathAddArcToPoint(_path, NULL, minx, miny, midx, miny, radius);
    CGPathAddLineToPoint(_path, NULL, maxx, miny);
    CGPathAddLineToPoint(_path, NULL, maxx, maxy);
    CGPathAddArcToPoint(_path, NULL, minx, maxy, minx, midy, radius);

	// Close the path
    CGPathCloseSubpath(_path);
	//CGContextClosePath(context);
    
    [self.paths addObject:(id)_path];
    
    CGPathRelease(_path);
}

- (void)createNormalButtonPath:(int)index
{
    CGMutablePathRef _path;
    
    _path = CGPathCreateMutable();
    
    float bW = [periodCfg.Width floatValue]/[periodCfg.Items count];
    
    CGRect rrect = CGRectMake(bW*index, 0.0, bW, [periodCfg.Button.Height floatValue]);
    float minx = CGRectGetMinX(rrect), maxx = CGRectGetMaxX(rrect);
	float miny = CGRectGetMinY(rrect), maxy = CGRectGetMaxY(rrect);
    // Start at 1
    CGPathMoveToPoint(_path, NULL, minx, miny);
	
    CGPathAddLineToPoint(_path, NULL, maxx, miny);

    CGPathAddLineToPoint(_path, NULL, maxx, maxy);

    CGPathAddLineToPoint(_path, NULL, minx, maxy);
    CGPathAddLineToPoint(_path, NULL, minx, miny);
	// Close the path
    CGPathCloseSubpath(_path);
	//CGContextClosePath(context);
    
    [self.paths addObject:(id)_path];
    
    CGPathRelease(_path);
}

- (void)createLastButtonPath
{
    CGMutablePathRef _path;
    
    _path = CGPathCreateMutable();

    float bW = [periodCfg.Width floatValue]/[periodCfg.Items count];
    
    CGRect rrect = CGRectMake(bW*([periodCfg.Items count]-1), 0.0, bW, [periodCfg.Button.Height floatValue]);
	float radius = [periodCfg.Button.CornerRadius floatValue];
    float minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	float miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    // Start at 1
    CGPathMoveToPoint(_path, NULL, midx, miny);
    
    CGPathAddArcToPoint(_path, NULL, maxx, miny, maxx, midy, radius);
    CGPathAddArcToPoint(_path, NULL, maxx, maxy, midx, maxy, radius);
    
    CGPathAddLineToPoint(_path, NULL, minx, maxy);
    CGPathAddLineToPoint(_path, NULL, minx, miny);
	// Close the path
    CGPathCloseSubpath(_path);
	//CGContextClosePath(context);
    
    [self.paths addObject:(id)_path];
    
    CGPathRelease(_path);
}


- (id)initWithConfig:(cvChartFormatterPeriodSelector *)cfg
{
    if (self && cfg) {
        // Initialization code
        self.periodCfg = cfg;
        self.frame = CGRectMake([cfg.X floatValue], [cfg.Y floatValue], 
                                [cfg.Width floatValue], [cfg.Button.Height floatValue]);
        CALayer *layer = [self layer];
        self.backgroundColor = [UIColor clearColor];
        layer.backgroundColor = [cfg.BackgroundColor CGColor];
        layer.borderColor = [cfg.Button.BorderColor CGColor];
        layer.borderWidth = [cfg.Button.BorderWidth integerValue];
        layer.cornerRadius = [cfg.Button.CornerRadius integerValue];
        
        // setup items array
        selectedIndex = -1;
        numberOfSegments = [cfg.Items count];
        
        // generate paths for each button
        paths = [[NSMutableArray alloc] init];
        if (paths){
            [self createFirstButtonPath];
            for (int i=1; i<[cfg.Items count]-1; i++) {
                [self createNormalButtonPath:i];
            }
            [self createLastButtonPath];
        }
        
        
                
    }
    
    return self;    
}

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}


- (void)dealloc {
    [periodCfg release];
    [paths release];
    
    [super dealloc];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
	CGPoint pos = [touch locationInView:self];
    
    float bW = [periodCfg.Width floatValue]/[periodCfg.Items count];
    selectedIndex = (int)(pos.x / bW);
    //NSLog(@"touch end %d", selectedIndex);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}


@end
