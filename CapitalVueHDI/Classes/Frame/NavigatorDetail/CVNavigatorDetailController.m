    //
//  CVNavigatorDetailController.m
//  CapitalVueHD
//
//  Created by jishen on 9/24/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVNavigatorDetailController.h"

@interface CVNavigatorDetailController()


@property (nonatomic, retain) UIViewController *_navigatorController;
@property (nonatomic, retain) UIViewController *_detailController;

@property (nonatomic, assign) CGSize _navigatorSize;

/*
 * Action responds to tapping buttons or bar items of detail. It is about to
 * show a pop over controller.
 */
- (IBAction)popOverAction:(id)sender;

@end

@implementation CVNavigatorDetailController

@synthesize delegate;

@synthesize viewControllers = _viewControllers;
@synthesize orientation = _orientation;
@synthesize frame = _frame;

@synthesize _popOverController;
@synthesize _navigatorController;
@synthesize _detailController;

@synthesize _navigatorSize;

#define CVNAVIGATION_DETAIL_NAVIGATOR_VIEW_TAG 2011

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
	UIPopoverController *controller = [[UIPopoverController alloc] initWithContentViewController:_navigatorController];
	controller.popoverContentSize = CGSizeMake(300, 600);
	self._popOverController = controller;
	[controller release];
    [super viewDidLoad];
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
	[_popOverController release];
	[_navigatorController release];
	[_detailController release];
	[_viewControllers release];
    [super dealloc];
}

- (void)setViewControllers:(NSMutableArray *)viewControllers {
	CGRect rect;
	
	[_viewControllers release];
	_viewControllers = [viewControllers retain];
	
	self._navigatorController = [_viewControllers objectAtIndex:0];
	rect = CGRectMake(0, 0, 
					  _navigatorController.view.frame.size.width,
					  _navigatorController.view.frame.size.height);
	self._navigatorController.view.frame = rect;
	self._navigatorController.view.tag = CVNAVIGATION_DETAIL_NAVIGATOR_VIEW_TAG;
	self._navigatorSize = rect.size;
	[self.view addSubview:_navigatorController.view];
	
	self._detailController = [_viewControllers objectAtIndex:1];

	if (UIInterfaceOrientationPortrait == _orientation ||
		UIInterfaceOrientationPortraitUpsideDown == _orientation) {
		rect = CGRectMake(0, 0, 
						  _frame.size.width - _navigatorSize.width,
						  _detailController.view.frame.size.height);
		_detailController.view.frame = rect;
	} else {
		rect = CGRectMake(_navigatorSize.width, 0, _frame.size.width, _frame.size.height);
		_detailController.view.frame = rect;
	}
	[self.view addSubview:_detailController.view];
	[self.view bringSubviewToFront:_detailController.view];
	
	// get the buttons in detailController
	UIView *v;
	for (v in _detailController.view.subviews) {
		if ([v isKindOfClass:[UIButton class]]) {
			UIButton *b;
			b = (UIButton *)v;
			if (b.tag == tagButtonShow) {
				[b addTarget:self action:@selector(popOverAction:) forControlEvents:UIControlEventTouchUpInside];
			}
		}
		if ([v isKindOfClass:[UIBarButtonItem class]]) {
			UIBarButtonItem *i;
			i = (UIBarButtonItem *)v;
			if (nil == i.action) {
				i.action = @selector(popOverAction:);
			}
		}
	}
}

- (void)setOrientation:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	_orientation = orientation;
	
	if (UIInterfaceOrientationPortrait == _orientation ||
		UIInterfaceOrientationPortraitUpsideDown == _orientation) {
		// when switch to portrait, remove the navigator view from
		// this main view.
		
		UIView *v = [self.view viewWithTag:CVNAVIGATION_DETAIL_NAVIGATOR_VIEW_TAG];
		if (nil != v) {
			[v removeFromSuperview];
		}
		rect = CGRectMake(0, 0, 
						  _frame.size.width,
						  _frame.size.height);
		_detailController.view.frame = rect;
		[delegate navigatorDetailController:self
					 willHideViewController:_navigatorController
					   forPopoverController:_popOverController];
	} else {
		rect = CGRectMake(0, 0, _navigatorSize.width - 1, _navigatorSize.height - 10);
		_navigatorController.view.frame = rect;
		// when popover has been operated, the navigator view will be rmoved from
		// this main view automatically. So you have to check the existing of navigtor
		// view, and again add it if it is not there.
		UIView *v = [self.view viewWithTag:CVNAVIGATION_DETAIL_NAVIGATOR_VIEW_TAG];
		if (nil == v) {
			[self.view addSubview:_navigatorController.view];
		}
		// popover is not allowed in landscape mode
		[_popOverController dismissPopoverAnimated:NO];
		rect = CGRectMake(_navigatorSize.width, 0,
						  _frame.size.width - _navigatorController.view.frame.size.width,
						  _frame.size.height);
		_detailController.view.frame = rect;
		[delegate navigatorDetailController:self
					 willShowViewController:_navigatorController
					   forPopoverController:_popOverController];
	}
}

- (void)setFrame:(CGRect)frame {
	_frame = frame;
}

- (IBAction)popOverAction:(id)sender {
	UIView *button;
	BOOL isAllowPopover;
	
	button = (UIView *)sender;
	
	isAllowPopover = [delegate navigatorDetailController:self allowPopOverByButton:sender];
	
	// if popover is allowed by delegate, and
	// it is portrait mode, popover will be performed
	if (YES == isAllowPopover && 
		(UIInterfaceOrientationPortrait == _orientation ||
		 UIInterfaceOrientationPortraitUpsideDown == _orientation)) {
		[_popOverController setContentViewController:_navigatorController];
		[delegate navigatorDetailController:self popoverController:_popOverController willPresentViewController:_navigatorController];
		
		[_popOverController presentPopoverFromRect:button.frame
											inView:self.view 
						  permittedArrowDirections:UIPopoverArrowDirectionUp 
										  animated:YES];
	}
}

@end
