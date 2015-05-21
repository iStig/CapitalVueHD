    //
//  CVPortalSetIndustryController.m
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortalSetIndustryController.h"

#import "CVDataProvider.h"

@interface CVPortalSetIndustryController()

- (CGRect) sectorStatisticsFrame:(UIInterfaceOrientation)orientation;
- (CGRect) sectorGainerLoserFrame:(UIInterfaceOrientation)orientation;

@end

@implementation CVPortalSetIndustryController

@synthesize statisticsController;
@synthesize vcGainerLoser;
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
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [super viewDidLoad];

	CVSectorStatisticsPortletViewController *staCtrl;
	CVSectorGainerLoserPortletViewController *gainerloserCtrl;
	
	staCtrl = [[CVSectorStatisticsPortletViewController alloc] init];
	staCtrl.view.frame = [self sectorStatisticsFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	staCtrl.portalInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	gainerloserCtrl = [[CVSectorGainerLoserPortletViewController alloc] init];
	gainerloserCtrl.frame = [self sectorGainerLoserFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	gainerloserCtrl.portalInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	self.vcGainerLoser = gainerloserCtrl;
	self.statisticsController = staCtrl;
	[self.view addSubview:statisticsController.view];
	[self.view addSubview:vcGainerLoser.view];
	
	[staCtrl release];
	[gainerloserCtrl release];
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
	[statisticsController release];
    [super dealloc];
}

- (CGRect) sectorStatisticsFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVPORTLET_SECTOR_STATISTICS_PORTRAIT_X,
						  CVPORTLET_SECTOR_STATISTICS_PORTRAIT_Y,
						  CVPORTLET_SECTOR_STATISTICS_PORTRAIT_WIDTH,
						  CVPORTLET_SECTOR_STATISTICS_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVPORTLET_SECTOR_STATISTICS_LANDSCAPE_X,
						  CVPORTLET_SECTOR_STATISTICS_LANDSCAPE_Y,
						  CVPORTLET_SECTOR_STATISTICS_LANDSCAPE_WIDTH,
						  CVPORTLET_SECTOR_STATISTICS_LANDSCAPE_HEIGHT);
	}
	return rect;
}

							 
- (CGRect) sectorGainerLoserFrame:(UIInterfaceOrientation)orientation
{
	CGRect rect;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_X,
						  CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_Y,
						  CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_WIDTH,
						  CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_X,
						  CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_Y,
						  CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_WIDTH,
						  CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_HEIGHT);
	}
	return rect;
}

#pragma mark -
#pragma mark Overriden
/*
 * It adjust the views postion in accordance to the device orientation.
 *
 * @param: orientation - The orientation of the application’s user interface
 * @return: none
 */
- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	statisticsController.view.frame = [self sectorStatisticsFrame:orientation];
	[statisticsController adjustSubviews:orientation];
	vcGainerLoser.view.frame = [self sectorGainerLoserFrame:orientation];
	[vcGainerLoser adjustSubviews:orientation];
}

- (void)reloadData {
	[statisticsController reloadData];
	[vcGainerLoser reloadData];
}

@end
