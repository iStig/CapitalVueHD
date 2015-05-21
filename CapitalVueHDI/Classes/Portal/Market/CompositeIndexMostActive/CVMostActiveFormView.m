//
//  CVMostActiveFormView.m
//  CapitalVueHD
//
//  Created by jishen on 9/18/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMostActiveFormView.h"
#import "CVLabelStyle.h"
#import "UIColor+DespInit.h"
#import "CVSetting.h"
#import "CVLocalizationSetting.h"

@implementation CVMostActiveFormView


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
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"MostActiveFormConf_%@",[langSetting localizedString:@"LangCode"]] ofType:@"plist"];
	NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	int keyColumn = [[dict objectForKey:@"KeyColumn"] intValue];
	int fontSize = [[dict objectForKey:@"Size"] floatValue];
	int start    = [[dict objectForKey:@"Start"] intValue];

	UITextAlignment align = [[dict objectForKey:@"Align"] intValue];
	
	CVLabelStyle* labelStyle = [[CVLabelStyle alloc] init];
	if ( column < start )
	{
		NSString *ilang = [langSetting localizedString:@"LangCode"];
		
		labelStyle.font = [UIFont boldSystemFontOfSize:14.0];
		if ([ilang isEqualToString:@"cn"]) {
			labelStyle.textAlign = UITextAlignmentLeft;
		}else {
			labelStyle.textAlign = UITextAlignmentCenter;
		}

		labelStyle.foreColor = [UIColor blackColor];
		labelStyle.backColor = [UIColor clearColor];
	}
	else 
	{
		UIColor *posColor = [langSetting getColor:@"GainersRate"];
		UIColor *negColor = [langSetting getColor:@"LosersRate"];
		if (column==3)
			labelStyle.font = [UIFont boldSystemFontOfSize:fontSize];
		else
			labelStyle.font = [UIFont systemFontOfSize:fontSize];
		labelStyle.textAlign = align;
		labelStyle.backColor = [UIColor clearColor];
		float keyValue = [[[self.dataArray objectAtIndex:row] objectAtIndex:keyColumn] floatValue];
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
