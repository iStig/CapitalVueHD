//
//  CVFinancialSummaryCompositeIndexFormView.m
//  CapitalVueHD
//
//  Created by jishen on 9/12/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVFinancialSummaryCompositeIndexFormView.h"

#import "CVLabelStyle.h"
#import "UIColor+DespInit.h"
#import "CVLocalizationSetting.h"

@implementation CVFinancialSummaryCompositeIndexFormView

@synthesize compareArray;

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
	[compareArray dealloc];
    [super dealloc];
}

- (CVLabelStyle *)styleForRow:(int)row Column:(int)column {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"CompositeIndexFormStyle" ofType:@"plist"];
	NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	int fontSize = [[dict objectForKey:@"Size"] floatValue];
	int start    = [[dict objectForKey:@"Start"] intValue];
	
	CVLabelStyle* labelStyle = [[CVLabelStyle alloc] init];

	if ( column < start )
	{
		labelStyle.font = [UIFont boldSystemFontOfSize:13.0];
		labelStyle.textAlign = UITextAlignmentLeft;

		labelStyle.foreColor = [UIColor whiteColor];
		labelStyle.backColor = [UIColor clearColor];
	}
	else 
	{
		// customized
		labelStyle.font = [UIFont systemFontOfSize:fontSize];
		labelStyle.textAlign = UITextAlignmentRight;
		labelStyle.backColor = [UIColor clearColor];
		
		NSString *change;
		
		change = [self.compareArray objectAtIndex:row];
		
		UIColor *posColor = [langSetting getColor:@"GainersRate"];
		UIColor *negColor = [langSetting getColor:@"LosersRate"];
		
		if ([change floatValue] < 0) {
			labelStyle.foreColor = negColor;
		} else {
			labelStyle.foreColor = posColor;
		}

	}
	
	return [labelStyle autorelease];	
}


@end
