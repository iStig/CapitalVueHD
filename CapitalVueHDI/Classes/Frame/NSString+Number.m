//
//  NSString+Number.m
//  CapitalVueHD
//
//  Created by Carl on 11-2-22.
//  Copyright 2011 CapitalVue. All rights reserved.
//

#import "NSString+Number.h"


@implementation NSString(Number)

/*
 *	make the english number formart with ','
 *	12345678  formart to 12,345,678
 *	1234.5678 formart to 1,234.5678
 */
-(NSString *)formatToEnNumber{
	if (self == nil) {
		return nil;
	}
	NSMutableString *tempString = [[[NSMutableString alloc] init] autorelease];
	NSArray *array = [self componentsSeparatedByString:@"."];
	
	if ([array count] > 0 && [array count] <= 2) {
		
		NSString *firstString = [array objectAtIndex:0];
		
		int length = [firstString length];
		
		//caculate how many ',' need to be added
		int times = (length-1)/3;
		int extra = (length-1)%3 + 1;
		for (int i = times-1; i >= 0; i--) {
			NSRange range = NSMakeRange(i*3+extra,3);
			NSString *sub = [firstString substringWithRange:range];
			[tempString insertString:sub atIndex:0];
			[tempString insertString:@"," atIndex:0];
		}
		
		NSRange range = NSMakeRange(0,extra);
		NSString *sub = [firstString substringWithRange:range];
		[tempString insertString:sub atIndex:0];
		
		if ([array count] == 2) {
			[tempString appendFormat:@".%@",[array objectAtIndex:1]];
		}
	}
	
	return ([tempString length] == 0) ? self : tempString;
}

-(NSString *)deFormartNumber{
	if (self == nil) {
		return nil;
	}
	NSArray *array = [self componentsSeparatedByString:@","];
	NSMutableString *tempString = [[[NSMutableString alloc] init] autorelease];
	
	for (int i = 0; i < [array count]; i++) {
		[tempString appendString:[array objectAtIndex:i]];
	}
	
	return ([tempString length] == 0) ? self : tempString;
}

@end
