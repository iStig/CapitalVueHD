    //
//  CVCompositeIndexProfileViewController.m
//  CapitalVueHD
//
//  Created by jishen on 11/3/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVCompositeIndexProfileViewController.h"
#import "CVDataProvider.h"


@implementation CVCompositeIndexProfileViewController

@synthesize nameOfIndex;
@synthesize nameOfIndexValue;
@synthesize chineseNameOfIndex;
@synthesize chineseNameOfIndexValue;
@synthesize chineseIndexPinyin;
@synthesize chineseIndexPinyinValue;
@synthesize countryAndRegion;
@synthesize countryAndRegionValue;
@synthesize indexClassification;
@synthesize indexClassificationValue;
@synthesize indexCode;
@synthesize indexCodeValue;
@synthesize indexBaseValue;
@synthesize indexBaseValueValue;
@synthesize indexBaseDate;
@synthesize indexBaseDateValue;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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
	[nameOfIndex removeFromSuperview];
	[nameOfIndexValue removeFromSuperview];
	[chineseNameOfIndex removeFromSuperview];
	[chineseNameOfIndexValue removeFromSuperview];
	[chineseIndexPinyin removeFromSuperview];
	[chineseIndexPinyinValue removeFromSuperview];
	[countryAndRegion removeFromSuperview];
	[countryAndRegionValue removeFromSuperview];
	[indexClassification removeFromSuperview];
	[indexClassificationValue removeFromSuperview];
	[indexCode removeFromSuperview];
	[indexCodeValue removeFromSuperview];
	[indexBaseValue removeFromSuperview];
	[indexBaseValueValue removeFromSuperview];
	[indexBaseDate removeFromSuperview];
	[indexBaseDateValue removeFromSuperview];
	
	[nameOfIndex release];
	[nameOfIndexValue release];
	[chineseNameOfIndex release];
	[chineseNameOfIndexValue release];
	[chineseIndexPinyin release];
	[chineseIndexPinyinValue release];
	[countryAndRegion release];
	[countryAndRegionValue release];
	[indexClassification release];
	[indexClassificationValue release];
	[indexCode release];
	[indexCodeValue release];
	[indexBaseValue release];
	[indexBaseValueValue release];
	[indexBaseDate release];
	[indexBaseDateValue release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark public methods

- (void)initBulletin {

}

- (void)loadProfileData {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSArray *dataArray;
	NSDictionary *dict, *titleDict, *valueDict;
	
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = 15;
	paramInfo.parameters = _code;
	dict = [dp GetIndexProfile:paramInfo];
	[paramInfo release];
	
	titleDict = [dict objectForKey:@"head"];
	dataArray = [dict objectForKey:@"data"];
	if ([dataArray count] > 0) {
		valueDict = [dataArray objectAtIndex:0];
	} else {
		valueDict = nil;
	}
	
	self.titleLabel.text = [langSetting localizedString:@"Index Info"];
	self.nameOfIndex.text = [titleDict objectForKey:@"ZSJC"];
	self.nameOfIndexValue.text = [valueDict objectForKey:@"ZSJC"];
	self.chineseNameOfIndex.text = [titleDict objectForKey:@"ZSMC_CN"];
	self.chineseNameOfIndexValue.text = [valueDict objectForKey:@"ZSMC_CN"];
	self.chineseIndexPinyin.text = [titleDict objectForKey:@"ZSJCPY"];
	self.chineseIndexPinyinValue.text = [valueDict objectForKey:@"ZSJCPY"];
	self.countryAndRegion.text = [titleDict objectForKey:@"GJYDQ"];
	self.countryAndRegionValue.text = [valueDict objectForKey:@"GJYDQ"];
	self.indexClassification.text = [titleDict objectForKey:@"ZSFL"];
	self.indexClassificationValue.text = [valueDict objectForKey:@"ZSFL"];
	self.indexCode.text = [titleDict objectForKey:@"ZSDM"];
	self.indexCodeValue.text = [valueDict objectForKey:@"ZSDM"];
	self.indexBaseValue.text = [titleDict objectForKey:@"ZSJD"];
	self.indexBaseValueValue.text = [valueDict objectForKey:@"ZSJD"];
	self.indexBaseDate.text = [titleDict objectForKey:@"ZSJZR"];
	self.indexBaseDateValue.text = [valueDict objectForKey:@"ZSJZR"];
	
	[NSThread detachNewThreadSelector:@selector(changeIndicator:) toTarget:self withObject:[NSNumber numberWithBool:NO]];
	
	[pool release];
}


@end
