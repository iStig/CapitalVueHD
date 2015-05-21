//
//  CVMacroFormRowView.h
//  CapitalVueHD
//
//  Created by jishen on 9/27/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVMacroFormRowView : UITableViewCell {
	UILabel *dateLabel;
	UILabel *valueLabel;
	UILabel *growthLabel;
	NSInteger _columnNumber;
@private
	UIImageView *_verticalLine1;
	UIImageView *_verticalLine2;
	UIImageView *_horizontalLine;
}

@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *valueLabel;
@property (nonatomic, retain) UILabel *growthLabel;

@property (nonatomic, assign) NSInteger columnNumber;

@end
