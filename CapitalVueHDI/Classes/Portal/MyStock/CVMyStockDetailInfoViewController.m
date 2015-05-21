    //
//  CVMyStockDetailInfoViewController.m
//  CapitalVueHD
//
//  Created by leon on 10-10-8.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMyStockDetailInfoViewController.h"
#import "CVLocalizationSetting.h"
#import "NSString+Number.h"

@implementation CVMyStockDetailInfoViewController

@synthesize _labelMoney;
@synthesize _labelLatest;
@synthesize _labelChange;
@synthesize _labelChangePercent;
@synthesize _labelOpen;
@synthesize _labelHigh;
@synthesize _labelPETTM;
@synthesize _labelPELastyr;
@synthesize _labelVolume;
@synthesize _labelPriorClose;
@synthesize _labelLow;
@synthesize _labelPBMRQ;
@synthesize _labelTotalAShares;
@synthesize _labelTurnover;
@synthesize lblRealTime;

@synthesize nonIntrayDict = _nonIntrayDict;
@synthesize intrayDict = _intrayDict;

@synthesize activityIndicator = _activityIndicator;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 113, 646, 4)];
	UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 235, 646, 4)];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"mystock_detail_line.png" ofType:nil];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	line1.image = img;
	line2.image = img;
	[img release];
	[self.view addSubview:line1];
	[self.view addSubview:line2];
	[line1 release];
	[line2 release];
	
	[self createLabel];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMoneySymbol:) name:@"ChangeMoneySymbol" object:nil];
	
    [super viewDidLoad];
}

-(void) createLabel{
	self._labelMoney = [[UILabel alloc] initWithFrame:CGRectMake(20, 47, 40, 50)];
	[_labelMoney release];
	self._labelMoney.textAlignment = UITextAlignmentRight;
	self._labelMoney.tag = 1;
	self._labelLatest = [[UILabel alloc] initWithFrame:CGRectMake(60, 45, 210, 50)];
	[_labelLatest release];
	self._labelLatest.tag = 1;
	self._labelChange = [[UILabel alloc] initWithFrame:CGRectMake(282, 45, 180, 50)];
	[_labelChange release];
	self._labelChange.tag = 1;
	self._labelChangePercent = [[UILabel alloc] initWithFrame:CGRectMake(500, 45, 180, 50)];
	[_labelChangePercent release];
	self._labelChangePercent.tag = 1;
	self._labelOpen = [[UILabel alloc] initWithFrame:CGRectMake(20, 145, 80, 30)];
	[_labelOpen release];
	self._labelOpen.tag = 1;
	self._labelHigh = [[UILabel alloc] initWithFrame:CGRectMake(145, 145, 80, 30)];
	[_labelHigh release];
	self._labelHigh.tag = 1;
	self._labelPETTM = [[UILabel alloc] initWithFrame:CGRectMake(250, 145, 80, 30)];
	[_labelPETTM release];
	self._labelPETTM.tag = 1;
	self._labelPELastyr = [[UILabel alloc] initWithFrame:CGRectMake(390, 145, 80, 30)];
	[_labelPELastyr release];
	self._labelPELastyr.tag = 1;
	self._labelVolume = [[UILabel alloc] initWithFrame:CGRectMake(525, 145, 110, 30)];
	[_labelVolume release];
	self._labelVolume.tag = 1;
	self._labelPriorClose = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 80, 30)];
	[_labelPriorClose release];
	self._labelPriorClose.tag = 1;
	self._labelLow = [[UILabel alloc] initWithFrame:CGRectMake(145, 200, 80, 30)];
	[_labelLow release];
	self._labelLow.tag = 1;
	self._labelPBMRQ = [[UILabel alloc] initWithFrame:CGRectMake(250, 200, 80, 30)];
	[_labelPBMRQ release];
	self._labelPBMRQ.tag = 1;
	self._labelTotalAShares = [[UILabel alloc] initWithFrame:CGRectMake(390, 200, 100, 30)];
	[_labelTotalAShares release];
	self._labelTotalAShares.tag = 1;
	self._labelTurnover = [[UILabel alloc] initWithFrame:CGRectMake(525, 200, 150, 30)];
	[_labelTurnover release];
	self._labelTurnover.tag = 1;
	self.lblRealTime = [[UILabel alloc] initWithFrame:CGRectMake(15, 86, 127, 33)];
	[lblRealTime release];
	self.lblRealTime.tag = 1;
	
	[self.view addSubview:_labelMoney];
	[self.view addSubview:_labelLatest];
	[self.view addSubview:_labelChange];
	[self.view addSubview:_labelChangePercent];
	[self.view addSubview:_labelOpen];
	[self.view addSubview:_labelHigh];
	[self.view addSubview:_labelPETTM];
	[self.view addSubview:_labelPELastyr];
	[self.view addSubview:_labelVolume];
	[self.view addSubview:_labelPriorClose];
	[self.view addSubview:_labelLow];
	[self.view addSubview:_labelPBMRQ];
	[self.view addSubview:_labelTotalAShares];
	[self.view addSubview:_labelTurnover];
	[self.view addSubview:lblRealTime];
	_labelMoney.text = @"￥";
	for (id content in [self.view subviews])
	{
		UILabel *label = content;
		if ([label isKindOfClass:[UILabel class]]) {
			if (label.tag!=0) {
				label.backgroundColor = [UIColor clearColor];
				label.textColor = [UIColor whiteColor];
				label.font = [UIFont boldSystemFontOfSize:16];
			}
		}
	}
	_labelMoney.font = [UIFont boldSystemFontOfSize:16];
	_labelLatest.font = [UIFont boldSystemFontOfSize:32];
	_labelChange.font = [UIFont boldSystemFontOfSize:32];
	_labelChangePercent.font = [UIFont boldSystemFontOfSize:32];
	lblRealTime.font = [UIFont boldSystemFontOfSize:12];
	[_labelMoney setHidden:YES];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 5,
											 self.view.frame.size.height / 2 - 35,
											 _activityIndicator.frame.size.width, 
											 _activityIndicator.frame.size.height);
	_activityIndicator.hidesWhenStopped = YES;
	[_activityIndicator stopAnimating];
	[self.view addSubview:_activityIndicator];
}

-(NSString *)getLatestValue{
	NSString *Latest = [_intrayDict valueForKey:@"SP"];
	if (Latest == nil) {
		Latest = [_nonIntrayDict valueForKey:@"SP"];
	}
	return Latest;
}

-(NSString *)getChangeValue{
	NSString *Change = [_intrayDict valueForKey:@"ZF"];
	if (Change == nil) {
		Change = [_nonIntrayDict valueForKey:@"ZF"];
	}
	return Change;
}

-(NSString *)getChangePercentValue{
	NSString *ChangePercent = [_intrayDict valueForKey:@"ZDF"];
	if (ChangePercent == nil) {
		ChangePercent = [_nonIntrayDict valueForKey:@"ZDF"];
	}
	return ChangePercent;
}

-(NSString *)getOpenValue{
	NSString *Open = [_intrayDict valueForKey:@"KP"];
	if (Open == nil) {
		Open = [_nonIntrayDict objectForKey:@"KP"];
	}
	return Open;
}

-(NSString *)getPriorCloseValue{
	NSString *PriorClose = [_intrayDict valueForKey:@"ZS"];
	if (PriorClose == nil) {
		PriorClose = [_nonIntrayDict objectForKey:@"ZS"];
	}
	return PriorClose;
}

-(void) setData:(NSMutableDictionary *)mutableDict{
	NSDictionary *dict = [mutableDict objectForKey:@"dict"];
	BOOL isIntraday = [[mutableDict objectForKey:@"isIntraday"] boolValue];
	if (isIntraday) {
		self.intrayDict = dict;
	} else {
		self.nonIntrayDict = dict;
	}
}

-(void)showData{
	[_labelMoney setHidden:NO];
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [langSetting localizedString:@"LangCode"];
	
	NSString *Open = [self getOpenValue];

	NSString *High = [_intrayDict valueForKey:@"ZG"];
	if (High == nil) {
		High = [_nonIntrayDict objectForKey:@"ZG"];
	}
	NSString *PETTM = [_intrayDict valueForKey:@"TTM"];
	if (PETTM == nil) {
		PETTM = [_nonIntrayDict objectForKey:@"TTM"];
	}
	NSString *PELastyr = [_intrayDict valueForKey:@"LYR"];
	if (PELastyr == nil) {
		PELastyr = [_nonIntrayDict objectForKey:@"LYR"];
	}
	NSString *Volumn = [_intrayDict valueForKey:@"CJL"];
	if (Volumn == nil) {
		Volumn = [_nonIntrayDict objectForKey:@"CJL"];
	}
	NSString *PriorClose = [self getPriorCloseValue];
	
	NSString *Low = [_intrayDict valueForKey:@"ZD"];
	if (Low == nil) {
		Low = [_nonIntrayDict objectForKey:@"ZD"];
	}
	NSString *PBMRQ = [_intrayDict valueForKey:@"MRQ"];
	if (PBMRQ == nil) {
		PBMRQ = [_nonIntrayDict objectForKey:@"MRQ"];
	}
	NSString *TradableShares = [_intrayDict valueForKey:@"SJLTGB"];
	if (TradableShares == nil) {
		TradableShares = [_nonIntrayDict objectForKey:@"SJLTGB"];
	}
	NSString *Turnover = [_intrayDict valueForKey:@"CJ"];
	if (Turnover == nil) {
		Turnover = [_nonIntrayDict objectForKey:@"CJ"];
	}
	NSString *realTime = [_intrayDict valueForKey:@"time"];
	if (realTime == nil) {
		realTime = [_nonIntrayDict objectForKey:@"time"];
	}
		
	NSArray *array = [TradableShares componentsSeparatedByString:@","];
	TradableShares = [TradableShares stringByReplacingOccurrencesOfString:@"," withString:@""];
	float tradableshares = [TradableShares intValue];
	NSUInteger count = [array count];
	switch (count) {
		case 2:
			tradableshares = tradableshares/1000;
			TradableShares = [NSString stringWithFormat:@"%.2fTh.",tradableshares];
			break;
		case 3:
			tradableshares = tradableshares/1000000;
			TradableShares = [NSString stringWithFormat:@"%.2fM.",tradableshares];
			break;
		case 4:
			tradableshares = tradableshares/1000000000;
			TradableShares = [NSString stringWithFormat:@"%.2fB.",tradableshares];
			break;

		default:
			break;
	}
	
	// devide 1000 for turnover
	if (Turnover) {
		double dTurnover = [Turnover doubleValue];
		dTurnover = dTurnover/1000;
		Turnover = [NSString stringWithFormat:@"%.3lf",dTurnover];
	}
	
	if (Open){
		float fOpen = [Open floatValue];
		NSString *text = [NSString stringWithFormat:@"%.2f",fOpen];
		if ([_langCode isEqualToString:@"en"]) {
			text = [text formatToEnNumber];
		}
		_labelOpen.text = text;
	}

	if (High){
		float fHigh = [High floatValue];
		NSString *text = [NSString stringWithFormat:@"%.2f",fHigh];
		if ([_langCode isEqualToString:@"en"]) {
			text = [text formatToEnNumber];
		}
		_labelHigh.text = text;
	}

	if (PETTM){
		if ([_langCode isEqualToString:@"en"]) {
			PETTM = [PETTM formatToEnNumber];
		}
		_labelPETTM.text = PETTM;
	}

	if (PELastyr){
		if ([_langCode isEqualToString:@"en"]) {
			PELastyr = [PELastyr formatToEnNumber];
		}
		_labelPELastyr.text = PELastyr;
	}


	if (Volumn){
		if ([_langCode isEqualToString:@"en"]) {
			Volumn = [Volumn formatToEnNumber];
		}
		_labelVolume.text = Volumn;
	}

	if (PriorClose){
		if ([_langCode isEqualToString:@"en"]) {
			PriorClose = [PriorClose formatToEnNumber];
		}
		_labelPriorClose.text = PriorClose;
	}


	if (Low){
		float fLow = [Low floatValue];
		NSString *text = [NSString stringWithFormat:@"%.2f",fLow];
		if ([_langCode isEqualToString:@"en"]) {
			text = [text formatToEnNumber];
		}
		_labelLow.text = text;
	}

	if (PBMRQ){
		if ([_langCode isEqualToString:@"en"]) {
			PBMRQ = [PBMRQ formatToEnNumber];
		}
		_labelPBMRQ.text = PBMRQ;
	}

	if (TradableShares){
		if ([_langCode isEqualToString:@"en"]) {
			TradableShares = [TradableShares formatToEnNumber];
		}
		_labelTotalAShares.text = TradableShares;
	}


	if (Turnover){
		if ([_langCode isEqualToString:@"en"]) {
			Turnover = [Turnover formatToEnNumber];
		}
		_labelTurnover.text = Turnover;
	}
	
	if (realTime) {
		lblRealTime.text = realTime;
	}

	
	[_activityIndicator stopAnimating];
}

// this method can only be called while there is no intra chart data back
-(void)showWhileNoIntradayChart{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [langSetting localizedString:@"LangCode"];
	
	
	NSString *Latest = [self getLatestValue];
	
	NSString *Change = [self getChangeValue];
	
	NSString *ChangePercent = [self getChangePercentValue];
	
	UIColor *posColor = [langSetting getColor:@"GainersRate"];
	UIColor *negColor = [langSetting getColor:@"LosersRate"];
	
	float change = [Change floatValue];
	float changePercent = [ChangePercent floatValue];
	if (change>0) {
		ChangePercent = [NSString stringWithFormat:@"%.2f%%",changePercent];
		_labelChange.textColor = posColor;
		_labelChangePercent.textColor = posColor;
	}
	else if (change < 0){
		Change = [NSString stringWithFormat:@"%.2f",change];
		ChangePercent = [NSString stringWithFormat:@"%.2f%%",changePercent];
		_labelChange.textColor = negColor;
		_labelChangePercent.textColor = negColor;
	}
	else {
		_labelChange.textColor = [UIColor grayColor];
		_labelChangePercent.textColor = [UIColor grayColor];
	}
	if (Latest){
		float fLatest = [Latest floatValue];
		NSString *text = [NSString stringWithFormat:@"%.2f",fLatest];
		if ([_langCode isEqualToString:@"en"]) {
			text = [text formatToEnNumber];
		}
		_labelLatest.text = text;
	}
	
	if (Change){
		_labelChange.text = Change;
	}
	
	if (ChangePercent && ![ChangePercent isEqualToString:@"0"]){
		_labelChangePercent.text = ChangePercent;
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[_labelMoney release];
	[_labelLatest release];
	[_labelChange release];
	[_labelChangePercent release];
	[_labelOpen release];
	[_labelHigh release];
	[_labelPETTM release];
	[_labelPELastyr release];
	[_labelVolume release];
	[_labelPriorClose release];
	[_labelLow release];
	[_labelPBMRQ release];
	[_labelTotalAShares release];
	[_labelTurnover release];
	[lblRealTime release];
	
	[_nonIntrayDict release];
	[_intrayDict release];
	
	[_activityIndicator release];
	
    [super dealloc];
}

-(void)changeMoneySymbol:(NSNotification *)notification
{
	NSDictionary *dict = [notification userInfo];
	_labelMoney.text = [dict objectForKey:@"symbol"];
}

-(void) showDefault{
	_labelMoney.text = @"-";
	
	_labelLatest.text = @"-";
	
	_labelChange.text = @"-";
	
	_labelChangePercent.text = @"-";
	
	_labelOpen.text = @"-";
	
	_labelHigh.text = @"-";
	
	_labelPETTM.text = @"-";
	
	_labelPELastyr.text = @"-";
	
	_labelVolume.text = @"-";
	
	_labelPriorClose.text = @"-";
	
	_labelLow.text = @"-";
	
	_labelPBMRQ.text = @"-";
	
	_labelTotalAShares.text = @"-";
	
	_labelTurnover.text = @"-";
	
	lblRealTime.text = @"-";
}
@end
