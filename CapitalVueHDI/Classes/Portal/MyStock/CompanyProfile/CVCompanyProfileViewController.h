//
//  CVCompanyProfileViewController.h
//  CapitalVueHD
//
//  Created by jishen on 11/2/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVCompanyProfileBulletin.h"

@interface CVCompanyProfileViewController : UIViewController {
	UIImageView *imageBackgroundView;
	UILabel *titleLabel;
	UIScrollView *scrollView;
	UIInterfaceOrientation rotationInterfaceOrientation;
	UIActivityIndicatorView *_indicator;
@protected
	CVCompanyProfileBulletin *_bulletin;
	NSString *_code;
}

@property (nonatomic, assign) UIInterfaceOrientation rotationInterfaceOrientation;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageBackgroundView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSString *code;

- (void)loadProfileData;
- (void)initBulletin;
- (void)startRotationView;

@end
