    //
//  CVPortalViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/2/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortletViewController.h"


@interface CVPortletViewController()

@property (nonatomic, retain) UIPopoverController *_popoverControl;
@property (nonatomic, retain) UIImageView *_imageViewBarLeftEdge;
@property (nonatomic, retain) UIImageView *_imageViewBarRightEdge;
@property (nonatomic, retain) UIImageView *_imageViewBarMiddlePart;

@property (nonatomic, retain) UIImageView *_imageViewContentBottomLeftCorner;
@property (nonatomic, retain) UIImageView *_imageViewContentBottomRightCorner;
@property (nonatomic, retain) UIImageView *_imageViewContentLeftEdge;
@property (nonatomic, retain) UIImageView *_imageViewContentRightEdge;
@property (nonatomic, retain) UIImageView *_imageViewContentBottomEdge;
@property (nonatomic, retain) UIImageView *_imageViewContentFill;

- (void)drawBar;
- (void)drawButton;
- (void)drawContentBackground;

@end

@implementation CVPortletViewController

@synthesize frame;
@synthesize style;
@synthesize portletTitle;
@synthesize menuItems;
@synthesize portalInterfaceOrientation;

@synthesize _popoverControl;
@synthesize _imageViewBarLeftEdge;
@synthesize _imageViewBarRightEdge;
@synthesize _imageViewBarMiddlePart;

@synthesize _imageViewContentBottomLeftCorner;
@synthesize _imageViewContentBottomRightCorner;
@synthesize _imageViewContentLeftEdge;
@synthesize _imageViewContentRightEdge;
@synthesize _imageViewContentBottomEdge;
@synthesize _imageViewContentFill;

#define CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH 9.0

#define CVPORTLET_BAR_TITLE_START_X         15.0
#define CVPORTLET_BAR_TITLE_START_Y         3.0
#define CVPORTLET_BAR_TITLE_START_WIDTH     330.0

#define CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH     20.0
#define CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT    20.0

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
	// set frame of portlet view
	self.view.frame = frame;

	// set bar
	if (CVPortletViewStyleBarVisible == (style & CVPortletViewStyleBarVisible)) {
		[self drawBar];
		[self drawButton];
	}
	[self drawContentBackground];
    [super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
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
	[portletTitle release];
	[menuItems release];
	
	[_popoverControl release];
	[_imageViewBarLeftEdge release];
	[_imageViewBarRightEdge release];
	[_imageViewBarMiddlePart release];
	
	[_imageViewContentBottomLeftCorner release];
	[_imageViewContentBottomRightCorner release];
	[_imageViewContentLeftEdge release];
	[_imageViewContentRightEdge release];
	[_imageViewContentBottomEdge release];
	[_imageViewContentFill release];
	
    [super dealloc];
}
			
#pragma mark private methods
#define LABEL_TAG 2001
- (void)drawBar {
	UIImageView *imageView;
	CGRect imageFrame;
	UIImage *image;
	
	// +--+------------------------+--+
	// |  |                        |  |
	// |1 | 2                      |3 |
	// +--+------------------------+--+
	// 1. left corner of bar
	// 2. middle part of bar, whose width is allowed to be altered.
	// 3. right corner of bar
	
	// show the bar image of left corner
	NSString *path = [[NSBundle mainBundle] pathForResource:@"portlet_bar_left_edge.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:path];
	imageFrame = CGRectMake(0.0, 
							0.0,
							CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH, 
							CVPORTLET_BAR_HEIGHT);
	imageView = [[UIImageView alloc] initWithFrame:imageFrame];
	imageView.image = image;
	[image release];
	imageView.autoresizingMask = UIViewAutoresizingNone;
	self._imageViewBarLeftEdge = imageView;
	[self.view addSubview:_imageViewBarLeftEdge];
	[imageView release];
	
	// show the bar image of middle part
	path = [[NSBundle mainBundle] pathForResource:@"portlet_bar_middle_part.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:path];
	imageFrame = CGRectMake(CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH, 
							0.0, 
							self.view.frame.size.width - (CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH * 2), 
							CVPORTLET_BAR_HEIGHT);
	imageView = [[UIImageView alloc] initWithFrame:imageFrame];
	imageView.image = image;
	[image release];
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self._imageViewBarMiddlePart = imageView;
	[self.view addSubview:_imageViewBarMiddlePart];
	[imageView release];
	
	// show the bar image of right corner
	path = [[NSBundle mainBundle] pathForResource:@"portlet_bar_right_edge.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:path];
	imageFrame = CGRectMake(self.view.frame.size.width - CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH, 
							0.0, 
							CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH, 
							CVPORTLET_BAR_HEIGHT);
	imageView = [[UIImageView alloc] initWithFrame:imageFrame];
	imageView.image = image;
	[image release];
	imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	self._imageViewBarRightEdge = imageView;
	[self.view addSubview:_imageViewBarRightEdge];
	[imageView release];
	
	// add the label
	imageFrame = CGRectMake(CVPORTLET_BAR_TITLE_START_X,
							CVPORTLET_BAR_TITLE_START_Y,
							CVPORTLET_BAR_TITLE_START_WIDTH, 
							CVPORTLET_BAR_HEIGHT - CVPORTLET_BAR_TITLE_START_Y * 2);
	UILabel *label = [[UILabel alloc] initWithFrame:imageFrame];
	label.autoresizingMask = UIViewAutoresizingNone;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:16.0];
	label.textColor = [UIColor whiteColor];
	label.text = portletTitle;
	label.tag = LABEL_TAG;
	[self.view addSubview:label];
	[label release];
}


#define CVPORTLET_BUTTON_RIGHT_SPACE 10.0

- (void)drawButton {
	NSUInteger buttonNum;

	buttonNum = style & (CVPortletViewStyleRefresh | CVPortletViewStyleFullscreen | CVPortletViewStyleSetting | CVPortletViewStyleRestore);
	// figure out how many buttons there are existing on the right of bar
	buttonNum = ((buttonNum & 0x02) >> 1) + ((buttonNum & 0x04) >> 2) + ((buttonNum & 0x08) >> 3) + ((buttonNum &0x40) >> 6);//((buttonNum & 0x64) >> 6);
	
	if (CVPortletViewStyleRefresh == (style & CVPortletViewStyleRefresh)) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_refresh_button.png" ofType:nil];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
		
		button.frame = CGRectMake(self.view.frame.size.width - CVPORTLET_BUTTON_RIGHT_SPACE - CVPORTLET_BUTTON_WIDTH * buttonNum, 
				   (CVPORTLET_BAR_HEIGHT - CVPORTLET_BUTTON_HEIGHT) / 2, 
				   CVPORTLET_BUTTON_WIDTH, 
				   CVPORTLET_BUTTON_HEIGHT);
		[button setImage:image forState:UIControlStateNormal];
		[image release];
		[button addTarget:self action:@selector(clickFresh:) forControlEvents:UIControlEventTouchUpInside];
		button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[self.view addSubview:button];
		buttonNum--;
	}
	
	if (CVPortletViewStyleFullscreen == (style & CVPortletViewStyleFullscreen)) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_fullscreen_button.png" ofType:nil];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
		
		button.frame = CGRectMake(self.view.frame.size.width - CVPORTLET_BUTTON_RIGHT_SPACE - CVPORTLET_BUTTON_WIDTH * buttonNum, 
								  (CVPORTLET_BAR_HEIGHT - CVPORTLET_BUTTON_HEIGHT) / 2, 
								  CVPORTLET_BUTTON_WIDTH, 
								  CVPORTLET_BUTTON_HEIGHT);
		[button setImage:image forState:UIControlStateNormal];
		[image release];
		[button addTarget:self action:@selector(clickFullscreen:) forControlEvents:UIControlEventTouchUpInside];
		button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[self.view addSubview:button];
		buttonNum--;
	}
	
	if (CVPortletViewStyleRestore == (style & CVPortletViewStyleRestore)) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_restore_button.png" ofType:nil];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
		
		button.frame = CGRectMake(self.view.frame.size.width - CVPORTLET_BUTTON_RIGHT_SPACE - CVPORTLET_BUTTON_WIDTH * buttonNum, 
								  (CVPORTLET_BAR_HEIGHT - CVPORTLET_BUTTON_HEIGHT) / 2, 
								  CVPORTLET_BUTTON_WIDTH, 
								  CVPORTLET_BUTTON_HEIGHT);
		[button setImage:image forState:UIControlStateNormal];
		[image release];
		[button addTarget:self action:@selector(clickRestore:) forControlEvents:UIControlEventTouchUpInside];
		button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[self.view addSubview:button];
		buttonNum--;
	}
	
	if (CVPortletViewStyleSetting == (style & CVPortletViewStyleSetting)) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_setting_button.png" ofType:nil];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
		
		button.frame = CGRectMake(self.view.frame.size.width - CVPORTLET_BUTTON_RIGHT_SPACE - CVPORTLET_BUTTON_WIDTH * buttonNum, 
								  (CVPORTLET_BAR_HEIGHT - CVPORTLET_BUTTON_HEIGHT) / 2, 
								  CVPORTLET_BUTTON_WIDTH, 
								  CVPORTLET_BUTTON_HEIGHT);
		[button setImage:image forState:UIControlStateNormal];
		[image release];
		[button addTarget:self action:@selector(clickSetting:) forControlEvents:UIControlEventTouchUpInside];
		button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[self.view addSubview:button];
		buttonNum--;
		
		// Setting button needs to implement the popover menu
		CVMenuController *menuController;
		menuController = [[CVMenuController alloc] init];
		[menuController setDelegate:self];
		menuController.arraySetting = menuItems;
		
		UIPopoverController *controller = [[UIPopoverController alloc] initWithContentViewController:menuController];
		controller.popoverContentSize = CGSizeMake(236, 150);
		controller.delegate = self;
		self._popoverControl = controller;
		[menuController release];
		[controller release];
	}
}

- (void)drawContentBackground {
	UIImage *image;
	UIImageView *imageView;
	CGRect rect;
	CGFloat y;
	
	int i;
	
	i = ((CVPortletViewStyleContentTransparent & style) >> 5);
	i = ((CVPortletViewStyleNone & style) >>1);
	
	if ((0 == ((CVPortletViewStyleContentTransparent & style) >> 5)) &&
		(0 == ((CVPortletViewStyleNone & style) >>1))) {
		// y is the point of content beginning at bottom of bar, if there is.
		// Otherwise it is zero.
		y = CVPORTLET_BAR_HEIGHT * ((style & CVPortletViewStyleBarVisible) >> 4);
		
		// left edge
		rect = CGRectMake(0, 
						  y, 
						  CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  self.view.frame.size.height - y - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		imageView = [[UIImageView alloc] initWithFrame:rect];
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_content_left_edge.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		imageView.image = image;
		[image release];
		self._imageViewContentLeftEdge = imageView;
		[self.view addSubview:_imageViewContentLeftEdge];
		[imageView release];
		
		// content fill
		rect = CGRectMake(CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  y, 
						  self.view.frame.size.width - CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH * 2,
						  self.view.frame.size.height - y - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		imageView = [[UIImageView alloc] initWithFrame:rect];
		pathx = [[NSBundle mainBundle] pathForResource:@"portlet_content_fill.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		imageView.image = image;
		[image release];
		self._imageViewContentFill = imageView;
		[self.view addSubview:_imageViewContentFill];
		[imageView release];
		
		// right edge
		rect = CGRectMake(self.view.frame.size.width - CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  y, 
						  CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH,
						  self.view.frame.size.height - y - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		imageView = [[UIImageView alloc] initWithFrame:rect];
		pathx = [[NSBundle mainBundle] pathForResource:@"portlet_content_right_edge.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		imageView.image = image;
		[image release];
		self._imageViewContentRightEdge = imageView;
		[self.view addSubview:_imageViewContentRightEdge];
		[imageView release];
		
		// bottom-left corner
		rect = CGRectMake(0, 
						  self.view.frame.size.height - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT, 
						  CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH,
						  CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		imageView = [[UIImageView alloc] initWithFrame:rect];
		pathx = [[NSBundle mainBundle] pathForResource:@"portlet_content_bottomleft_corner.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		imageView.image = image;
		[image release];
		self._imageViewContentBottomLeftCorner = imageView;
		[self.view addSubview:_imageViewContentBottomLeftCorner];
		[imageView release];
		
		// bottom edge
		rect = CGRectMake(CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  self.view.frame.size.height - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT, 
						  self.view.frame.size.width - CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH * 2,
						  CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		imageView = [[UIImageView alloc] initWithFrame:rect];
		pathx = [[NSBundle mainBundle] pathForResource:@"portlet_content_bottom_edge.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		imageView.image = image;
		[image release];
		self._imageViewContentBottomEdge = imageView;
		[self.view addSubview:_imageViewContentBottomEdge];
		[imageView release];
		
		// bottom-right corner
		rect = CGRectMake(self.view.frame.size.width - CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  self.view.frame.size.height - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT, 
						  CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH,
						  CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		imageView = [[UIImageView alloc] initWithFrame:rect];
		pathx = [[NSBundle mainBundle] pathForResource:@"portlet_content_bottomright_corner.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		imageView.image = image;
		[image release];
		self._imageViewContentBottomRightCorner = imageView;
		[self.view addSubview:_imageViewContentBottomRightCorner];
		[imageView release];
	}
}

#pragma mark public methods

- (void)setPortletTitle:(NSString *)t {
	UILabel *label;
	label = (UILabel *)[self.view viewWithTag:LABEL_TAG];
	label.text = t;
}

- (NSString *)getPortletTitle {
	UILabel *label;
	label = (UILabel *)[self.view viewWithTag:LABEL_TAG];
	return label.text;
}


- (void)setDelegate:(id)delegate{
	refreshDelegate = delegate;
}
/*
 * It responds to the touch-up-inside against refresh button
 *
 * @param: sender - an instance of refresh button 
 * @return: none
 */
- (IBAction)clickFresh:(id)sender {
	// customization
	if (refreshDelegate) {
		[refreshDelegate clickRefreshButton];
	}
}

/*
 * It responds to the touch-up-inside against fullscreen button
 *
 * @param: sender - an instance of fullscreen button 
 * @return: none
 */
- (IBAction)clickFullscreen:(id)sender {
	// customization
//	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//	[dict setObject:[NSNumber numberWithInt:0] forKey:@"Number"];
//	[[NSNotificationCenter defaultCenter]
//	 postNotificationName:@"CVPortalSwitchPortalSetNotification" object:dict];
//	[dict release];
}

/*
 * It responds to the touch-up-inside against fullscreen button
 *
 * @param: sender - an instance of fullscreen button 
 * @return: none
 */
- (IBAction)clickRestore:(id)sender {
	// customization
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[NSNumber numberWithInt:0] forKey:@"Number"];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"CVPortalSwitchPortalSetNotification" object:dict];
	[dict release];
}


/*
 * It responds to the touch-up-inside against setting button
 *
 * @param: sender - an instance of setting button 
 * @return: none
 */
- (IBAction)clickSetting:(id)sender {
	UIButton *button = (UIButton *)sender;
	[_popoverControl presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

/*
 * It processes the customized action, when the item of menu is tapped.
 * The developer has to implement this method, if he/she would like to
 * use the style of setting.
 *
 * @param: indexPath - An index path locating the new selected row in menu.
 * @return: none
 */
- (void)actionMenuItemAtIndexPath:(NSIndexPath *)indexPath {
	// customization
}

/*
 * It allows to do any changes after the menu dismissed.
 */
- (void)actionMenuDidDismiss {
	// customization
}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	CGRect rect;
	CGFloat y;
	
	if (0 != (CVPortletViewStyleBarVisible & style)) {
		// show the bar image of left corner
		_imageViewBarLeftEdge.frame = CGRectMake(0.0, 
								0.0,
								CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH, 
								CVPORTLET_BAR_HEIGHT);
		
		// show the bar image of middle part
		_imageViewBarMiddlePart.frame = CGRectMake(CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH, 
								0.0, 
								self.view.frame.size.width - (CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH * 2), 
								CVPORTLET_BAR_HEIGHT);
		
		// show the bar image of right corner
		_imageViewBarRightEdge.frame = CGRectMake(self.view.frame.size.width - CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH, 
								0.0, 
								CVPORTLET_BAR_CIRCULAR_CORNER_WIDTH, 
								CVPORTLET_BAR_HEIGHT);
	}
	
	if (0 == (CVPortletViewStyleContentTransparent & style)) {
		// y is the point of content beginning at bottom of bar, if there is.
		// Otherwise it is zero.
		y = CVPORTLET_BAR_HEIGHT * ((style & CVPortletViewStyleBarVisible) >> 4);
		
		// right edge
		rect = CGRectMake(0, 
						  y, 
						  CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  self.view.frame.size.height - y - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		_imageViewContentLeftEdge.frame = rect;
		
		// content fill
		rect = CGRectMake(CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  y, 
						  self.view.frame.size.width - CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH * 2,
						  self.view.frame.size.height - y - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		_imageViewContentFill.frame = rect;
		
		// right edge
		rect = CGRectMake(self.view.frame.size.width - CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  y, 
						  CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH,
						  self.view.frame.size.height - y - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		_imageViewContentRightEdge.frame = rect;
		
		// bottom-left corner
		rect = CGRectMake(0, 
						  self.view.frame.size.height - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT, 
						  CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH,
						  CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		_imageViewContentBottomLeftCorner.frame = rect;
		
		// bottom edge
		rect = CGRectMake(CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  self.view.frame.size.height - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT, 
						  self.view.frame.size.width - CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH * 2,
						  CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		_imageViewContentBottomEdge.frame = rect;
		
		// bottom-right corner
		rect = CGRectMake(self.view.frame.size.width - CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH, 
						  self.view.frame.size.height - CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT, 
						  CVPORTLET_CONTENT_BOTTOM_CORNER_WIDTH,
						  CVPORTLET_CONTENT_BOTTOM_CORNER_HEIGHT);
		_imageViewContentBottomRightCorner.frame = rect;
	}
	[self._popoverControl dismissPopoverAnimated:YES];
}

- (void)reloadData {
}

#pragma mark CVMenuControllerDelegate
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self actionMenuItemAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[self actionMenuDidDismiss];
}

@end
