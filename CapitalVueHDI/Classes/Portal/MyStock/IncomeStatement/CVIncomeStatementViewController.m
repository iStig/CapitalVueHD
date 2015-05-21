    //
//  CVIncomeStatementViewController.m
//  CapitalVueHD
//
//  Created by jishen on 10/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVIncomeStatementViewController.h"


@implementation CVIncomeStatementViewController

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
    [super viewDidLoad];
	
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	
	self.titleLabel.text = [local localizedString:@"Income Statement"];
	

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
    [super dealloc];
}

#pragma mark -
#pragma mark Overriden

- (NSDictionary *)loadEquitySheetData:(NSString *)equityCode {
	[NSThread detachNewThreadSelector:@selector(changeIndicator:) toTarget:self withObject:[NSNumber numberWithBool:YES]];
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = 15;
	paramInfo.parameters = equityCode;
	dict = [dp GetStockIncomeStatement:paramInfo];
	[paramInfo release];
	return dict;
}

- (NSString *)sheetConfigFile:(id)obj {
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [local localizedString:@"LangCode"];
	
	NSString *hydm;
	NSString *cfgFilePath;
	NSDictionary *dict;
	
	dict = (NSDictionary *)obj;
	
	hydm = [dict objectForKey:@"HYDM"];
	hydm = [hydm lowercaseString];
	if ([hydm isEqualToString:@"i31"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"IncomeStatementTrust_%@",_langCode] ofType:@"plist"];
	} else if ([hydm isEqualToString:@"i11"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"IncomeStatementInsurance_%@",_langCode] ofType:@"plist"];
	} else if ([hydm isEqualToString:@"i01"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"IncomeStatementBank_%@",_langCode] ofType:@"plist"];
	} else if ([hydm isEqualToString:@"i21"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"IncomeStatementSecurities_%@",_langCode] ofType:@"plist"];
	} else if ([hydm hasPrefix:@"i00"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"IncomeStatementOther_%@",_langCode] ofType:@"plist"];
	} else {
		cfgFilePath = nil;
	}
	
	if (cfgFilePath) {
		cfgFilePath = [[[NSString alloc] initWithString:cfgFilePath] autorelease];
	}
	
	
	return cfgFilePath;
}

- (void)changeIndicator:(NSNumber *)action
{
	BOOL bAnimate = [action boolValue];
	if(bAnimate)
	{
		[_indicator startAnimating];
		_indicator.hidden = NO;
	}
	else
	{
		[_indicator stopAnimating];
		_indicator.hidden = YES;
	}
}



@end
