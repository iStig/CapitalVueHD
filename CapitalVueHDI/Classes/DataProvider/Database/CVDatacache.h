//
//  CVDatacache.h
//  CapitalVueHD
//
//  Created by jishen on 11/4/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
// The compoment of CVDatacache cached the data of a webservice calling in order to
// avoid frequently visiting the server and improve the efficiency.
//
// A webservice calling has its own cache file with the name format Cache_<api>_<parameters>.plist, 
// which is placed at the documentary directory. The cached data is NSDictionary-typed, having
// three keys "contents", "date created" and "token". 
//
// "contents" is the parsed content of a webservice calling, "date created" is the date when the cached
// data is created, and "token" is a serieal number to check the version of requested data
// in remote server.

#import <Foundation/Foundation.h>


@interface CVDatacache : NSObject {
@private
	NSLock *_mutex;
}

/*
 * It returns the tocken of data requested by the webservice calling, 
 * which's cached. This api is available for CapitialVue's CV_Services.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return:	a string of token, if the data of the specified service 
 *			calling exists; nil, if there's no data. 
 */
- (NSString *)tokenOfData:(NSString *)api args:(id)parameters;

/*
 * It tells that the data requested by the webservice calling needs
 * to be updated. This api is only avaialbe for Cada_Service.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return:	YES, if it needs to be updated. NO, if it doesn't need.
 */
- (BOOL)isNeedUpdate:(NSString *)api args:(id)parameters;

/*
 * It sets the lifecycle of specified cached data
 *
 * @param:	api - webservice api
 *			parameters - parameter of the api
 * @return:	none
 */
- (void)setLifecycle:(NSInteger)minutes api:(NSString *)api args:(id)parameters;

/*
 * It gets the lifecycle of specified cached data
 *
 * @param:	api - webservice api
 *			parameters - paramter of the api
 * @return:	none
 */
- (NSInteger)lifecycle:(NSString *)api args:(id)parameters;

/*
 * It reads the cached data requested by the webservice calling.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return:	NSDictionary-typed data
 */
- (NSDictionary *)read:(NSString *)api args:(id)parameters;

/*
 * It writes the data to the filesystem as cached data.
 * Cached data is stored in a file whose name format is
 * Cache_<api>_<parameters>_<data>.plist, token is only
 * available for CV_Service
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return: none
 */
- (void)write:(NSString *)api args:(id)parameters withData:(NSDictionary *)data;

/*
 * It removes the cached data requested by the webservice calling.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return: none
 */
- (void)remove:(NSString *)api args:(id)parameters;

/*
 * It removes the all the cached data.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return: none
 */
- (void)empty;

@end
