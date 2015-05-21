//
//  NSArray+Sort.h
//  SortArray
//
//  Created by ANNA on 10-8-11.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray(Sort)

- (NSArray *)sortArrayWithSubIndex:(int)index ascending:(BOOL)ascending;

@end

@interface NSMutableArray(Sort)

- (void)sortWithSubIndex:(int)index ascending:(BOOL)ascending;
- (NSMutableArray *)filterWithArray:(NSArray *)array;
- (NSMutableArray *)filterWithArrayInFile:(NSString *)path;

@end

