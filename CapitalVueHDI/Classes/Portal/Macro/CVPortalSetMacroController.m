    //
//  CVPortalSetMacroController.m
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortalSetMacroController.h"

#import "CVPortalSetMacroCoordinates.h"

#import "CVMacroNavigatorViewController.h"
#import "CVMacroDetailViewController.h"

#import "CVDataProvider.h"
#import "CVSetting.h"

@interface CVPortalSetMacroController()

// the navigator-detail frame
@property (nonatomic, retain) CVNavigatorDetailController *_navigationDetailController;

@property (nonatomic, retain) CVMacroNavigatorViewController *_macroNavigatorViewController;
@property (nonatomic, retain) CVMacroDetailViewController *_detailViewController;

/*
 * It returns the rectangle size of navigation-detail frame in accordance with
 * the device orientation.
 *
 * @param:	orientation - device orientation
 * @return:	origin point and size of frame
 */
- (CGRect)navigationDetailFrame:(UIInterfaceOrientation)orientation;

@end

@implementation CVPortalSetMacroController

@synthesize _navigationDetailController,_detailViewController,_macroNavigatorViewController;

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
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [super viewDidLoad];
	
	// create navigator-detail frame
	CVNavigatorDetailController *aController;
	aController = [[CVNavigatorDetailController alloc] init];
	aController.frame = [self navigationDetailFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	
	CVMacroNavigatorViewController *aNavigator;
	aNavigator = [[CVMacroNavigatorViewController alloc] init];
	aNavigator.frame = CGRectMake(0, 0, CVMACRO_NAVIGATOR_LANDSCAPE_WIDTH, CVMACRO_NAVIGATOR_LANDSCAPE_HEIGHT);
	
	CVMacroDetailViewController *aDetail;
	aDetail = [[CVMacroDetailViewController alloc] init];
	aDetail.frame = CGRectMake(0, 0, CVMACRO_NAVIGATOR_LANDSCAPE_WIDTH, CVMACRO_NAVIGATOR_LANDSCAPE_HEIGHT);
	aNavigator.delegate = aDetail;
	

	NSArray *array;
	array = [[NSArray alloc] initWithObjects:aNavigator, aDetail, nil];
	aController.viewControllers = array;
	[array release];
	aNavigator.parent = aController._popOverController;
	aController.orientation = [[UIApplication sharedApplication] statusBarOrientation];
	aController.delegate = aDetail;
	aController.view.frame = [self navigationDetailFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	self._navigationDetailController = aController;

	[aController release];
	
	[self.view addSubview:_navigationDetailController.view];
	
	
	CVSetting *setting = [CVSetting sharedInstance];
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	[dp setDataIdentifier:@"getMacroData" lifecycle:[setting cvCachedDataLifecycle:CVSettingMacro]];
	
	NSArray *arrayD = [langSetting getMacroNaviItems];
	NSDictionary *groupDictD = [arrayD objectAtIndex:0];
	NSArray *itemsD = [groupDictD objectForKey:@"items"];
	NSDictionary *itemDictD = [itemsD objectAtIndex:0];
	[self adjustSubviews:[[UIApplication sharedApplication] statusBarOrientation]];
	[aNavigator.delegate didReceiveNavigatorRequest:[groupDictD objectForKey:@"group"] forItem:itemDictD indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	
	self._detailViewController = aDetail;
	self._macroNavigatorViewController = aNavigator;
	
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
	[_navigationDetailController release];
	[_macroNavigatorViewController release];
	[_detailViewController release];
    [super dealloc];
}

#pragma mark -
#pragma mark private method
/*
 * It returns the rectangle size of navigation-detail frame in accordance with
 * the device orientation.
 *
 * @param:	orientation - device orientation
 * @return:	origin point and size of frame
 */
- (CGRect)navigationDetailFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVMACRO_NAVIGATOR_DETAIL_PORTRAIT_X, 
						  CVMACRO_NAVIGATOR_DETAIL_PORTRAIT_Y, 
						  CVMACRO_NAVIGATOR_DETAIL_PORTRAIT_WIDTH, 
						  CVMACRO_NAVIGATOR_DETAIL_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVMACRO_NAVIGATOR_DETAIL_LANDSCAPE_X, 
						  CVMACRO_NAVIGATOR_DETAIL_LANDSCAPE_Y, 
						  CVMACRO_NAVIGATOR_DETAIL_LANDSCAPE_WIDTH, 
						  CVMACRO_NAVIGATOR_DETAIL_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	_navigationDetailController.frame = [self navigationDetailFrame:orientation];
	_navigationDetailController.orientation = orientation;
}

- (void)reloadData{
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	CVSetting *setting = [CVSetting sharedInstance];
	BOOL isNeedReload = NO;
	if (!_detailViewController.valuedData) {
		if (![setting isReachable]) {
			return;
		} else {
			isNeedReload = YES;
		}
	} else {
		if ([dp isDataExpired:@"getMacroData"]) {
			isNeedReload = YES;
		}
	}
	if (isNeedReload) {
		[self._macroNavigatorViewController reloadCurrentItem];
	}
}

@end
