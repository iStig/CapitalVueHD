//
//  CVButtonPanelView.h
//  CapitalVueHD
//
//  Created by leon on 10-9-25.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CVPortalSetNewsController;
#import "CVNewsNavigatorController.h"
//#import "CVPortalSetNewsController.h"

@interface CVButtonPanelView : UIView {
	UIImageView *_imageBackground;
	UIImageView *_imageSecondBackground;   //竖版第二列背景
	NSArray *_arrayButtonTitle;
	NSMutableArray	*_arrayPortraitButtons;				//把button放入数组中
	NSMutableArray  *_arrayLandscapeButtons;
	UIImage		*_img;
	NSUInteger  _iChecked;                        //保存当前选择的按钮Tag
	BOOL		_isLandscape;
	CVPortalSetNewsController *_portalSetNewsController;
	CVNewsNavigatorController *_newsNavigatorController;
	UIPopoverController *_popoverController;
	UIInterfaceOrientation _buttonPanelInterfaceOrientation;
	NSMutableArray *_arrayNews;
	BOOL		_isClickButton;
	NSInteger _currentPage;
	BOOL		_ifLoaded;
@private
	NSMutableArray *_columnsContentArray;
	
	NSLock *_newsLock;
}
@property (nonatomic, retain) CVPortalSetNewsController *portalSetNewsController;
@property (nonatomic, retain) CVNewsNavigatorController *newsNavigatorController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIImageView *imageBackground;
@property (nonatomic, retain) NSArray *arrayButtonTitle;
@property (nonatomic, retain) UIImage	  *img;
@property (nonatomic) BOOL isLandscape;
@property (nonatomic) NSUInteger  iChecked;
- (void)loadButtons;
- (void)reloadList;
- (void)refreshList;
- (void)getList:(id)sender;
- (void)selectedNextPage;
- (void)createButtonPanel;
- (void)adjustSubviews:(UIInterfaceOrientation)orientation;
- (void)getNewsClassList:(NSInteger)number andForceRefresh:(BOOL)forceRefresh;
- (void)updateNewsfromHome:(NSDictionary *)dict;
- (void)updatePopoverPosition;
- (void)updatePopoverContent:(NSMutableArray *)arrayNews;
@end
