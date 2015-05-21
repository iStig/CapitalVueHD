//
//  CVStockInTheNewsPortletViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/6/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVPortletViewController.h"
#import "CVScrollPageViewController.h"

@interface CVStockInTheNewsPortletViewController : CVPortletViewController <CVScrollPageViewDeleage> {
@private
	NSArray *stockList;
	NSMutableArray *controllersCache;
	CVScrollPageViewController *scrollPageViewController;
	UIActivityIndicatorView *activityIndicator;
	UILabel *lbl;
	BOOL _ifLoaded;
	BOOL isNeedRefresh;
	
	BOOL _isNewToken;
}

@property (nonatomic,assign)BOOL isNeedRefresh;
-(void)reloadData;

@end
