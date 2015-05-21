//
//  CVStockTopMarketCapital.m
//  CapitalVueHD
//
//  Created by Dream on 10-11-11.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVStockTopMarketCapital.h"
#import "CVLocalizationSetting.h"

@implementation CVStockTopMarketCapital
@synthesize m_title;
@synthesize m_value;
@synthesize m_description;
@synthesize m_imgvLogo;
@synthesize m_strImage;
@synthesize m_company;
@synthesize m_code;
@synthesize m_close;
@synthesize m_chg;
@synthesize m_chgP;
@synthesize m_imgvBar;

- (id)initWithFrame:(CGRect)frame {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	BOOL isEnglish = [[langSetting localizedString:@"LangCode"] isEqualToString:@"en"];
    if ((self = [super initWithFrame:frame])) {
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
		self.m_title = lblTitle;
		lblTitle.font = [UIFont systemFontOfSize:18];
		lblTitle.textAlignment = UITextAlignmentCenter;
		[lblTitle release];
		
		UILabel *lblValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 300, 30)];
		self.m_value = lblValue;
		lblValue.font = [UIFont boldSystemFontOfSize:30];
		lblValue.textAlignment = UITextAlignmentCenter;
		[lblValue release];
		
		UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(36, 105, 614, 65)];
		text.editable = NO;
		text.userInteractionEnabled = NO;
		self.m_description = text;
		[text release];
		
		UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(151, 16, 120, 80)];
		self.m_imgvLogo = imgv;
		[imgv release];
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"MarketMostActiavedBG.png" ofType:nil];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
		UIImageView *imgv2 = [[UIImageView alloc] initWithImage:img];
		[img release];
		UILabel *lblCompany = [[UILabel alloc] init];
		UILabel *lblCode = [[UILabel alloc] init];
		UILabel *lblClose = [[UILabel alloc] init];
		UILabel *lblChg = [[UILabel alloc] init];
		UILabel *lblChgP = [[UILabel alloc] init];
		_close = [[UILabel alloc] init];
		_chg = [[UILabel alloc] init];
		lblCompany.backgroundColor = [UIColor clearColor];
		lblCompany.font = [UIFont boldSystemFontOfSize:14];
		lblCode.backgroundColor = [UIColor clearColor];
		lblCode.font = [UIFont systemFontOfSize:14];
		lblClose.backgroundColor = [UIColor clearColor];
		lblChg.backgroundColor = [UIColor clearColor];
		lblChgP.backgroundColor = [UIColor clearColor];
		_close.backgroundColor = [UIColor clearColor];
		_chg.backgroundColor = [UIColor clearColor];
		lblCompany.opaque = NO;
		lblCode.opaque = NO;
		lblClose.opaque = NO;
		lblChg.opaque = NO;
		lblChgP.opaque = NO;
		lblClose.font = [UIFont systemFontOfSize:12];
		lblChg.font = [UIFont systemFontOfSize:12];
		lblChgP.font = [UIFont systemFontOfSize:12];
		_close.font = [UIFont systemFontOfSize:12];
		_chg.font = [UIFont systemFontOfSize:12];
		_chgP.font = [UIFont systemFontOfSize:12];
		_close.text = [langSetting localizedString:@"Close:"];
		_chg.text = [langSetting localizedString:@"CHG:"];
		
		if (!isEnglish) {
			[imgv2 addSubview:lblCompany];
		}
		[imgv2 addSubview:lblCode];
		[imgv2 addSubview:lblClose];
		[imgv2 addSubview:lblChg];
		[imgv2 addSubview:lblChgP];
		[imgv2 addSubview:_close];
		[imgv2 addSubview:_chg];
		
		_btnBack = [[UIButton alloc] initWithFrame:CGRectMake(151, 16, 120, 80)];
		_btnBack.backgroundColor = [UIColor clearColor];
		[_btnBack addTarget:self action:@selector(btnTapToMySecurity:) forControlEvents:UIControlEventTouchUpInside];
		
		self.m_company = lblCompany;
		self.m_code = lblCode;
		self.m_close = lblClose;
		self.m_chg = lblChg;
		self.m_chgP = lblChgP;
		self.m_imgvBar = imgv2;
		
		[imgv2 release];
		[lblChgP release];
		[lblChg release];
		[lblClose release];
		[lblCompany release];
		[lblCode release];
		
		
		[self addSubview:m_title];
		[self addSubview:m_value];
		[self addSubview:m_description];
		[self addSubview:m_imgvLogo];
		[self addSubview:m_imgvBar];
		[self addSubview:_btnBack];
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
	[m_title release];
	[m_value release];
	[m_description release];
	[m_imgvLogo release];
	[m_imgvBar release];
	[_btnBack release];
	[m_company release];
	[m_code release];
	[m_close release];
	[m_chg release];
	[m_chgP release];
	[_chg release];
	[_chgP release];
	[_close release];
}

-(void)updateOrientation:(UIInterfaceOrientation)orientation
{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	BOOL isEnglish = [[langSetting localizedString:@"LangCode"] isEqualToString:@"en"];
	if (UIInterfaceOrientationPortrait==orientation
		|| UIInterfaceOrientationPortraitUpsideDown==orientation)
	{
		m_title.center = CGPointMake(403, 34);
		m_value.center = CGPointMake(403, 62);
		m_description.frame = CGRectMake(0, 0, 614, 65);
		m_description.center = CGPointMake(343, 165);
		m_description.font = [UIFont systemFontOfSize:16];
		m_imgvLogo.center = CGPointMake(211, 56);
		[m_imgvBar setFrame:CGRectMake(18, 103, self.frame.size.width-36, 24)];
		[_btnBack setFrame:CGRectMake(18, 103, self.frame.size.width-36, 24)];
		if (isEnglish) {
			[m_code sizeToFit];
			m_code.center = CGPointMake(kDistance +m_code.frame.size.width/2.0f, 12);
			m_code.font = [UIFont boldSystemFontOfSize:14];
		}else {
			[m_company sizeToFit];
			m_company.center = CGPointMake(kDistance+m_company.frame.size.width/2.0f, 12);
			[m_code sizeToFit];
			m_code.center = CGPointMake(kDistance + m_company.center.x+(m_company.frame.size.width+m_code.frame.size.width)/2.0f, 12);
		}

		[_close sizeToFit];
		_close.center = CGPointMake(kDistance+m_code.center.x+(m_code.frame.size.width+_close.frame.size.width)/2.0f, 12);
		[m_close sizeToFit];
		m_close.center = CGPointMake(kDistance+_close.center.x+(_close.frame.size.width+m_close.frame.size.width)/2.0f, 12);
		[_chg sizeToFit];
		_chg.center = CGPointMake(kDistance+m_close.center.x+(_chg.frame.size.width+m_close.frame.size.width)/2.0f,12);
		[m_chg sizeToFit];
		m_chg.center = CGPointMake(kDistance+_chg.center.x+(m_chg.frame.size.width+_chg.frame.size.width)/2.0f,12);
		[m_chgP sizeToFit];
		m_chgP.center = CGPointMake(m_chg.center.x+(m_chg.frame.size.width+m_chgP.frame.size.width)/2.0f, 12);

	}
	else
	{
		m_title.center = CGPointMake(283, 37);
		m_value.center = CGPointMake(283, 66.5);
		m_description.frame = CGRectMake(0, 0, 397, 78);
		m_description.center = CGPointMake(218.5, 165);
		m_description.font = [UIFont systemFontOfSize:14];
		m_imgvLogo.center = CGPointMake(101, 58);
		[m_imgvBar setFrame:CGRectMake(18, 103, self.frame.size.width-36, 24)];
		[_btnBack setFrame:CGRectMake(18, 103, self.frame.size.width-36, 24)];
		if (isEnglish) {
			[m_code sizeToFit];
			m_code.center = CGPointMake(kDistance + m_code.frame.size.width/2.0f, 12);
			m_code.font = [UIFont boldSystemFontOfSize:14];
		} else {
			[m_company sizeToFit];
			m_company.center = CGPointMake(kDistance+m_company.frame.size.width/2.0f, 12);
			[m_code sizeToFit];
			m_code.center = CGPointMake(kDistance + m_company.center.x+(m_company.frame.size.width+m_code.frame.size.width)/2.0f, 12);
		}

		[_close sizeToFit];
		_close.center = CGPointMake(kDistance+m_code.center.x+(m_code.frame.size.width+_close.frame.size.width)/2.0f, 12);
		[m_close sizeToFit];
		m_close.center = CGPointMake(kDistance+_close.center.x+(_close.frame.size.width+m_close.frame.size.width)/2.0f, 12);
		[_chg sizeToFit];
		_chg.center = CGPointMake(kDistance+m_close.center.x+(_chg.frame.size.width+m_close.frame.size.width)/2.0f,12);
		[m_chg sizeToFit];
		m_chg.center = CGPointMake(kDistance+_chg.center.x+(m_chg.frame.size.width+_chg.frame.size.width)/2.0f,12);
		[m_chgP sizeToFit];
		m_chgP.center = CGPointMake(m_chg.center.x+(m_chg.frame.size.width+m_chgP.frame.size.width)/2.0f, 12);
	}
	UIColor *posColor = [langSetting getColor:@"GainersRate"];
	UIColor *negColor = [langSetting getColor:@"LosersRate"];
	
	float fValue = [[[[[m_chgP.text componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@"%"] objectAtIndex:0] floatValue];
	if (fValue<0)
	{
		m_close.textColor = negColor;
		m_chg.textColor = negColor;
		m_chgP.textColor = negColor;
	}
	else if(fValue==0)
	{
		m_close.textColor = [UIColor darkGrayColor];
		m_chg.textColor = [UIColor darkGrayColor];
		m_chgP.textColor = [UIColor darkGrayColor];
	}
	else
	{
		m_close.textColor = posColor;
		m_chg.textColor = posColor;
		m_chgP.textColor = posColor;
	}
//	NSLog(@"Company frmae is:%f",m_company.frame.size.width);
//	[m_description reloadInputViews];
//	[self loadImage];
}

- (void) btnTapToMySecurity:(id)sender{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	NSString *code = m_code.text;
	if (code) {
		[dict setObject:code forKey:@"code"];
		[dict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
		[dict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
		[[NSNotificationCenter defaultCenter] 
		 postNotificationName:CVPortalSwitchPortalSetNotification object:[dict autorelease]];
	}
	else
		[dict release];
	
}
@end