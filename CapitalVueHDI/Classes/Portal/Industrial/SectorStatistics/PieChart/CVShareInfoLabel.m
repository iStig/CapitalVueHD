//
//  CVShareInfoLabel.m
//  PieChart
//
//  Created by ANNA on 10-9-19.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVShareInfoLabel.h"


@implementation CVShareInfoLabel

- (CGSize)sizeThatFits:(CGSize)size
{
	CGSize bestSize = [super sizeThatFits:size];
	return CGSizeMake(bestSize.width, size.height);
}

@end
