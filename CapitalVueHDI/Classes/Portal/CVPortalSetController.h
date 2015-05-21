//
//  CVPortalSetController.h
//  CapitalVueHD
//
//  Created by jishen on 9/14/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVPortalSetController : UIViewController {
	UIInterfaceOrientation portalInterfaceOrientation;
}

@property (nonatomic, assign) UIInterfaceOrientation portalInterfaceOrientation;

/*
 * It adjust the views postion in accordance to the device orientation.
 *
 * @param: orientation - The orientation of the application’s user interface
 * @return: none
 */
- (void)adjustSubviews:(UIInterfaceOrientation)orientation;

- (void)reloadData;

@end
