//
//  CVTodaysNewsContentView.h
//  CapitalValDemo
//
//  Created by leon on 10-8-12.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVTodaysNewsContentView : UIView {
	UIImageView *_imageFirThumb;
	UIImageView *_imageSecThumb;
	UIImageView *_imageThiThumb;
	
	UIImageView *_imagePoint1;
	UIImageView *_imagePoint2;
	UIImageView *_imageLine;
	
	UILabel *_labelFirTitle;
	UILabel *_labelSecTitle;
	UILabel *_labelThiTitle;
	UILabel *_labelFouTitle;
	
	UIButton *_buttonFirst;
	UIButton *_buttonSecond;
	UIButton *_buttonThird;
	UIButton *_buttonForth;
}

@property (nonatomic, retain) UIImageView *imageFirThumb;
@property (nonatomic, retain) UIImageView *imageSecThumb;
@property (nonatomic, retain) UIImageView *imageThiThumb;

@property (nonatomic, retain) UIImageView *imagePoint1;
@property (nonatomic, retain) UIImageView *imagePoint2;
@property (nonatomic, retain) UIImageView *imageLine;

@property (nonatomic, retain) UILabel *labelFirTitle;
@property (nonatomic, retain) UILabel *labelSecTitle;
@property (nonatomic, retain) UILabel *labelThiTitle;
@property (nonatomic, retain) UILabel *labelFouTitle;

@property (nonatomic, retain) UIButton *buttonFirst;
@property (nonatomic, retain) UIButton *buttonSecond;
@property (nonatomic, retain) UIButton *buttonThird;
@property (nonatomic, retain) UIButton *buttonForth;
@end
