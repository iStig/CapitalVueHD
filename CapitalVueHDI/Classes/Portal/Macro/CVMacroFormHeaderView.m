//
//  CVMacroFormHeaderView.m
//  CapitalVueHD
//
//  Created by jishen on 11/1/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMacroFormHeaderView.h"


@implementation CVMacroFormHeaderView

@synthesize header1;
@synthesize header2;
@synthesize header3;

@synthesize columnNumber = _columnNumber;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		header1 = [[UILabel alloc] init];
		header2 = [[UILabel alloc] init];
		header3 = [[UILabel alloc] initWithFrame:CGRectMake(429, 0, 214, 30)];
		
		header1.backgroundColor = [UIColor clearColor];
		header2.backgroundColor = [UIColor clearColor];
		header3.backgroundColor = [UIColor clearColor];
		
		header1.font = [UIFont boldSystemFontOfSize:14];
		header2.font = [UIFont boldSystemFontOfSize:14];
		header3.font = [UIFont boldSystemFontOfSize:14];
		
		header1.textColor = [UIColor whiteColor];
		header2.textColor = [UIColor whiteColor];
		header3.textColor = [UIColor whiteColor];
		
		header1.textAlignment = UITextAlignmentCenter;
		header2.textAlignment = UITextAlignmentCenter;
		header3.textAlignment = UITextAlignmentCenter;
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"portlet_macro_form_header.png" ofType:nil];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
		_imgvBack = [[UIImageView alloc] initWithImage:img];
		_imgvBack.frame = CGRectMake(0, 0, 647, 30);
		[img release];
		
		[self addSubview:header1];
		[self addSubview:header2];
		[self addSubview:header3];
		[self addSubview:_imgvBack];
		
		self.columnNumber = 3;
    }
    return self;
}

- (void)setColumnNumber:(NSInteger)number{
	_columnNumber = number;
	if (_columnNumber == 2) {
		header1.frame = CGRectMake(0, 0, 314, 30);
		header2.frame = CGRectMake(314, 0, 323, 30);
		
		header3.hidden = YES;
	} else if (_columnNumber == 3) {
		header1.frame = CGRectMake(0, 0, 202, 30);
		header2.frame = CGRectMake(204, 0, 224, 30);
		
		header3.hidden = NO;
	}
	
}

- (void)dealloc {
	[header1 release];
	[header2 release];
	[header3 release];
	
	[_imgvBack release];
	
    [super dealloc];
}


@end
