    //
//  CVPortalViewController.m
//  CapitalVueHD
//
//  Created by jishen on 8/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortalViewController.h"

#import "CVPortalButton.h"

#import "CVAboutViewController.h"

#import "CVPortalSetHomeController.h"
#import "CVPortalSetMarketController.h"
#import "CVPortalSetMacroController.h"
#import "CVPortalSetIndustryController.h"
#import "CVPortalSetMyStockController.h"
#import "CVPortalSetNewsController.h"

#import "CVDataProvider.h"
#import "CVLocalizationSetting.h"
#import "CVSetting.h"
#import "NoConnectionAlert.h"

@interface CVPortalViewController()

@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) UIImage *imageButtonNormal;
@property (nonatomic, retain) UIImage *imageButtonHighlight;

@property (nonatomic, retain) CVPortalPortalSetManager *portalSetManager;
@property (nonatomic, retain) NSArray *_equityCodesArray;

@property (nonatomic, retain) CVAboutViewController *_aboutController;

/*
 * It responds to the tapping by finger.
 *
 * @param: sender - the object who recevies the touch event
 * @return: none
 */
- (IBAction)buttonClicked:(id)sender;

/*
 * It responds to the notification, and shows the specified portal sert.
 *
 * @param: notification - it encapsulates information by sender
 * @return: none
 */
- (void)switchPortalSet:(NSNotification *)notification;

/*
 * It returns the origin point and size of search bar in accordance with
 * the device orientation.
 *
 * @param: orientation - device orientation
 * @return: rectangle frame size
 */
- (CGRect)searchBarFrame:(UIInterfaceOrientation)orientation;

/*
 * It loads the all the codes of equity
 *
 * @param:	none
 * @return:	none
 */
- (void)loadData;

/*
 * It will schedule for clear expire cache
 *
 */
-(void)backGroundRemoveCache;

@end

@implementation CVPortalViewController

@synthesize imageBarRightEdge;
@synthesize imageBarLeftEdge;
@synthesize imageBarMiddlePortion;
@synthesize imageBarLogo;

@synthesize logoButton;
@synthesize _aboutController;

@synthesize searchEquityBar;

@synthesize imageButtonNormal;
@synthesize imageButtonHighlight;
@synthesize buttonArray;

@synthesize portalSetManager;

@synthesize _equityCodesArray;

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

#define CVPORTAL_BUTTON_WIDTH 72.0
#define CVPORTAL_BUTTON_HEIGHT 27.0
#define CVPORTAL_BUTTON_GAP 4.0

- (void)viewDidLoad {
	//self.view.layer.cornerRadius = 8;
	//self.view.layer.masksToBounds = YES;
    [super viewDidLoad];
	
	[self backGroundRemoveCache];

//	[NSTimer scheduledTimerWithTimeInterval:2400 target:self selector:@selector(backGroundRemoveCache) userInfo:nil repeats:YES];
	
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	
	searchEquityBar.placeholder = [langSetting localizedString:@"Ticker"];
	
	// initialize button images for normal status and highlight status
	UIImage *image;
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portal_button_normal.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	self.imageButtonNormal = image;
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"portal_button_highlight.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	self.imageButtonHighlight = image; 
	[image release];
	// initialzie instance of CVProtalButton
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:CVPortalSetTypeMax];
	CVPortalButton *button;
	UIView *buttonGroup;
	CGRect buttonGroupFrame;
	int i;
	CGFloat x;
	
	// x coordinate of start point of the first right button
	x = (self.view.frame.size.width - CVPORTAL_BUTTON_WIDTH * CVPortalSetTypeMax) / 2;
	// the rectangle size for the 'CVPortalSetTypeMax' buttons.
	buttonGroupFrame = CGRectMake(x, 8, 
								  CVPORTAL_BUTTON_WIDTH * CVPortalSetTypeMax + CVPORTAL_BUTTON_GAP * (CVPortalSetTypeMax - 1), 
								  CVPORTAL_BUTTON_WIDTH);
	// A view used for grouping all the buttons together in order to automatically resize the gap
	// between buttons.
	buttonGroup = [[UIView alloc] initWithFrame:buttonGroupFrame];
	buttonGroup.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	// create buttons and maitain them by an array
	NSArray *titles = [langSetting getTabBarTitles];
	for (i = CVPortalSetTypeHome; i < CVPortalSetTypeMax; i++) {
		button = [CVPortalButton buttonWithType:UIButtonTypeCustom];
		NSString *t = [titles objectAtIndex:i];
		[button setBackgroundImage:imageButtonNormal forState:UIControlStateNormal];
		[button setTitle:t forState:UIControlStateNormal];
		[button.titleLabel setFont:[UIFont systemFontOfSize:13]];
		[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		button.frame = CGRectMake(i * (CVPORTAL_BUTTON_WIDTH + CVPORTAL_BUTTON_GAP), 0, CVPORTAL_BUTTON_WIDTH, CVPORTAL_BUTTON_HEIGHT);
		button.portalset = i;
		button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		[array addObject:button];
	}
	self.buttonArray = array;
	[array release];
	
	// add the buttons to the grouped view
	for (button in buttonArray) {
		[buttonGroup addSubview:button];
	}
	[self.view addSubview:buttonGroup];
	[buttonGroup release];
	
	// create portal set manager
	CVPortalPortalSetManager *manager = [[CVPortalPortalSetManager alloc] init];
	self.portalSetManager = manager;
	[manager release];
	
	// initialize search result table
	_searchResultController = [[CVSearchDisplayController alloc] init];
	[_searchResultController.view setFrame:CGRectMake(0, 0, 275, 320)];
	[_searchResultController setDelegate:self];
	
	
	popoverController = [[UIPopoverController alloc] initWithContentViewController:_searchResultController];
	popoverController.popoverContentSize = CGSizeMake(275, 320);
	
	// initialize the 
	CVAboutViewController *anAboutController;
	anAboutController =[[CVAboutViewController alloc] init];
	self._aboutController = anAboutController;
	[anAboutController release];
	
	// register an object in observer center to receive a notification 
	// which asks to swith portal set
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(switchPortalSet:)
												 name:CVPortalSwitchPortalSetNotification object:nil];
	
	//
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[NSNumber numberWithInt:CVPortalSetTypeHome] forKey:@"Number"];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict/*[NSNumber numberWithInt:CVPortalSetTypeHome]*/];
	[dict release];
	
	[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	searchEquityBar.frame = [self searchBarFrame:toInterfaceOrientation];
	
	CVPortalSetType type;
	
	for (type = CVPortalSetTypeHome; type < CVPortalSetTypeMax; type++) {
		CVPortalSetHomeController *controller;
		controller = [portalSetManager getPortalSet:type];
		if (nil != controller) {
			[controller adjustSubviews:toInterfaceOrientation];
		}
	}
	[popoverController dismissPopoverAnimated:YES];
}

/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	UIInterfaceOrientation toInterfaceOrientation;
	
	toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	searchEquityBar.frame = [self searchBarFrame:toInterfaceOrientation];
	
	CVPortalSetType type;
	
	for (type = CVPortalSetTypeHome; type < CVPortalSetTypeMax; type++) {
		CVPortalSetHomeController *controller;
		controller = [portalSetManager getPortalSet:type];
		if (nil != controller) {
			[controller adjustSubviews:toInterfaceOrientation];
		}
	}
}
*/

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
	[imageBarRightEdge release];
	[imageBarLeftEdge release];
	[imageBarMiddlePortion release];
	[imageBarLogo release];
	
	[searchEquityBar release];
	[logoButton release];
	[_aboutController release];
	
	[imageButtonNormal release];
	[imageButtonHighlight release];
	[buttonArray release];
	
	[portalSetManager release];
	
	[_equityCodesArray release];
	
	[_searchResultController release];
	[popoverController release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark private method

/*
 * It responds to the tapping by finger.
 *
 * @param: sender - the object who recevies the touch event
 * @return: none
 */
- (IBAction)buttonClicked:(id)sender {
	CVPortalButton *element, *button;
	
	button = (CVPortalButton *)sender;
	//[button setImage:imageButtonHighlight forState:UIControlStateNormal];
	[button setBackgroundImage:imageButtonHighlight forState:UIControlStateNormal];

	for (element in buttonArray) {
		if (element.portalset != button.portalset) {
			//[element setImage:imageButtonNormal forState:UIControlStateNormal];
			[element setBackgroundImage:imageButtonNormal forState:UIControlStateNormal];
		}
	}
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[NSNumber numberWithInt:button.portalset] forKey:@"Number"];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict/*[NSNumber numberWithInt:button.portalset]*/];
	[dict release];
}

static BOOL isFirstTime = YES;
/*
 * It responds to the notification, and shows the specified portal sert.
 *
 * @param: notification - it encapsulates information by sender
 * @return: none
 */
- (void)switchPortalSet:(NSNotification *)notification {
	NSNumber *obj;
	CVPortalSetType type;
	CVPortalSetController *portalSet;
	
	NSMutableDictionary *dict;
	dict = (NSMutableDictionary *)[notification object];
	obj = [dict valueForKey:@"Number"];
	type = [obj intValue];
	
	CVPortalButton *element, *button;
	
	for (element in buttonArray) {
		[element setBackgroundImage:imageButtonNormal forState:UIControlStateNormal];
	}
	button = [buttonArray objectAtIndex:type];
	[button setBackgroundImage:imageButtonHighlight forState:UIControlStateNormal];
	
	switch (type) {
		case CVPortalSetTypeHome:
		{
			CVPortalSetHomeController *controller;
			controller = [portalSetManager getPortalSet:type];
			if (nil == controller) {
				controller = [[CVPortalSetHomeController alloc] init];
				controller.portalInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
				[portalSetManager setPortalSet:controller type:type];
				[controller release];
			}
			portalSet = controller;
			break;
		}
			
		case CVPortalSetTypeMarket:
		{
			CVPortalSetMarketController *controller;
			controller = [portalSetManager getPortalSet:type];
			if (nil == controller) {
				controller = [[CVPortalSetMarketController alloc] init];
				controller.portalInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
				[portalSetManager setPortalSet:controller type:type];
				[controller release];
			}
			portalSet = controller;
			break;
		}
		case CVPortalSetTypeIndustrial:
		{
			CVPortalSetIndustryController *controller;
			controller = [portalSetManager getPortalSet:type];
			if (nil == controller) {
				controller = [[CVPortalSetIndustryController alloc] init];
				[portalSetManager setPortalSet:controller type:type];
				[controller release];
			}
			portalSet = controller;
			break;
		}
		case CVPortalSetTypeMacro:
		{
			CVPortalSetMacroController *controller;
			controller = [portalSetManager getPortalSet:type];
			if (nil == controller) {
				controller = [[CVPortalSetMacroController alloc] init];
				[portalSetManager setPortalSet:controller type:type];
				[controller release];
			}
			portalSet = controller;
			break;
		}
		case CVPortalSetTypeMyStock:
		{
			CVPortalSetMyStockController *controller;
			controller = [portalSetManager getPortalSet:type];
			
			if (nil == controller) {
				controller = [[CVPortalSetMyStockController alloc] init];
				[portalSetManager setPortalSet:controller type:type];
				[controller release];
			}
			NSString *code = [dict valueForKey:@"code"];
			if (code) {
				[NSObject cancelPreviousPerformRequestsWithTarget:controller];
				[controller performSelector:@selector(updateStockDetailFromHome:) withObject:dict afterDelay:0.5];
				isFirstTime = NO;
			} else if (YES == isFirstTime) {
				//Number = 5;
				//code = 000002;
				//isEquity = 1;
				// FIXME: the following codes are executed at the first time when the my-stock-button is tapped
				CVSetting *setting = [CVSetting sharedInstance];
				NSString *lanCode = [setting cvLanguage];
				NSString *sseName;
				if ([lanCode isEqualToString:@"cn"]) {
					sseName = @"上证指数";
				} else {
					sseName = @"SSE Composite";
				}
				
				NSDictionary *defaultCode;
				defaultCode = [[NSDictionary alloc] initWithObjectsAndKeys:@"000001", @"code",
							   [NSNumber numberWithBool:NO], @"isEquity", sseName, @"name", nil];
				[controller performSelector:@selector(updateStockDetailFromHome:) withObject:defaultCode afterDelay:0.5];
				[defaultCode release];
				isFirstTime = NO;
			}

			portalSet = controller;
			break;
		}
		case CVPortalSetTypeNews:
		{
			CVPortalSetNewsController *controller;
			controller = [portalSetManager getPortalSet:type];
			if (nil == controller) {
				controller = [[CVPortalSetNewsController alloc] init];
				controller.portalInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
				[portalSetManager setPortalSet:controller type:type];
				controller.isLoadByHome = NO;
				[controller release];
			}
			NSDictionary *dictNews = [dict valueForKey:@"dictContent"];
			if ([dictNews count]>0) {
				controller.isLoadByHome = YES;
				[self performSelector:@selector(updateNewsfromHome:) withObject:dictNews afterDelay:0.2];
			}
			portalSet = controller;
			break;
		}
		default:
			break;
	}
	
	if (currentPortalSet != portalSet) {
		if (nil != currentPortalSet) {
			[currentPortalSet.view removeFromSuperview];
		}
		currentPortalSet = portalSet;
		[self.view addSubview:currentPortalSet.view];
		[currentPortalSet reloadData];
	}
	[self performSelector:@selector(dismissRotationNotification) withObject:nil afterDelay:0.3];
}

- (void)dismissRotationNotification{
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalDismissRotationViewNotification object:nil];
}

- (void)updateNewsfromHome:(NSDictionary *)dict{
	if ([currentPortalSet isKindOfClass:[CVPortalSetNewsController class]]) {
		[currentPortalSet performSelector:@selector(updateNewsfromHome:) withObject:dict];
	}
	
}

/*
 * It returns the origin point and size of search bar in accordance with
 * the device orientation.
 *
 * @param: orientation - device orientation
 * @return: rectangle frame size
 */
- (CGRect)searchBarFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(625, 0, 135, 44);
	} else {
		rect = CGRectMake(800, 0, 200, 44);
	}
	
	return rect;
}

/*
 * It loads the all the codes of equity
 *
 * @param:	none
 * @return:	none
 */
- (void)loadData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = 15;
	dict = [dp GetStockList:CVDataProviderStockListTypeAll withParams:paramInfo];
	[paramInfo release];
	
	self._equityCodesArray = [dict objectForKey:@"data"];
	
	[pool release];
}

/*
 * It will schedule for clear expire cache
 *
 */
-(void)backGroundRemoveCache{
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		return;
	}
	NSLog(@"begin check expire cache files");
	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *ary = [manager contentsOfDirectoryAtPath:docPath error:NULL];
	if (!ary) {
		NSLog(@"find cache path error");
		return;
	}
	for (NSObject *obj in ary) {
		NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
		NSString *filename = [[NSString alloc] initWithFormat:@"%@",obj];
		if ([filename hasPrefix:@"cache"]) {
			NSString *realFileName = [[NSString alloc] initWithFormat:@"%@/%@",docPath,filename];
			NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:realFileName];
			
			if (dict) {
				NSDate *cacheDate = [dict objectForKey:@"date created"];
				NSNumber *nLifeCycle = [dict objectForKey:@"lifecycle"];
				
				if (cacheDate && nLifeCycle) {
					//check 
					NSTimeInterval cacheTimeInterval = [cacheDate timeIntervalSince1970];
					
					NSDate *currentDate = [NSDate date];
					NSTimeInterval currentTimeInterval = [currentDate timeIntervalSince1970];
					
					NSInteger iLifeCycle = [nLifeCycle intValue] * 60;
					if ((currentTimeInterval - cacheTimeInterval) > iLifeCycle){
						if (![manager removeItemAtPath:realFileName error:NULL]) {
							NSLog(@"back remove expire cache file error");
						}else {
							NSLog(@"remove expire cache file : %@",filename);
						}
						
					}
				}
			}
			
			[dict release];
			[realFileName release];
		}
		[filename release];
		[pool2 release];
	}
}

/*
 * It returns the frame of portalset of News in accrodance with the device orientation.
 * @param: orientation - the orientation of device
 * @return: coordinates and size of portlet
 * leon added 09/15/2010
 */

- (CGRect)setNewsPortalFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(16, 72, CVPORTAL_SETNEWS_PORTRAIT_WIDTH, CVPORTAL_SETNEWS_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(16, 72, CVPORTAL_SETNEWS_LANDSCAPE_WIDTH, CVPORTAL_SETNEWS_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

#pragma mark -
#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[popoverController dismissPopoverAnimated:YES];
	NSString *code;
	unichar firstChar;
	
	[self.searchEquityBar resignFirstResponder];
	
	code = nil;
	// start to query sqlite to get the code
	firstChar = [searchBar.text characterAtIndex:0];
	if ((firstChar > 'A' && firstChar < 'Z') ||
		(firstChar > 'a' && firstChar < 'z')) {
		NSDictionary *dict;
		
		for (dict in _equityCodesArray) {
			if ([searchBar.text isEqualToString:[dict objectForKey:@"GPJCPY"]]) {
				code = [dict objectForKey:@"GPDM"];
				break;
			}
		}
	} else {
		code = searchBar.text;
		for (unsigned i; i < [code length]; i++) {
			firstChar = [searchBar.text characterAtIndex:i];
			if (firstChar > '9' || firstChar < '0') {
				code = nil;
				break;
			}
		}
	}
	
	if ([_searchResultController.displayList count] <= 0) {
		return;
	}
	
	BOOL isFind = NO;
	for (int i = 0; i < [_searchResultController.displayList count]; i ++) {
		NSDictionary *dict = [_searchResultController.displayList objectAtIndex:i];
		if ([searchEquityBar.text isEqualToString:[dict valueForKey:@"GPDM"]]) {
			isFind = YES;
		}
	}
	if (isFind == NO) {
		return;
	}
	
	if (code) {
		NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
		[dict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
		[dict setObject:code forKey:@"code"];
		[dict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
		[self performSelector:@selector(sendStockCode:) withObject:dict afterDelay:0.1];
	}
}

- (void) sendStockCode:(NSMutableDictionary *)dict
{
	isFirstTime = NO;
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
}

- (void)selectedSearchItem:(NSString *)code{
	CVSetting *s = [CVSetting sharedInstance];
	if (![s isReachable]){
		[self.searchEquityBar resignFirstResponder];
		[searchEquityBar setText:code];
		[popoverController dismissPopoverAnimated:YES];
		[NoConnectionAlert alert];
		return;
	}
	
	[self.searchEquityBar resignFirstResponder];
	[searchEquityBar setText:code];
	[popoverController dismissPopoverAnimated:YES];
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
	[dict setObject:code forKey:@"code"];
	[dict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
	[self performSelector:@selector(sendStockCode:) withObject:dict afterDelay:0.1];
	
	NSString *symbol = @"￥";
	if(code)
	{
		if([code intValue]!=0)
		{
			int iHead = [code intValue]/100000;
			if(iHead==2)
			{
				symbol = @"HK$";
			}
			else if (iHead==9){
				symbol = @"$";
			}
			else
				symbol = @"￥";
		}
	}
	NSMutableDictionary *symbolDict = [[NSMutableDictionary alloc] init];
	[symbolDict setObject:symbol forKey:@"symbol"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMoneySymbol" object:nil userInfo:[symbolDict autorelease]];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	NSString *code;
	unichar firstChar;
	
	[self.searchEquityBar resignFirstResponder];
	
	code = nil;
	// start to query sqlite to get the code
	if (nil == searchBar.text) {
		firstChar = [searchBar.text characterAtIndex:0];
		if ((firstChar > 'A' && firstChar < 'Z') ||
			(firstChar > 'a' && firstChar < 'z')) {
			NSDictionary *dict;
		
			for (dict in _equityCodesArray) {
				if ([searchBar.text isEqualToString:[dict objectForKey:@"GPJCPY"]]) {
					code = [dict objectForKey:@"GPDM"];
					break;
				}
			}
		} else {
			code = searchBar.text;
			for (unsigned i=0; i < [code length]; i++) {
				firstChar = [searchBar.text characterAtIndex:i];
				if (firstChar > '9' || firstChar < '0') {
					for (NSDictionary *dict in _equityCodesArray) {
						if ([searchBar.text isEqualToString:[dict objectForKey:@"GPJC"]]) {
							code = [dict objectForKey:@"GPDM"];
							break;
						}
					}
				}
			}
		}
	
		if (code) {
			NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
			[dict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
			[[NSNotificationCenter defaultCenter]
			 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
			[dict setObject:code forKey:@"code"];
			[dict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
			[self performSelector:@selector(sendStockCode:) withObject:dict afterDelay:0.1];
		}
	}
	
	
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	if ([searchText length] == 0) {
		[popoverController dismissPopoverAnimated:YES];
	}
	else {
		[popoverController presentPopoverFromRect:searchEquityBar.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		[_searchResultController setCode:searchText];
	}
}


- (IBAction)logoButtonTapped:(id)sender {
	if (_aboutController) {
		[self presentModalViewController:_aboutController animated:NO];
	}
}

- (void) showSplash
{
	UIViewController *modalViewController = [[UIViewController alloc] init];
	
	CGRect splashFrame;
	NSString *imgName;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationLandscapeLeft==orientation
		|| UIInterfaceOrientationLandscapeRight==orientation)
	{
		splashFrame = CGRectMake(0, 0, 1024, 748);
		imgName = @"Default-Landscape.png";
	}
	else
	{
		splashFrame = CGRectMake(0, 0, 768, 1004);
		imgName = @"Default-Portrait.png";
	}
		
	
	modalView = [[UIView alloc] initWithFrame:splashFrame];
	modalView.backgroundColor = [UIColor blackColor];
	
	modalViewController.view = modalView;
	
	[self presentModalViewController:modalViewController animated:NO];
	
	[self performSelector:@selector(hideSplash) withObject:nil afterDelay:2.0];
}

- (void) hideSplash
{
	[[self modalViewController] dismissModalViewControllerAnimated:YES];
}
@end
