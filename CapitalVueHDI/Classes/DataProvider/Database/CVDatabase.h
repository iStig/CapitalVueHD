//
//  CVDatabase.h
//  CapitalVueHD
//
//  Created by jishen on 9/28/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CVDatabase : NSObject {

}

+ (CVDatabase *)openDatabase;
+ (void)closeDatabase;

- (void)insertEquityCodes:(NSArray *)equityCodes columns:(NSArray *)columns;

- (NSDictionary *)getEnquityCodes;

/*
 * It get the specified data from the remote server. And return the data in dictionary format
 *
 * @param: api -  the name of api
 *         parameters - paramters of the api structured in array
 * @return: none
 */
- (NSDictionary *)getData:(NSString *)api args:(NSArray *)parameters;

- (void)insertData:(NSDictionary *) ofApi:(NSString *)api andArgs:(NSArray *)paramters;

@end
