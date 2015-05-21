//
//  CVTodaysNewsTableViewCell.m
//  CapitalValDemo
//
//  Created by leon on 10-8-21.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVTodaysNewsTableViewCell.h"


@implementation CVTodaysNewsTableViewCell
@synthesize strTitle = _strTitle;
@synthesize strTime = _strTime;
@synthesize strThumbnail = _strThumbnail;
@synthesize labelTitle = _labelTitle;
@synthesize labelTime =_labelTime;
@synthesize imageThumbnail = _imageThumbnail;
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
//        // Initialization code
//    }
//    return self;
//}
//
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
- (void) removeElement{
	[_labelTitle removeFromSuperview];
	[_labelTime removeFromSuperview];
	[_imageThumbnail removeFromSuperview];
	
	_labelTitle = nil;
	_labelTime = nil;
	_imageThumbnail = nil;
}

- (void) addElement{
	[self loadLabel];
	if (_strThumbnail) {
		[NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
	}
}

- (void) loadLabel{
	if(!_strThumbnail)
	{
		_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 260.0, 40.0)];
		_labelTime  = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 50.0, 260.0, 30.0)];
	}
	else {
		_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 130.0, 260.0, 40.0)];
		_labelTime  = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 180.0, 260.0, 30.0)];
	}

	
	
	_labelTitle.font = [UIFont systemFontOfSize:15.0];
	_labelTitle.baselineAdjustment =  UIBaselineAdjustmentAlignCenters;
	_labelTitle.textAlignment = UITextAlignmentLeft;
	_labelTitle.textColor = [UIColor blackColor];
	_labelTitle.numberOfLines = 0;
	
	_labelTime.font = [UIFont systemFontOfSize:14.0];
	_labelTime.baselineAdjustment =  UIBaselineAdjustmentAlignCenters;
	_labelTime.textAlignment = UITextAlignmentLeft;
	_labelTime.textColor = [UIColor blackColor];
	
	_labelTitle.text = _strTitle;
	_labelTime.text  = _strTime;
	
	[self.contentView addSubview:_labelTitle];
	[self.contentView addSubview:_labelTime];
}

- (void)loadImage {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_imageThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 5.0, 260, 128)];
	NSURL *url = [NSURL URLWithString:_strThumbnail];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *img = [[UIImage alloc] initWithData:imageData];
	if (nil != img) {
		_imageThumbnail.image = img;
		[self.contentView addSubview:_imageThumbnail];
	}
	[img release];
	
	[pool release];
}

- (void)dealloc {
	[_strTitle release];
	[_strTime release];
	[_strThumbnail release];
	[_labelTitle release];
	[_labelTime release];
	_imageThumbnail;
    [super dealloc];
}


@end
