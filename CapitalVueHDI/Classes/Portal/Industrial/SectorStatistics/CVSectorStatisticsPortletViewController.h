//
//  CVSectorStatisticsPortletViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/12/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVIndustrialViewCoordinates.h"
#import "CVPortletViewController.h"
#import "CVPieChartView.h"
#import "CVShareInfoView.h"
#import "DreamScroll.h"
#import "CVIndustrialNotifyDefine.h"
#import "NSString+Number.h"

enum SECTOR_STATISTICS {
	SECTOR_STATISTICS_TURNOVER,
	SECTOR_STATISTICS_VOLUME,
	SECTOR_STATISTICS_TOTAL_CAP,
	SECTOR_STATISTICS_TRADABLE_CAP,
	SECTOR_STATISTICS_INVALID
};

enum SECTOR_DEFITION {
	SECTOR_DEFITION_ENERGY,						// 10
	SECTOR_DEFITION_MAERIALS,					// 15
	SECTOR_DEFITION_INDUSTRIALS,				// 20
	SECTOR_DEFITION_CONSUMER_DISCRETIONARY,		// 25
	SECTOR_DEFITION_CONSUMER_STAPLES,			// 30
	SECTOR_DEFITION_HEALTH_CARE,				// 35
	SECTOR_DEFITION_FINANCIAL,					// 40
	SECTOR_DEFITION_INFORMATION_TECHNOLOGY,		// 45
	SECTOR_DEFITION_TELECOMMUNICATION_SERVICES,	// 50
	SECTOR_DEFITION_UTILITIES,					// 55
	SECTOR_DEFITION_INVALID
};

#define kDataTypeTurnover		0
#define kDataTypeVolume			1
#define kDataTypeTotalCap		2
#define kDataTypeTradableCap	3

@interface CVSectorStatisticsPortletViewController : CVPortletViewController <CVScrollPageViewDeleage,CVPieChartViewDelegate, CVPiewChartDelegate> {
@private
	UIImage *imagePortraitBackground;
	UIImage *imageLandscapeBackground;
	UIImageView *imageViewBackground;
	UIImageView *imgvShareInfo;
	UILabel *_titleLabel;
	UILabel *_statisticsLabel;
	UIButton *_btnRefresh;
	
	UIImageView *_imgvPortraitNoData;
	UIImageView *_imgvLandscapeNoData;
	
	UIActivityIndicatorView *_activityIndicator;
	DreamScroll *_scrollPageController;
	
	// It carries page views for turnover, volume, total capital and tradable capital
	NSMutableArray *_pageViewCache;
	// It holds the data for each page
	NSMutableArray *_pageDataCache;
	NSMutableArray *_sectorSummaryArray;
	NSMutableDictionary *_sectorSummaryTitleDict;
	@protected
	BOOL ifLoaded;
	int dreamIndex;
	CVShareInfoView *_shareInfoView;
	NSInteger rotateCount;
	
	NSArray *SectorIds;
	NSUInteger currentIndex;
	
	BOOL _isEmptyData;
	BOOL bTurnover,bVolume,bTotalCap,bTradableCap;
}
@property BOOL ifLoaded;
@end
