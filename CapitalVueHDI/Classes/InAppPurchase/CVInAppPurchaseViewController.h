//
//  CVInAppPurchaseViewController.h
//  CapitalVueHD
//
//  Created by jishen on 12/13/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKStoreManager;

@interface CVInAppPurchaseViewController : UIViewController {
@private
	MKStoreManager *_storeManager;
	NSString *_serviceID;
}

@end
