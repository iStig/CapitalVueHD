/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#import "AFItemView.h"
#import <QuartzCore/QuartzCore.h>
#import "AFOpenFlowConstants.h"


@implementation AFItemView
@synthesize number, imageView, horizontalPosition, verticalPosition;
@synthesize contentView;

- (id)initWithFrame:(CGRect)frame 
{
	if (self = [super initWithFrame:frame]) 
	{
		self.opaque = YES;
		self.backgroundColor = NULL;
		verticalPosition = 0;
		horizontalPosition = 0;
		
		// Image View
		imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView.opaque = YES;
		[self addSubview:imageView];
		

	}
	
	return self;
}

- (void)setImage:(UIImage *)newImage 
originalImageHeight:(CGFloat)imageHeight 
reflectionFraction:(CGFloat)reflectionFraction
{
//	UIImage *oldImage = [newImage retain];
//	UIImageView *oldImageView = [imageView retain];
	[imageView setImage:newImage];
//	[newImage release];
	verticalPosition = imageHeight * reflectionFraction / 2;
	originalImageHeight = imageHeight;
	self.frame = CGRectMake(0, 0, newImage.size.width, newImage.size.height);
//	[oldImage release];
//	[oldImageView release];
}

#define CONTENT_VIEW_TAG 2011
- (void)setContentView:(UIView *)view {
	UIView *oldView;
	
	oldView = [self viewWithTag:CONTENT_VIEW_TAG];
	if (nil != oldView) {
		[oldView removeFromSuperview];
//dream's changre		[oldView release];
	}
	view.tag = CONTENT_VIEW_TAG;
	[self addSubview:view];
	self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
}

- (void)setNumber:(int)newNumber {
	horizontalPosition = COVER_SPACING * newNumber;
	number = newNumber;
}

- (CGSize)calculateNewSize:(CGSize)baseImageSize boundingBox:(CGSize)boundingBox {
	CGFloat boundingRatio = boundingBox.width / boundingBox.height;
	CGFloat originalImageRatio = baseImageSize.width / baseImageSize.height;
	
	CGFloat newWidth;
	CGFloat newHeight;
	if (originalImageRatio > boundingRatio) {
		newWidth = boundingBox.width;
		newHeight = boundingBox.width * baseImageSize.height / baseImageSize.width;
	} else {
		newHeight = boundingBox.height;
		newWidth = boundingBox.height * baseImageSize.width / baseImageSize.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (void)setFrame:(CGRect)newFrame {
	[super setFrame:newFrame];
	[imageView setFrame:newFrame];
}

- (void)dealloc 
{
	[imageView release];
	[contentView release];
	
	[super dealloc];
}

@end