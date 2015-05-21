//
//  UIView+FrameAdjust.m
//  TableDesign
//
//  Created by ANNA on 10-8-10.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "UIView+FrameAdjust.h"


@implementation UIView(FrameAdjust)

- (void)setPosX:(float_t)posx
{
	self.frame = CGRectMake(posx, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setPosY:(float_t)poxy
{
	self.frame = CGRectMake(self.frame.origin.x, poxy, self.frame.size.width, self.frame.size.height);
}

- (void)setWidth:(float_t)width
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(float_t)height
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

@end
