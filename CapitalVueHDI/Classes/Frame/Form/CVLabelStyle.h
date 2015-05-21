//
//  CVLabelStyle.h
//  TableDesign
//
//  Created by ANNA on 10-8-10.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CVLabelStyle : NSObject 
{
	UIFont* font;
	UIColor* foreColor;
	UIColor* backColor;
	UITextAlignment textAlign;
}

@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) UIColor* foreColor;
@property (nonatomic, retain) UIColor* backColor;
@property (nonatomic, assign) UITextAlignment textAlign;

-(id)cloneOne;

@end
