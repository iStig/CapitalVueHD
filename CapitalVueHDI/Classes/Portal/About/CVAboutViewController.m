    //
//  CVAboutViewController.m
//  CapitalVueHD
//
//  Created by jishen on 12/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVAboutViewController.h"
#import "CVAboutBulletinController.h"

@interface CVAboutViewController ()

@property (nonatomic, retain) UINavigationController *_navgationController;
@property (nonatomic, retain) CVAboutBulletinController *_aboutBullinController;

@end

@implementation CVAboutViewController

@synthesize _navgationController;
@synthesize _aboutBullinController;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
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
	self.view.backgroundColor = [UIColor clearColor];
	self.view.autoresizesSubviews = NO;
	
	CVAboutBulletinController *aBulletin;
	aBulletin = [[CVAboutBulletinController alloc] initWithNibName:@"CVAboutBulltinViewController" bundle:nil];
	aBulletin.delegate = self;
	self._aboutBullinController = aBulletin;
	[aBulletin release];
	
	UINavigationController *aNavController;
	aNavController = [[UINavigationController alloc] initWithRootViewController:_aboutBullinController];
	aNavController.view.backgroundColor = [UIColor whiteColor];
	aNavController.view.autoresizesSubviews = NO;
	aNavController.navigationBar.barStyle = UIBarStyleBlack;
	self._navgationController = aNavController;
	[aNavController release];
	
	[self.view addSubview:aNavController.view];
	if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation] ||
		UIInterfaceOrientationPortraitUpsideDown == [[UIApplication sharedApplication] statusBarOrientation]) {
		self.view.frame = CGRectMake(0, 0, 768, 1004);
		_navgationController.view.frame = CGRectMake(0, 0, 768, 1004);
	} else {
		self.view.frame = CGRectMake(128, 0, 768, 748);
		_navgationController.view.frame = CGRectMake(128, 0, 768, 748);
	}
	_aboutBullinController.orientation = [[UIApplication sharedApplication] statusBarOrientation];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if (UIInterfaceOrientationPortrait == toInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == toInterfaceOrientation) {
		self.view.frame = CGRectMake(0, 0, 768, 1004);
		_navgationController.view.frame = CGRectMake(0, 0, 768, 1004);
	} else {
		self.view.frame = CGRectMake(128, 0, 768, 748);
		_navgationController.view.frame = CGRectMake(128, 0, 768, 748);
	}
	_aboutBullinController.orientation = toInterfaceOrientation;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_navgationController release];
	[_aboutBullinController release];
    [super dealloc];
}

#pragma mark -
#pragma mark CVAboutBulletinControllerDelegate
- (void)didTapDoneButton {
	[self dismissModalViewControllerAnimated:NO];
}

@end
