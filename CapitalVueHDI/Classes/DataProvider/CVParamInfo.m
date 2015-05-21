//
//  CVParamInfo.m
//  CapitalVueHD
//
//  Created by jishen on 11/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVParamInfo.h"


@implementation CVParamInfo

@synthesize minutes;
@synthesize parameters = _parameters;

- (void)dealloc {
	[_parameters release];
	[super dealloc];
}

- (void)setParameters:(NSObject *)parameters {
	if (_parameters) {
		[_parameters release];
	}
	_parameters = [parameters retain];
}

@end
