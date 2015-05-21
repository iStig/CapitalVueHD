//
//  CVFinancialSummaryTopMovingFormView.m
//  CapitalVueHD
//
//  Created by jishen on 9/12/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVFinancialSummaryTopMovingFormView.h"
#import "CVLabelStyle.h"
#import "UIColor+DespInit.h"
#import "CVLocalizationSetting.h"

@implementation CVFinancialSummaryTopMovingFormView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
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
    [super dealloc];
}

- (CVLabelStyle *)styleForRow:(int)row Column:(int)column {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"TopMovingSecuritiesFormStyle" ofType:@"plist"];
	NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	int fontSize = [[dict objectForKey:@"Size"] floatValue];
	int start    = [[dict objectForKey:@"Start"] intValue];
	UITextAlignment align = [[dict objectForKey:@"Align"] intValue];
	
	CVLabelStyle* labelStyle = [[CVLabelStyle alloc] init];
	if ( column < start )
	{
		labelStyle.font = [UIFont boldSystemFontOfSize:13.0];
		labelStyle.textAlign = UITextAlignmentCenter;
		labelStyle.foreColor = [UIColor whiteColor];
		labelStyle.backColor = [UIColor clearColor];
	}
	else 
	{
		NSString *keyName;
		NSUInteger i, dynamicKeyColumn = 0;
		
		labelStyle.font = [UIFont systemFontOfSize:fontSize];
		labelStyle.textAlign = align;
		labelStyle.backColor = [UIColor clearColor];
		
		for (i = 0; i < [self.headerArray count]; i++) {
			keyName = [self.headerArray objectAtIndex:i];
			if ([keyName isEqualToString:@"CHG(%)"] == YES) {
				dynamicKeyColumn = i;
				break;
			}
		}
		NSArray *rowArray;
		float keyValue;
		rowArray = [self.dataArray objectAtIndex:row];
		if ([rowArray count] > 3) {
			keyValue = [[rowArray objectAtIndex:3] floatValue];
		}
		
		UIColor *posColor = [langSetting getColor:@"GainersRate"];
		UIColor *negColor = [langSetting getColor:@"LosersRate"];
		
		if (keyValue < 0 )
		{
			labelStyle.foreColor = negColor;
		}
		else 
		{
			labelStyle.foreColor = posColor;
		}
	}
	
	return [labelStyle autorelease];	
}

@end
