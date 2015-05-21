//
//  CVAboutBulletin.h
//  CapitalVueHD
//
//  Created by jishen on 12/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVAboutBulletin : UIView {
	UIButton *shareButton;
	UIButton *legalButton;
	UIButton *clearCacheButton;
}

@property (nonatomic, retain) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) IBOutlet UIButton *legalButton;
@property (nonatomic, retain) IBOutlet UIButton *clearCacheButton;
@property (nonatomic, retain) IBOutlet UIButton *feedbackButton;
@end
