//
//  CVMacroFormRowView.m
//  CapitalVueHD
//
//  Created by jishen on 9/27/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMacroFormRowView.h"

@interface CVMacroFormRowView()

@property (nonatomic, retain) UIImageView *_verticalLine1;
@property (nonatomic, retain) UIImageView *_verticalLine2;
@property (nonatomic, retain) UIImageView *_horizontalLine;

@end


@implementation CVMacroFormRowView

@synthesize dateLabel;
@synthesize valueLabel;
@synthesize growthLabel;

@synthesize _verticalLine1;
@synthesize _verticalLine2;
@synthesize _horizontalLine;

@synthesize columnNumber = _columnNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		dateLabel = [[UILabel alloc] init];
		valueLabel = [[UILabel alloc] init];
		growthLabel = [[UILabel alloc] initWithFrame:CGRectMake(424, 0, 223, 26)];
		
		dateLabel.backgroundColor = [UIColor clearColor];
		valueLabel.backgroundColor = [UIColor clearColor];
		growthLabel.backgroundColor = [UIColor clearColor];
		
		dateLabel.font = [UIFont systemFontOfSize:14];
		valueLabel.font = [UIFont systemFontOfSize:14];
		growthLabel.font = [UIFont systemFontOfSize:14];
		
		dateLabel.textColor = [UIColor whiteColor];
		valueLabel.textColor = [UIColor whiteColor];
		growthLabel.textColor = [UIColor whiteColor];
		
		dateLabel.textAlignment = UITextAlignmentCenter;
		valueLabel.textAlignment = UITextAlignmentCenter;
		growthLabel.textAlignment = UITextAlignmentCenter;
		
		NSString *path;
		UIImage *img;
		
		path = [[NSBundle mainBundle] pathForResource:@"portlet_macro_form_line.png" ofType:nil];
		img = [[UIImage alloc] initWithContentsOfFile:path];
		
		_verticalLine1 = [[UIImageView alloc] init];
		_verticalLine1.image = img;
		
		_verticalLine2 = [[UIImageView alloc] init];
		_verticalLine2.image = img;
		
		_horizontalLine = [[UIImageView alloc] init];
		_horizontalLine.image = img;
		
		[img release];
		
		[self addSubview:dateLabel];
		[self addSubview:valueLabel];
		[self addSubview:growthLabel];
		
		[self addSubview:_verticalLine1];
		[self addSubview:_verticalLine2];
		[self addSubview:_horizontalLine];
		
		self.columnNumber = 3;
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setColumnNumber:(NSInteger)number{
	_columnNumber = number;
	if (_columnNumber == 2) {
		dateLabel.frame = CGRectMake(0, 0, 313, 26);
		valueLabel.frame = CGRectMake(315, 0, 313, 26);
		_verticalLine1.frame = CGRectMake(314, 0, 1, 26);
		
		growthLabel.hidden = YES;
		_verticalLine2.hidden = YES;
	} else if (_columnNumber == 3) {
		dateLabel.frame = CGRectMake(0, 0, 194, 26);
		valueLabel.frame = CGRectMake(196, 0, 224, 26);
		
		_verticalLine1.frame = CGRectMake(195, 0, 1, 26);
		_verticalLine2.frame = CGRectMake(423, 0, 1, 26);
		growthLabel.hidden = NO;
		_verticalLine2.hidden = NO;
	}

}


- (void)dealloc {
	[dateLabel release];
	[growthLabel release];
	[valueLabel release];
	
	[_verticalLine1 release];
	[_verticalLine2 release];
	[_horizontalLine release];
	
    [super dealloc];
}


@end
