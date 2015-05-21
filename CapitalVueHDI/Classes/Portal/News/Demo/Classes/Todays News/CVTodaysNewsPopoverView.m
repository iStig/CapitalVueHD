//
//  CVTodaysNewsPopoverView.m
//  CapitalValDemo
//
//  Created by leon on 10-8-23.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVTodaysNewsPopoverView.h"


@implementation CVTodaysNewsPopoverView
@synthesize labelTitle = _labelTitle;
@synthesize imgbackground = _imgbackground;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _imgbackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 302.0, 681.0)];
		//UIImage *img = [UIImage imageNamed:@"todaysnews_list_background.png"];
		//imgbackground.image = img;
		[self addSubview:_imgbackground];
		//[_imgbackground release];
		
		_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 30.0, 150.0, 30.0)];
		_labelTitle.backgroundColor = [UIColor clearColor];
		_labelTitle.textColor = [UIColor whiteColor];
		[self addSubview:_labelTitle];
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

- (void)dealloc {
	[_labelTitle release];
	[_imgbackground release];
    [super dealloc];
}


@end
