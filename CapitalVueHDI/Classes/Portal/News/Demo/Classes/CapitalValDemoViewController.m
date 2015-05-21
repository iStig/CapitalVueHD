//
//  CapitalValDemoViewController.m
//  CapitalValDemo
//
//  Created by leon on 10-7-30.
//  Copyright SmilingMobile 2010. All rights reserved.
//
//  窗口主界面，mainbroad,放置Portal

#import "CapitalValDemoViewController.h" 
#import "CVPortletView.h"
#import "CVTodaysNewsview.h"

@implementation CapitalValDemoViewController
@synthesize imageBackground = _imageBackground;

//@synthesize  m_todaysnewsportraitcontroller;
//@synthesize  m_todaysnewslandscapecontroller;
@synthesize  todaysnewsview = _todaysnewsview;

//创建Today's News模块，有横屏和竖屏俩种模式
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_todaysnewsview = [[CVTodaysNewsView alloc] initWithFrame:CGRectMake(16.0f, 33.0f, 742.0f, 294.0f)];
	[_todaysnewsview didSpreadToFullScreen];
	[self.view addSubview:_todaysnewsview];
	
	UIImage *img = [UIImage imageNamed:@"portrait_background.png"];
	_imageBackground.image = img;

    [super viewDidLoad];
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

//重力感应，切换背景图片和视图
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	UIInterfaceOrientation toOrientation = self.interfaceOrientation;
	if (toOrientation == UIInterfaceOrientationPortrait
		|| toOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		UIImage *img = [UIImage imageNamed:@"portrait_background.png"];
		_imageBackground.image = img;
		_todaysnewsview.frame = CGRectMake(16.0f, 72.0f, 742.0f, 294.0f);
	}
	else {
		UIImage *img = [UIImage imageNamed:@"landscape_background.png"];
		_imageBackground.image = img;
		_todaysnewsview.frame = CGRectMake(16.0f, 72.0f, 501.0f, 362.0f);
	}
	[_todaysnewsview updateOrientation];

}

- (void)changeViewMode{
	NSLog(@"a");
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_imageBackground release];
	[_todaysnewsview release];
	//[m_todaysnewsportraitcontroller release];
	//[m_todaysnewslandscapecontroller release];
    [super dealloc];
}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[self willAnimateRotationToInterfaceOrientation:orientation duration:0];

}
@end
