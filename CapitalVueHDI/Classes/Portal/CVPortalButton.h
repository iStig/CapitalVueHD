//
//  CVPortalButton.h
//  CapitalVueHD
//
//  Created by jishen on 8/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CVPortal.h"

@interface CVPortalButton : UIButton {
	CVPortalSetType portalset;
}

@property (nonatomic) CVPortalSetType portalset;

@end
