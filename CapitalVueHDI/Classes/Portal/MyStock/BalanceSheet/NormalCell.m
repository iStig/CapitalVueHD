//
//  NormalCell.m
//  CapitalVueHD
//
//  Created by jishen on 10/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "NormalCell.h"


@implementation NormalCell

@synthesize titleLabel;
@synthesize delimiter;
@synthesize valueLabel;

@synthesize cellHeight;
@synthesize titleIndent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[titleLabel release];
	[delimiter release];
	[valueLabel release];
    [super dealloc];
}

- (void)setCellHeight:(CGFloat)h {
	self.delimiter.frame = CGRectMake(delimiter.frame.origin.x,
									  delimiter.frame.origin.y, 
									  delimiter.frame.size.width,
									  h);
	self.titleLabel.frame = CGRectMake(titleLabel.frame.origin.x,
									   titleLabel.frame.origin.y, 
									   titleLabel.frame.size.width, 
									   h);
	self.valueLabel.frame = CGRectMake(valueLabel.frame.origin.x,
									   valueLabel.frame.origin.y, 
									   valueLabel.frame.size.width, 
									   h);
}

- (void)setTitleIndent:(CGFloat)i {
	self.titleLabel.frame = CGRectMake(titleLabel.frame.origin.x + i,
									   titleLabel.frame.origin.y, 
									   titleLabel.frame.size.width - i,
									   titleLabel.frame.size.height);
}

@end
