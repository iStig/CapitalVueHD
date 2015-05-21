//
//  CVMostActivePortletViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/14/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPortletViewController.h"
#import "CVScrollPageViewController.h"
#import "CVCompositeIndexPortletViewController.h"
#import "CVFormView.h"

@interface CVMostActivePortletViewController : CVPortletViewController <CVScrollPageViewDeleage, CVCompositeIndexPortletViewDelegate, CVFormViewDelegate> {
	//NSString *indexCode;
	NSString *indexSymbol;
@private
	NSString *_indexCode;
	// it contains the head of a form
	NSMutableArray *_keysArray;
	
	NSMutableArray *_headArray;
	
	NSMutableArray *_dataArray;
	CVScrollPageViewController *_scrollPageController;
	
	// size of form
	NSDictionary *_settingDictionary;
	CGFloat _portraitX;
	CGFloat _portraitY;
	CGFloat _portraitWidth;
	CGFloat _portraitHeight;
	NSMutableArray *_portraitCellWidthArray;
	NSMutableArray *_portraitCellSpaceArray;
	CGFloat _landscapeX;
	CGFloat _landscapeY;
	CGFloat _landscapeWidth;
	CGFloat _landscapeHeight;
	NSMutableArray *_landscapeCellWidthArray;
	NSMutableArray *_landscapeCellSpaceArray;
	
	// Activity Indicator
	UIActivityIndicatorView *_activityIndicator;
	NSLock*	_loadingDataLock;
	BOOL _ifLoaded;
	BOOL _valuedData;
	
	UILabel *lbl;
	UIImageView *imgvSectBG;
}

@property (nonatomic, retain) NSString *indexCode;
@property (nonatomic, retain) NSString *indexSymbol;
@property (nonatomic, retain) NSMutableArray *headArray;
@property (nonatomic, retain) NSMutableArray *dataArray;

-(void)waitForCoverFlowLoading:(NSNotification *)notification;
@end
