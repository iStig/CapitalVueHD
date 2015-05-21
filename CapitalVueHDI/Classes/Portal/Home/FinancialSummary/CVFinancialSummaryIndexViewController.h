//
//  CVFinancialSummaryIndexViewController.h
//  CapitalVueHD
//
//  Created by ANNA on 10-8-29.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVFinancialSummaryCompositeIndexFormView.h"
#import "CVFinancialSummary.h"

#define PORTLET_FINANCE_SUMMARY_COMPOSIT_PORTRAIT_WIDTH   330
#define PORTLET_FINANCE_SUMMARY_COMPOSIT_PORTRAIT_HEIGHT  97

#define PORTLET_FINANCE_SUMMARY_COMPOSIT_LANDSCAPE_WIDTH  430
#define PORTLET_FINANCE_SUMMARY_COMPOSIT_LANDSCAPE_HEIGHT 158


@interface CVFinancialSummaryIndexViewController : UIViewController <CVFormViewDelegate>
{
	CVFinancialSummaryType indexType;
@private
	
	UIImageView *_line1;
	UIImageView *_line2;
	
	CVFinancialSummaryCompositeIndexFormView *_macroView;
	
	NSArray *_compositeArray;
	NSMutableArray *_headArray;
	NSMutableArray *_dataArray;
	BOOL _isEmptyData;
	BOOL _ifLoaded;
	BOOL _valuedData;
	
	UIActivityIndicatorView *_indicator;
}

@property (nonatomic, assign) CVFinancialSummaryType indexType;
@property (nonatomic, assign) BOOL valuedData;

- (void)adjustSubviews:(UIInterfaceOrientation)orientation;
- (void)reloadData;
-(void)afterLoadData;

@end
