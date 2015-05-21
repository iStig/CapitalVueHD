//
//  CVPortletView.h
//  CapitalValDemo
//
//  Created by leon on 10-8-4.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVSettingTableView.h"


@interface CVPortletView : UIView<UIPopoverControllerDelegate> {
	UILabel *_labelTitle;
	UIImageView *_imageBackground;
	UIButton *_buttonRefresh;
	UIButton *_buttonRestore;
	UIButton *_buttonFullscreen;
	UIButton *_buttonSetting;
	UIPopoverController *_popoverSetting;
	CVSettingTableView *_settingTableView;
}
@property (nonatomic, retain) UILabel *labelTitle;
@property (nonatomic, retain) UIImageView *imageBackground;
@property (nonatomic, retain) UIButton *buttonRefresh;
@property (nonatomic, retain) UIButton *buttonRestore;
@property (nonatomic, retain) UIButton *buttonFullscreen;
@property (nonatomic, retain) UIButton *buttonSetting;
@property (nonatomic, retain) UIPopoverController *popoverSetting;
@property (nonatomic, retain) CVSettingTableView *settingTableView;

-(IBAction) clickRefreshButton:(id)sender;
-(IBAction) clickFullscreenButton:(id)sender;
-(IBAction) clickSettingButton:(id)sender;
-(IBAction) clickRestoreButton:(id)sender;

- (void)didSpreadToFullScreen;
- (void)didSpreadToRestoreScreen;
@end
