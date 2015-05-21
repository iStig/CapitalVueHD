    //
//  CVMyIndexDetailInfoViewController.m
//  CapitalVueHD
//
//  Created by jishen on 11/2/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMyIndexDetailInfoViewController.h"
#import "CVLocalizationSetting.h"
#import "NSString+Number.h"


@implementation CVMyIndexDetailInfoViewController

@synthesize latest;
@synthesize latestValue;
@synthesize change;
@synthesize changeValue;
@synthesize changeRatio;
@synthesize changeRatioValue;
@synthesize open;
@synthesize openValue;
@synthesize priorClose;
@synthesize priorCloseValue;
@synthesize high;
@synthesize highValue;
@synthesize low;
@synthesize lowValue;
@synthesize volumex100;
@synthesize volumex100Value;
@synthesize turnover000;
@synthesize turnover000Value;
@synthesize lblRealTime;

@synthesize nonIntrayDict = _nonIntrayDict;
@synthesize intrayDict = _intrayDict;

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
	[img release];
	NSString *path2 = [[NSBundle mainBundle] pathForResource:@"mystock_detail_line.png" ofType:nil];
	UIImage *img2 = [[UIImage alloc] initWithContentsOfFile:path2];
	line2.image = img2;
	[img2 release];
	[self.view addSubview:line1];
	[self.view addSubview:line2];
	[line1 release];
	[line2 release];
    [super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[latest release];
	[latestValue release];
	[change release];
	[changeValue release];
	[changeRatio release];
	[changeRatioValue release];
	[open release];
	[openValue release];
	[priorClose release];
	[priorCloseValue release];
	[high release];
	[highValue release];
	[low release];
	[lowValue release];
	[volumex100 release];
	[volumex100Value release];
	[turnover000 release];
	[turnover000Value release];
	[lblRealTime release];
	
	[_nonIntrayDict release];
	[_intrayDict release];
    [super dealloc];
}

-(void) showDefault{
	self.latestValue.text = @"--";
	self.changeValue.text = @"--";
	self.changeRatioValue.text = @"--";
	self.openValue.text = @"--";
	self.priorCloseValue.text = @"--";
	self.highValue.text = @"--";
	self.lowValue.text = @"--";
	self.volumex100Value.text = @"--";
	self.turnover000Value.text = @"--";
	self.lblRealTime.text = @"--";
}

-(void)showTitle:(NSDictionary *)dict{
	NSDictionary *titleDict = nil;
	
	if (dict) {
		titleDict = [dict objectForKey:@"head"];
		
		self.latest.text = [titleDict objectForKey:@"SPJ"];
		self.change.text = [titleDict objectForKey:@"CHANGE"];
		self.changeRatio.text = [titleDict objectForKey:@"CHANGE_PERCENT"];
		self.open.text = [titleDict objectForKey:@"KPJ"];
		self.priorClose.text = [titleDict objectForKey:@"ZSP"];
		self.high.text = [titleDict objectForKey:@"ZGJ"];
		self.low.text = [titleDict objectForKey:@"ZDJ"];
		self.volumex100.text = [titleDict objectForKey:@"CJL"];
		self.turnover000.text = [titleDict objectForKey:@"CJJE"];
	}
}


-(NSString *)getLatestValue{
	NSDictionary *valueDict = nil ,*nonIntrayValueDict = nil;
	NSArray *dataArray = nil, *nonIntrayDataArray = nil;
	
	dataArray = [_intrayDict objectForKey:@"data"];
	if ([dataArray count] > 0) {
		valueDict = [dataArray objectAtIndex:0];
	}
	
	nonIntrayDataArray = [_nonIntrayDict objectForKey:@"data"];
	if ([nonIntrayDataArray count] > 0) {
		nonIntrayValueDict = [nonIntrayDataArray objectAtIndex:0];
	} else {
		nonIntrayValueDict = nil;
	}
	NSString *strTemp = [valueDict objectForKey:@"SPJ"];
	if (strTemp == nil) {
		strTemp = [nonIntrayValueDict objectForKey:@"SPJ"];
		strTemp = [NSString stringWithFormat:@"%ld", [strTemp integerValue]/1000];
	}
	return strTemp;
}

-(NSString *)getPriorCloseValue{
	NSDictionary *valueDict = nil ,*nonIntrayValueDict = nil;
	NSArray *dataArray = nil, *nonIntrayDataArray = nil;
	
	dataArray = [_intrayDict objectForKey:@"data"];
	if ([dataArray count] > 0) {
		valueDict = [dataArray objectAtIndex:0];
	}
	
	nonIntrayDataArray = [_nonIntrayDict objectForKey:@"data"];
	if ([nonIntrayDataArray count] > 0) {
		nonIntrayValueDict = [nonIntrayDataArray objectAtIndex:0];
	} else {
		nonIntrayValueDict = nil;
	}
	
	NSString *strTemp = [valueDict objectForKey:@"Prior Close"];
	if (strTemp == nil) {
		strTemp = [nonIntrayValueDict objectForKey:@"ZSP"];
	}
	return strTemp;
}

-(void)showData{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [langSetting localizedString:@"LangCode"];
	
	NSDictionary *valueDict = nil ,*nonIntrayValueDict = nil;
	NSArray *dataArray = nil, *nonIntrayDataArray = nil;
	
	// udpate the value of open, high, low, latest, change and change%
	// it's not good ...
	[self showTitle:_nonIntrayDict];
	dataArray = [_intrayDict objectForKey:@"data"];
	if ([dataArray count] > 0) {
		valueDict = [dataArray objectAtIndex:0];
	}
	
	nonIntrayDataArray = [_nonIntrayDict objectForKey:@"data"];
	if ([nonIntrayDataArray count] > 0) {
		nonIntrayValueDict = [nonIntrayDataArray objectAtIndex:0];
	} else {
		nonIntrayValueDict = nil;
	}
	
	NSString *strTemp;
	double doubleTemp;
		
		
		
	// prior close
	strTemp = [self getPriorCloseValue];
	if (strTemp) {
		doubleTemp = [strTemp doubleValue];
		strTemp = [NSString stringWithFormat:@"%.2lf", doubleTemp];
		if ([_langCode isEqualToString:@"en"]) {
			strTemp = [strTemp formatToEnNumber];
		}
		self.priorCloseValue.text = strTemp;
	}
	
	// open
	strTemp = [valueDict objectForKey:@"KPJ"];
	if (strTemp == nil) {
		strTemp = [nonIntrayValueDict objectForKey:@"KPJ"];
	}
	if (strTemp) {
		doubleTemp = [strTemp doubleValue];
		strTemp = [NSString stringWithFormat:@"%.2lf", doubleTemp];
		if ([_langCode isEqualToString:@"en"]) {
			strTemp = [strTemp formatToEnNumber];
		}
		self.openValue.text = strTemp;
	}
	// high
	strTemp = [valueDict objectForKey:@"ZGJ"];
	if (strTemp == nil) {
		strTemp = [nonIntrayValueDict objectForKey:@"ZGJ"];
	}
	if (strTemp) {
		doubleTemp = [strTemp doubleValue];
		strTemp = [NSString stringWithFormat:@"%.2lf", doubleTemp];
		if ([_langCode isEqualToString:@"en"]) {
			strTemp = [strTemp formatToEnNumber];
		}
		self.highValue.text = strTemp;
	}
	// low
	strTemp = [valueDict objectForKey:@"ZDJ"];
	if (strTemp == nil) {
		strTemp = [nonIntrayValueDict objectForKey:@"ZDJ"];
	}
	if (strTemp) {
		doubleTemp = [strTemp doubleValue];
		strTemp = [NSString stringWithFormat:@"%.2lf", doubleTemp];
		if ([_langCode isEqualToString:@"en"]) {
			strTemp = [strTemp formatToEnNumber];
		}
		self.lowValue.text = strTemp;
	}
	
	strTemp = [valueDict objectForKey:@"CJL"];
	if (strTemp == nil) {
		strTemp = [nonIntrayValueDict objectForKey:@"CJL"];
	}
	if ([_langCode isEqualToString:@"en"]) {
		strTemp = [strTemp formatToEnNumber];
	}
	self.volumex100Value.text = strTemp;
	
	strTemp = [valueDict objectForKey:@"CJJE"];
	if (strTemp == nil) {
		strTemp = [nonIntrayValueDict objectForKey:@"CJJE"];
	}
	
	//divide 1000 for turnover
	double dTurnover = [strTemp doubleValue];
	dTurnover = dTurnover/1000;
	strTemp = [NSString stringWithFormat:@"%.3lf",dTurnover];
	
	if ([_langCode isEqualToString:@"en"]) {
		strTemp = [strTemp formatToEnNumber];
	}
	self.turnover000Value.text = strTemp;
	
	NSString *strstrDate = [valueDict objectForKey:@"FSRQ"];
	if (strstrDate == nil) {
		strstrDate = [nonIntrayValueDict objectForKey:@"FSRQ"];
	}
	if (!strstrDate)
		strstrDate =[valueDict objectForKey:@"time"];
	self.lblRealTime.text = strstrDate;
	
}

// this method can only be called while there is no intra chart data back
-(void)showWhileNoIntradayChart{
	NSDictionary *titleDict = nil, *valueDict = nil ,*nonIntrayValueDict = nil;
	NSArray *dataArray = nil, *nonIntrayDataArray = nil;
	
	NSString *strTemp;
	double doubleTemp;
	
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [langSetting localizedString:@"LangCode"];
	
	// udpate the value of open, high, low, latest, change and change%
	// it's not good ...
	titleDict = [_intrayDict objectForKey:@"head"];
	dataArray = [_intrayDict objectForKey:@"data"];
	if ([dataArray count] > 0) {
		valueDict = [dataArray objectAtIndex:0];
	}
	
	nonIntrayDataArray = [_nonIntrayDict objectForKey:@"data"];
	if ([nonIntrayDataArray count] > 0) {
		nonIntrayValueDict = [nonIntrayDataArray objectAtIndex:0];
	} else {
		nonIntrayValueDict = nil;
	}
	
	// latest
	strTemp = [self getLatestValue];
	if (strTemp) {
		strTemp = [NSString stringWithFormat:@"%ld", [strTemp integerValue]];
		if ([_langCode isEqualToString:@"en"]) {
			strTemp = [strTemp formatToEnNumber];
		}
		self.latestValue.text = strTemp;
	}
	// change
	strTemp = [valueDict objectForKey:@"CHANGE"];
	if (strTemp == nil) {
		strTemp = [nonIntrayValueDict objectForKey:@"CHANGE"];
	}
	if (strTemp) {
		UIColor *posColor = [langSetting getColor:@"GainersRate"];
		UIColor *negColor = [langSetting getColor:@"LosersRate"];
		doubleTemp = [strTemp doubleValue];
		if (doubleTemp > 0.0) {
			self.changeValue.textColor = posColor;
			self.changeRatioValue.textColor = posColor;
		} else if (doubleTemp == 0.0) {
			self.changeValue.textColor = [UIColor whiteColor];
			self.changeRatioValue.textColor = [UIColor whiteColor];
		} else {
			self.changeValue.textColor = negColor;
			self.changeRatioValue.textColor = negColor;
		}
		
		strTemp = [NSString stringWithFormat:@"%.2lf", doubleTemp];
		self.changeValue.text = strTemp;
	}
	
	// change percent %
	strTemp = [valueDict objectForKey:@"CHANGE_PERCENT"];
	if (strTemp == nil) {
		strTemp = [nonIntrayValueDict objectForKey:@"CHANGE_PERCENT"];
	}
	if (strTemp) {
		doubleTemp = [strTemp doubleValue];
		strTemp = [NSString stringWithFormat:@"%.2f%%", doubleTemp];
		self.changeRatioValue.text = strTemp;
	}
}


@end
