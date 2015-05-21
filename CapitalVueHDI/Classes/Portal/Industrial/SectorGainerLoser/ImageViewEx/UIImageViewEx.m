//
//  UIImageViewEx.m
//  CapitalVueHD
//
//  Created by Dream on 10-9-19.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "UIImageViewEx.h"

#import "CVLocalizationSetting.h"

@implementation UIImageViewEx
@synthesize lblLine1;
@synthesize lblLine2;
@synthesize imgvGainerRate;
@synthesize imgvLoserRate;
@synthesize lblMidLine;
@synthesize lblBoldLine;
@synthesize fIncreased;
@synthesize fDecreased;
@synthesize lblName1;
@synthesize lblName2;
@synthesize lblRate;


- (id) initWithName:(NSString *)sectorName increased:(NSString *)strIncreased decreased:(NSString *)strDecreased changed:(NSString *)strChanged
{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self = [super init];
	fIncreased = [strIncreased floatValue];
	fDecreased = [strDecreased floatValue];
	float increased = [strIncreased floatValue];
	float decreased = [strDecreased floatValue];
	
	
	UILabel *line1 = [[UILabel alloc] init];
	UILabel *line2 = [[UILabel alloc] init];
	UILabel *midLine = [[UILabel alloc] init];
	UILabel *boldLine = [[UILabel alloc] init];
	
	UILabel *name1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PortraitWidth,20.0)];
	UILabel *name2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PortraitWidth, 20.0)];
	UILabel *rate = [[UILabel alloc] init];
	UIImageView *gainerRate = [[UIImageView alloc] init];
	UIImageView *loserRate = [[UIImageView alloc] init];
		
	line1.backgroundColor = [UIColor grayColor];
	line2.backgroundColor = [UIColor grayColor];
	midLine.backgroundColor = [UIColor grayColor];
	boldLine.backgroundColor = [UIColor grayColor];
	
	name1.backgroundColor = [UIColor clearColor];
	name2.backgroundColor = [UIColor clearColor];
	rate.backgroundColor = [UIColor clearColor];
	rate.font = [UIFont boldSystemFontOfSize:15];
	
	//NSLocale *localInfo = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
//	NSString *codePays  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
//	NSString *nomPays = [localInfo displayNameForKey:NSLocaleCountryCode  value:codePays];
	NSLocale *localInfo = [NSLocale currentLocale];
	
	NSString *localeStr;
	
	localeStr = [localInfo objectForKey:NSLocaleIdentifier];
//	NSLog(@"zhcn equals:%@",localeStr);
	UIColor *posColor = [langSetting getColor:@"GainersRate"];
	UIColor *negColor = [langSetting getColor:@"LosersRate"];
	
	gainerRate.backgroundColor = posColor;
	

	loserRate.backgroundColor = negColor;
	
	name1.font = [UIFont systemFontOfSize:NameFontSize];
	name2.font = [UIFont systemFontOfSize:NameFontSize];
	name1.textAlignment = UITextAlignmentCenter;
	name2.textAlignment = UITextAlignmentCenter;
	//red green rect
	gainerRate.frame = CGRectMake(MidlineX*(1.0-increased/100.0), (PortraitHeight-ColorRectHeight)/2.0, MidlineX*increased/100.0, ColorRectHeight);
	loserRate.frame = CGRectMake(MidlineX, (PortraitHeight-ColorRectHeight)/2.0, MidlineX*decreased/100.0, ColorRectHeight);
	
	//name label
	NSArray *sectorArray = [sectorName componentsSeparatedByString:@" "];
	if (1==[sectorArray count])
	{
		name1.text = sectorName;
	//	name1.font = [UIFont systemFontOfSize:14.0/((float)sectorName.length)*10];
		name1.textColor = [UIColor blackColor];
		name1.center = CGPointMake(PortraitNameCenterX, PortraitNameCenterY1);
		name2.text = @"";
		name2.hidden = YES;
		if([sectorName isEqualToString:@"非日常生活消费品"]){
			name1.text = @"非日常生活";
			name2.text = @"消费品";
			name2.hidden = NO;
		}
			
	}
	else
	{
		if (sectorArray == nil) {
			name1.text = @"---";
			name2.text = @"---";
		}else {
			name1.text = [sectorArray objectAtIndex:0];
			if ([name1.text isEqualToString:@"Telecommunication"])
				name1.text = @"Telecom";
			name2.text = [sectorArray objectAtIndex:1];
		}
		
//		name1.font = [UIFont systemFontOfSize:14.0/((float)sectorName.length)*10];
		name1.textColor = [UIColor blackColor];
		name2.textColor = [UIColor blackColor];
		name1.center = CGPointMake(PortraitNameCenterX, PortraitNameCenterY1);
		name2.center = CGPointMake(PortraitNameCenterX, PortraitNameCenterY2);
		
	}
	
	//Rate text
	if (strChanged) {
		rate.text = [NSString stringWithFormat:@"%0.2f%%",[strChanged floatValue]];
	}else {
		rate.text = @"-.--";
	}

	[rate sizeToFit];
	posColor = [langSetting getColor:@"GainersRateLabel"];
	negColor = [langSetting getColor:@"LosersRateLabel"];
	if ([strChanged floatValue]>0)
		rate.textColor = posColor;
	else
		rate.textColor = negColor;
	
	rate.center = CGPointMake(PortraitNameCenterX, PortraitRateCenterY);
	

	
	[self addSubview:line1];
	[self addSubview:line2];
	[self addSubview:midLine];
	[self addSubview:boldLine];
	[self addSubview:name1];
	[self addSubview:name2];
	[self addSubview:rate];
	[self addSubview:gainerRate];
	[self addSubview:loserRate];
	
	lblLine1 = line1;
	lblLine2 = line2;
	lblMidLine = midLine;
	lblBoldLine = boldLine;
	
	lblName1 = name1;
	lblName2 = name2;
	
	lblName1.font = [UIFont boldSystemFontOfSize:11];
	lblName2.font = [UIFont boldSystemFontOfSize:11];
	
	lblRate = rate;
	imgvGainerRate = gainerRate;
	imgvLoserRate = loserRate;
	
	[line1 release];
	[line2 release];
	[rate release];
	[midLine release];
	[boldLine release];
	[name1 release];
	[name2 release];
	[gainerRate release];
	[loserRate release];
	
	self.backgroundColor = [UIColor clearColor];
	
	return self;
}

- (void) initView
{
	
}

- (void) updateOrientation:(UIInterfaceOrientation)orientation
{
	if (orientation==UIInterfaceOrientationPortrait
		|| orientation==UIInterfaceOrientationPortraitUpsideDown)
	{
		lblLine1.frame = CGRectMake(0, 0, PortraitWidth, 1);
		//lblLine2.frame = CGRectMake(0, PortraitHeight-1, PortraitWidth, 1);
		lblMidLine.frame = CGRectMake(MidlineX, 0, 1, PortraitHeight);
		lblBoldLine.frame = CGRectMake(BoldlineX, 0, 2, PortraitHeight);
		imgvGainerRate.frame = CGRectMake(MidlineX*(1.0-fIncreased/100.0), (PortraitHeight-ColorRectHeight)/2.0, MidlineX*fIncreased/100.0, ColorRectHeight);
		imgvLoserRate.frame = CGRectMake(MidlineX, (PortraitHeight-ColorRectHeight)/2.0, MidlineX*fDecreased/100.0, ColorRectHeight);
		lblName1.frame = CGRectMake(0, 0, FontWidth, FontHeight);
		lblName2.frame = CGRectMake(0, 0, FontWidth, FontHeight);
		lblName1.center = CGPointMake(PortraitNameCenterX, PortraitNameCenterY1);
		lblName2.center = CGPointMake(PortraitNameCenterX, PortraitNameCenterY2);
		lblRate.center = CGPointMake(PortraitNameCenterX, PortraitRateCenterY);
		
	}
	else
	{
		lblLine1.frame = CGRectMake(0, 0, 1, LandscapeHeight);
	//	lblLine2.frame = CGRectMake(0, LandscapeHeight-1, LandscapeWidth, 1);
		lblMidLine.frame = CGRectMake(0, MidlineY, LandscapeWidth, 1);
		lblBoldLine.frame = CGRectMake(0, BoldlineY, LandscapeWidth, 2);
		imgvGainerRate.frame = CGRectMake((LandscapeWidth-ColorRectWidth)/2, MidlineY*(1.0-fIncreased/100.0), ColorRectWidth, MidlineY*fIncreased/100.0);
		imgvLoserRate.frame = CGRectMake((LandscapeWidth-ColorRectWidth)/2, MidlineY, ColorRectWidth, MidlineY*fDecreased/100.0);
		lblName1.frame = CGRectMake(0, 0, FontWidth, FontHeight);
		lblName2.frame = CGRectMake(0, 0, FontWidth, FontHeight);
		lblName1.center = CGPointMake(LandscapeWidth/2.0, LandscapeNameCenter1);
		lblName2.center = CGPointMake(LandscapeWidth/2.0, LandscapeNameCenter2);
		lblRate.center = CGPointMake(LandscapeWidth/2.0, LandscapeRateCenterY);
	}
}
@end
