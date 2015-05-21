//
//  CVSectorGainerLoserPortletViewController.h
//  CapitalVueHD
//
//  Created by Dream on 10-9-17.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVPortletViewController.h"
#import "CVDataProvider.h"
#import "UIImageViewEx.h"
#import "RectImage.h"
#import "CVIndustrialNotifyDefine.h"


#define CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_X       20
#define CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_Y       20
#define CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_WIDTH   731
#define CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_HEIGHT  457

#define CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_X      20
#define CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_Y      20
#define CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_WIDTH  498
#define CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_HEIGHT 655

#define RectImageWidth				233.
#define RectImageHeight				34.

#define ScrollPortraitX				15.0
#define ScrollPortraitY				87.0
#define ScrollLandscapeX			48.0
#define ScrollLandscapeY			46.0

#define PortraitGainerCenterX		589.
#define PortraitGainerCenterY		185.0
#define PortraitGainerWidth			233.
#define PortraitGainerHeight		182.0

#define PortraitLoserCenterX		589.
#define PortraitLoserCenterY		385.0
#define PortraitLoserWidth			233.
#define PortraitLoserHeight			182.0

#define LandscapeGainerCenterX		125.0
#define LandscapeGainerCenterY		540.0
#define LandscapeGainerWidth		233.
#define LandscapeGainerHeight		250.

#define LandscapeLoserCenterX		370.0
#define LandscapeLoserCenterY		540.0
#define LandscapeLoserWidth			233.0
#define LandscapeLoserHeight		250.0

#define PortraitLabelsX				15.0
#define PortraitLabelsY1			47.0
#define PortraitLabelsY2			413.0
#define PortraitLabelsHeight		43.0

#define LandscapeLabelsX1			0.0
#define LandscapeLabelsX2			448.0
#define LandscapeLabelsY			46.0
#define LandscapeLabelsWidth		48

//Arrow Postion
#define PortraitRedArrowX			589.
#define PortraitRedArrowY			275.0
#define PortraitGreenArrowX			589.
#define PortraitGreenArrowY			85.0

#define LandscapeRedArrowX			370.0
#define LandscapeRedArrowY			395.0
#define LandscapeGreenArrowX		135.0
#define LandscapeGreenArrowY		400.0



#define RedImageName				@"CV_iPad_TopGL_red"
#define GreenImageName				@"CV_iPad_TopGL_green"
#define RedArrowName				@"CV_iPad_TopGL_RedArrow"
#define GreenArrowName				@"CV_iPad_TopGL_GreenArrow"

#define GainersLosersTitle			[langSetting localizedString:@"Sector Gainers/Losers"]
#define PercentFontSize				10.0

#define GrayBackPortraitX			15.
#define GrayBackPortraitY			87.
#define GrayBackPortraitWidth		320.
#define GrayBackPortraitHeight		325.

#define GrayBackLandscapeX			49.
#define GrayBackLandscapeY			46.
#define GrayBackLandscapeWidth		399.
#define GrayBackLandscapeHeight		258.

#define BlueBackPortraitX			0.
#define BlueBackPortraitY			46.
#define BlueBackPortraitWidth		468.0
#define BlueBackPortraitHeight		410.0

#define BlueBackLandscapeX			0.
#define BlueBackLandscapeY			46.
#define BlueBackLandscapeWidth		497.
#define BlueBackLandscapeHeight		330.

#define kInfoLandscapeX				210.
#define kInfoLandscapeY1			45.
#define kInfoLandscapeY2			270.
#define kInfoPortraitY				228.
#define kInfoPortraitX1				2.
#define kInfoPortraitX2				254.

#define kInfoLandscapeWidth			78.
#define kInfoLandscapeHeight		30.

@interface CVSectorGainerLoserPortletViewController : CVPortletViewController <UIScrollViewDelegate>{
	CVDataProvider *dpGainerLoser;
	UIScrollView *svLandscapeRate;
	UIScrollView *svPortraitRate;
	UIImageView *imgvTop;
	UIView *imgvTopGainers;
	UIView *imgvTopLosers;
	NSDictionary *sectorList;
	NSDictionary *topList;
	UIActivityIndicatorView *aivList;
	UIActivityIndicatorView *aivTopGainerLoser;
	
	UIImageView *imgvGrayBackground;
	UIImageView *imgvBlueBackground;
	
	UIImageView *imgvLeftLabel;
	UIImageView *imgvRightLabel;
	UIImageView *imgvTopLabel;
	UIImageView *imgvBottomLabel;
	
	UIImageView *imgvRedArrow;
	UIImageView *imgvGreenArrow;
	
	NSInteger lastSelected;
	
	BOOL _valuedData;
	BOOL ifLoaded;
	BOOL bLabelShow;
	NSInteger iTimeCount;
	
	BOOL _isGainerLoserLoaded;
	
	NSDictionary *configDict;
	
	
	UILabel *lblGainersInfo1;
	UILabel *lblGainersInfo2;
	UILabel *lblLosersInfo1;
	UILabel *lblLosersInfo2;
	UIButton *_btnPlayOrStop;
	BOOL _canPlay;
	NSTimer *autoTimer;
	
	NSArray *sectorIds;
}


@property (nonatomic,retain) CVDataProvider *dpGainerLoser;
@property (nonatomic,retain) UIScrollView *svLandscapeRate;
@property (nonatomic,retain) UIScrollView *svPortraitRate;
@property (nonatomic,retain) UIView *imgvTopGainers;
@property (nonatomic,retain) UIView *imgvTopLosers;
@property (nonatomic,retain) NSDictionary *sectorList;
@property (nonatomic,retain) NSDictionary *topList;
@property (nonatomic,retain) UIActivityIndicatorView *aivList;
@property (nonatomic,retain) UIActivityIndicatorView *aivTopGainerLoser;
@property (nonatomic,retain) UIImageView *imgvGrayBackground;
@property (nonatomic,retain) UIImageView *imgvBlueBackground;
@property (nonatomic,retain) UIImageView *imgvLeftLabel;
@property (nonatomic,retain) UIImageView *imgvRightLabel;
@property (nonatomic,retain) UIImageView *imgvTopLabel;
@property (nonatomic,retain) UIImageView *imgvBottomLabel;

@property (nonatomic,retain) UIImageView *imgvRedArrow;
@property (nonatomic,retain) UIImageView *imgvGreenArrow;

@property (nonatomic,retain) UILabel *lblGainersInfo1;
@property (nonatomic,retain) UILabel *lblGainersInfo2;
@property (nonatomic,retain) UILabel *lblLosersInfo1;
@property (nonatomic,retain) UILabel *lblLosersInfo2;

- (void) getSectorListData:(NSNumber *)isRefresh;
- (void) getTopGainerLoser:(NSString *)icode;
- (void) postNotificationToScrollPieChart:(NSString *)icode;
- (void) getNotificationToStopAutoScroll:(NSNotification *)notification;
- (void) getScrollerNotificationFromPieChart:(NSNotification *)notification;
- (void) updateSectorList;
- (void) updateTopList;
- (void) updateOrientation;
- (CGRect) playButtonFrame;
- (void) autoScroll;
- (void) btnPlayClick:(id)sender;
- (void) preStepForLoadData;
- (void) afterLoadData;
@end
