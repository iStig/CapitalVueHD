//
//  cvCal.h
//  CapitalVueHD
//
//  Created by Stan on 11-2-28.
//  Copyright 2011 CapitalVue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	cvCalFlagIPO = 1,
	cvCalFlagLockup= 1<<1,
	cvCalFlagPersonal = 1<<2,
}cvCalFlag;

typedef enum{
	cvCalTypeWeekday,
	cvCalTypeWeekend,
	cvCalTypeToday
}cvCalType;

#define kFlagFrame0 CGRectMake(5, 5, 100, 20)
#define kFlagFrame1 CGRectMake(5, 35, 100, 20)
#define kFlagFrame2 CGRectMake(5, 65, 100, 20)

#define Conn(x,y) x##y

@interface cvCal : UIView {
	UIImageView *imgvIPO,*imgvLockup,*imgvPersonal;
	
	UILabel *lblDay;
	
	BOOL bIPO,bLockup,bPersonal;
	
	UIButton *btnCal,*btnAdd;
	
	cvCalType _calType;
	
	NSUInteger _calFlag;
}

-(id)initWithDate:(NSDate *)date;

-(void)setCalFlag:(NSUInteger)flag;
@end
