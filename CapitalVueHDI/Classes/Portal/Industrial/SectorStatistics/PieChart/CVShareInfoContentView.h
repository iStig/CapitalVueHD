//
//  CVShareInfoContentView.h
//  PieChart
//
//  Created by ANNA on 10-9-19.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVShareInfoContentView : UIView 
{
	float fLinePosX;

}
@property float fLinePosX;

- (void)drawInContext:(CGContextRef)context;

@end
