    //
//  CVPortalPanelController.m
//  CapitalValDemo
//
//  Created by leon on 10-8-4.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
/*
Portlet模块，带蓝色工具栏，工具栏上有Title，Refresh/Restore/Fullscreen
 Setting Button,按钮可以选择性显示或者不显示，工具栏可显示或者隐藏，Portlet
 模块能重用
 */

#import "CVPortletView.h"
#import "CVSettingTableController.h"
#import "CVSettingTableView.h"

@implementation CVPortletView
@synthesize labelTitle = _labelTitle;
@synthesize imageBackground = _imageBackground;
@synthesize buttonRefresh = _buttonRefresh;
@synthesize buttonRestore = _buttonRestore;
@synthesize buttonFullscreen = _buttonFullscreen;
@synthesize buttonSetting = _buttonSetting;
@synthesize popoverSetting = _popoverSetting;
@synthesize settingTableView = _settingTableView;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		//self.frame = [[UIScreen mainScreen] applicationFrame];
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

//点击状态栏按钮时，响应事件
-(IBAction) clickRefreshButton:(id)sender{
	NSLog(@"a click");
}

-(IBAction) clickFullscreenButton:(id)sender{
	//NSLog(@"b click");
	
	self.frame = [[UIScreen mainScreen] applicationFrame];
	[self didSpreadToFullScreen];
}

- (void)didSpreadToFullScreen
{
	//do nothing in base class
}

- (void)didSpreadToRestoreScreen{
	//do nothing in base class
}

-(IBAction) clickSettingButton:(id)sender{
	CGRect frame = _buttonSetting.frame;
	_settingTableView = [[CVSettingTableView alloc] initWithFrame:CGRectMake(/*248.0*/frame.origin.x-215, /*40.0*/frame.origin.y+25, 269.0, 229.0)];
	[self addSubview:_settingTableView];
	//[view release];
}

-(IBAction) clickRestoreButton:(id)sender{
	
	[self didSpreadToRestoreScreen];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (_settingTableView) {
		[_settingTableView removeFromSuperview];
		[_settingTableView release];
		_settingTableView = nil;
	}
}

- (void)dealloc {
	[_labelTitle release];
	[_imageBackground release];
	[_buttonRefresh release];
	[_buttonRestore release];
	[_buttonFullscreen release];
	[_buttonSetting release];
	[_popoverSetting release];
	if (_settingTableView) {
		[_settingTableView release];
	}
    [super dealloc];
}


@end
