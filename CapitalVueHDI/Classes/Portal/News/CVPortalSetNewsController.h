//
//  CVPortalSetNewsController.h
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPortletViewController.h"
//#import "CapitalValDemoViewController.h"
//#import "CVButtonPanelViewController.h"
#import "CVPortalSetController.h"
//#import "CVButtonPanelView.h"
#import "CVNewsDetailView.h"
@class CVButtonPanelView;
#define CVPORTAL_SETNEWS_PORTRAIT_WIDTH   739
#define CVPORTAL_SETNEWS_PORTRAIT_HEIGHT  914

#define CVPORTAL_SETNEWS_LANDSCAPE_WIDTH   981
#define CVPORTAL_SETNEWS_LANDSCAPE_HEIGHT  653

#define CVPORTLET_PORTRAIT_WIDTH    739
#define CVPORTLET_PORTRAIT_HEIGHT   914
#define CVPORTLET_LANDSCAPE_WIDTH   981
#define CVPORTLET_LANDSCAPE_HEIGHT  653

#define CVBUTTON_PANEL_Y				 46
#define CVBUTTON_PANEL_PORTRAIT_WIDTH    738
#define CVBUTTON_PANEL_PORTRAIT_HEIGHT   76
#define CVBUTTON_PANEL_LANDSCAPE_WIDTH   980
#define CVBUTTON_PANEL_LANDSCAPE_HEIGHT  38

@interface CVPortalSetNewsController : CVPortalSetController {
	CVPortletViewController *portletViewController;
	
	//CVNewsDetailView *newsDetailPortraitView;
	//CVNewsDetailView *newsDetailLandscapeView;
	CVNewsDetailView *newsDetailView;
	
	CVButtonPanelView *buttonPanelPortraitView;
	CVButtonPanelView *buttonPanelLandscapeView;
	
	NSMutableArray *_arrayNewsChooseStatus;
	
	UIButton *buttonFontBig;
	UIButton *buttonFontSmall;
	
@private
	// FIXME this print button should be part of the portlet class
	UIButton *_printButton;
	
	BOOL isLoadByHome;
	UILabel *lbl;
}

@property (nonatomic) BOOL isLoadByHome;
@property (nonatomic,retain) CVButtonPanelView *buttonPanelPortraitView;
@property (nonatomic,retain) CVButtonPanelView *buttonPanelLandscapeView;

//@property (nonatomic, retain) CVNewsDetailView *newsDetailPortraitView;
//@property (nonatomic, retain) CVNewsDetailView *newsDetailLandscapeView;
@property (nonatomic, retain) CVNewsDetailView *newsDetailView;
@property (nonatomic, retain) NSMutableArray *arrayNewsChooseStatus;
@property (nonatomic,retain) CVPortletViewController *portletViewController;
- (CGRect)portletFrame:(UIInterfaceOrientation)orientation;
- (void)loadButtonPanel;
- (void)loadDetailContent;   
- (void)updateNewsfromHome:(NSDictionary *)dict;
- (NSNumber *)getDetailFontSize;
-(void)showNetWorkLabel;
-(void)hideNetWorkLabel;
@end
