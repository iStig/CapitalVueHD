//
//  CVWebServiceAgent.h
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Encrypt.h"
#import <stdlib.h>
@interface CVWebServiceAgent : NSObject <NSXMLParserDelegate> {
@private
	NSString *m_element;
	NSString *m_key;
	NSString *m_value;
	NSMutableArray *m_array;
	NSMutableDictionary *m_rootObject;
	NSMutableDictionary *m_object;
}


/*
 * It get the specified data from the remote server. And return the data in dictionary format
 *
 * @param: api -  the name of api
 *         parameters - paramters of the api structured in array
 * @return: none
 */
- (NSDictionary *)GetData:(NSString *)api args:(NSArray *)parameters;
- (NSString *)serviceUrl:(NSString *)api args:(NSArray *)paramters;

@end
