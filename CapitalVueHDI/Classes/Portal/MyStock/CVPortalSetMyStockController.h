//
//  CVPortalSetMyStockController.h
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPortalSetController.h"
#import "CVNavigatorDetailController.h"

@interface CVPortalSetMyStockController : CVPortalSetController {
	BOOL _isStockFromHome;
@private
	// the navigator-detail frame
	CVNavigatorDetailController *_navigationDetailController;
}
@property (nonatomic, retain) CVNavigatorDetailController *_navigationDetailController;

- (CGRect)navigationDetailFrame:(UIInterfaceOrientation)orientation;
- (void)updateStockDetailFromHome:(NSDictionary *)dict;

@end
