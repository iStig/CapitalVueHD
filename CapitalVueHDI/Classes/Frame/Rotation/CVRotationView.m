//
//  CVRotationView.m
//  CapitalVueHD
//
//  Created by leon on 10-10-15.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVRotationView.h"


@implementation CVRotationView
@synthesize imageBackground = _imageBackground;
@synthesize labelTitle = _labelTitle;
@synthesize buttonRelatedNews = _buttonRelatedNews;
@synthesize rotationInterfaceOrientation;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_background.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
        _imageBackground = [[UIImageView alloc] initWithImage:imgx];
		[imgx release];
		_imageBackground.userInteractionEnabled = YES;
		_imageBackground.frame = CGRectMake(0, 0, 492, 354);
		[self addSubview:_imageBackground];
		
		_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 15.0, 200.0, 30.0)];
		_labelTitle.backgroundColor = [UIColor clearColor];
		_labelTitle.textColor = [UIColor blackColor];
		_labelTitle.font = [UIFont systemFontOfSize:15];
		[_imageBackground addSubview:_labelTitle];
		
	}
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)startRotationView{
	[self setHidden:NO];
	CGPoint start = CGPointMake(self.frame.origin.x + 40 + self.frame.size.width/2.0,
								self.frame.origin.y + self.frame.size.height + 20);
	self.center = start;
	
	//scale rotate and then concat,also with the alpha
	CGAffineTransform scale = CGAffineTransformMakeScale(0.1,0.1);
	CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI/3);
	self.transform = CGAffineTransformConcat(scale, rotate);
	self.alpha = 0.5;
	
	[UIView beginAnimations:@"circle" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	float ptX = self.center.x;
	float ptY = self.center.y;
	if (self.rotationInterfaceOrientation == UIInterfaceOrientationPortrait ||
		self.rotationInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.center = CGPointMake(ptX+200, ptY-220);
	}
	else {
		self.center = CGPointMake(ptX+200, ptY-175);
	}

	
	
	scale = CGAffineTransformMakeScale(0.5, 0.5);
	rotate = CGAffineTransformMakeRotation(M_PI/6);
	self.transform = CGAffineTransformConcat(scale, rotate);
	self.alpha = 0.75;
	[UIView commitAnimations];
	[self performSelector:@selector(anotherAnimation) withObject:nil afterDelay:0.2];
}

- (void)anotherAnimation{
	float ptX = self.center.x;
	float ptY = self.center.y;
	[UIView beginAnimations:@"2circle" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	self.transform = CGAffineTransformIdentity;
	if (self.rotationInterfaceOrientation == UIInterfaceOrientationPortrait ||
		self.rotationInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.center = CGPointMake(ptX-200, ptY-220);
	}
	else {
		self.center = CGPointMake(ptX-200, ptY-120);
	}
	self.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)dealloc {
	[_imageBackground release];
	[_labelTitle release];
    [super dealloc];
}


@end
