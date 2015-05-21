//
//  CVDataAnalyzer.m
//  CapitalVueHD
//
//  Created by jishen on 8/25/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVDataAnalyzer.h"

@interface CVDataAnalyzer ()

/*
 * It converts the NSDictionary-formatted data to an array. 
 * Each element of array carries a piece of news.
 *
 * @param: data - raw data
 * @return: news list
 */
+ (NSDictionary *)analyzeNewsDetail:(NSDictionary *)data;           //get detail news by a post_id
+ (NSDictionary *)analyzeTodayNewsList:(NSDictionary *)data;
+ (NSDictionary *)analyzeStockDetail:(NSDictionary *)data;          //add by leon
+ (NSDictionary *)analyzeStockInTheNews:(NSDictionary *)data;

/*
 * It analyze the data with the data format like below
 *
 * root = {
 *   language =  {
 *     node =  (
 *      {
 *        name = "aa";
 *        value = " GAINERS";
 *      },
 *      ......
 *      ......
 *      {
 *        name = "bbb";
 *        value = SECTOR;
 *      }
 *
 *     );
 *   };
 *   result =  {
 *     row = (
 *       {
 *         node = (
 *           {
 *             name = "aa";
 *             value = "13.57";
 *           },
 *           ......
 *           ......
 *           {
 *             name = "bbb";
 *             value = "Consumer Discretionary";
 *           }
 *         );
 *       },
 *       ......
 *       ......
 *       {
 *         node = (
 *           {
 *             name = "aa";
 *             value = "10.57";
 *           }
 *           ......
 *           ......
 *           {
 *             name = "bbb";
 *             value = "Consumer Staples";
 *           }
 *        );
 *      }
 *    )
 * }
 *
 *
 * It returns the dictionary with format like below.
 *
 * head = (
 *   {
 *     name = "aa";
 *     value = " GAINERS";
 *   },
 *   ......
 *   ......
 *   {
 *     name = "bbb";
 *     value = SECTOR;
 *   }
 * )
 * data = (
 *   {
 *     "aa" = "10.57";
 *     ......
 *     ......
 *     "bbb" = "Consumer Staples";
 *   }
 *   ......
 *   ......
 *   {
 *     "aa" = "13.57";
 *     ......
 *     ......
 *     "bbb" = "Consumer Discretionary";
 *   }
 * )
 *
 * @param: data - input data to be analyzed
 * @return: dictionary
 */
+ (NSDictionary *)analyzeFormFormatData:(NSDictionary *)data;

/*
 * It analyzes the data contains gainers and decliners organized in
 * one array, and split the data into two arrays, an array of gainers
 * with key "gainers" and an array of decliners with key "decliners"
 *
 * @param: data - input data to be analyzed
 * @return: dictionary
 */
+ (NSDictionary *)analyzeTopGainersDecliners:(NSDictionary *)data;

+ (NSDictionary *)analyzeCadaData:(NSDictionary *)data;

@end



@implementation CVDataAnalyzer

#pragma mark private methods

+ (NSDictionary *)analyzeNewsDetail:(NSDictionary *)data{
	NSDictionary *dictTemp;
	NSMutableDictionary *newDict;
	
	//todayNewsDict = nil;
	newDict = nil;
	dictTemp = nil;
	
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp valueForKey:@"portlet"];
	if (nil != dictTemp) {
		if (nil != dictTemp) {
			NSDictionary *dict = [dictTemp objectForKey:@"row"];
			
			NSDictionary *valueDict;
			NSObject *object;
			newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
			valueDict = [dict objectForKey:@"post_id"];
			if (valueDict) {
				object = [valueDict objectForKey:@"value"];
				if (object) {
					[newDict setObject:object forKey:@"post_id"];
				}
			}
			valueDict = [dict objectForKey:@"title"];
			if (valueDict) {
				object = [valueDict objectForKey:@"value"];
				if (object) {
					[newDict setObject:object forKey:@"title"];
				}
			}
			valueDict = [dict objectForKey:@"body"];
			if (valueDict) {
				object = [valueDict objectForKey:@"value"];
				if (object) {
					[newDict setObject:object forKey:@"body"];
				}
			}
			valueDict = [dict objectForKey:@"poststat_setid"];  
			if (valueDict) {
				object = [valueDict objectForKey:@"value"];
				if(object)
					[newDict setObject:object forKey:@"poststat_setid"];
			}
			valueDict = [dict objectForKey:@"t_stamp"];
			if (valueDict) {
				object = [valueDict objectForKey:@"value"];
				if(object){
					[newDict setObject:object forKey:@"t_stamp"];
				}
			}
			valueDict = [dict objectForKey:@"thumbUrl"];
			if (valueDict) {
				object = [valueDict objectForKey:@"value"];
				if(object){
					[newDict setObject:object forKey:@"thumbUrl"];
				}
			}
			
			id valueObj;
			valueDict = [dict objectForKey:@"tag_list"];
			if (valueDict)
				valueObj = [valueDict objectForKey:@"row"];
			if ([valueObj isKindOfClass:[NSDictionary class]]) {
				NSDictionary *d;
				d = (NSDictionary *)valueObj;
				object = [d objectForKey:@"value"];
				if (object)
					[newDict setObject:object forKey:@"tag_list_index_0"];
			} else if ([valueObj isKindOfClass:[NSArray class]]) {
				NSDictionary *d;
				NSArray *a;
				a = (NSArray *)valueObj;
				d = [a objectAtIndex:0];
				object = [d objectForKey:@"value"];
				if (object)
					[newDict setObject:object forKey:@"tag_list_index_0"];
			}
		}
	}
	return [newDict autorelease];
}
/*
 * It converts the NSDictionary-formatted data to an array. 
 * Each element of array carries a piece of news.
 *
 * @param: data - raw data
 * @return: news list
 */
+ (NSDictionary *)analyzeTodayNewsList:(NSDictionary *)data {
	NSDictionary *dictTemp;
	NSDictionary *todayNewsDict;
	
	NSString *token;
	NSMutableArray *newList;
	
	token = nil;
	newList = nil;
	todayNewsDict = nil;
	dictTemp = nil;
	
	// get token
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"token"];
	token = [dictTemp objectForKey:@"value"];
	// get data
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp valueForKey:@"portlet"];
	if (nil != dictTemp) {
		NSArray *array = nil;
		NSDictionary *dictionary = nil;
		NSObject *obj = [dictTemp objectForKey:@"row"];
		if ([obj isKindOfClass:[NSDictionary class]]) {
			dictionary = (NSDictionary *)obj;
		} else if ([obj isKindOfClass:[NSArray class]]) {
			array = (NSArray *)obj;
		}
		
		if (nil != array) {
			NSDictionary *rowDict;
			NSDictionary *valueDict;
			NSObject *object;
			NSMutableDictionary *newDict;
			
			newList = [[NSMutableArray alloc] initWithCapacity:1];
			
			for (rowDict in array) {
				// FIXME
				if ([rowDict isKindOfClass:[NSDictionary class]]) {
				newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
				valueDict = [rowDict objectForKey:@"post_id"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"post_id"];
				}
				valueDict = [rowDict objectForKey:@"title"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"title"];
				}
				valueDict = [rowDict objectForKey:@"body"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"body"];
				}
				valueDict = [rowDict objectForKey:@"ownername"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"ownername"];
				}
				valueDict = [rowDict objectForKey:@"t_stamp"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"t_stamp"];
				}
				valueDict = [rowDict objectForKey:@"poststat_groupid"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"poststat_groupid"];
				}
				valueDict = [rowDict objectForKey:@"poststat_groupdn"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"poststat_groupdn"];
				}
				valueDict = [rowDict objectForKey:@"summary"];
				if (valueDict) {
					//object = [valueDict objectForKey:@"value"];
					[newDict setObject:valueDict forKey:@"summary"];
				}
				
				id valueObj;
				valueDict = [rowDict objectForKey:@"tag_list"];
				if (valueDict)
					valueObj = [valueDict objectForKey:@"row"];
				if ([valueObj isKindOfClass:[NSDictionary class]]) {
					NSDictionary *d;
					d = (NSDictionary *)valueObj;
					object = [d objectForKey:@"value"];
					if (object)
						[newDict setObject:object forKey:@"tag_list_index_0"];
				} else if ([valueObj isKindOfClass:[NSArray class]]) {
					NSDictionary *d;
					NSArray *a;
					a = (NSArray *)valueObj;
					d = [a objectAtIndex:0];
					object = [d objectForKey:@"value"];
					if (object)
						[newDict setObject:object forKey:@"tag_list_index_0"];
				}
				valueDict = [rowDict objectForKey:@"poststat_setid"];   //leon changed
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"poststat_setid"];
				}
				
				valueDict = [rowDict objectForKey:@"url"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"url"];
				}
				valueDict = [rowDict objectForKey:@"text_body"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"text_body"];
				}
				valueDict = [rowDict objectForKey:@"thumbUrl"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"thumbUrl"];
				}
				valueDict = [rowDict objectForKey:@"thumbWidth"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"thumbWidth"];
				}
				valueDict = [rowDict objectForKey:@"thumbHeight"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"thumbHeight"];
				}
				valueDict = [rowDict objectForKey:@"smallUrl"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"smallUrl"];
				}
				valueDict = [rowDict objectForKey:@"smallWidth"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"smallWidth"];
				}
				valueDict = [rowDict objectForKey:@"smallHeight"];
				if (valueDict) {
					object = [valueDict objectForKey:@"value"];
					if(object)
						[newDict setObject:object forKey:@"smallHeight"];
				}
				[newList addObject:newDict];
				[newDict release];
				}
			}
		} else if (nil != dictionary) {
			NSDictionary *rowDict;
			NSDictionary *valueDict;
			NSObject *object;
			NSMutableDictionary *newDict;
			
			newList = [[NSMutableArray alloc] initWithCapacity:1];
			rowDict = dictionary;
				// FIXME
			if ([rowDict isKindOfClass:[NSDictionary class]]) {
					newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
					valueDict = [rowDict objectForKey:@"post_id"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"post_id"];
					}
					valueDict = [rowDict objectForKey:@"title"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"title"];
					}
					valueDict = [rowDict objectForKey:@"body"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"body"];
					}
					valueDict = [rowDict objectForKey:@"ownername"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"ownername"];
					}
					valueDict = [rowDict objectForKey:@"t_stamp"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"t_stamp"];
					}
					valueDict = [rowDict objectForKey:@"poststat_groupid"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"poststat_groupid"];
					}
					valueDict = [rowDict objectForKey:@"poststat_groupdn"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"poststat_groupdn"];
					}
					valueDict = [rowDict objectForKey:@"summary"];
					if (valueDict) {
						[newDict setObject:valueDict forKey:@"summary"];
					}
					
					id valueObj;
					valueDict = [rowDict objectForKey:@"tag_list"];
					if (valueDict)
						valueObj = [valueDict objectForKey:@"row"];
					if ([valueObj isKindOfClass:[NSDictionary class]]) {
						NSDictionary *d;
						d = (NSDictionary *)valueObj;
						object = [d objectForKey:@"value"];
						if (object)
							[newDict setObject:object forKey:@"tag_list_index_0"];
					} else if ([valueObj isKindOfClass:[NSArray class]]) {
						NSDictionary *d;
						NSArray *a;
						a = (NSArray *)valueObj;
						d = [a objectAtIndex:0];
						object = [d objectForKey:@"value"];
						if (object)
							[newDict setObject:object forKey:@"tag_list_index_0"];
					}
					valueDict = [rowDict objectForKey:@"poststat_setid"];   //leon changed
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"poststat_setid"];
					}
					
					valueDict = [rowDict objectForKey:@"url"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"url"];
					}
					valueDict = [rowDict objectForKey:@"text_body"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"text_body"];
					}
					valueDict = [rowDict objectForKey:@"thumbUrl"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"thumbUrl"];
					}
					valueDict = [rowDict objectForKey:@"thumbWidth"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"thumbWidth"];
					}
					valueDict = [rowDict objectForKey:@"thumbHeight"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"thumbHeight"];
					}
					valueDict = [rowDict objectForKey:@"smallUrl"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"smallUrl"];
					}
					valueDict = [rowDict objectForKey:@"smallWidth"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"smallWidth"];
					}
					valueDict = [rowDict objectForKey:@"smallHeight"];
					if (valueDict) {
						object = [valueDict objectForKey:@"value"];
						if(object)
							[newDict setObject:object forKey:@"smallHeight"];
					}
					[newList addObject:newDict];
					[newDict release];
			}	
		}

	}
	
	if (token != nil && newList != nil) {
		todayNewsDict = [[[NSDictionary alloc] initWithObjectsAndKeys:newList, @"data", token, @"token", nil] autorelease];
		
	}	
	[newList release];
	
	return todayNewsDict;
}

+ (NSDictionary *)analyzeStockInTheNews:(NSDictionary *)data {
	NSDictionary *dictTemp;
	NSMutableDictionary *stockDict;
	NSString *token;
	NSMutableArray *newList;
	
	stockDict = [[NSMutableDictionary alloc] initWithCapacity:1];
	
	token = nil;
	newList = nil;
	dictTemp = nil;
	
	// get token
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"token"];
	token = [dictTemp objectForKey:@"value"];
	if (token) {
		[stockDict setObject:token forKey:@"token"];
	}
	// get the value
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"result"];
	NSArray *dataList = [dictTemp objectForKey:@"row"];
	if (dataList != nil) {
		NSDictionary *dataElement;
		NSMutableDictionary *newElement;
		
		newList = [[NSMutableArray alloc] initWithCapacity:1];
		
		for (dataElement in dataList) {
			NSArray *keys;
			keys = [dataElement allKeys];
			
			NSString *key;
			id value;
			newElement = [[NSMutableDictionary alloc] initWithCapacity:1];
			for (key in keys) {
				value = [dataElement objectForKey:key];
				if ([value isKindOfClass:[NSMutableDictionary class]]) {
					id obj = [value objectForKey:@"value"]; 
					if (nil != obj)
						[newElement setObject:obj forKey:key];
				} else {
					[newElement setObject:value forKey:key];
				}
			}
			[newList addObject:newElement];
			[newElement release];
		}
		
		
		[stockDict setObject:newList forKey:@"data"];
		[newList release];
	}
	
	return [stockDict autorelease];
}

/*
 * It analyzes the data contains gainers and decliners organized in
 * one array, and split the data into two arrays, an array of gainers
 * with key "gainers" and an array of decliners with key "decliners".
 *
 * @param: data - input data to be analyzed
 * @return: dictionary
 */
+ (NSDictionary *)analyzeTopGainersDecliners:(NSDictionary *)data {
	NSDictionary *dictTemp;
	NSMutableDictionary *returnDict;
	NSMutableArray *headList;
	NSMutableArray *gainersList;
	NSMutableArray *declinersList;
	
	returnDict = nil;
	
	// get the definition of each keys, which are taken as titles of a form
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"language"];
	if (dictTemp != nil) {
		headList = [dictTemp objectForKey:@"node"];
	}
	
	// get the value
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"result"];
	NSArray *values = [dictTemp objectForKey:@"row"];
	
	if (dictTemp != nil) {
		NSDictionary *dict;
		
		gainersList = [[NSMutableArray alloc] initWithCapacity:1];
		declinersList = [[NSMutableArray alloc] initWithCapacity:1];
		for (dict in values) {
			NSArray *nodeArray;
			NSDictionary *nodeDict;
			
			NSMutableDictionary *newDict;
			
			NSString *name;
			NSString *value;
			float change;
			
			newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
			
			nodeArray = [dict objectForKey:@"node"];
			for (nodeDict in nodeArray) {
				name = [nodeDict valueForKey:@"name"];
				value = [nodeDict valueForKey:@"value"];
				
				// the value of change
				if ([name isEqualToString:@"日涨跌幅"]) {
					change = [value floatValue];
				}
				
				if (name && value) {
					[newDict setObject:value forKey:name];
				}
			}
			
			// put the dict to array accroding to 
			// the change
			if (change > 0) {
				[gainersList addObject:newDict];
			} else {
				[declinersList addObject:newDict];
			}
			[newDict release];
		}
		
		
		
		returnDict = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];

		// set the gainersList, declinersList and headList
		[returnDict setObject:gainersList forKey:@"gainers"];
		[gainersList release];
		[returnDict setObject:declinersList forKey:@"decliners"];
		[declinersList release];
		
		if (nil != headList) {
			[returnDict setObject:headList forKey:@"head"];
		}
	}
	
	return returnDict;
}

/*
 * It analyze the data with the data format like below
 *
 * root = {
 *   language =  {
 *     node =  (
 *      {
 *        name = "aa";
 *        value = " GAINERS";
 *      },
 *      ......
 *      ......
 *      {
 *        name = "bbb";
 *        value = SECTOR;
 *      }
 *
 *     );
 *   };
 *   result =  {
 *     row = (
 *       {
 *         node = (
 *           {
 *             name = "aa";
 *             value = "13.57";
 *           },
 *           ......
 *           ......
 *           {
 *             name = "bbb";
 *             value = "Consumer Discretionary";
 *           }
 *         );
 *       },
 *       ......
 *       ......
 *       {
 *         node = (
 *           {
 *             name = "aa";
 *             value = "10.57";
 *           }
 *           ......
 *           ......
 *           {
 *             name = "bbb";
 *             value = "Consumer Staples";
 *           }
 *        );
 *      }
 *    )
 * }
 *
 *
 * It returns the dictionary with format like below.
 *
 * head = (
 *   {
 *     name = "aa";
 *     value = " GAINERS";
 *   },
 *   ......
 *   ......
 *   {
 *     name = "bbb";
 *     value = SECTOR;
 *   }
 * )
 * data = (
 *   {
 *     "aa" = "10.57";
 *     ......
 *     ......
 *     "bbb" = "Consumer Staples";
 *   }
 *   ......
 *   ......
 *   {
 *     "aa" = "13.57";
 *     ......
 *     ......
 *     "bbb" = "Consumer Discretionary";
 *   }
 * )
 *
 * @param: data - input data to be analyzed
 * @return: dictionary
 */

+ (NSDictionary *)analyzeStockDetail:(NSDictionary *)data{
	NSDictionary *dictTemp;
	NSMutableDictionary *returnDict;
	NSMutableArray *headList;
	NSMutableArray *dataList;
	
	returnDict = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
	
	// get the definition of each keys, which are taken as titles of a form
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"language"];
	if (dictTemp != nil) {
		headList = [dictTemp objectForKey:@"node"];
		[returnDict setObject:headList forKey:@"head"];
	}
	
	// get the value
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"result"];
	NSObject *obj = [dictTemp objectForKey:@"row"];
	
	if (obj != nil) {
		if ([obj isKindOfClass:[NSDictionary class]]) {			
			NSArray *nodeArray;
			NSDictionary *values, *nodeDict;
			
			NSMutableDictionary *newDict;
			
			NSString *name;
			NSString *value;
			
			values = (NSDictionary *)obj;
			dataList = [[NSMutableArray alloc] initWithCapacity:1];
			newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
			
			nodeArray = [values objectForKey:@"node"];
			for (nodeDict in nodeArray) {
				name = [nodeDict valueForKey:@"name"];
				value = [nodeDict valueForKey:@"value"];
				
				if (name && value) {
					[newDict setObject:value forKey:name];
				}
			}
			
			[dataList addObject:newDict];
			[newDict release];
			[returnDict setObject:dataList forKey:@"data"];
			[dataList release];
		} else {
			NSDictionary *dict;
			NSArray *values;
			
			values = (NSArray *)obj;
			dataList = [[NSMutableArray alloc] initWithCapacity:1];
			for (dict in values) {
				NSArray *nodeArray;
				NSDictionary *nodeDict;
				
				NSMutableDictionary *newDict;
				
				NSString *name;
				NSString *value;
				
				newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
				
				nodeArray = [dict objectForKey:@"node"];
				for (nodeDict in nodeArray) {
					name = [nodeDict valueForKey:@"name"];
					value = [nodeDict valueForKey:@"value"];
					
					if (name && value) {
						[newDict setObject:value forKey:name];
					}
				}
				
				[dataList addObject:newDict];
				[newDict release];
			}
			
			[returnDict setObject:dataList forKey:@"data"];
			[dataList release];
		}
	}
	return returnDict;
}

+ (NSDictionary *)analyzeFormFormatData:(NSDictionary *)data {
	NSDictionary *dictTemp;
	NSMutableDictionary *returnDict;
	NSMutableArray *headList;
	NSMutableArray *dataList;
	
	returnDict = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
	
	// get the definition of each keys, which are taken as titles of a form
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"language"];
	if (dictTemp != nil) {
		headList = [dictTemp objectForKey:@"node"];
		[returnDict setObject:headList forKey:@"head"];
	}
	
	// get the value
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"result"];
	NSObject *obj = [dictTemp objectForKey:@"row"];
	
	if (obj != nil) {
		if ([obj isKindOfClass:[NSDictionary class]]) {			
			NSArray *nodeArray;
			NSDictionary *values, *nodeDict;
			
			NSMutableDictionary *newDict;
			
			NSString *name;
			NSString *value;
			
			values = (NSDictionary *)obj;
			dataList = [[NSMutableArray alloc] initWithCapacity:1];
			newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
			
			nodeArray = [values objectForKey:@"node"];
			for (nodeDict in nodeArray) {
				name = [nodeDict valueForKey:@"name"];
				value = [nodeDict valueForKey:@"value"];
				
				if (name && value) {
					[newDict setObject:value forKey:name];
				}
			}
			
			[dataList addObject:newDict];
			[newDict release];
			[returnDict setObject:dataList forKey:@"data"];
			[dataList release];
		} else {
			NSDictionary *dict;
			NSArray *values;
		
			values = (NSArray *)obj;
			dataList = [[NSMutableArray alloc] initWithCapacity:1];
			for (dict in values) {
				NSArray *nodeArray;
				NSDictionary *nodeDict;
			
				NSMutableDictionary *newDict;
			
				NSString *name;
				NSString *value;
			
				newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
			
				nodeArray = [dict objectForKey:@"node"];
				for (nodeDict in nodeArray) {
					name = [nodeDict valueForKey:@"name"];
					value = [nodeDict valueForKey:@"value"];
				
					if (name && value) {
						[newDict setObject:value forKey:name];
					}
				}
			
				[dataList addObject:newDict];
				[newDict release];
			}
		
			[returnDict setObject:dataList forKey:@"data"];
			[dataList release];
		}
	}
	return returnDict;
}

+ (NSDictionary *)analyzeCadaData:(NSDictionary *)data {
	NSDictionary *dictTemp;
	NSMutableDictionary *returnDict;
	NSMutableArray *headList;
	NSMutableArray *dataList;
	
	returnDict = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
	
	// get the definition of each keys, which are taken as titles of a form
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"language"];
	if (dictTemp != nil) {
		NSMutableDictionary *head, *headDict;
		headList = [dictTemp objectForKey:@"node"];
		
		// convert headList to headDict
		if (nil != headList) {
			NSString *key;
			NSString *value;
			
			headDict = [[NSMutableDictionary alloc] initWithCapacity:1];
			for (head in headList) {
				key = [head objectForKey:@"name"];
				value = [head objectForKey:@"value"];
				
				if (key && value)
					[headDict setObject:value forKey:key];
			}
			
			[returnDict setObject:headDict forKey:@"head"];
			[headDict release];
		}
	}
	
	// get the value
	dictTemp = [data objectForKey:@"root"];
	dictTemp = [dictTemp objectForKey:@"result"];
	NSObject *obj = [dictTemp objectForKey:@"row"];
	
	if (obj != nil) {
		if ([obj isKindOfClass:[NSDictionary class]]) {			
			NSArray *nodeArray;
			NSDictionary *values, *nodeDict;
			
			NSMutableDictionary *newDict;
			
			NSString *name;
			NSString *value;
			
			values = (NSDictionary *)obj;
			dataList = [[NSMutableArray alloc] initWithCapacity:1];
			newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
			
			nodeArray = [values objectForKey:@"node"];
			for (nodeDict in nodeArray) {
				name = [nodeDict valueForKey:@"name"];
				value = [nodeDict valueForKey:@"value"];
				
				if (name && value) {
					[newDict setObject:value forKey:name];
				}
			}
			
			[dataList addObject:newDict];
			[newDict release];
			[returnDict setObject:dataList forKey:@"data"];
			[dataList release];
		} else {
			NSDictionary *dict;
			NSArray *values;
			
			values = (NSArray *)obj;
			dataList = [[NSMutableArray alloc] initWithCapacity:1];
			for (dict in values) {
				NSArray *nodeArray;
				NSDictionary *nodeDict;
				
				NSMutableDictionary *newDict;
				
				NSString *name;
				NSString *value;
				
				newDict = [[NSMutableDictionary alloc] initWithCapacity:1];
				
				nodeArray = [dict objectForKey:@"node"];
				for (nodeDict in nodeArray) {
					name = [nodeDict valueForKey:@"name"];
					value = [nodeDict valueForKey:@"value"];
					
					if (name && value) {
						[newDict setObject:value forKey:name];
					}
				}
				
				[dataList addObject:newDict];
				[newDict release];
			}
			
			[returnDict setObject:dataList forKey:@"data"];
			[dataList release];
		}
	}
	
	return returnDict;
}


#pragma mark public methods

+ (id) analyze:(CVDataType)type data:(NSDictionary *)rawData {
	NSDictionary *dict;
	dict = nil;
	switch (type) {
		case CVDataTypeNewsDetail:
		{
			dict = [CVDataAnalyzer analyzeNewsDetail:rawData];
			break;
		}
		case CVDataTypeRelativeNewsList:
		case CVDataTypeTodayNewsList:
		case CVDataTypeHeadlineNewsList:
		case CVDataTypeLatestNewsList:
		case CVDataTypeMacroNewsList:
		case CVDataTypeDiscretionaryNewsList:
		case CVDataTypeStaplesNewsList:
		case CVDataTypeFinancialsNewsList:
		case CVDataTypeHealthCareNewsList:
		case CVDataTypeIndustrialsNewsList:
		case CVDataTypeMaterialsNewsList:
		case CVDataTypeEnergyNewsList:
		case CVDataTypeTelecomNewsList:
		case CVDataTypeUtilitiesNewsList:
		case CVDataTypeITNewsList:
		case CVDataTypeIndustryNewsList:
		case CVDataTypeStockNewsList:
		{
			dict = [CVDataAnalyzer analyzeTodayNewsList:rawData];
			break;
		}
			
		case CVDataTypeStockInTheNews:
		{
			dict = [CVDataAnalyzer analyzeStockInTheNews:rawData];
			break;
		}
		
		case CVDataTypeStockCodeList:
		case CVDataTypeStockTopMarketCapital:
		case CVDataTypeSectorList:
		case CVDataTypeSectorTurnover:
		case CVDataTypeSectorVolume:
		case CVDataTypeSectorTotalCap:
		case CVDataTypeSectorTradableCap:
		case CVDataTypeStockChart:
		case CVDataTypeMacroData:
		case CVDataTypeEquityBalanceSheet:
		case CVDataTypeEquityIncomeStatement:
		case CVDataTypeEquityCashFlow:
		{
			dict = [CVDataAnalyzer analyzeFormFormatData:rawData];
			break;
		}
		
		case CVDataTypeStockTopMovingSecurites:
		case CVDataTypeFundTopMovingSecurites:
		case CVDataTypeBondTopMovingSecurites:
		case CVDataTypeCompositeIndexSummary:
		case CVDataTypeStockMostActive:
		case CVDataTypeCompositeIndexList:
		case CVDataTypeIndexProfile:
		case CVDataTypeIndexLatestPrice:
		case CVDataTypeEquityProfile:
		case CVDataTypeStockDetail:
		case CVDataTypeSectorSummary:
		case CVDataTypeBenchmarkTopAShare:
		case CVDataTypeBenchmarkTopBlueChips:
		{
			dict = [CVDataAnalyzer analyzeCadaData:rawData];
			break;
		}
		
		case CVDataTypeSectorTopGainerDecliner:
		{
			dict = [CVDataAnalyzer analyzeTopGainersDecliners:rawData];
			break;
		}
		
		default:
			break;
	}
	
	return dict;
}

@end