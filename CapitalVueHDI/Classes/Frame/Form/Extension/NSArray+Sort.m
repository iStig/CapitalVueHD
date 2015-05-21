//
//  NSArray+Sort.m
//  SortArray
//
//  Created by ANNA on 10-8-11.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "NSArray+Sort.h"
#import "NSString+Sort.h"

@implementation NSArray(Sort)

- (NSArray *)sortArrayWithSubIndex:(int)index ascending:(BOOL)ascending
{
	NSMutableArray* sortArray = [NSMutableArray array];
	for (int i = 0; i < [self count]; ++i)
	{
		NSArray* tmpArray = [self objectAtIndex:i];
		
		int j = 0;
		while ( j < [sortArray count] )
		{
			NSArray* currentArray = [sortArray objectAtIndex:j];
			
			NSString* tmpString = [tmpArray objectAtIndex:index];
			NSString* currentString = [currentArray objectAtIndex:index];
			
			if ( [tmpString localizedCompare:currentString] < 0 && ascending )
			{
				break;
			}
			else if ( [tmpString localizedCompare:currentString] > 0 && !ascending )
			{
				break;
			}
			++j;
		}
		[sortArray insertObject:tmpArray atIndex:j];
	}
	return sortArray;
}


@end

@implementation NSMutableArray(Sort)

- (void)sortWithSubIndex:(int)index ascending:(BOOL)ascending
{
	for (int i = 0; i < [self count]-1; ++i)
	{
		for (int j = i+1; j < [self count]; ++j) 
		{
			NSArray* tmpArray = [self objectAtIndex:i];
			NSArray* currentArray = [self objectAtIndex:j];
			
			NSString* tmpString = [tmpArray objectAtIndex:index];
			NSString* currentString = [currentArray objectAtIndex:index];
						
			NSComparisonResult result = [tmpString compareOnConsiderNumberValue:currentString];
			if ( result > 0 && ascending )
			{
				[self exchangeObjectAtIndex:i withObjectAtIndex:j];
			}
			else if ( result < 0 && !ascending )
			{
				[self exchangeObjectAtIndex:i withObjectAtIndex:j];
			}
		}
	}	
}

- (NSMutableArray *)filterWithArray:(NSArray *)filter
{
	if ( !filter )
	{
		return self;
	}
	
	NSMutableArray* filteredArray = [NSMutableArray array];
	for (int i = 0; i < [filter count]; ++i)
	{
		int index = [[filter objectAtIndex:i] intValue];
		if ( index < 0 || index >= [self count]) 
		{
			continue;
		}
		[filteredArray addObject:[self objectAtIndex:index]];
	}
	
	return filteredArray;
	
}
- (NSMutableArray *)filterWithArrayInFile:(NSString *)path
{
	if ( !path )
	{
		return self;
	}
	NSArray* filer = [[NSArray alloc] initWithContentsOfFile:path];
	return [self filterWithArray:filer];
}


@end
