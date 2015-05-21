//
//  CVPortalViewController.h
//  CapitalVueHD
//
//  Created by jishen on 8/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVPortal.h"
#import "CVPortalSetController.h"
#import "CVPortalPortalSetManager.h"
#import "CVSearchDisplayController.h"

@class CVPortalPortalSetManager;
@class CVAboutViewController;

@interface CVPortalViewController : UIViewController <UISearchBarDelegate> {
	UIImageView *imageBarRightEdge;
	UIImageView *imageBarLeftEdge;
	UIImageView *imageBarMiddlePortion;
	UIImageView *imageBarLogo;
	
	UISearchBar *searchEquityBar;
	
	UIView *modalView;
	
	UIButton *logoButton;
@private
	CVPortalSetController *currentPortalSet;
	UIImage *imageButtonNormal;
	UIImage *imageButtonHighlight;
	NSMutableArray *buttonArray;
	
	CVPortalPortalSetManager *portalSetManager;
	CVSearchDisplayController *_searchResultController;
	UIPopoverController *popoverController;
	
	CVAboutViewController *_aboutController;
	
	NSArray *_equityCodesArray;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageBarRightEdge;
@property (nonatomic, retain) IBOutlet UIImageView *imageBarLeftEdge;
@property (nonatomic, retain) IBOutlet UIImageView *imageBarMiddlePortion;
@property (nonatomic, retain) IBOutlet UIImageView *imageBarLogo;

@property (nonatomic, retain) IBOutlet UIButton *logoButton;
@property (nonatomic, retain) IBOutlet UISearchBar *searchEquityBar;

- (IBAction)logoButtonTapped:(id)sender;
- (CGRect)setNewsPortalFrame:(UIInterfaceOrientation)orientation;
- (void)sendStockCode:(NSMutableDictionary *)dict;

- (void) showSplash;
- (void) hideSplash;

@end
