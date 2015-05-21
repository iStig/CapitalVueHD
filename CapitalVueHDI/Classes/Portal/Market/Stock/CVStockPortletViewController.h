//
//  CVStockPortletViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/14/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVMarketViewCoordinates.h"
#import "CVStockTopMarketCapital.h"
#import "CVPortletViewController.h"
#import "CVScrollPageViewController.h"

@interface CVStockPortletViewController : CVPortletViewController <CVScrollPageViewDeleage> {

@private
	NSDictionary *_dataDict;
	CVScrollPageViewController *_scrollPageController;
	UIActivityIndicatorView *_activityIndicator;
	NSString *currentCode;
	NSArray *_ordinalNumberArray; 
	NSMutableArray *_viewArray;
	
	NSArray *_stockInfoArray;
	
	UILabel *lbl;
	BOOL _ifLoaded;
	BOOL _valuedData;
}
- (NSString *)stringWithB:(NSString *)str;
- (void) codeChanged:(NSNotification *)notification;
-(void)waitForCoverFlowLoading:(NSNotification *)notification;
@end
