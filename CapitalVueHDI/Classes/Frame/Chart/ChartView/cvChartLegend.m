//
//  cvChartLegend.m
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cvChartLegend.h"
#import "NSString+Number.h"
#import "CVLocalizationSetting.h"


@implementation cvChartLegend

@synthesize financialData, legendCfg, focusIndex;

- (id)initWithConfig:(cvChartFormatterLegend *)cfg{
    if (self && cfg) {
        // Initialization code
        self.frame = CGRectMake([cfg.X floatValue], [cfg.Y floatValue], 
                                [cfg.Width floatValue], [cfg.Height floatValue]);
        self.backgroundColor = [cfg.BackgroundColor CGColor];
        self.borderColor = [cfg.BorderColor CGColor];
        self.borderWidth = [cfg.BorderWidth integerValue];
        self.cornerRadius = [cfg.CornerRadius integerValue];
        
        self.legendCfg = cfg;
		
		aryTitles = [[NSMutableArray alloc] initWithCapacity:[legendCfg.Items count]];
		
		for (int i = 0; i < [legendCfg.Items count]; i++) {
			UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
			lblTitle.backgroundColor = [UIColor clearColor];
			[self addSublayer:lblTitle.layer];
			[aryTitles addObject:lblTitle];
			[lblTitle release];
		}
		
		_langCode = [[CVLocalizationSetting sharedInstance] localizedString:@"LangCode"];
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
    [legendCfg release];
	[aryTitles release];
    [super dealloc];
}

-(void)drawInContext:(CGContextRef)context
{
    float r, g, b, a;
    float *textcolor = (float *)CGColorGetComponents([legendCfg.TextColor CGColor]);
    
    r = textcolor[0]; g = textcolor[1];
    b = textcolor[2]; a = textcolor[3];
	
    CGContextSetRGBFillColor(context, r, g, b, a);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGAffineTransform myTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 60);
    CGContextSetTextMatrix(context, myTransform);
    
    float startX, startY, yStep;
    int i;
    cvChartFormatterLegendItem *currItem = nil;
    UIFont *font = [UIFont fontWithName:legendCfg.TextFont size:[legendCfg.TextSize floatValue]];
    
    for(i=0; i<[legendCfg.Items count]; i++){
        currItem = [legendCfg.Items objectAtIndex:i];
        if (currItem == nil) NSLog(@"currItem nil");
        CGSize textSize;
        textSize = [@"Title" sizeWithFont:font];
        startX = [currItem.X floatValue];
        startY = [currItem.Y floatValue] + textSize.height;
        // draw title
        CGContextSelectFont(context, [legendCfg.TextFont UTF8String], [legendCfg.TextSize floatValue], kCGEncodingMacRoman);
		UILabel *lblTitle = (UILabel *)[aryTitles objectAtIndex:i];
		lblTitle.frame = CGRectMake(startX, startY-14, 0, 0);
		lblTitle.backgroundColor = [UIColor clearColor];
		lblTitle.font = [UIFont systemFontOfSize:[legendCfg.TextSize floatValue]];
		lblTitle.textColor = [UIColor whiteColor];
		lblTitle.text = currItem.Title;
		
		[lblTitle sizeToFit];
        // draw value
        yStep = textSize.height + 6;
		
		// hard code
		// legendCfg.TextFont -> @"Helvetica-Bold"
        CGContextSelectFont(context, [@"Helvetica-Bold" UTF8String], [legendCfg.TextSize floatValue]+4.0f, kCGEncodingMacRoman);
        
        if (nil != financialData && focusIndex < [financialData count]){
            NSDictionary *dayData = [financialData objectAtIndex:focusIndex];
            
            if (YES == [currItem.ValueKey isEqualToString:@"date"]){
                NSString *currStr;
                NSDate *currDate;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				NSNumber *numIsIntraday;
				
				numIsIntraday = [dayData objectForKey:@"isIntraday"];
				if (YES == [numIsIntraday boolValue]) {
					[dateFormatter setDateFormat:@"MM-dd HH:mm"];
				} else {
					[dateFormatter setDateFormat:@"yyyy-MM-dd"];
				}
                currDate = [dayData objectForKey:@"date"];
                currStr = [dateFormatter stringFromDate:currDate];
				textSize = [currStr sizeWithFont:[UIFont boldSystemFontOfSize:16]];
				if (currStr) {
					CGContextShowTextAtPoint(context, startX, startY+yStep, [currStr UTF8String], strlen([currStr UTF8String]));
				}
				
                [dateFormatter release];
            }else {
				if ((NSNull *)[dayData objectForKey:currItem.ValueKey] != [NSNull null]) {
					float val = [[dayData objectForKey:currItem.ValueKey] floatValue];
					NSString *formatStr = [NSString stringWithFormat:@"%%.%df", [currItem.DigitsAfterDecimal integerValue]];
					NSString *currStr = [NSString stringWithFormat:formatStr,val];
					if ([_langCode isEqualToString:@"en"]) {
						currStr = [currStr formatToEnNumber];
					}
					
					textSize = [currStr sizeWithFont:[UIFont boldSystemFontOfSize:16]];
					if (currStr) {
						CGContextShowTextAtPoint(context, startX, startY+yStep, [currStr UTF8String], strlen([currStr UTF8String]));
					}
				}
            }
        }
    }
}


@end
