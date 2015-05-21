//
//  CVAboutBulletinController.h
//  CapitalVueHD
//
//  Created by jishen on 12/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class CVAboutLegalViewController;
@protocol CVAboutBulletinControllerDelegate

- (void)didTapDoneButton;

@end


@interface CVAboutBulletinController : UIViewController <UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate,UIAlertViewDelegate> {
	id<CVAboutBulletinControllerDelegate> delegate;
	UIScrollView *scrollView;
@private
	NSArray *_aboutArray;
	CVAboutLegalViewController *vcLegal;
}

@property (nonatomic, assign) id<CVAboutBulletinControllerDelegate> delegate;
@property (nonatomic) UIInterfaceOrientation orientation;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;;

@end
