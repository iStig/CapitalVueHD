//
//  CVNewsTableViewCell.m
//  CapitalValDemo
//
//  Created by leon on 10-8-21.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVNewsTableViewCell.h"


@implementation CVNewsTableViewCell
@synthesize strTitle = _strTitle;
@synthesize strTime = _strTime;
@synthesize strThumbnail = _strThumbnail;
@synthesize labelTitle = _labelTitle;
@synthesize labelTime =_labelTime;
@synthesize imageThumbnail = _imageThumbnail;

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
		self.imageThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 15.0, 240, 148)];
		[_imageThumbnail release];
		[NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
	}
}

- (void) loadLabel{
	if(!_strThumbnail)
	{
		_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 15.0, 260.0, 35.0)];
		_labelTime  = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 55.0, 260.0, 15.0)];
	}
	else {
		_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 165.0, 260.0, 35.0)];
		_labelTime  = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 205.0, 260.0, 15.0)];
	}
	
	_labelTitle.font = [UIFont boldSystemFontOfSize:15.0];
	_labelTitle.baselineAdjustment =  UIBaselineAdjustmentAlignCenters;
	_labelTitle.textAlignment = UITextAlignmentLeft;
	_labelTitle.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
	_labelTitle.numberOfLines = 0;
	
	_labelTime.font = [UIFont systemFontOfSize:14.0];
	_labelTime.baselineAdjustment =  UIBaselineAdjustmentAlignCenters;
	_labelTime.textAlignment = UITextAlignmentLeft;
	_labelTime.textColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
	
	_labelTitle.text = _strTitle;
	_labelTime.text  = _strTime;
	
	[self.contentView addSubview:_labelTitle];
	[self.contentView addSubview:_labelTime];
}

- (void)loadImage {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSURL *url = [NSURL URLWithString:_strThumbnail];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *img = [[UIImage alloc] initWithData:imageData];
	if (nil != img) {
		UIImage *cropImage;
		CGFloat originWidth = img.size.width;
		CGFloat originHeight = img.size.height;
		CGFloat uiImageWidth = 228.0;
		CGFloat uiImageHeight = 160.0;
		if (originWidth/originHeight > uiImageWidth/uiImageHeight) {
			CGFloat cropWidth = uiImageWidth*(originHeight/uiImageHeight);
			CGFloat cropLeftWidth = (originWidth - cropWidth)/2;
			cropImage = [[img croppedImage:CGRectMake(cropLeftWidth, 0, cropWidth, originHeight)] retain];
		}else {
			CGFloat cropHeight = uiImageHeight*(originWidth/uiImageWidth);
			CGFloat cropTopHeight = (originHeight - cropHeight)/2;
			cropImage = [[img croppedImage:CGRectMake(0, cropTopHeight, originWidth, cropHeight)] retain];
		}
		[self performSelectorOnMainThread:@selector(showImage:) withObject:cropImage waitUntilDone:NO];
		[img release];
	}
	
	
	[pool release];
}

- (void)dealloc {
	[_strTitle release];
	[_strTime release];
	[_strThumbnail release];
	[_labelTitle release];
	[_labelTime release];
	[_imageThumbnail release];
    [super dealloc];
}

-(void)showImage:(UIImage *)img{
	self.imageThumbnail.image = img;
	[self.contentView addSubview:self.imageThumbnail];
	[img release];
}

@end
