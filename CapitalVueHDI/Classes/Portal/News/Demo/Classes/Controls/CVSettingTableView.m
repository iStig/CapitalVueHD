    //
//  CVSettingTableView.m
//  CapitalValDemo
//
//  Created by leon on 10-8-7.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
/*
 Create Setting module,when click setting button,
 it will be created
 */

#import "CVSettingTableView.h"


@implementation CVSettingTableView
@synthesize tableControllerSetting = _tableControllerSetting;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

//init Setting Module‘s frame,and add TableView to this view
- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		UIImageView *imgbackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 269.0, 229.0)];
		UIImage *img = [UIImage imageNamed:@"settingview_background.png"];
		imgbackground.image = img;
		[self addSubview:imgbackground];
		[imgbackground release];
		
		_tableControllerSetting = [[CVSettingTableController alloc] init];
		_tableControllerSetting.view.frame = CGRectMake(6.0, 24.0, 257.0, 199.0);
		[self addSubview:_tableControllerSetting.view];
	}
	return self;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	[_tableControllerSetting release];
    [super dealloc];
}


@end
