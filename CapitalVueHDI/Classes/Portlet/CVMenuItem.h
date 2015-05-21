//
//  CVMenuItem.h
//  CapitalVueHD
//
//  Created by jishen on 9/3/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CVMenuItem : NSObject {
	NSString *title;
	NSString *name;
	BOOL select;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) BOOL select;

@end
