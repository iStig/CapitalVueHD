//
//  CVPortletViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/2/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVMenuController.h"
#import "CVLocalizationSetting.h"

@protocol CVPorletRefreshDelegate

-(void)clickRefreshButton;

@end


enum {
	CVPortletViewStyleNone       = 1 << 0,
	CVPortletViewStyleRefresh    = 1 << 1,
	CVPortletViewStyleFullscreen = 1 << 2,
	CVPortletViewStyleSetting    = 1 << 3,
	CVPortletViewStyleBarVisible = 1 << 4,
	CVPortletViewStyleContentTransparent = 1 << 5,
	CVPortletViewStyleRestore    = 1 << 6,
	CVPortletViewStylePrint      = 1 << 7
};

typedef NSUInteger CVPortalViewStyle;

#define CVPORTLET_BAR_HEIGHT                46.0
#define CVPORTLET_BUTTON_WIDTH       36.0
#define CVPORTLET_BUTTON_HEIGHT      36.0

@interface CVPortletViewController : UIViewController <CVMenuControllerDelegate, UISearchBarDelegate, UIPopoverControllerDelegate> {
	CVPortalViewStyle style;
	CGRect frame;
	NSString *portletTitle;
	NSMutableArray *menuItems;
	UIInterfaceOrientation portalInterfaceOrientation;

	
@private
	id<CVPorletRefreshDelegate> refreshDelegate;
	UIPopoverController *_popoverControl;
	UIImageView *_imageViewBarLeftEdge;
	UIImageView *_imageViewBarRightEdge;
	UIImageView *_imageViewBarMiddlePart;
	
	UIImageView *_imageViewContentBottomLeftCorner;
	UIImageView *_imageViewContentBottomRightCorner;
	UIImageView *_imageViewContentLeftEdge;
	UIImageView *_imageViewContentRightEdge;
	UIImageView *_imageViewContentBottomEdge;
	UIImageView *_imageViewContentFill;
	
}

@property (nonatomic) CVPortalViewStyle style;
@property (nonatomic) CGRect frame;
@property (nonatomic, retain) NSString *portletTitle;
@property (nonatomic, retain) NSMutableArray *menuItems;
@property (nonatomic) UIInterfaceOrientation portalInterfaceOrientation;

- (void)setDelegate:(id)delegate;
/*
 * It responds to the touch-up-inside against refresh button
 *
 * @param: sender - an instance of refresh button 
 * @return: none
 */
- (IBAction)clickFresh:(id)sender;

/*
 * It responds to the touch-up-inside against fullscreen button
 *
 * @param: sender - an instance of fullscreen button 
 * @return: none
 */
- (IBAction)clickFullscreen:(id)sender;

/*
 * It responds to the touch-up-inside against setting button
 *
 * @param: sender - an instance of setting button 
 * @return: none
 */
- (IBAction)clickSetting:(id)sender;


/*
 * It processes the customized action, when the item of menu is tapped.
 * The developer has to implement this method, if he/she would like to
 * use the style of setting.
 *
 * @param: indexPath - An index path locating the new selected row in menu.
 * @return: none
 */
- (void)actionMenuItemAtIndexPath:(NSIndexPath *)indexPath;

/*
 * It allows to do any changes after the menu dismissed.
 */
- (void)actionMenuDidDismiss;


/*
 * It adjusts the layout of subviews in accordance with the device orientation.
 */
- (void)adjustSubviews:(UIInterfaceOrientation)orientation;

- (void)reloadData;

@end
