//
//  cvCal.m
//  CapitalVueHD
//
//  Created by Stan on 11-2-28.
//  Copyright 2011 CapitalVue. All rights reserved.
//

#import "cvCal.h"
@interface cvCal()
-(CGRect)getFrameByIndex:(NSUInteger)index;

@end



@implementation cvCal
-(id)initWithDate:(NSDate *)date{
	self = [super initWithFrame:CGRectMake(0, 0, 150, 150)];
	if (self){
		
	}
	
	return self;
}

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
    [super dealloc];
}

-(void)setCalFlag:(NSUInteger)flag{
	BOOL ipo = flag & cvCalFlagIPO;
	BOOL lockup = flag & cvCalFlagLockup;
	BOOL personal = flag & cvCalFlagPersonal;
	uint iIPO = ipo?1:0;
	uint iLockup = lockup?1:0;
	uint iPersonal = personal?1:0;
	
	imgvIPO.hidden = ipo;
	imgvLockup.hidden = lockup;
	imgvPersonal.hidden = personal;
	
	imgvIPO.frame = [self getFrameByIndex:iIPO];
	imgvLockup.frame = [self getFrameByIndex:iIPO+iLockup];
	imgvPersonal.frame = [self getFrameByIndex:iIPO+iLockup+iPersonal];


}


-(CGRect)getFrameByIndex:(NSUInteger)index{
	switch (index) {
		case 1:
			return kFlagFrame0;
			break;
		case 2:
			return kFlagFrame1;
			break;
		case 3:
			return kFlagFrame2;
			break;
		default:
			return CGRectZero;
			break;
	}
}
@end
