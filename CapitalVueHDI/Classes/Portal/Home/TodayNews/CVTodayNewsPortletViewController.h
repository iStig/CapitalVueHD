//
//  CVTodayNewsPortletViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/5/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVPortletViewController.h"
#import "CVScrollPageViewController.h"
#import "CVMenuController.h"

@interface CVTodayNewsPortletViewController : CVPortletViewController <CVScrollPageViewDeleage, CVMenuControllerDelegate> {
@private
	CVScrollPageViewController *pageViewController;
	NSMutableArray *arrayTodayNews;
	
	UIActivityIndicatorView	*activityIndicator;
	NSString *_lastToken;
	
	UILabel *lbl;
	
	BOOL _ifLoaded;
	
	BOOL _isNewToken;
}

-(void)reloadData;

@end
