//
//  CVPortalSetMarketController.h
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVPortalSetController.h"

#import "CVCompositeIndexPortletViewController.h"
#import "CVMostActivePortletViewController.h"
#import "CVStockPortletViewController.h"

@interface CVPortalSetMarketController : CVPortalSetController {
@private
	CVCompositeIndexPortletViewController *compositeIndexController;
	CVMostActivePortletViewController *mostActiveController;
	CVStockPortletViewController *stockController;
}

@end
