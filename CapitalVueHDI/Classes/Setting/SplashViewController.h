//
//  SplashViewController.h
//  CapitalVueHD
//
//  Created by Dream on 10-11-2.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"
#import "UIImage+Alpha.h"
#import "UIImage+RoundedCorner.h"

#define SplashLandscapeX			403.
#define SplashLandscapeY			555.
#define SplashLandscapeWidth		218.
#define SplashLandscapeHeight		12.

#define SplashPortraitX				301.
#define SplashPortraitY				800.
#define SplashPortraitWidth			164.
#define SplashPortraitHeight		12.

#define LoadingHome		0
#define LoadingMarket	1
#define LoadingIndustry 2
@class CVPortalViewController;
@class CVDataProvider;

@interface SplashViewController : UIViewController {
	UIImageView *imgvBar;
	UIImageView *imgvBarBack;
	UIImageView *imgvBackground;
	
	CGRect portraitFrame;
	CGRect landscapeFrame;
	BOOL homeLoaded,marketLoaded,industryLoaded;
	NSUInteger currentLoading;
	NSInteger animationCount;
	float duration;
	NSDictionary *dict;
	CVDataProvider *dp;
	
	BOOL defaultAnimated,homeAnimated,marketAnimated,industryAnimated;
	

	NSUInteger leftCount;
	UILabel *lblLoading;
	NSDictionary *labels;
	
	NSTimer *labelTimer;
	
}
@property(nonatomic, retain)UIImageView *imgvBar;


- (void) updateOrientation:(UIInterfaceOrientation)orientation;




@end
