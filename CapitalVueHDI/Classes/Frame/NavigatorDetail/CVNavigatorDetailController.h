//
//  CVNavigatorDetailController.h
//  CapitalVueHD
//
//  Created by jishen on 9/24/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#define tagButtonShow		5400	//button tag that can show popup

@protocol CVNavigatorDetailControllerDelegate;

@interface CVNavigatorDetailController : UIViewController {
	id <CVNavigatorDetailControllerDelegate> delegate;
@private
	
	NSArray *_viewControllers;
	UIInterfaceOrientation _orientation;
	CGRect _frame;
	CGSize _navigatorSize;
	
	UIViewController *_navigatorController;
	UIViewController *_detailController;
	@protected
	UIPopoverController *_popOverController;
}

@property (nonatomic, assign) id <CVNavigatorDetailControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, retain) UIPopoverController *_popOverController;
@end

#import "CVNavigatorDetailControllerDelegate.h"
