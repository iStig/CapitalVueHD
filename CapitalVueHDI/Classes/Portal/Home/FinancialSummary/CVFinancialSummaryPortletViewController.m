    //
//  CVFinancialSummaryPortletViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVFinancialSummaryPortletViewController.h"

#import "CVSetting.h"
#import "CVDataProvider.h"

#import "CVFinancialSummaryIndicesViewController.h"
#import "CVFinancialSummaryTopMovingSecurityViewController.h"

@interface CVFinancialSummaryPortletViewController()

@property (nonatomic, retain) UIImageView *imageViewBackground;
@property (nonatomic, retain) UIImage *imagePortraitBackground;
@property (nonatomic, retain) UIImage *imageLandscapeBackground;
@property (nonatomic, retain) NSMutableArray *arrayControllers;
@property (nonatomic, retain) CVFinancialSummaryIndexViewController *compositeIndexController;
@property (nonatomic, retain) UIButton *equityButton;
@property (nonatomic, retain) UIButton *fundButton;
@property (nonatomic, retain) UIButton *bondButton;

- (void)loadControllers:(NSNumber *)typeNumber;
- (CGRect)indiceFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the frame size of composite index form in accordance with
 * the device orientation.
 *
 * @param:	orientation - the device orientation
 * @return:	CGRect-typed value indicating the origin and size
 */
- (CGRect)compositeIndexFrame:(UIInterfaceOrientation)orientation;
- (CGRect)topMovingFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the frame size of background
 *
 * @param:	orientation - the device orientation
 * @return:	CGRect-typed value indicating the origin and size
 */
- (CGRect)imageBackgroundFrame:(UIInterfaceOrientation)orientation;

- (IBAction)actionClickButton:(id)sender;

@end

@implementation CVFinancialSummaryPortletViewController

@synthesize imageViewBackground;
@synthesize imagePortraitBackground;
@synthesize imageLandscapeBackground;
@synthesize arrayControllers;
@synthesize compositeIndexController;
@synthesize equityButton;
@synthesize fundButton;
@synthesize bondButton;

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
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self.style = CVPortletViewStyleBarVisible | CVPortletViewStyleContentTransparent;
    [super viewDidLoad];
	
	
	// add backgournd image
	UIImage *image;
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"finance_summary_portrait_background.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	self.imagePortraitBackground = image;
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"finance_summary_landscape_background.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	self.imageLandscapeBackground = image;
	[image release];
	
	UIImageView *imageView;
	imageView = [[UIImageView alloc] init];
	self.imageViewBackground = imageView;
	imageViewBackground.frame = [self imageBackgroundFrame:self.portalInterfaceOrientation];
	[imageView release];
	
	[self.view addSubview:imageViewBackground];
	
	// add three buttons for euqity, fund and bond
	UIButton *button;
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, 246, CVPORTLET_BAR_HEIGHT);
	button.tag = 1;
	[button setTitle:[langSetting localizedString:@"Equity"] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
	[button addTarget:self action:@selector(actionClickButton:) forControlEvents:UIControlEventTouchUpInside];
	self.equityButton = button;
	[self.view addSubview:equityButton];
	
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(246, 0, 246, CVPORTLET_BAR_HEIGHT);
	button.tag = 2;
	[button setTitle:[langSetting localizedString:@"Fund"] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
	pathx = [[NSBundle mainBundle] pathForResource:@"home_fund_highlight_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	[button addTarget:self action:@selector(actionClickButton:) forControlEvents:UIControlEventTouchUpInside];
	self.fundButton = button;
	[self.view addSubview:fundButton];
	
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(492, 0, 246, CVPORTLET_BAR_HEIGHT);
	button.tag = 3;
	[button setTitle:[langSetting localizedString:@"Bond"] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
	pathx = [[NSBundle mainBundle] pathForResource:@"home_bond_highlight_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	[button addTarget:self action:@selector(actionClickButton:) forControlEvents:UIControlEventTouchUpInside];
	self.bondButton = button;
	[self.view addSubview:bondButton];
	
	imageViewTabLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(246, 0, 1, 46)];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_home_tab_line.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	imageViewTabLine1.image = image;
	[image release];
	[self.view addSubview:imageViewTabLine1];
	
	imageViewTabLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(492, 0, 1, 46)];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_home_tab_line.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	imageViewTabLine2.image = image;
	[image release];
	[self.view addSubview:imageViewTabLine2];

	
	NSMutableArray *controllers;
	
	controllers = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < 3; i++) {
		[controllers addObject:[NSNull null]];
    }
    self.arrayControllers = controllers;
    [controllers release];
	
	// initially load summary of enquity
	_currentSummary = CVFinancialSummaryTypeEquity;
	
	[self loadControllers:[NSNumber numberWithInt:_currentSummary]];
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
	[imageViewBackground release];
	[imagePortraitBackground release];
	[imageLandscapeBackground release];
	[arrayControllers release];
	[imageViewTabLine1 release];
	[imageViewTabLine2 release];
	[line1 release];
	[line2 release];
    [super dealloc];
}

#pragma mark -
#pragma mark private methods

- (void)loadControllers:(NSNumber *)typeNumber {
	CVFinancialSummaryType type = [typeNumber intValue];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSMutableDictionary *controllers;
	CVFinancialSummaryIndicesViewController *indiceController;
	CVFinancialSummaryIndexViewController *indexController;
	CVFinancialSummaryTopMovingSecurityViewController *topMovingController;
	
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	
	if (type < CVFinancialSummaryTypeInvalid) {
		controllers = [arrayControllers objectAtIndex:type];
		// replace the placeholder if necessary
		if ([NSNull null] == (NSNull *)controllers) {			
			controllers = [[NSMutableDictionary alloc] initWithCapacity:1];
			
			// create controller for indice
			indiceController = [[CVFinancialSummaryIndicesViewController alloc] init];
			indiceController.indicesType = type;
			if (CVFinancialSummaryTypeEquity == type) {
				indiceController.symbol = [langSetting localizedString:@"SSE Equity Index"];
				indiceController.code = @"000001";
			} else if (CVFinancialSummaryTypeFund == type) {
				indiceController.symbol = [langSetting localizedString:@"SSE Fund Index"];
				indiceController.code = @"000011";
			} else {
				indiceController.symbol = [langSetting localizedString:@"SSE Bond Index"];
				indiceController.code = @"000012";
			}

			[controllers setObject:indiceController forKey:@"indice"];
			[indiceController release];
			
			// create controller for equity/fund/bond index
			indexController = [[CVFinancialSummaryIndexViewController alloc] init];
			indexController.indexType = type;
			[controllers setObject:indexController forKey:@"index"];
			[indexController release];
			
			// create controller for top moving securities
			topMovingController = [[CVFinancialSummaryTopMovingSecurityViewController alloc] init];
			topMovingController.topMovingType = type;
			topMovingController.portalInterfaceOrientation = portalInterfaceOrientation;
			topMovingController.view.autoresizingMask = UIViewAutoresizingNone;
			topMovingController.view.autoresizesSubviews = NO;
			[controllers setObject:topMovingController forKey:@"topmoving"];
			[topMovingController release];
			
			// put the dicitionary into the placehold
			[arrayControllers replaceObjectAtIndex:type withObject:controllers];
			[controllers release];
			
			
			CVSetting *s;
			s = [CVSetting sharedInstance];
			
			if (CVFinancialSummaryTypeEquity == type) {
				[dp setDataIdentifier:@"FinancialSummaryEquity" lifecycle:[s cvCachedDataLifecycle:CVSettingHomeFinancialSummary]];
			} else if (CVFinancialSummaryTypeBond == type) {
				[dp setDataIdentifier:@"FinancialSummaryBond" lifecycle:[s cvCachedDataLifecycle:CVSettingHomeFinancialSummary]];
			} else if (CVFinancialSummaryTypeFund == type) {
				[dp setDataIdentifier:@"FinancialSummaryFund" lifecycle:[s cvCachedDataLifecycle:CVSettingHomeFinancialSummary]];
			}
		} else {
			controllers = [arrayControllers objectAtIndex:type];
		}

		
		// add indice view
		indiceController = [controllers objectForKey:@"indice"];
		if (nil == indiceController.view.superview) {
			indiceController.view.frame = [self indiceFrame:portalInterfaceOrientation];
			indiceController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[self.view addSubview:indiceController.view];
		}
		
		// add index view
		indexController = [controllers objectForKey:@"index"];
		if (nil == indexController.view.superview) {
			indexController.view.frame = [self compositeIndexFrame:portalInterfaceOrientation];
			indexController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[self.view addSubview:indexController.view];
		}
		
		// add top securities view
		topMovingController = [controllers objectForKey:@"topmoving"];
		if (nil == topMovingController.view.superview) {
			topMovingController.view.frame = [self topMovingFrame:portalInterfaceOrientation];
			topMovingController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[self.view addSubview:topMovingController.view];
		}
	}
	
	[pool release];
}

- (CGRect)indiceFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(10, 43, 363, 163);
	} else {
		rect = CGRectMake(10, 43, 440, 185);
	}
	
	return rect;
}

/*
 * It return the frame size of composite index form in accordance with
 * the device orientation.
 *
 * @param:	orientation - the device orientation
 * @return:	none
 */
- (CGRect)compositeIndexFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(20, 206, 
						  PORTLET_FINANCE_SUMMARY_COMPOSIT_PORTRAIT_WIDTH,
						  PORTLET_FINANCE_SUMMARY_COMPOSIT_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(20, 238, 
						  PORTLET_FINANCE_SUMMARY_COMPOSIT_LANDSCAPE_WIDTH,
						  PORTLET_FINANCE_SUMMARY_COMPOSIT_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

- (CGRect)topMovingFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(384, 60, CVPORTLET_TOP_MOVING_PORTRAIT_WIDTH, CVPORTLET_TOP_MOVING_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(20, 410, CVPORTLET_TOP_MOVING_LANDSCAPE_WIDTH, CVPORTLET_TOP_MOVING_LANDSCAPE_HEIGHT);
	}
	return rect;
}

/*
 * It returns the frame size of background
 *
 * @param:	orientation - the device orientation
 * @return:	CGRect-typed value indicating the origin and size
 */
- (CGRect)imageBackgroundFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {		
		rect = CGRectMake(0, CVPORTLET_BAR_HEIGHT, 739, 267);
		imageViewBackground.image = imagePortraitBackground;
	} else {
		rect = CGRectMake(0, CVPORTLET_BAR_HEIGHT, 462, 608);
		imageViewBackground.image = imageLandscapeBackground;
	}
	
	return rect;
}

- (IBAction)actionClickButton:(id)sender {
	UIButton *button = (UIButton *)sender;
	NSMutableDictionary *controllers;
	CVFinancialSummaryIndicesViewController *indiceController;
	CVFinancialSummaryTopMovingSecurityViewController *topMovingController;
	CVFinancialSummaryIndexViewController *indexController;
	
	CVFinancialSummaryType type;
	if (button == equityButton) {
		type = CVFinancialSummaryTypeEquity;
		[equityButton setBackgroundImage:nil forState:UIControlStateNormal];
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"home_fund_highlight_button.png" ofType:nil];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[fundButton setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
		pathx = [[NSBundle mainBundle] pathForResource:@"home_bond_highlight_button.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[bondButton setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
	} else if (button == fundButton) {
		type = CVFinancialSummaryTypeFund;
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"home_Equity_highlight_button.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		[equityButton setBackgroundImage:imgx forState:UIControlStateNormal];
		[imgx release];
		[fundButton setBackgroundImage:nil forState:UIControlStateNormal];
		pathx = [[NSBundle mainBundle] pathForResource:@"home_bond_highlight_button.png" ofType:nil];
		imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		[bondButton setBackgroundImage:imgx forState:UIControlStateNormal];
		[imgx release];
	} else if (button == bondButton) {
		type = CVFinancialSummaryTypeBond;
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"home_Equity_highlight_button.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		[equityButton setBackgroundImage:imgx forState:UIControlStateNormal];
		[imgx release];
		pathx = [[NSBundle mainBundle] pathForResource:@"home_fund_highlight_button.png" ofType:nil];
		imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		[fundButton setBackgroundImage:imgx forState:UIControlStateNormal];
		[imgx release];
		[bondButton setBackgroundImage:nil forState:UIControlStateNormal];
	}
	
	for (unsigned int i = CVFinancialSummaryTypeEquity; i < CVFinancialSummaryTypeInvalid; i++) {
		controllers = [arrayControllers objectAtIndex:i];
		if (i == type) {
//			[NSThread detachNewThreadSelector:@selector(loadControllers:) toTarget:self withObject:[NSNumber numberWithInt:type]];
			[self loadControllers:[NSNumber numberWithInt:type]];
		}else {
			if ([NSNull null] != (NSNull *)controllers) {
				indiceController = [controllers objectForKey:@"indice"];
				topMovingController = [controllers objectForKey:@"topmoving"];
				indexController = [controllers objectForKey:@"index"];
				
				[indiceController.view removeFromSuperview];
				[topMovingController.view removeFromSuperview];
				[indexController.view removeFromSuperview];
			}
		}
	}
	
	_currentSummary = type;
	
	[self reloadData];
}

#pragma mark -
#pragma mark Override
-(void)adjustSubviews:(UIInterfaceOrientation)orientation {
	imageViewBackground.frame = [self imageBackgroundFrame:orientation];
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		// roate buttons
		equityButton.frame = CGRectMake(0, 0, 246, CVPORTLET_BAR_HEIGHT);
		fundButton.frame = CGRectMake(246, 0, 246, CVPORTLET_BAR_HEIGHT);
		bondButton.frame = CGRectMake(492, 0, 246, CVPORTLET_BAR_HEIGHT);
		imageViewTabLine1.frame = CGRectMake(246, 1, 1, 46);
		imageViewTabLine2.frame = CGRectMake(492, 1, 1, 46);
	} else {
		// roate buttons
		equityButton.frame = CGRectMake(0, 0, 154, CVPORTLET_BAR_HEIGHT);
		fundButton.frame = CGRectMake(154, 0, 154, CVPORTLET_BAR_HEIGHT);
		bondButton.frame = CGRectMake(308, 0, 154, CVPORTLET_BAR_HEIGHT);
		imageViewTabLine1.frame = CGRectMake(154, 1, 1, 46);
		imageViewTabLine2.frame = CGRectMake(308, 1, 1, 46);
	}
	
	compositeIndexController.view.frame = [self compositeIndexFrame:orientation];
	[compositeIndexController adjustSubviews:orientation];
	
	NSDictionary *controllers;
	unsigned int i;
	for (i = CVFinancialSummaryTypeEquity; i < CVFinancialSummaryTypeInvalid; i++) {
		CVFinancialSummaryIndicesViewController *indiceController;
		CVFinancialSummaryTopMovingSecurityViewController *topMovingController;
		CVFinancialSummaryIndexViewController *indexController;
		
		controllers = [arrayControllers objectAtIndex:i];
		if ([NSNull null] != (NSNull *)controllers) {
			indiceController = [controllers objectForKey:@"indice"];
			topMovingController = [controllers objectForKey:@"topmoving"];
			indexController = [controllers objectForKey:@"index"];
			
			indiceController.view.frame = [self indiceFrame:orientation];
			[indiceController adjustChartView:orientation];
			topMovingController.view.frame = [self topMovingFrame:orientation];
			[topMovingController adjustFormView:orientation];
			indexController.view.frame = [self compositeIndexFrame:orientation];
			[indexController adjustSubviews:orientation];
		}
	}
}

- (void)reloadData {
	CVDataProvider *dp;
	NSDictionary *controllers;
	CVFinancialSummaryIndicesViewController *indiceController;
	CVFinancialSummaryTopMovingSecurityViewController *topMovingController;
	CVFinancialSummaryIndexViewController *indexController;
	
	
	BOOL isIndiceNeedReload = NO;
	BOOL isIndexNeedReload = NO;
	BOOL isTopMovingNeedReload = NO;
	
	dp = [CVDataProvider sharedInstance];
	
	controllers = [arrayControllers objectAtIndex:_currentSummary];
	
	indiceController = [controllers objectForKey:@"indice"];
	topMovingController = [controllers objectForKey:@"topmoving"];
	indexController = [controllers objectForKey:@"index"];
	
	if (CVFinancialSummaryTypeEquity == _currentSummary) {
		if ([dp isDataExpired:@"FinancialSummaryEquity"]) {
			isIndiceNeedReload = YES;
			isIndexNeedReload = YES;
			isTopMovingNeedReload = YES;
		} else {
			if (!indiceController.valuedData) {
				isIndiceNeedReload = YES;
			}
			if (!indexController.valuedData) {
				isIndexNeedReload = YES;
			}
			if (!topMovingController.valuedData) {
				isTopMovingNeedReload = YES;
			}
		}
	} else if (CVFinancialSummaryTypeBond == _currentSummary) {
		if ([dp isDataExpired:@"FinancialSummaryBond"]) {
			isIndiceNeedReload = YES;
			isIndexNeedReload = YES;
			isTopMovingNeedReload = YES;
		} else {
			if (!indiceController.valuedData) {
				isIndiceNeedReload = YES;
			}
			if (!indexController.valuedData) {
				isIndexNeedReload = YES;
			}
			if (!topMovingController.valuedData) {
				isTopMovingNeedReload = YES;
			}
		}
	} else if (CVFinancialSummaryTypeFund == _currentSummary) {
		if ([dp isDataExpired:@"FinancialSummaryFund"]) {
			isIndiceNeedReload = YES;
			isIndexNeedReload = YES;
			isTopMovingNeedReload = YES;
		} else {
			if (!indiceController.valuedData) {
				isIndiceNeedReload = YES;
			}
			if (!indexController.valuedData) {
				isIndexNeedReload = YES;
			}
			if (!topMovingController.valuedData) {
				isTopMovingNeedReload = YES;
			}
		}
	}
	
	if (isIndiceNeedReload) {
		[indiceController reloadData];
	}
	if (isIndexNeedReload) {
		[indexController reloadData];
	}
	if (isTopMovingNeedReload) {
		[topMovingController reloadData];
	}
}

@end
