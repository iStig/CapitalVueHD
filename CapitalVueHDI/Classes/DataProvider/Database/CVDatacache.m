//
//  CVDatacache.m
//  CapitalVueHD
//
//  Created by jishen on 11/4/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVDatacache.h"
#import "CVDataProvider.h"

@interface CVDatacache()

@property (nonatomic, retain) NSLock *_mutex;

/*
 * It returns the path of file where data requested by the webservice calling
 * is stored.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return:	a string of filename; nil, if there's such file. 
 */
- (NSString *)_pathOfCachedData:(NSString *)api args:(id)parameters;

/*
 * It returns an array of path of all cached data 
 */
- (NSArray *)allCachedData;

@end

@implementation CVDatacache

@synthesize _mutex;

- (id)init {
	if ((self = [super init])) {
		self._mutex = [[NSLock alloc] init];
	}
	return self;
}

- (void)dealloc {
	[_mutex release];
	[super dealloc];
}

#pragma mark -
#pragma mark private method

/*
 * It returns the path of file where data requested by the webservice calling
 * is stored.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return:	a string of filename; nil, if there's such file. 
 */
- (NSString *)_pathOfCachedData:(NSString *)api args:(id)parameters {
	NSString *path;
	NSMutableString *filename;
	
	if (nil != api) {
		// api
		filename = [[NSMutableString alloc] initWithFormat:@"cache_%@", api];
		
		// parameters
		if ([parameters isKindOfClass:[NSString class]]) {
			[filename appendFormat:@"_%@", parameters];
		} else if ([parameters isKindOfClass:[NSArray class]]) {
			NSString *param;
			for (param in parameters) {
				[filename appendFormat:@"_%@", param];
			}
		}
		[filename appendFormat:@".plist", filename];
		
		NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docPath = [docPaths objectAtIndex:0];
		path = [docPath stringByAppendingPathComponent:filename];
		[filename release];
	} else {
		path = nil;
	}
	
	return path;
}

/*
 * It returns an array of path of all cached data 
 */
- (NSArray *)allCachedData {
	NSArray *docPaths, *filesInDoc;
	NSString *docPath;
	NSError *error = nil;
	
	docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	docPath = [docPaths objectAtIndex:0];
	
	filesInDoc = [[NSFileManager defaultManager]
				  subpathsOfDirectoryAtPath:docPath error:&error];
	
	// filtered all the cached files
	NSMutableArray *cachedFiles;
	NSString *filename;
	cachedFiles = [[NSMutableArray alloc] init];
	for (filename in filesInDoc) {
		if ([filename hasPrefix:@"cache_"]) {
			NSString *filepath;
			filepath = [[NSString alloc] initWithFormat:@"%@/%@",docPath, filename];
			[cachedFiles addObject:filepath];
			[filepath release];
		}
	}
	
	return [cachedFiles autorelease];;
}

#pragma mark -
#pragma mark public method

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
- (NSString *)tokenOfData:(NSString *)api args:(id)parameters {
	NSString *token;
	NSString *path;
	NSDictionary *data;
	
	[_mutex lock];
	
	path = [self _pathOfCachedData:api args:parameters];
	data = [[NSDictionary alloc] initWithContentsOfFile:path];
	token = [data objectForKey:@"token"];
	if (token) {
		token = [[[NSString alloc] initWithString:token] autorelease];
	} else {
		token= nil;
	}
	[data release];
	
	[_mutex unlock];
	return token;
}

/*
 * It sets the lifecycle of specified cached data
 *
 * @param:	minutes - lifecycle
 *			api - webservice api
 *			parameters - parameter of the api
 * @return:	none
 */
- (void)setLifecycle:(NSInteger)minutes api:(NSString *)api args:(id)parameters {
	NSString *path;
	NSMutableDictionary *cachedData;
	NSNumber *number;
		
	[_mutex lock];
	
	number = [[NSNumber alloc] initWithInteger:minutes];
	
	path = [self _pathOfCachedData:api args:parameters];
	
	if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
		cachedData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		[cachedData setObject:number forKey:@"lifecycle"];
	} else {
		cachedData = [[NSMutableDictionary alloc] initWithCapacity:1];
		[cachedData setObject:number forKey:@"lifecycle"];
	}
	
	BOOL success;
	success = [cachedData writeToFile:path atomically:YES];
	
	[cachedData release];
	
	[number release];
	
	[_mutex unlock];	
}

/*
 * It gets the lifecycle of specified cached data
 *
 * @param:	api - webservice api
 *			parameters - paramter of the api
 * @return:	minutes of lifecycle of specified cached data.
 */
- (NSInteger)lifecycle:(NSString *)api args:(id)parameters {
	NSString *path;
	NSDictionary *cachedData, *data;
	
	NSNumber *number;
	NSInteger minutes;
	
	[_mutex lock];
	
	minutes = 0;
	
	path = [self _pathOfCachedData:api args:parameters];
	
	data = nil;
	
	if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
		cachedData = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
		number = [cachedData objectForKey:@"lifecycle"];
		minutes = [number integerValue];
	}
	
	[_mutex unlock];
	
	return minutes;
}

/*
 * It tells that the data requested by the webservice calling needs
 * to be updated. This api is only avaialbe for Cada_Service.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return:	YES, if it needs to be updated. NO, if it doesn't need.
 */
- (BOOL)isNeedUpdate:(NSString *)api args:(id)parameters {
	NSString *path;
	NSDictionary *cachedData;
	
	BOOL isNeed = NO;
	
	[_mutex lock];
	
	path = [self _pathOfCachedData:api args:parameters];
	
	if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
		cachedData = [[NSDictionary alloc] initWithContentsOfFile:path];
		if (cachedData) {
			NSDate *date;
			NSTimeInterval cacheTimeInterval, currentTimeInterval;
			
			NSNumber *number;
			NSInteger minutes;
			
			date = [cachedData objectForKey:@"date created"];
			cacheTimeInterval = [date timeIntervalSince1970];
			
			date = [NSDate date];
			currentTimeInterval = [date timeIntervalSince1970];
			
			number = [cachedData objectForKey:@"lifecycle"];
			minutes = [number integerValue];
			
			// if minutes is zero, it means to never updates the existing cached data
			if ((0 != minutes) && ((currentTimeInterval - cacheTimeInterval) > minutes * 60)) {
				isNeed = YES;
			}
		}
		[cachedData release];
	} else {
		isNeed = YES;
	}
	
	[_mutex unlock];
	
	return isNeed;
}

/*
 * It reads the cached data requested by the webservice calling.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return:	NSDictionary-typed data
 */
- (NSDictionary *)read:(NSString *)api args:(id)parameters {
	NSString *path;
	NSDictionary *cachedData, *data;
	
	[_mutex lock];
	
	path = [self _pathOfCachedData:api args:parameters];
	
	data = nil;
	
	if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
		cachedData = [[NSDictionary alloc] initWithContentsOfFile:path];
		data = [cachedData objectForKey:@"contents"];
		if (data != nil) {
			data = [[[NSDictionary alloc] initWithDictionary:data] autorelease];
		}
		[cachedData release];
	}
	
	[_mutex unlock];
	
	return data;
}

/*
 * It writes the data to the filesystem as cached data.
 * Cached data is stored in a file whose name format is
 * Cache_<api>_<parameters>.plist, token is only
 * available for CV_Service
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return: none
 */
- (void)write:(NSString *)api args:(id)parameters withData:(NSDictionary *)data {
	NSString *path;
	NSString *token;
	NSDate *date;
	NSMutableDictionary *cachedData;
	
	[_mutex lock];
	path = [self _pathOfCachedData:api args:parameters];

	if (data) {
		
		if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
			cachedData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		} else {
			cachedData = [[NSMutableDictionary alloc] init];
		}
		
		date = [NSDate date];
		[cachedData setObject:date forKey:@"date created"];
		
		token = [data objectForKey:@"token"];
		if (token) {
			[cachedData setObject:token forKey:@"token"];
		}
		
		[cachedData setObject:data forKey:@"contents"];
		
		BOOL success;
		success = [cachedData writeToFile:path atomically:YES];
		
		[cachedData release];
	}
	
	[_mutex unlock];
}

/*
 * It removes the cached data requested by the webservice calling.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return: none
 */
- (void)remove:(NSString *)api args:(id)parameters {
	NSString *path;
	NSError *log;
	
	[_mutex lock];
	path = [self _pathOfCachedData:api args:parameters];
	if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
		[[NSFileManager defaultManager] removeItemAtPath:path error:&log];
	}
	[_mutex unlock];
}

/*
 * It removes the all the cached data.
 *
 * @param:	api - webservice api
 *			parameters - object of parameters. It might be NSString,
 *						NSDictionary, and NSArray as well.
 * @return: none
 */
- (void)empty {
	NSArray *filelist;
	NSString *path;
	NSError *errorLog;
	
	filelist = [self allCachedData];
	for (path in filelist) {
		if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
			[[NSFileManager defaultManager] removeItemAtPath:path error:&errorLog];
		}
	}
	[[CVDataProvider sharedInstance] setAllDataExpired];
}

@end
