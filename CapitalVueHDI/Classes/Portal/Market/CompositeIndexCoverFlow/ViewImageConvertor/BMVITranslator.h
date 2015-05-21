//
//  VITranslator.h
//  View2Image
//
//  Created by chuan li on 9/16/10.
//  Copyright 2010 USTC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BMVITranslator : NSObject 
{
	UIView*	_view;
	CGContextRef	_context;
}

@property (nonatomic, retain) UIView*	view;

- (UIImage *)imageFromView:(UIView *)view;

@end
