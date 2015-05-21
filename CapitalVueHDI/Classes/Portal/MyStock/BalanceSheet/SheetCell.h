//
//  SheetCell.h
//  CapitalVueHD
//
//  Created by jishen on 10/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SheetCell : NSObject {
	NSUInteger type;
	BOOL isHeader;
	NSString *title;
	NSString *value;
}

@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *value;

@end
