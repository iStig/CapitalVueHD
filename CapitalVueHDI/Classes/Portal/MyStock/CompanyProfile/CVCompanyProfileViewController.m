    //
//  CVCompanyProfileViewController.m
//  CapitalVueHD
//
//  Created by jishen on 11/2/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVCompanyProfileViewController.h"

#import "CVDataProvider.h"

#import "CVCompanyProfileBulletin.h"

@interface CVCompanyProfileViewController()

@property (nonatomic, retain) CVCompanyProfileBulletin *_bulletin;

@end

@implementation CVCompanyProfileViewController

@synthesize rotationInterfaceOrientation;
@synthesize titleLabel;
@synthesize imageBackgroundView;
@synthesize scrollView;

@synthesize code = _code;

@synthesize _bulletin;

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
	self.view.userInteractionEnabled = YES;
	self.view.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height - 30);
	self.rotationInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
	self.view.alpha = 0.5;
	self.view.backgroundColor = [UIColor clearColor];
	self.view.autoresizesSubviews = NO;
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_indicator.hidesWhenStopped = YES;
	_indicator.center = CGPointMake(self.view.frame.size.width/2.0f,self.view.frame.size.height/2.0f);
	[_indicator startAnimating];
	[self.view addSubview:_indicator];
	[self initBulletin];
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
	[titleLabel release];
	[imageBackgroundView release];
	[scrollView release];
	[_bulletin release];
	
	[_code release];
	
    [super dealloc];
}


- (void)setCode:(NSString *)code {
	if (nil != code) {
		[_code release];
		_code = [code retain];
		[self performSelector:@selector(loadProfileData) withObject:nil afterDelay:0.4];
	}
}

#pragma mark -
#pragma mark public methods

- (void)initBulletin {
	CVCompanyProfileBulletin *v;
	
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CVCompanyProfileBulletin" owner:self options:nil];
	
	for (id currentObject in topLevelObjects){
		if ([currentObject isKindOfClass:[CVCompanyProfileBulletin class]]) {
			v =  (CVCompanyProfileBulletin *) currentObject;
			v.autoresizesSubviews = NO;
			v.autoresizingMask = UIViewAutoresizingNone;
			v.backgroundColor = [UIColor clearColor];
			break;
		}
	}
	v.companyDescriptionValue.font = [UIFont systemFontOfSize:12.0];
	v.companyDescriptionValue.backgroundColor = [UIColor clearColor];
	v.addressValue.font = [UIFont systemFontOfSize:12.0];
	v.addressValue.backgroundColor = [UIColor clearColor];
	self._bulletin = v;
	scrollView.contentSize = _bulletin.frame.size;
	[self.scrollView insertSubview:_bulletin belowSubview:_indicator];
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
	dict = [dp GetStockProfile:paramInfo];
	[paramInfo release];
	
	titleDict = [dict objectForKey:@"head"];
	dataArray = [dict objectForKey:@"data"];
	if ([dataArray count] > 0) {
		valueDict = [dataArray objectAtIndex:0];
	} else {
		valueDict = nil;
	}
	
	self.titleLabel.text = [langSetting localizedString:@"Company Info"];
	_bulletin.companyNameInEnglish.text = [titleDict objectForKey:@"GSYWMC"];
	_bulletin.companyNameInEnglishValue.text = [valueDict objectForKey:@"GSYWMC"];
	_bulletin.chineseNameOfCompany.text = [titleDict objectForKey:@"GSZWMC"];
	_bulletin.chineseNameOfCompanyValue.text = [valueDict objectForKey:@"GSZWMC"];
	_bulletin.companyDescription.text = [titleDict objectForKey:@"LSJS"];
	_bulletin.companyDescriptionValue.text = [valueDict objectForKey:@"LSJS"];
	_bulletin.shortName.text = [titleDict objectForKey:@"GSYWJC"];
	_bulletin.shortNameValue.text = [valueDict objectForKey:@"GSYWJC"];
	_bulletin.website.text = [titleDict objectForKey:@"GSWZ"];
	_bulletin.websiteValue.text = [valueDict objectForKey:@"GSWZ"];
	_bulletin.listingDate.text = [titleDict objectForKey:@"SSRQ"];
	//_bulletin.listingDateValue.text = [valueDict objectForKey:@"SSRQ"];
	_bulletin.legalRepresentative.text = [titleDict objectForKey:@"FRDB"];
	_bulletin.legalRepresentativeValue.text = [valueDict objectForKey:@"FRDB"];
	_bulletin.dateEstablished.text = [titleDict objectForKey:@"CLRQ"];
	//_bulletin.dateEstablishedValue.text = [valueDict objectForKey:@"CLRQ"];
	_bulletin.registeredCapital.text = [titleDict objectForKey:@"ZCZB"];
	_bulletin.registeredCapitalValue.text = [valueDict objectForKey:@"ZCZB"];
	_bulletin.businessRegisteredNumber.text = [titleDict objectForKey:@"GSDJH"];
	_bulletin.businessRegisteredNumberValue.text = [valueDict objectForKey:@"GSDJH"];
	_bulletin.address.text = [titleDict objectForKey:@"ZCDZ"];
	_bulletin.addressValue.text = [valueDict objectForKey:@"ZCDZ"];
	_bulletin.postcode.text = [titleDict objectForKey:@"YB"];
	_bulletin.postcodeValue.text = [valueDict objectForKey:@"YB"];
	_bulletin.email.text = [titleDict objectForKey:@"DZYJ"];
	_bulletin.emailValue.text = [valueDict objectForKey:@"DZYJ"];
	_bulletin.telephone.text = [titleDict objectForKey:@"DH"];
	_bulletin.telephoneValue.text = [valueDict objectForKey:@"DH"];
	_bulletin.fax.text = [titleDict objectForKey:@"CZ"];
	_bulletin.faxValue.text = [valueDict objectForKey:@"CZ"];
	
	NSString *text_ss = [valueDict objectForKey:@"SSRQ"];
	NSArray *ary_ss = [text_ss componentsSeparatedByString:@" 00:00:00"];
	if ([ary_ss count] > 0) {
		_bulletin.listingDateValue.text = [ary_ss objectAtIndex:0];
	}else {
		_bulletin.listingDateValue.text = text_ss;
	}

	NSString *text_cl = [valueDict objectForKey:@"CLRQ"];
	NSArray *ary_cl = [text_cl componentsSeparatedByString:@" 00:00:00"];
	if ([ary_cl count] > 0) {
		_bulletin.dateEstablishedValue.text = [ary_cl objectAtIndex:0];
	}else {
		_bulletin.dateEstablishedValue.text = text_cl;
	}

	
	[NSThread detachNewThreadSelector:@selector(changeIndicator:) toTarget:self withObject:[NSNumber numberWithBool:NO]];
	[pool release];
}


- (void)startRotationView {
	[self.view setHidden:NO];
	CGPoint start;
	start = CGPointMake(self.view.frame.origin.x + 40 + self.view.frame.size.width / 2, self.view.frame.origin.y + self.view.frame.size.height + 20);
	
	self.view.center = start;
	//scale rotate and then concat,also with the alpha
	CGAffineTransform scale = CGAffineTransformMakeScale(0.1,0.1);
	CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI/3);
	self.view.transform = CGAffineTransformConcat(scale, rotate);
	self.view.alpha = 0.5;
	
	[UIView beginAnimations:@"circle" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	float ptX = self.view.center.x;
	float ptY = self.view.center.y;
	if (self.rotationInterfaceOrientation == UIInterfaceOrientationPortrait ||
		self.rotationInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.view.center = CGPointMake(ptX+200, ptY-220);
	}
	else {
		self.view.center = CGPointMake(ptX+200, ptY-175);
	}
	
	scale = CGAffineTransformMakeScale(0.5, 0.5);
	rotate = CGAffineTransformMakeRotation(M_PI/6);
	self.view.transform = CGAffineTransformConcat(scale, rotate);
	self.view.alpha = 0.75;
	[UIView commitAnimations];
	[self performSelector:@selector(anotherAnimation) withObject:nil afterDelay:0.2];
}


- (void)anotherAnimation{
	float ptX = self.view.center.x;
	float ptY = self.view.center.y;
	[UIView beginAnimations:@"2circle" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	self.view.transform = CGAffineTransformIdentity;
	if (self.rotationInterfaceOrientation == UIInterfaceOrientationPortrait ||
		self.rotationInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.view.center = CGPointMake(ptX-200, ptY-220);
	}
	else {
		self.view.center = CGPointMake(ptX-200, ptY-120);
	}
	self.view.alpha = 1.0;
	[UIView commitAnimations];
	[NSThread detachNewThreadSelector:@selector(changeIndicator:) toTarget:self withObject:[NSNumber numberWithBool:YES]];
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
