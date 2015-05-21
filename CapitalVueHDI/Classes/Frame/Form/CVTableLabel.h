//
//  CVTableLabel.h
//  TableDesign
//
//  Created by ANNA on 10-8-10.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CVBorderType
{
	CVNoLine = 0,
	CVTopLine = 1,
	CVBottomLine = 2,
	CVLeftLine = 4,
	CVRightLine = 8
};
typedef NSUInteger CVBorderType;

@interface CVTableLabel : UILabel
{
	CVBorderType _border;
}

- (id)initWithFrame:(CGRect)rect BorderType:(CVBorderType)border;

- (void)drawInContext:(CGContextRef)context;

@end
