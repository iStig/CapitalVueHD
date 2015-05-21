//
//  CVPortalSetMacroController.h
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVPortalSetController.h"
#import "CVNavigatorDetailController.h"

@class CVMacroNavigatorViewController;
@class CVMacroDetailViewController;

@interface CVPortalSetMacroController : CVPortalSetController {
@private
	// the navigator-detail frame
	CVNavigatorDetailController *_navigationDetailController;
	
	CVMacroNavigatorViewController *_macroNavigatorViewController;
	CVMacroDetailViewController *_detailViewController;
}

@end
