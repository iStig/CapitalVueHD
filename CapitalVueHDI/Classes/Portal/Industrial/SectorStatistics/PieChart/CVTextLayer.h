//
//  CVTextLayer.h
//  TextContext
//
//  Created by ANNA on 10-9-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CVTextLayer : CALayer
{
	NSString* _text;
	UIFont*	  _font;
	UIColor*  _textColor;
	
	CGFloat   _angle;
}

@property (nonatomic, copy) NSString* text;
@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) UIColor* textColor;
@property (nonatomic, assign) CGFloat	angle;

@end
