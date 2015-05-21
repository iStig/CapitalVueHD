//
//  CVFinancialSummaryPortletViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVPortletViewController.h"
#import "CVFinancialSummary.h"

#import "CVFinancialSummaryIndexViewController.h"

@interface CVFinancialSummaryPortletViewController : CVPortletViewController {
@private
	UIImageView *imageViewBackground;
	UIImage *imagePortraitBackground;
	UIImage *imageLandscapeBackground;
	NSMutableArray *arrayControllers;
	
	CVFinancialSummaryIndexViewController *compositeIndexController;
	
	// FIXME: buttons should be replaced by segment controller
	UIButton *equityButton;
	UIButton *fundButton;
	UIButton *bondButton;
	
	UIImageView *imageViewTabLine1;
	UIImageView *imageViewTabLine2;
	
	UIImageView *line1;
	UIImageView *line2;
	
	CVFinancialSummaryType _currentSummary;
}

@end
