//
//  CVParamInfo.h
//  CapitalVueHD
//
//  Created by jishen on 11/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CVParamInfo : NSObject {
	NSInteger minutes;
@private
	NSObject *_parameters;
}

@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, retain) NSObject *parameters;

@end
