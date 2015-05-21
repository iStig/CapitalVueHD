//
//  CVCompositeIndexPortletViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/13/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVMarketViewCoordinates.h"

#import "AFOpenFlowView.h"
#import "CVChartDataCache.h"

@protocol CVCompositeIndexPortletViewDelegate

- (void)didCompositeIndexChanged:(NSDictionary *)compositeIndex;

@end

@interface CVCompositeIndexPortletViewController : UIViewController <AFOpenFlowViewDelegate, AFOpenFlowViewDataSource, CVChartDataCacheDelegate> {
	id<CVCompositeIndexPortletViewDelegate> delegate;
@private
	AFOpenFlowView *_openFlowView;
	UILabel *_currentIndexLabel;
	UIActivityIndicatorView *_activityIndicator;
	/*
	 * an array carries summary of each composite index, of which are 
	 * name, country, colose index, turnover, date, abbreviation,
	 * volume, change, range, index code, latest data date and oldest data date.
	 */
	NSArray *_indexSummaryArray;
	NSDictionary *_indexSummaryKeys;
	
	NSLock*	_loadingViewLock;
	NSMutableDictionary *_indexDict;
	
	NSInteger _currentIndex;
	
	BOOL _valuedData;
	BOOL _hasLoaded;
}

@property (nonatomic, assign) id<CVCompositeIndexPortletViewDelegate> delegate;

- (void)reloadData;
- (void)adjustSubviews:(UIInterfaceOrientation)orientation;

@end
