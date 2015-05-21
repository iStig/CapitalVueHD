//
//  CVAboutViewController.h
//  CapitalVueHD
//
//  Created by jishen on 12/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVAboutBulletinController.h"

@class CVAboutBulletinController;

@interface CVAboutViewController : UIViewController <CVAboutBulletinControllerDelegate> {
@private
	UINavigationController *_navgationController;
	CVAboutBulletinController *_aboutBullinController;
}

@end
