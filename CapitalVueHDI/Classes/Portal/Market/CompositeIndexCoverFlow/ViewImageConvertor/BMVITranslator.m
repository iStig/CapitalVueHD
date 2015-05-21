//
//  VITranslator.m
//  View2Image
//
//  Created by chuan li on 9/16/10.
//  Copyright 2010 USTC. All rights reserved.
//

#import "BMVITranslator.h"

@interface BMVITranslator()

- (void)renderSubView:(UIView *)view;

@end


@implementation BMVITranslator

@synthesize view = _view;

- (void)dealloc
{
	[_view release];
	
	[super dealloc];
}

- (UIImage *)imageFromView:(UIView *)view
{
	self.view = view;
	UIGraphicsBeginImageContext(view.bounds.size);
	_context = UIGraphicsGetCurrentContext();
	[view.layer renderInContext:_context];
	
	[self renderSubView:view];
	UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

- (void)renderSubView:(UIView *)view
{
	for ( UIView* subView in [view subviews] )
	{
		if (subView.frame.size.width < 1.0 || subView.frame.size.height < 1.0)
		{
			continue;
		}
		UIGraphicsBeginImageContext(subView.bounds.size);
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		if ([subView.layer contentsAreFlipped]) 
		{
			CGContextTranslateCTM(context, 0.0f, subView.bounds.size.height);
			CGContextScaleCTM(context, 1.0f, -1.0f);
		}
		[subView.layer renderInContext:context];
		UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		CGRect imageRect = [subView.superview convertRect:subView.frame toView:self.view];
		CGContextDrawImage(_context, imageRect, [subImage CGImage]);
		
		[self renderSubView:subView];
	}
}

@end
