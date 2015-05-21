//
//  CVNewsDetailView.h
//  CapitalVueHD
//
//  Created by leon on 10-9-25.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVNewsNavigatorController.h"
#import "CVNewsrelatedView.h"
#import "CVSnapshotView.h"
@class CVPortalSetNewsController;


@interface CVNewsDetailView : UIView<UIWebViewDelegate, CVNewsGoWebDetailProtocal, CVLoadNewsDelegate> {
	UIInterfaceOrientation detailInterfaceOrientation;
	UIWebView      *_webView;
	UIImageView *_imageTableViewBackground;
	UIImageView *_imageNewsrelatedBackground;
	NSString *_strPostID;
	NSString *_strSetID;
	NSString *_strCode;
	NSArray *_arrayTable;
	NSMutableArray *_arrayNews;
	BOOL		_isLandscape;
	CVPortalSetNewsController *_portalSetNewsController;
	CVNewsNavigatorController *_newsNavigatorController;
	CVNewsrelatedView  *_newsrelatedView;
	CVSnapshotView			  *_snapshotView;
	NSInteger _iSelectedColumn;                 //table上当前选中的index
	UIActivityIndicatorView *_activityWebView;
	UIActivityIndicatorView *_activityTableView;
	
	UIButton *buttonRelatedNews;
	UIButton *buttonSnapshot;
	NSNumber *fontsize;
	NSDictionary   *dictCurrentNews;            //当前选择的一条新闻
}
@property (nonatomic) UIInterfaceOrientation detailInterfaceOrientation;
@property (nonatomic, retain) NSString *strPostID;
@property (nonatomic, retain) NSString *strSetID;
@property (nonatomic, retain) NSString *strCode;
@property (nonatomic, retain) CVNewsNavigatorController *newsNavigatorController;
@property (nonatomic, retain) CVPortalSetNewsController *portalSetNewsController;
@property (nonatomic, retain) CVNewsrelatedView  *newsrelatedView;
@property (nonatomic, retain) NSMutableArray *arrayNews;
@property (nonatomic, retain) CVSnapshotView *snapshotView;
@property (nonatomic, retain) NSNumber *fontsize;
@property (nonatomic) BOOL isLandscape;
@property (nonatomic) NSInteger iSelectedColumn;
@property (nonatomic, retain) NSDictionary *dictCurrentNews;

- (void)createContentView;
- (void)adjustSubviews:(UIInterfaceOrientation)orientation;
- (NSString *)stampchangetime:(NSString *)timestamp isDetail:(BOOL)isDetail;
- (NSString *)addImageUrl:(NSString *)strContent;
- (void)updateContent:(NSMutableArray *)array;
- (void)loadWebContent:(NSDictionary *)dict;
- (void)updateNewsfromHome:(NSMutableArray *)array index:(NSInteger)index;

- (void)startActivityView;
- (void)stopActivityView;
- (void)startActivityTableView;
- (void)stopActivityTableView;
- (void)saveDetailFontSize;
- (void)dismissRotationView;
- (void)changeDetailFontToBig;
- (void)changeDetailFontToSmall;
- (void)setButtonImage;
- (void)popPrintController:(id)sender;
@end
