//
//  UIImageViewEx.h
//  CapitalVueHD
//
//  Created by Dream on 10-9-19.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
#define ContentViewStylePortrait  0
#define ContentViewStyleLandscape 1

#define LandscapeWidth 80.0
#define LandscapeHeight 314.0

#define PortraitWidth 430.0
#define PortraitHeight 65.0

#define MidlineX 160.0
#define MidlineY 129.0

#define BoldlineX 320.0
#define BoldlineY 258.0

#define LandscapeNameCenter1 270.0
#define LandscapeNameCenter2 282.0
#define LandscapeRateCenterY 301.0

#define PortraitNameCenterX 378.0
#define PortraitNameCenterY1 16.0
#define PortraitNameCenterY2 28.0
#define PortraitRateCenterY 50.0

#define NameFontSize 12.0

#define ColorRectWidth 28.0
#define ColorRectHeight 23.0

#define FontWidth 108.0
#define FontHeight 20.0

@interface UIImageViewEx : UIImageView {
	NSInteger iStyle;
	BOOL bSelected;
	CGRect portraitFrame;
	CGRect landscapeFrame;
	UILabel *lblLine1;
	UILabel *lblLine2;
	UIImageView *imgvLoserRate;
	UIImageView *imgvGainerRate;
	UILabel *lblMidLine;
	UILabel *lblBoldLine;

	CGFloat fIncreased;
	CGFloat fDecreased;
	UILabel *lblName1;
	UILabel *lblName2;
	UILabel *lblRate;
}
@property (nonatomic,retain) UILabel *lblLine1;
@property (nonatomic,retain) UILabel *lblLine2;
@property (nonatomic,retain) UIImageView *imgvLoserRate;
@property (nonatomic,retain) UIImageView *imgvGainerRate;
@property (nonatomic,retain) UILabel *lblMidLine;
@property (nonatomic,retain) UILabel *lblBoldLine;
@property CGFloat fIncreased;
@property CGFloat fDecreased;
@property (nonatomic,retain) UILabel *lblName1;
@property (nonatomic,retain) UILabel *lblName2;
@property (nonatomic,retain) UILabel *lblRate;


- (void) updateOrientation:(UIInterfaceOrientation)orientation;
- (id) initWithName:(NSString *)sectorName increased:(NSString *)strIncreased decreased:(NSString *)strDecreased changed:(NSString *)strChanged;

@end
