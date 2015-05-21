    //
//  CVInAppPurchaseViewController.m
//  CapitalVueHD
//
//  Created by jishen on 12/13/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVInAppPurchaseViewController.h"

@interface CVInAppPurchaseViewController()

@property (nonatomic, retain) MKStoreManager *_storeManager;
@property (nonatomic, retain) NSString *_serviceID;

@end

@implementation CVInAppPurchaseViewController

@synthesize _storeManager;
@synthesize _serviceID;

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
	
	self._storeManager = [MKStoreManager sharedManager];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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
	[_storeManager release];
	[_serviceID release];
    [super dealloc];
}

- (IBAction)buyServiceLevel1:(id)sender {
	NSDictionary *objInfo;
	
	objInfo = [[NSDictionary alloc] initWithObjects:@"level1", @"service", nil];
	[_storeManager buyFeature:_serviceID];
	[objInfo release];
}

- (IBAction)buyServiceLevel2:(id)sender {
	NSDictionary *objInfo;
	
	objInfo = [[NSDictionary alloc] initWithObjects:@"level2", @"service", nil];
	[_storeManager buyFeature:_serviceID];
	[objInfo release];	
}

@end
