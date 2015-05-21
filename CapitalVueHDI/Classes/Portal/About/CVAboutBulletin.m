//
//  CVAboutBulletin.m
//  CapitalVueHD
//
//  Created by jishen on 12/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVAboutBulletin.h"


@implementation CVAboutBulletin

@synthesize shareButton;
@synthesize legalButton;
@synthesize clearCacheButton;
@synthesize feedbackButton;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[shareButton release];
	[legalButton release];
	[clearCacheButton release];
	[feedbackButton release];
    [super dealloc];
}


@end
