//
//  CVTodaysNewsPopoverView.h
//  CapitalValDemo
//
//  Created by leon on 10-8-23.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVTodaysNewsPopoverView : UIView {
	UILabel *_labelTitle;
	UIImageView *_imgbackground;
}
@property (nonatomic, retain) UILabel *labelTitle;
@property (nonatomic, retain) UIImageView *imgbackground;
@end
