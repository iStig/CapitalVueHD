    //
//  CVPortalSetController.m
//  CapitalVueHD
//
//  Created by jishen on 9/14/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortalSetController.h"

#import "CVPortal.h"

@interface CVPortalSetController()

- (CGRect)portalSetFrame:(UIInterfaceOrientation)orientation;

@end

@implementation CVPortalSetController

@synthesize portalInterfaceOrientation;

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
	self.view.frame = [self portalSetFrame:[[UIApplication sharedApplication] statusBarOrientation]];
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

/*
 * It adjust the views postion in accordance to the device orientation.
 *
 * @param: orientation - The orientation of the application’s user interface
 * @return: none
 */
- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	self.view.frame = [self portalSetFrame:orientation];
}

#pragma mark -
#pragma mark private method
- (CGRect)portalSetFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(0, CVPORTAL_PANEL_BAR, 768, 1024 - CVPORTAL_PANEL_BAR);
	} else {
		rect = CGRectMake(0, CVPORTAL_PANEL_BAR, 1024, 768 - CVPORTAL_PANEL_BAR);
	}
	
	return rect;
}

- (void)reloadData {
}

@end
