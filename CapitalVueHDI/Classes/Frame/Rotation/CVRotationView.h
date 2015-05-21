//
//  CVRotationView.h
//  CapitalVueHD
//
//  Created by leon on 10-10-15.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVRotationView : UIView {
	UIInterfaceOrientation rotationInterfaceOrientation;
	UIImageView *_imageBackground;
	UILabel *_labelTitle;
	UIButton *_buttonRelatedNews;
}
@property (nonatomic) UIInterfaceOrientation rotationInterfaceOrientation;
@property (nonatomic, retain) UIImageView *imageBackground;
@property (nonatomic, retain) UILabel *labelTitle;
@property (nonatomic, retain) UIButton *buttonRelatedNews;

- (void)startRotationView;
@end
