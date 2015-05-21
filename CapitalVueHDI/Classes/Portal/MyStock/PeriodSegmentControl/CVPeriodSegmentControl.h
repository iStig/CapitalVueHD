//
//  CVPeriodSegmentControl.h
//  CapitalVueHD
//
//  Created by jishen on 10/27/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CVPeriodSegmentControlDelegate

- (void)touchSegmentAtIndex:(NSUInteger)index;

@end


@interface CVPeriodSegmentControl : UIView {
	id <CVPeriodSegmentControlDelegate> delegate;

@private
	NSMutableArray *_segemnts;
	UIImage *_leftHighlight, *_normalHighlight, *_rightHighlight;
}

@property (nonatomic, assign) id <CVPeriodSegmentControlDelegate> delegate;

@property (nonatomic, assign) NSUInteger index;

@end
