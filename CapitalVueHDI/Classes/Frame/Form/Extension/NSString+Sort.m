//
//  NSString+Sort.m
//  SortArray
//
//  Created by ANNA on 10-8-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "NSString+Sort.h"

@implementation NSString(Sort)

- (NSComparisonResult)compareOnConsiderNumberValue:(NSString *)string
{
	float selfValue, targetValue;
	NSScanner* selfScanner = [NSScanner scannerWithString:self];
	NSScanner* targetScanner = [NSScanner scannerWithString:string];
	
	if ( [selfScanner scanFloat:&selfValue] && [targetScanner scanFloat:&targetValue] )
	{
		if (selfValue > targetValue)
		{
			return NSOrderedDescending;
		}
		else if ( selfValue < targetValue )
		{
			return NSOrderedAscending;
		}
		else 
		{
			return NSOrderedSame;
		}
	}

	return [self localizedCompare:string];
}

@end
