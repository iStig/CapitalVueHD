//
//  CVDataProvider.m
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVDataProvider.h"

#import "CVWebServiceAgent.h"
#import "CVDataAnalyzer.h"
#import "CVDatacache.h"

#import "CVSetting.h"

@interface CVDataProvider (CachePolicy)
- (NSDictionary *)_cv_service:(NSString *)api withParams:(id)params dataType:(CVDataType)type;

- (NSDictionary *)_cada_service:(NSString *)api withParams:(NSArray *)params dataType:(CVDataType)type;

- (NSDictionary *)_cada_service:(NSString *)api paramInfo:(CVParamInfo *)paramInfo dataType:(CVDataType)type;

- (NSDictionary *)_cada_service_update:(NSString *)api withParams:(NSArray *)params dataType:(CVDataType)type;

- (NSDictionary *)_cada_service_update:(NSString *)api paramInfo:(CVParamInfo *)paramInfo dataType:(CVDataType)type;

- (NSDictionary *)_rt_service:(NSString *)api args:(CVParamInfo *)paramInfo;


/*
 * Get token of special api
 *
 * @param:	type - news list type
 *			obj - paramters
 * @return	token
 */
- (NSString *)getToken:(NSString *)api withParams:(NSArray *)params;

/*
 * It registers a api with its  parameters and which will be excuted in the backend.
 *
 * @param:	api - the webserive api
 *			params - the api's parameters
 *			type - data type
 *
 * @return:	YES, if service is registered; NO, if the service has already registered.
 */
- (BOOL)_registerService:(NSString *)api withParams:(NSArray *)params dataType:(CVDataType)type;


/*
 * It put the api and parameters togeter as a string for the purpose of comparison of two services
 *
 * @param:	api - the webservice api 
 *			params - the api's parameters
 *
 * @return:	a string consists of api and aprameters; nil, if errors occurs.
 */
- (NSString *)_api_params:(NSString *)api withParams:(NSArray *)params;

/*
 * It cleans local cache, retrieve the data from the server
 * and stores it locally. The data that is requested is defined by
 * a register pool.
 *
 * @param:	none
 * @return:	none
 */
- (void)_updateCache;

/*
 * It excutes the registerd api every a span of time in a independent thread.
 *
 * @param:	theTimer - time span
 * @return:	none
 */
- (void)_scheduledProcess:(NSTimer *)theTimer;

@end

@implementation CVDataProvider

static CVDataProvider *sharedInstance = nil;
static NSString *langCode = nil;
static CVDatacache *_cache = nil;
static NSLock *_loadingMutex = nil;
static NSMutableArray *_registeredService = nil;
static NSMutableDictionary *_dataBlockLifecycle = nil;

+ (CVDataProvider *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            [[self alloc] init]; // assignment not done here
			
			CVSetting *s = [CVSetting sharedInstance];
			langCode = [s cvLanguage];
			
//			NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
//			NSArray* languages = [defs objectForKey:@"AppleLanguages"];
//			NSString* preferredLang = [languages objectAtIndex:0];
			//if ([preferredLang isEqualToString:@"zh-Hans"]) {
//				langCode = @"cn";
			CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
			langCode = [langSetting localizedString:@"LangCode"];
			//}
			
			_cache = [[CVDatacache alloc] init];
			_registeredService = [[NSMutableArray alloc] init];
			_dataBlockLifecycle = [[NSMutableDictionary alloc] init];
			_loadingMutex = [[NSLock alloc] init];
        }
    }
    return [sharedInstance autorelease];
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
	if ((self = [super init])) {

	}
	return self;
}


- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
	//[_cache release];
}

- (id)autorelease {
    return self;
}

#pragma mark -
#pragma mark private method

- (NSString *)getToken:(NSString *)api withParams:(NSArray *)params{
	NSAssert(NO,@"This method is not ready yet");
	NSString *token;
	
	token = [_cache tokenOfData:api args:params];
	return token;
}

- (NSDictionary *)_cv_service:(NSString *)api withParams:(NSArray *)params dataType:(CVDataType)type {
	CVWebServiceAgent *agent;
	NSDictionary *dict;
	NSString *token;
	
	agent = [[CVWebServiceAgent alloc] init];
	token = [_cache tokenOfData:api args:params];
	if (token == nil) {
		dict = [agent GetData:api args:params];
		dict = [CVDataAnalyzer analyze:type data:dict];
		NSLog(@"cv service: %@ read from server", api);
		[_cache write:api args:params withData:dict];
	} else {
		NSMutableArray *array;
		
		array = [[NSMutableArray alloc] init];
		if (params) {
			[array addObjectsFromArray:params];
		}
		NSString *tokenArg;
		tokenArg = [[NSString alloc] initWithFormat:@"'%@'", token];
		[array addObject:tokenArg];
		[tokenArg release];
		dict = [agent GetData:api args:array];
		if (nil == dict || 0 == [dict count]) {
			NSLog(@"cv service: %@ read from cache, 'cause token's unchanged", api);
			dict = [_cache read:api args:params];
		} else {
			NSLog(@"cv service: %@ read from server, 'cause token's updated", api);
			dict = [CVDataAnalyzer analyze:type data:dict];
			[_cache write:api args:params withData:dict];
		}
		[array release];
	}
	
	[agent release];
	return dict;
}

- (NSDictionary *)_cv_service_update:(NSString *)api withParams:(NSArray *)params dataType:(CVDataType)type {
	CVWebServiceAgent *agent;
	NSDictionary *dict;
	
	agent = [[CVWebServiceAgent alloc] init];
	dict = [agent GetData:api args:params];
	dict = [CVDataAnalyzer analyze:type data:dict];
	if (nil == dict || 0 == [dict count]) {
		NSLog(@"cv service update: %@ no data returned", api);
		dict = [_cache read:api args:params];
	} else {
		NSLog(@"cv service update: %@ data returned and cache it", api);
		[_cache write:api args:params withData:dict];
	}
	[agent release];
	return dict;
}

- (NSDictionary *)_cada_service:(NSString *)api withParams:(NSArray *)params dataType:(CVDataType)type {
	CVWebServiceAgent *agent;
	NSDictionary *dict = nil;
	BOOL isNeedUpdate;
	[_loadingMutex lock];
	[self _registerService:api withParams:params dataType:type];
	isNeedUpdate = [_cache isNeedUpdate:api args:params];
	if (NO == isNeedUpdate) {
		NSLog(@"cada service: %@ read from cache", api);
		dict = [_cache read:api args:params];
		if (nil == dict || [dict count] <= 1) {
			isNeedUpdate = YES;
		}
	}
	
	if (YES == isNeedUpdate) {
		agent = [[CVWebServiceAgent alloc] init];
		dict = [agent GetData:api args:params];
		dict = [CVDataAnalyzer analyze:type data:dict];
		NSLog(@"cada service: %@ read from server", api);
		if (nil != dict && [dict count] > 0) {			
			[_cache remove:api args:params];
			[_cache write:api args:params withData:dict];
		} else {
			dict = [_cache read:api args:params];
		}
		[agent release];
	}
	[_loadingMutex unlock];
	
	return dict;
}

- (NSDictionary *)_cada_service:(NSString *)api paramInfo:(CVParamInfo *)paramInfo dataType:(CVDataType)type {
	NSLog(@"userdefaults cache:%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"cache"]);
	CVWebServiceAgent *agent;
	NSDictionary *dict = nil;
	NSArray *paramArray;
	BOOL isNeedUpdate;
	
	paramArray = (NSArray *)paramInfo.parameters;
	
	isNeedUpdate = [_cache isNeedUpdate:api args:paramArray];
	if (NO == isNeedUpdate) {
		NSLog(@"cada service: %@ read from cache", api);
		[_cache setLifecycle:paramInfo.minutes api:api args:paramArray];
		dict = [_cache read:api args:paramArray];
		if (nil == dict || [dict count] <= 1) {
			isNeedUpdate = YES;
		}
	}
	if (YES == isNeedUpdate) {
		agent = [[CVWebServiceAgent alloc] init];
		dict = [agent GetData:api args:paramArray];
		dict = [CVDataAnalyzer analyze:type data:dict];
		NSLog(@"cada service: %@ read from server", api);
		if (nil != dict && [dict count] > 0) {			
			[_cache remove:api args:paramArray];
			[_cache setLifecycle:paramInfo.minutes api:api args:paramArray];
			[_cache write:api args:paramArray withData:dict];
		} else {
			dict = [_cache read:api args:paramArray];
		}
		[agent release];
	}
	
	return dict;
}

- (NSDictionary *)_cada_service_update:(NSString *)api withParams:(NSArray *)params dataType:(CVDataType)type {
	NSLog(@"userdefaults cache:%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"cache"]);
	CVWebServiceAgent *agent;
	NSDictionary *dict;
	//[_loadingMutex lock];
	agent = [[CVWebServiceAgent alloc] init];
	dict = [agent GetData:api args:params];
	dict = [CVDataAnalyzer analyze:type data:dict];
	NSLog(@"cada service: %@ update from server", api);
	if (nil != dict && [dict count] > 0) {			
		[_cache remove:api args:params];
		[_cache write:api args:params withData:dict];
	}
	[agent release];
	//[_loadingMutex unlock];
	return dict;
}

- (NSDictionary *)_cada_service_update:(NSString *)api paramInfo:(CVParamInfo *)paramInfo dataType:(CVDataType)type {
	NSLog(@"userdefaults cache:%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"cache"]);
	CVWebServiceAgent *agent;
	NSDictionary *dict;
	NSArray *paramArray;
	
	paramArray = (NSArray *)paramInfo.parameters;
	
	agent = [[CVWebServiceAgent alloc] init];
	dict = [agent GetData:api args:paramArray];
	dict = [CVDataAnalyzer analyze:type data:dict];
	NSLog(@"cada service : %@ update from server", api);
	if (nil != dict && [dict count] > 0) {			
		[_cache remove:api args:paramArray];
		[_cache setLifecycle:paramInfo.minutes api:api args:paramArray];
		[_cache write:api args:paramArray withData:dict];
	} else {
		dict = [_cache read:api args:paramArray];
	}
	[agent release];
	
	return dict;
}

- (NSDictionary *)_rt_service:(NSString *)api args:(CVParamInfo *)paramInfo {
	CVWebServiceAgent *agent;
	NSDictionary *dict;
	NSArray *paramArray;
//	BOOL isNeedUpdate;
	
	dict = nil;
	paramArray = (NSArray *)paramInfo.parameters;
	
//	isNeedUpdate = [_cache isNeedUpdate:api args:paramArray];
//	if (NO == isNeedUpdate){
//		NSLog(@"real time service: %@ read from cache", api);
//		[_cache setLifecycle:paramInfo.minutes api:api args:paramArray];
//		dict = [_cache read:api args:paramArray];
//		if (nil == dict || [dict count] <= 1) {
//			isNeedUpdate = YES;
//		}
//	}
//	if (isNeedUpdate) {
		// retrieve data from remote server
		NSLog(@"real time service: %@ read from server", api);
		agent = [[CVWebServiceAgent alloc] init];
		dict = [agent GetData:api args:paramArray];
		dict = [CVDataAnalyzer analyze:CVDataTypeStockTopMovingSecurites data:dict];
		[agent release];
	
		if (nil != dict && [dict count] > 0) {
			[_cache remove:api args:paramArray];
			[_cache setLifecycle:paramInfo.minutes api:api args:paramArray];
			[_cache write:api args:paramArray withData:dict];
		} else {
			// if data is not retrievable, get the cached data instead.
			dict = [_cache read:api args:paramArray];
		}
//	}
	
	return dict;
}

/*
 * It registers a api with its  parameters and which will be excuted in the backend.
 *
 * @param:	api - the webserive api
 *			params - the api's parameters
 *			type - data type
 *
 * @return:	none
 */
- (BOOL)_registerService:(NSString *)api withParams:(NSArray *)params dataType:(CVDataType)type {
	NSMutableDictionary *aService;
	NSString *toBeRegisteredService, *existingService;
	
	NSString *registeredApi;
	NSArray *registeredParams;
	
	BOOL isServiceExisted;
	
	toBeRegisteredService = [self _api_params:api withParams:params];
	
	isServiceExisted = NO;
	for (aService in _registeredService) {
		registeredApi = [aService objectForKey:@"api"];
		registeredParams = [aService objectForKey:@"parameters"];
		existingService = [self _api_params:registeredApi withParams:registeredParams];
		if ([toBeRegisteredService isEqualToString:existingService]) {
			isServiceExisted = YES;
		}
	}
	
	if (NO == isServiceExisted) {
		aService = [[NSMutableDictionary alloc] initWithCapacity:1];
		// api
		if (api)
			[aService setObject:api forKey:@"api"];
		// parameters
		if (params)
			[aService setObject:params forKey:@"parameters"];
		// type
		[aService setObject:[NSNumber numberWithInt:type] forKey:@"type"];
		[_registeredService addObject:aService];
		[aService release];
	}
	
	return (!isServiceExisted);
}

/*
 * It put the api and parameters togeter as a string for the purpose of comparison of two services
 *
 * @param:	api - the webservice api 
 *			params - the api's parameters
 *
 * @return:	a string consists of api and aprameters.
 */
- (NSString *)_api_params:(NSString *)api withParams:(NSArray *)params {
	NSMutableString *s;
	
	s = [[NSMutableString alloc] initWithFormat:@"%@", api];
	
	// parameters
	if ([params isKindOfClass:[NSString class]]) {
		[s appendFormat:@"_%@", params];
	} else if ([params isKindOfClass:[NSArray class]]) {
		NSString *param;
		for (param in params) {
			[s appendFormat:@"_%@", param];
		}
	}
	
	return [s autorelease];
}

/*
 * It cleans local cache, retrieve the data from the server
 * and stores it locally. The data that is requested is defined by
 * a register pool.
 *
 * @param:	none
 * @return:	none
 */
- (void)_updateCache {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *aService;
	
	NSString *api;
	NSArray *params;
	NSNumber *numType;
	CVDataType type;
	NSUInteger i, count;
	
	[_loadingMutex lock];
	count = [_registeredService count];
	[_loadingMutex unlock];
	
	NSLog(@"=====================");
	NSLog(@"=    Update Cache   =");
	NSLog(@"=====================");
	for (i = 0; i < count; i++) {
		[_loadingMutex lock];
		aService = [_registeredService objectAtIndex:i];
		[_loadingMutex unlock];
		
		api = [[aService objectForKey:@"api"] retain];
		params = [[aService objectForKey:@"parameters"] retain];
		numType = [[aService objectForKey:@"type"] retain];
		type = [numType intValue];
		[self _cada_service_update:api withParams:params dataType:type];
		[api release];
		[params release];
		[numType release];
	}
	NSLog(@"=====================");
	NSLog(@"=    Unlock Cache   =");
	NSLog(@"=====================");
	
	[pool release];
	[NSThread exit];
}

/*
 * It excutes the registerd api every a span of time in a independent thread.
 *
 * @param:	theTimer - time span
 * @return:	none
 */
- (void)_scheduledProcess:(NSTimer *)theTimer {
	[NSThread detachNewThreadSelector:@selector(_updateCache) toTarget:self withObject:nil];
}

- (BOOL)isNeedUpdate:(NSString *)identifier{
	NSAssert(NO,@"This method is not ready yet");
	return NO;
}

#pragma mark -
#pragma mark public method

/*
 * It set the identifier for data and its lifecycle.
 *
 * @param:	identifier -  the identifier of a data block
 *			minutes - lifecycle
 * @return:	none
 */
- (void)setDataIdentifier:(NSString *)identifier lifecycle:(NSInteger)minutes {
	NSNumber *number = [NSNumber numberWithInt:minutes];
	NSDate *date;
	NSMutableDictionary *element;
	
	[_loadingMutex lock];
	element = [_dataBlockLifecycle objectForKey:identifier];
	if (element) {
		[element setObject:number forKey:@"lifecycle"];
	} else {
		element = [[NSMutableDictionary alloc] initWithCapacity:1];
		number = [[NSNumber alloc] initWithInteger:minutes];
		date = [NSDate date];
		[element setObject:number forKey:@"lifecycle"];
		[element setObject:date forKey:@"timestamp"];
		[_dataBlockLifecycle setObject:element forKey:identifier];
		[element release];
		[number release];
	}
	
	[_loadingMutex unlock];

}

/*
 * It checks whether the data blcok of identifier expires
 *
 * @param:	identifier -  the identifier of a data block
 * @return:	none
 */
- (BOOL)isDataExpired:(NSString *)identifier {
	BOOL isExpired = NO;
	
	NSMutableDictionary *element;
	NSNumber *number;
	NSInteger minutes;
	NSDate *date;
	NSTimeInterval lastTimeInterval, currentTimeInterval;
	
	element = [_dataBlockLifecycle objectForKey:identifier];
	number = [element objectForKey:@"lifecycle"];
	minutes = [number integerValue];
	
	date = [element objectForKey:@"timestamp"];
	lastTimeInterval = [date timeIntervalSince1970];
	
	date = [NSDate date];
	currentTimeInterval = [date timeIntervalSince1970];
	
	if ((currentTimeInterval - lastTimeInterval) > minutes * 60) {
		[element setObject:date forKey:@"timestamp"];
		[_dataBlockLifecycle setObject:element forKey:identifier];
		isExpired = YES;
	}
	
	return isExpired;
}

-(void)setAllDataExpired{
	NSMutableDictionary *element;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
	for (element in [_dataBlockLifecycle allValues]) {
		[element setObject:date forKey:@"timestamp"];
	}
}

-(NSString *)GetNewsToken:(CVDataProviderNewsListType)type withParams:(NSArray *)obj{
	NSString *token;
	
	NSString *api;
	
	NSArray *args;
	NSString *langArg;
	NSMutableArray *parameters;
	
	args = (NSArray *)obj;
	langArg = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
	parameters = [[NSMutableArray alloc] initWithCapacity:1];
	
	switch (type) {
		case CVDataProviderNewsListTypeTodayNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getTodayNews";
			break;
		}
			
		case CVDataProviderNewsListTypeSectorTodayNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeHeadlineNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getHeadlineNews";
			break;
		}
			
		case CVDataProviderNewsListTypeLatestNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getLatestNews";
			break;
		}
			
		case CVDataProviderNewsListTypeMacroNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getMacroNews";
			break;
		}
			
		case CVDataProviderNewsListTypeDiscretionaryNews:
		{
			[parameters addObject:@"'consumer discretionary'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeStaplesNews:
		{
			[parameters addObject:@"'consumer staples'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeFinancialsNews:
		{
			[parameters addObject:@"'Financial'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeHealthCareNews:
		{
			[parameters addObject:@"'health care'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeIndustrialsNews:
		{
			[parameters addObject:@"'Industrials'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeMaterialsNews:
		{
			[parameters addObject:@"'Materials'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeEnergyNews:
		{
			[parameters addObject:@"'Energy'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeTelecomNews:
		{
			[parameters addObject:@"'Telecom'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeUtilitiesNews:
		{
			[parameters addObject:@"'Utilities'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeITNews:
		{
			[parameters addObject:@"'IT'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			api = @"getIndustryNews";
			break;
		}
			
		case CVDataProviderNewsListTypeRelative:
		{
			[parameters addObjectsFromArray:args];
			if ([parameters count] > 1) {
				[parameters insertObject:langArg atIndex:2];
			}
			api = @"getRelativeNews";
			break;
		}
			
		case CVDataProviderNewsListTypeStock:
		{
			[parameters addObjectsFromArray:args];
			if ([parameters count] > 1) {
				[parameters insertObject:langArg atIndex:1];
			}
			api = @"getStockNews";
			break;
		}
			
		default:
			break;
	}

	token = [_cache tokenOfData:api args:parameters];

	[parameters release];
	[langArg release];
	
	return token;
}

/*
 * It gets the news list of the specified type
 *
 * @param:	type - news list type
 *			obj - paramters
 * @return: dictionary
 */
-(NSDictionary *)GetNewsList:(CVDataProviderNewsListType)type withParams:(id)obj forceRefresh:(BOOL)needRefresh {
	NSDictionary *dict;
	
	NSArray *args;
	NSString *langArg;
	NSMutableArray *parameters;
	
	dict = nil;
	args = (NSArray *)obj;
	langArg = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
	parameters = [[NSMutableArray alloc] initWithCapacity:1];
	
	switch (type) {
		case CVDataProviderNewsListTypeTodayNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getTodayNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getTodayNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeSectorTodayNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeHeadlineNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getHeadlineNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getHeadlineNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeLatestNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getLatestNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getLatestNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeMacroNews:
		{
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getMacroNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getMacroNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
		
		case CVDataProviderNewsListTypeDiscretionaryNews:
		{
			[parameters addObject:@"'consumer discretionary'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeStaplesNews:
		{
			[parameters addObject:@"'consumer staples'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeFinancialsNews:
		{
			[parameters addObject:@"'Financial'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeHealthCareNews:
		{
			[parameters addObject:@"'health care'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeIndustrialsNews:
		{
			[parameters addObject:@"'Industrials'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeMaterialsNews:
		{
			[parameters addObject:@"'Materials'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeEnergyNews:
		{
			[parameters addObject:@"'Energy'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeTelecomNews:
		{
			[parameters addObject:@"'Telecom'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeUtilitiesNews:
		{
			[parameters addObject:@"'Utilities'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeITNews:
		{
			[parameters addObject:@"'IT'"];
			[parameters addObject:langArg];
			[parameters addObjectsFromArray:args];
			if (needRefresh) {
				dict = [self _cv_service_update:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}else {
				dict = [self _cv_service:@"getIndustryNews" withParams:parameters dataType:CVDataTypeTodayNewsList];
			}
			break;
		}
			
		case CVDataProviderNewsListTypeRelative:
		{
			[parameters addObjectsFromArray:args];
			if ([parameters count] > 1) {
				[parameters insertObject:langArg atIndex:2];
			}
			if (needRefresh) {
				dict = [self _cv_service_update:@"getRelativeNews" withParams:parameters dataType:CVDataTypeRelativeNewsList];
			}else {
				dict = [self _cv_service:@"getRelativeNews" withParams:parameters dataType:CVDataTypeRelativeNewsList];
			}
			break;
		}
		
		case CVDataProviderNewsListTypeStock:
		{
			[parameters addObjectsFromArray:args];
			if ([parameters count] > 1) {
				[parameters insertObject:langArg atIndex:1];
			}
			if (needRefresh) {
				dict = [self _cv_service_update:@"getStockNews" withParams:parameters dataType:CVDataTypeStockNewsList];
			}else {
				dict = [self _cv_service:@"getStockNews" withParams:parameters dataType:CVDataTypeStockNewsList];
			}
			break;
		}

		default:
			break;
	}
	[parameters release];
	[langArg release];
	
	return dict;
}

/*
 * It gets news article
 *
 * @param:	postid - news id
 * @return:	news article content
 */
-(NSDictionary *)GetNewsDetail:(NSString *)postid{
	NSDictionary *dict;
	NSArray *parameters;
	CVWebServiceAgent *agent = [[CVWebServiceAgent alloc] init];
	
	parameters = [[NSArray alloc] initWithObjects:postid,[NSString stringWithFormat:@"'%@'",langCode],nil];
	dict = [agent GetData:@"getNewsDetail" args:parameters];
	[parameters release];
	dict = [CVDataAnalyzer analyze:CVDataTypeNewsDetail data:dict];
	[agent release];
	return dict;
}

-(NSString *)getStockInNewsToken:(CVDataProviderStockListType)type withParams:(CVParamInfo *)paramInfo{
	NSString *api;
	NSArray *paramArray;
	switch (type) {
		case CVDataProviderStockListTypeNewsRelated:
		{
			// FIXME: why $industry=30?
			paramArray = [NSArray arrayWithObjects:@"$industry=30",[NSString stringWithFormat:@"$lang='%@'",langCode],nil];
			api = @"getStockInTheNews";
			break;
		}
		default:
			break;
	}
	
	NSString *token = [_cache tokenOfData:api args:paramArray];
	
	return token;
}

/*
 * It gets the stock list of the specified type.
 *
 * @param:	type - stock list type
 *			obj - parameters
 * @return:	dictionary
 */
-(NSDictionary *)GetStockList:(CVDataProviderStockListType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	NSArray *parameters;
	CVParamInfo *info;
	
	info = [[CVParamInfo alloc] init];
	info.minutes = paramInfo.minutes;
	
	switch (type) {
		case CVDataProviderStockListTypeAll:
		{	
			NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *docPath = [docPaths objectAtIndex:0];
			NSString *documentPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"StockCodesList_%@.plist",langCode]];
			NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"StockCodesList_%@.plist",langCode] ofType:nil];
			
			
			NSDictionary *documentDict = [[NSDictionary alloc] initWithContentsOfFile:documentPath];
			NSDictionary *bundleDict = [[NSDictionary alloc] initWithContentsOfFile:bundlePath];
			
			if (!documentDict || [[documentDict allKeys] count]==0){
				[bundleDict writeToFile:documentPath atomically:NO];
				[documentDict release];
				documentDict = bundleDict;
			}
			else{
				[bundleDict release];
			}
			
			
			// ($lastUpdateTime=false,$lang='en',$format='xml',$flush=false)
			parameters = [[NSArray alloc] initWithObjects:@"$lastUpdateTime=false",[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
			info.parameters = parameters;
			info.minutes = 24*60;
			dict = [self _cada_service:@"getEquityCodes" paramInfo:info dataType:CVDataTypeStockCodeList];
			
			if (!dict || [[dict allKeys] count]==0 || [[dict objectForKey:@"contents"] count]==0){
				dict = [documentDict autorelease];
			}
			else{
				[dict writeToFile:documentPath atomically:NO];
				[documentDict release];
			}
			
			
			[parameters release];
			break;
		}
			
		case CVDataProviderStockListTypeTopMovingSecruties:
		{			
			// ($lang='en',$limit=10,$format='xml',$flush=false)
			parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],@"$limit=15",@"$format='xml'",@"$flush=false", nil];
			info.parameters = parameters;
			dict = [self _cada_service:@"getTopMovingEquites" paramInfo:info dataType:CVDataTypeStockTopMovingSecurites];
			
			[parameters release];
			break;
		}
			
		case CVDataProviderStockListTypeNewsRelated:
		{
			// FIXME: why $industry=30?
			NSArray *paramArray = [[NSArray alloc] initWithObjects:@"$industry=30",[NSString stringWithFormat:@"$lang='%@'",langCode],nil];
//			paramArray = (NSArray *)paramInfo.parameters;
//			NSLog(@"%stock in the news:%@",paramInfo);
			dict = [self _cv_service:@"getStockInTheNews" withParams:paramArray dataType:CVDataTypeStockInTheNews];
			[paramArray release];
			break;
		}
			
		case CVDataProviderStockListTypeMostActive:
		{
			NSString *indexCode, *arg1;
			
			// ($index_code='000001', $lang='en',$limit=50,$format='xml',$flush=false)
			indexCode = (NSString *)paramInfo.parameters;
			arg1 = [[NSString alloc] initWithFormat:@"$index_code='%@'", indexCode];
			parameters = [[NSArray alloc] initWithObjects:arg1,
						  [NSString stringWithFormat:@"$lang='%@'",langCode],
						  @"$limit=15",
						  @"$format='xml'",
						  @"$flush=false", nil];
			
			info.parameters = parameters;
			
			dict = [self _cada_service:@"getCompositeIndexEquities" paramInfo:info dataType:CVDataTypeStockMostActive];
			[parameters release];
			[arg1 release];
			break;
		}
			
		case CVDataProviderStockListTypeTopMarketCapital:
		{
			// ($lang='en',$format='xml',$flush=false)
			parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
			info.parameters = parameters;
			dict = [self _cada_service:@"getHighestMarketCapsInSseSzse" paramInfo:info dataType:CVDataTypeStockTopMarketCapital];
			[parameters release];
		}
		
		default:
			break;
	}
	
	[info release];
	
	return dict;
}

/*
 * It gets the stock list of the specified type.
 *
 * @param:	type - stock list type
 *			obj - parameters
 * @return:	dictionary
 */
-(NSDictionary *)ReGetStockList:(CVDataProviderStockListType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	NSArray *parameters;
	CVParamInfo *info;
	
	info = [[CVParamInfo alloc] init];
	info.minutes = paramInfo.minutes;
	
	switch (type) {
		case CVDataProviderStockListTypeAll:
		{			
			// ($lastUpdateTime=false,$lang='en',$format='xml',$flush=false)
			parameters = [[NSArray alloc] initWithObjects:@"$lastUpdateTime=false",[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
			info.parameters = parameters;
			dict = [self _cada_service_update:@"getEquityCodes" paramInfo:info dataType:CVDataTypeStockCodeList];
			
			[parameters release];
			break;
		}
			
		case CVDataProviderStockListTypeTopMovingSecruties:
		{			
			// ($lang='en',$limit=10,$format='xml',$flush=false)
			parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],@"$limit=15",@"$format='xml'",@"$flush=false", nil];
			info.parameters = parameters;
			dict = [self _cada_service_update:@"getTopMovingEquites" paramInfo:info dataType:CVDataTypeStockTopMovingSecurites];
			
			[parameters release];
			break;
		}
			
		case CVDataProviderStockListTypeNewsRelated:
		{
			// FIXME: why $industry=30?
			NSArray *paramArray = [[NSArray alloc] initWithObjects:@"$industry=30",[NSString stringWithFormat:@"$lang='%@'",langCode],nil];
			//			paramArray = (NSArray *)paramInfo.parameters;
			//			NSLog(@"%stock in the news:%@",paramInfo);
			dict = [self _cv_service_update:@"getStockInTheNews" withParams:paramArray dataType:CVDataTypeStockInTheNews];
			[paramArray release];
			break;
		}
			
		case CVDataProviderStockListTypeMostActive:
		{
			NSString *indexCode, *arg1;
			
			// ($index_code='000001', $lang='en',$limit=50,$format='xml',$flush=false)
			indexCode = (NSString *)paramInfo.parameters;
			arg1 = [[NSString alloc] initWithFormat:@"$index_code='%@'", indexCode];
			parameters = [[NSArray alloc] initWithObjects:arg1,
						  [NSString stringWithFormat:@"$lang='%@'",langCode],
						  @"$limit=15",
						  @"$format='xml'",
						  @"$flush=false", nil];
			
			info.parameters = parameters;
			
			dict = [self _cada_service_update:@"getCompositeIndexEquities" paramInfo:info dataType:CVDataTypeStockMostActive];
			[parameters release];
			[arg1 release];
			break;
		}
			
		case CVDataProviderStockListTypeTopMarketCapital:
		{
			// ($lang='en',$format='xml',$flush=false)
			parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
			info.parameters = parameters;
			dict = [self _cada_service_update:@"getHighestMarketCapsInSseSzse" paramInfo:info dataType:CVDataTypeStockTopMarketCapital];
			[parameters release];
		}
			
		default:
			break;
	}
	
	[info release];
	
	return dict;
}

/*
 * It gets the profile of a given stock
 *
 * @param:	code - stock code
 * @return:	NSDictionary
 */
-(NSDictionary *)GetStockProfile:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *arg1;
	NSArray *parameters;
	
	// ($gpdm='600352',$lang='en',$format='xml',$flush=false)
	arg1 = [[NSString alloc] initWithFormat:@"$gpdm='%@'", paramInfo.parameters];
	parameters = [[NSArray alloc] initWithObjects:arg1, [NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.minutes = 15;
	paramInfo.parameters = parameters;
	
	dict = [self _cada_service:@"getEquityProfile" paramInfo:paramInfo dataType:CVDataTypeEquityProfile];
	[parameters release];
	[arg1 release];
	
	return dict;
}

-(NSDictionary *)GetMyStockDetail:(CVDataProviderMyStockDetailType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	NSArray *parameters;
	
	NSString *arg;
	
	switch (type) {
		case CVDataProviderMyStockDetailTypeStock:
		{
			NSString *codeArg, *langArg;
			arg = (NSString *)paramInfo.parameters;
			// $gpdms='600600',$gics='',$lang='cn',$format='xml',$flush=false
			if (arg == nil) {
				break;
			}
			codeArg = [[NSString alloc] initWithFormat:@"$gpdms='%@'", arg];
			langArg = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
			
			parameters = [[NSArray alloc] initWithObjects:codeArg, 
						  @"$gics=''", langArg, @"$format='xml'", 
						  @"$flush=false", nil];
			paramInfo.parameters = parameters;
			dict = [self _cada_service:@"getEquityByCodes" paramInfo:paramInfo dataType:CVDataTypeStockDetail];
			[parameters release];
			[codeArg release];
			[langArg release];
			break;
		}
			
		case CVDataProviderMyStockDetailTypeMinuteStock:
		{
			NSString *codeArg, *langArg;
			arg = (NSString *)paramInfo.parameters;
			// ($gpdm='600600',$format='xml')
			codeArg = [[NSString alloc] initWithFormat:@"$gpdms='%@'", arg];
			langArg = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
			
			parameters = [[NSArray alloc] initWithObjects:codeArg, @"$format='xml'", nil];
			paramInfo.parameters = parameters;
			dict = [self _rt_service:@"getMinuteStockDetail" args:paramInfo];
			[parameters release];
			[codeArg release];
			[langArg release];
			break;
		}
			
		case CVDataProviderMyStockDetailTypeMinuteComposite:
		{
			NSString *codeArg, *langArg;
			arg = (NSString *)paramInfo.parameters;
			// ($gpdm='600600',$format='xml')
			codeArg = [[NSString alloc] initWithFormat:@"$zsdm='%@'", arg];
			langArg = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
			
			parameters = [[NSArray alloc] initWithObjects:codeArg, @"$format='xml'", nil];
			paramInfo.parameters = parameters;
			dict = [self _rt_service:@"getMinuteCompositeDetail" args:paramInfo];
			[parameters release];
			[codeArg release];
			[langArg release];
			break;
		}
			
		case CVDataProviderMyStockDetailTypeMinuteMultipleStock:
		{
			NSString *codeArg, *langArg;
			arg = (NSString *)paramInfo.parameters;
			// ($gpdm='600600,600601',$format='xml')
			codeArg = [[NSString alloc] initWithFormat:@"$gpdms='%@'", arg];
			langArg = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
			
			parameters = [[NSArray alloc] initWithObjects:codeArg, langArg, @"$format='xml'", nil];
			paramInfo.parameters = parameters;
			dict = [self _rt_service:@"getMinuteMultipleStockDetail" args:paramInfo];
			[parameters release];
			[codeArg release];
			[langArg release];
			break;
		}
			
		case CVDataProviderMyStockDetailTypeMinuteMultipleComposite:
		{
			NSString *codeArg, *langArg;
			arg = (NSString *)paramInfo.parameters;
			// ($gpdms='600600,000300',$format='xml')
			codeArg = [[NSString alloc] initWithFormat:@"$zsdms='%@'", arg];
			langArg = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
			
			parameters = [[NSArray alloc] initWithObjects:codeArg, langArg, @"$format='xml'", nil];
			paramInfo.parameters = parameters;
			dict = [self _rt_service:@"getMinuteMultipleCompositeDetail" args:paramInfo];
			[parameters release];
			[codeArg release];
			[langArg release];
			break;
		}
			
		case CVDataProviderMyStockDetailTypeFund:
			
			break;
		case CVDataProviderMyStockDetailTypeBond:
			
			break;
		default:
			break;
	}
	
	return dict;
}

-(NSDictionary *)ReGetMyStockDetail:(CVDataProviderMyStockDetailType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	NSArray *parameters;
	
	NSString *arg;
	
	switch (type) {
		case CVDataProviderMyStockDetailTypeStock:
		{
			NSString *codeArg, *langArg;
			arg = (NSString *)paramInfo.parameters;
			// $gpdms='600600',$gics='',$lang='cn',$format='xml',$flush=false
			if (arg == nil) {
				break;
			}
			codeArg = [[NSString alloc] initWithFormat:@"$gpdms='%@'", arg];
			langArg = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
			
			parameters = [[NSArray alloc] initWithObjects:codeArg, 
						  @"$gics=''", langArg, @"$format='xml'", 
						  @"$flush=false", nil];
			paramInfo.parameters = parameters;
			dict = [self _cada_service_update:@"getEquityByCodes" paramInfo:paramInfo dataType:CVDataTypeStockDetail];
			[parameters release];
			[codeArg release];
			[langArg release];
			break;
		}
			
		case CVDataProviderMyStockDetailTypeMinuteStock:
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderMyStockDetailTypeMinuteStock");
			break;
		case CVDataProviderMyStockDetailTypeMinuteComposite:
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderMyStockDetailTypeMinuteComposite");
			break;
		case CVDataProviderMyStockDetailTypeMinuteMultipleStock:
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderMyStockDetailTypeMinuteMultipleStock");
			break;
		case CVDataProviderMyStockDetailTypeMinuteMultipleComposite:
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderMyStockDetailTypeMinuteMultipleComposite");
			break;
		case CVDataProviderMyStockDetailTypeFund:
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderMyStockDetailTypeFund");
			break;
		case CVDataProviderMyStockDetailTypeBond:
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderMyStockDetailTypeBond");
			break;
		default:
			break;
	}
	
	return dict;
}

#pragma mark -
#pragma mark Chart Data

-(NSDictionary *)GetChartData:(CVDataProviderChartType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	CVParamInfo *info;
	NSArray *parameters;
	
	info = [[CVParamInfo alloc] init];
	info.minutes = paramInfo.minutes;
	
	switch (type) {
		case CVDataProviderChartTypeStock:
		{
			NSDictionary *paramDict;
			NSString *code;
			NSNumber *days;
			
			paramDict = (NSDictionary *)paramInfo.parameters;
			code = [paramDict valueForKey:@"code"];
			days = [paramDict valueForKey:@"days"];
			
			// ('000001','1990-01-01','en',5)
			NSLog(@"Get Equity By Code:%@",code);
			
			NSString *arg1 = [[NSString alloc] initWithFormat:@"'%@'", code];
			NSString *arg2 = [[NSString alloc] initWithString:@"'1990-01-01'"];
			NSString *arg3 = [[NSString alloc] initWithFormat:@"'%@'", @"en"];
			NSString *arg4 = [[NSString alloc] initWithFormat:@"%@", days];
			parameters = [[NSArray alloc] initWithObjects:arg1, arg2, arg3, arg4, nil];
			info.parameters = parameters;
			dict = [self _cada_service:@"getEquityChart" paramInfo:info dataType:CVDataTypeStockChart];
			[parameters release];
			[arg1 release];
			[arg2 release];
			[arg3 release];
			[arg4 release];
			break;
		}

		case CVDataProviderChartTypeFund:
		{
			break;
		}
		case CVDataProviderChartTypeBond:
		{
			break;
		}
		case CVDataProviderChartTypeEquityIndices:
		case CVDataProviderChartTypeFundIndices:
		case CVDataProviderChartTypeBondIndices:
		{
			CVWebServiceAgent *agent = [[CVWebServiceAgent alloc] init];
			NSDictionary *paramDict;
			NSString *code;
			NSNumber *days;
			
			paramDict = (NSDictionary *)paramInfo.parameters;
			code = [paramDict valueForKey:@"code"];
			days = [paramDict valueForKey:@"days"];
			
			// ('000001','1990-01-01','en',5)
			NSString *arg1 = [[NSString alloc] initWithFormat:@"'%@'", code];
			NSString *arg2 = [[NSString alloc] initWithString:@"'1990-01-01'"];
			NSString *arg3 = [[NSString alloc] initWithFormat:@"'%@'", @"en"];
			NSString *arg4 = [[NSString alloc] initWithFormat:@"%@", days];
			parameters = [[NSArray alloc] initWithObjects:arg1, arg2, arg3, arg4, nil];
			info.parameters = parameters;
			dict = [self _cada_service:@"getCompositeIndexChart" paramInfo:info dataType:CVDataTypeStockChart];
			[parameters release];
			[arg1 release];
			[arg2 release];
			[arg3 release];
			[arg4 release];
			[agent release];
			break;
		}
			
		case CVDataProviderChartTypeMultipleIndex:
		{
			CVWebServiceAgent *agent = [[CVWebServiceAgent alloc] init];
			NSDictionary *paramDict;
			NSString *code;
			NSNumber *days;
			
			paramDict = (NSDictionary *)paramInfo.parameters;
			code = [paramDict valueForKey:@"code"];
			days = [paramDict valueForKey:@"days"];
			
			// $index_codes='000001,000300', $date='2008-01-01', $lang='en',$limit=0,$format='xml',$flush=false
			NSString *arg1 = [[NSString alloc] initWithFormat:@"'%@'", code];
			NSString *arg2 = [[NSString alloc] initWithString:@"'2008-01-01'"];
			NSString *arg3 = [[NSString alloc] initWithFormat:@"'%@'", @"en"];
			NSString *arg4 = [[NSString alloc] initWithFormat:@"%@", days];
			NSString *arg5 = [[NSString alloc] initWithFormat:@"'%@'", @"xml"];
			NSString *arg6 = [[NSString alloc] initWithFormat:@"%@", @"false"];
			
			parameters = [[NSArray alloc] initWithObjects:arg1, arg2, arg3, arg4, arg5, arg6, nil];
			info.parameters = parameters;
			dict = [self _cada_service:@"getIndicesChart" paramInfo:info dataType:CVDataTypeStockChart];
			[parameters release];
			[agent release];
			break;
		}
			
		case CVDataProviderChartTypeEquityIntraday:
		{
			CVWebServiceAgent *agent;
			NSDictionary *paramDict;
			NSString *code;
			
			agent = [[CVWebServiceAgent alloc] init];
			
			// ('000002','2010-12-06 13:32','xml')
			paramDict = (NSDictionary *)paramInfo.parameters;
			code = [paramDict objectForKey:@"code"];
			if (code) {
				NSString *arg1, *arg2;
				NSDate *date;
				NSDateFormatter *format;
				NSString *strDate;
				
				date = [NSDate date];
				format = [[NSDateFormatter alloc] init];
				[format setDateFormat:@"yyyy-MM-dd 09:30:00"];
				strDate = [format stringFromDate:date];
				[format release];
				
				arg1 = [[NSString alloc] initWithFormat:@"'%@'", code];
				arg2 = [[NSString alloc] initWithFormat:@"'%@'", strDate];
				parameters = [[NSArray alloc] initWithObjects:arg1,arg2, @"'xml'", nil];
				[arg1 release];
				[arg2 release];
				info.parameters = parameters;
				dict = [self _rt_service:@"getMinuteData" args:info];
				[parameters release];
				
			}
			[agent release];
			break;
		}
		case CVDataProviderChartTypeEquityIndexIntraday:
		{
			CVWebServiceAgent *agent;
			NSDictionary *paramDict;
			NSString *code;
			
			agent = [[CVWebServiceAgent alloc] init];
			
			// ('000300','2010-12-06 13:32','xml')
			paramDict = (NSDictionary *)paramInfo.parameters;
			code = [paramDict objectForKey:@"code"];
			if (code) {
				NSString *arg1, *arg2;
				NSDate *date;
				NSDateFormatter *format;
				NSString *strDate;
				
				date = [NSDate date];
				format = [[NSDateFormatter alloc] init];
				[format setDateFormat:@"yyyy-MM-dd 09:30:00"];
				strDate = [format stringFromDate:date];
				[format release];
				
				arg1 = [[NSString alloc] initWithFormat:@"'%@'", code];
				arg2 = [[NSString alloc] initWithFormat:@"'%@'", strDate];
				parameters = [[NSArray alloc] initWithObjects:arg1,arg2, @"'xml'", nil];
				[arg1 release];
				[arg2 release];
				info.parameters = parameters;
				dict = [self _rt_service:@"getIndexMinuteData" args:info];
				[parameters release];
				
			}
			[agent release];
			break;
		}
			
		default:
			break;
	}
	
	[info release];
	
	return dict;
}

/*
 *	Double cache level for chart data,
 *
 *	first check 22*24 days cache file,
 *	then return the special number of chart data,
 *	from the large chart data for request
 *
 */
-(NSDictionary *)GetDoubleCacheDataForChart:(CVDataProviderChartType)type withParams:(CVParamInfo *)paramInfo andRefresh:(BOOL)isRefresh{
	NSDictionary *dict = nil;
	CVParamInfo *info;
	NSArray *parameters;
	
	info = [[CVParamInfo alloc] init];
	info.minutes = paramInfo.minutes;
	
	switch (type) {
		case CVDataProviderChartTypeStock:
		{
			//check data for 528days
			
			NSDictionary *paramDict;
			NSString *code;
			NSNumber *days;
			
			paramDict = (NSDictionary *)paramInfo.parameters;
			code = [paramDict valueForKey:@"code"];
			days = [paramDict valueForKey:@"days"];
			int numDays = [days intValue];
			
			// ('000001','1990-01-01','en',5)
			NSLog(@"Get Equity By Code:%@",code);
			
			NSString *arg1 = [[NSString alloc] initWithFormat:@"'%@'", code];
			NSString *arg2 = [[NSString alloc] initWithString:@"'1990-01-01'"];
			NSString *arg3 = [[NSString alloc] initWithFormat:@"'%@'", @"en"];
			NSString *arg4 = [[NSString alloc] initWithFormat:@"%d", 22*24];
			parameters = [[NSArray alloc] initWithObjects:arg1, arg2, arg3, arg4, nil];
			info.parameters = parameters;
			if (isRefresh) {
				dict = [self _cada_service_update:@"getEquityChart" paramInfo:info dataType:CVDataTypeStockChart];
			} else {
				dict = [self _cada_service:@"getEquityChart" paramInfo:info dataType:CVDataTypeStockChart];
			}

			
			[parameters release];
			[arg1 release];
			[arg2 release];
			[arg3 release];
			[arg4 release];
			
			//return special number of days chart
			int dataCount = [[dict objectForKey:@"data"] count];
			if (dict && numDays < dataCount) {
				NSArray *defaultAry = [dict objectForKey:@"data"];
				
				NSRange range = NSMakeRange(0, numDays);
				NSArray *dataArray = [defaultAry subarrayWithRange:range];
				NSArray *headArray = [dict objectForKey:@"head"];
				dict = [NSDictionary dictionaryWithObjectsAndKeys:headArray,@"head",dataArray,@"data",nil];
			}
			
			break;
		}
			
		case CVDataProviderChartTypeFund:
		{
			break;
		}
		case CVDataProviderChartTypeBond:
		{
			break;
		}
		case CVDataProviderChartTypeEquityIndices:
		case CVDataProviderChartTypeFundIndices:
		case CVDataProviderChartTypeBondIndices:
		{
			//check data for 528days
			
			CVWebServiceAgent *agent = [[CVWebServiceAgent alloc] init];
			NSDictionary *paramDict;
			NSString *code;
			NSNumber *days;
			
			paramDict = (NSDictionary *)paramInfo.parameters;
			code = [paramDict valueForKey:@"code"];
			days = [paramDict valueForKey:@"days"];
			int numDays = [days intValue];
			
			// ('000001','1990-01-01','en',5)
			NSString *arg1 = [[NSString alloc] initWithFormat:@"'%@'", code];
			NSString *arg2 = [[NSString alloc] initWithString:@"'1990-01-01'"];
			NSString *arg3 = [[NSString alloc] initWithFormat:@"'%@'", @"en"];
			NSString *arg4 = [[NSString alloc] initWithFormat:@"%d", 22*24];
			parameters = [[NSArray alloc] initWithObjects:arg1, arg2, arg3, arg4, nil];
			info.parameters = parameters;
			if (isRefresh) {
				dict = [self _cada_service_update:@"getCompositeIndexChart" paramInfo:info dataType:CVDataTypeStockChart];
			} else {
				dict = [self _cada_service:@"getCompositeIndexChart" paramInfo:info dataType:CVDataTypeStockChart];
			}
			
			[parameters release];
			[arg1 release];
			[arg2 release];
			[arg3 release];
			[arg4 release];
			[agent release];
			
			//return special number of days chart
			int dataCount = [[dict objectForKey:@"data"] count];
			if (dict && numDays < dataCount) {
				NSArray *defaultAry = [dict objectForKey:@"data"];
				
				NSRange range = NSMakeRange(0, numDays);
				NSArray *dataArray = [defaultAry subarrayWithRange:range];
				NSArray *headArray = [dict objectForKey:@"head"];
				dict = [NSDictionary dictionaryWithObjectsAndKeys:headArray,@"head",dataArray,@"data",nil];
			}
			
			break;
		}
			
		case CVDataProviderChartTypeMultipleIndex:
		{
			
			break;
		}
			
		case CVDataProviderChartTypeEquityIntraday:
		{
			
			break;
		}
		case CVDataProviderChartTypeEquityIndexIntraday:
		{
			
			break;
		}
			
		default:
			break;
	}
	
	[info release];
	
	return dict;
}

-(NSDictionary *)ReGetChartData:(CVDataProviderChartType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	CVParamInfo *info;
	NSArray *parameters;
	
	info = [[CVParamInfo alloc] init];
	info.minutes = paramInfo.minutes;
	
	switch (type) {
		case CVDataProviderChartTypeStock:
		{
			NSDictionary *paramDict;
			NSString *code;
			NSNumber *days;
			
			paramDict = (NSDictionary *)paramInfo.parameters;
			code = [paramDict valueForKey:@"code"];
			days = [paramDict valueForKey:@"days"];
			
			// ('000001','1990-01-01','en',5)
			NSLog(@"Get Equity By Code:%@",code);
			
			NSString *arg1 = [[NSString alloc] initWithFormat:@"'%@'", code];
			NSString *arg2 = [[NSString alloc] initWithString:@"'1990-01-01'"];
			NSString *arg3 = [[NSString alloc] initWithFormat:@"'%@'", @"en"];
			NSString *arg4 = [[NSString alloc] initWithFormat:@"%@", days];
			parameters = [[NSArray alloc] initWithObjects:arg1, arg2, arg3, arg4, nil];
			info.parameters = parameters;
			dict = [self _cada_service_update:@"getEquityChart" paramInfo:info dataType:CVDataTypeStockChart];
			[parameters release];
			[arg1 release];
			[arg2 release];
			[arg3 release];
			[arg4 release];
			break;
		}
			
		case CVDataProviderChartTypeFund:
		{
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderChartTypeFund");
			break;
		}
		case CVDataProviderChartTypeBond:
		{
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderChartTypeBond");
			break;
		}
		case CVDataProviderChartTypeEquityIndices:
		case CVDataProviderChartTypeFundIndices:
		case CVDataProviderChartTypeBondIndices:
		{
			CVWebServiceAgent *agent = [[CVWebServiceAgent alloc] init];
			NSDictionary *paramDict;
			NSString *code;
			NSNumber *days;
			
			paramDict = (NSDictionary *)paramInfo.parameters;
			code = [paramDict valueForKey:@"code"];
			days = [paramDict valueForKey:@"days"];
			
			// ('000001','1990-01-01','en',5)
			NSString *arg1 = [[NSString alloc] initWithFormat:@"'%@'", code];
			NSString *arg2 = [[NSString alloc] initWithString:@"'1990-01-01'"];
			NSString *arg3 = [[NSString alloc] initWithFormat:@"'%@'", @"en"];
			NSString *arg4 = [[NSString alloc] initWithFormat:@"%@", days];
			parameters = [[NSArray alloc] initWithObjects:arg1, arg2, arg3, arg4, nil];
			info.parameters = parameters;
			dict = [self _cada_service_update:@"getCompositeIndexChart" paramInfo:info dataType:CVDataTypeStockChart];
			[parameters release];
			[arg1 release];
			[arg2 release];
			[arg3 release];
			[arg4 release];
			[agent release];
			break;
		}
			
		case CVDataProviderChartTypeMultipleIndex:
		{
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderChartTypeMultipleIndex");
			break;
		}
			
		case CVDataProviderChartTypeEquityIntraday:
		{
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderChartTypeEquityIntraday");
			break;
		}
		case CVDataProviderChartTypeEquityIndexIntraday:
		{
			NSAssert(NO,@"ReGetMyStockDetail is not sutable for CVDataProviderChartTypeEquityIndexIntraday");
			break;
		}
			
		default:
			break;
	}
	[info release];
	
	return dict;
}

#pragma mark -

-(NSDictionary *)GetCompositeIndexList:(CVDataProviderCompositeIndexType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	
	switch (type) {
		case CVDataProviderCompositeIndexTypeDaily:
		{
			NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode], @"$limit=10", @"$format='xml'", @"$flush=false", nil];
			
			paramInfo.parameters = parameters;
			dict = [self _cada_service:@"getDailyCompositeIndex" paramInfo:paramInfo dataType:CVDataTypeCompositeIndexList];
			[parameters release];
			break;
		}
			
		case CVDataProviderCompositeIndexTypeSummary:
		{
			NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode], @"'xml'", nil];
			
			paramInfo.parameters = parameters;
			dict = [self _cada_service:@"getCompositeIndexSummary" paramInfo:paramInfo dataType:CVDataTypeCompositeIndexSummary];
			[parameters release];
			break;
		}
			
		default:
			break;
	}

	return dict;
}

-(NSDictionary *)ReGetCompositeIndexList:(CVDataProviderCompositeIndexType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	
	switch (type) {
		case CVDataProviderCompositeIndexTypeDaily:
		{
			NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode], @"$limit=10", @"$format='xml'", @"$flush=false", nil];
			
			paramInfo.parameters = parameters;
			dict = [self _cada_service_update:@"getDailyCompositeIndex" paramInfo:paramInfo dataType:CVDataTypeCompositeIndexList];
			[parameters release];
			break;
		}
			
		case CVDataProviderCompositeIndexTypeSummary:
		{
			NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode], @"'xml'", nil];
			
			paramInfo.parameters = parameters;
			dict = [self _cada_service_update:@"getCompositeIndexSummary" paramInfo:paramInfo dataType:CVDataTypeCompositeIndexSummary];
			[parameters release];
			break;
		}
			
		default:
			break;
	}
	
	return dict;
}

/*
 * It gets the profile of a givein composite index
 *
 * @param:	code - code of composite index
 * @return:	NSDictionary
 */
-(NSDictionary *)GetIndexProfile:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	CVParamInfo *info;
	NSString *code;
	
	dict = nil;
	info = [[CVParamInfo alloc] init];
	info.minutes = paramInfo.minutes;
	code = (NSString *)paramInfo.parameters;
	if (nil != code) {
		// ($index_code='000001',$lang='en',$format='xml',$flush=false)
		NSArray *parameters;
		NSString *arg1;
		
		arg1 = [[NSString alloc] initWithFormat:@"$index_code='%@'",code];
		parameters = [[NSArray alloc] initWithObjects:arg1, [NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
		info.parameters = parameters;
		dict = [self _cada_service:@"getIndexProfile" paramInfo:info dataType:CVDataTypeIndexProfile];
		[parameters release];
		[arg1 release];
	}
	[info release];
	
	return dict;
}

/*
 * It gets the latest status of a given composite index
 * 
 * @param: code - code of composite index
 * @return: NSDictionary
 */
-(NSDictionary *)GetIndexLatestPrice:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *code;
	
	dict = nil;
	code = (NSString *)paramInfo.parameters;
	if (nil != code) {
		// ($index_code='000001',$lang='en',$format='xml',$flush=false)
		NSArray *parameters;
		NSString *arg1;
		
		arg1 = [[NSString alloc] initWithFormat:@"$index_code='%@'", code];
		parameters = [[NSArray alloc] initWithObjects:arg1, [NSString stringWithFormat:@"$lang='%@'",langCode],
					  @"$format='xml'",@"$flush=false", nil];
		paramInfo.parameters = parameters;
		dict = [self _cada_service:@"getIndexLatestPrice" paramInfo:paramInfo dataType:CVDataTypeIndexLatestPrice];
		[parameters release];
		[arg1 release];
	}
	
	return dict;
}

/*
 * It gets the securities of fund
 *
 * @param:	type - list type
 *			paramInfo -  lifecycle and parameter
 * @reutnr:	an array consisting of securities
 */
-(NSDictionary *)GetFundList:(CVDataProviderFundListType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	CVParamInfo *info;
	
	info = [[CVParamInfo alloc] init];
	info.minutes = paramInfo.minutes;
	switch (type) {
		case CVDataProviderFundListTypeDailySummary:
		{
			NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode], 
								   @"$format='xml'", @"$flush=false", nil];
			info.parameters = parameters;
			dict = [self _cada_service:@"getSelectedFundSummaryDaily" paramInfo:info dataType:CVDataTypeCompositeIndexList];
			[parameters release];
			break;
		}
			
		case CVDataProviderFundListTypeTopMovingSecruties:
		{
			// ($lang='en',$limit=10,$format='xml',$flush=false)
			NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],
								   @"$limit=15",@"$format='xml'",@"$flush=false", nil];
			info.parameters = parameters;
			dict = [self _cada_service:@"getTopMovingFunds" paramInfo:info dataType:CVDataTypeFundTopMovingSecurites];
			[parameters release];
			
			break;
		}
			
		default:
			break;
	}
	
	[info release];
	
	return dict;
}

-(NSDictionary *)GetFundSummary:(CVParamInfo *)paramInfo {
	return nil;
}

/*
 * It gets the securities of bond
 *
 * @param:	type - list type
 *			paramInfo -  lifecycle and parameter
 * @reutnr:	an array consisting of securities
 */
-(id)GetBondList:(CVDataProviderBondListType)type withParams:(CVParamInfo *)paramInfo {
	NSDictionary *dict = nil;
	CVParamInfo *info;
	
	info = [[CVParamInfo alloc] init];
	info.minutes = paramInfo.minutes;
	switch (type) {
		case CVDataProviderBondListTypeDailySummary:
		{
			NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],
								   @"$format='xml'", @"$flush=false", nil];
			info.parameters = parameters;
			dict = [self _cada_service:@"getSelectedBondSummaryDaily" paramInfo:info dataType:CVDataTypeCompositeIndexList];
			[parameters release];
			break;
		}
		case CVDataProviderBondListTypeTopMovingSecruties:
		{
			// ($lang='en',$limit=10,$format='xml',$flush=false)
			NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],
								   @"$limit=15",@"$format='xml'",@"$flush=false", nil];
			info.parameters = parameters;
			dict = [self _cada_service:@"getTopMovingBonds" paramInfo:info dataType:CVDataTypeBondTopMovingSecurites];
			[parameters release];
			break;
		}
			
		default:
			break;
	}
	[info release];
	return dict;
}

/*
 * It gets the sectors with its basic information, including sector name,
 * number of stocks of a sector, number of gainers as well as number of losers.
 *
 * @parm: none
 * @return: dictionary
 */
-(NSDictionary *)GetSectorList:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	CVParamInfo *info;

	// ($lang='en',$format='xml',$flush=false)
	info = [[CVParamInfo alloc] init];
	
	NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],
						   @"$format='xml'",@"$flush=false", nil];
	info.minutes = paramInfo.minutes;
	info.parameters = parameters;
	dict = [self _cada_service:@"getSectorGainerLoser" paramInfo:info dataType:CVDataTypeSectorList];
	[info release];
	[parameters release];
	
	return dict;
}

- (NSDictionary *)RefreshSectorList:(CVParamInfo *)paramInfo{
	NSDictionary *dict;
	CVParamInfo *info;
	
	// ($lang='en',$format='xml',$flush=false)
	info = [[CVParamInfo alloc] init];
	
	NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],
						   @"$format='xml'",@"$flush=false", nil];
	info.minutes = paramInfo.minutes;
	info.parameters = parameters;
	dict = [self _cada_service_update:@"getSectorGainerLoser" paramInfo:info dataType:CVDataTypeSectorList];
	[info release];
	[parameters release];
	
	return dict;
}

/*
 * It gets the top gainers and top decliners of a sector.
 *
 * @param: sectorId - the id of a sector.
 *							Sector					Id
 *						Energy						10
 *						Materials					15
 *						Industrials					20
 *						Consumer Discretionary		25
 *						Consumer Staples			30
 *						Health Care					35
 *						Financials					40
 *						Information Technology		45
 *						Telecommunication Services	50
 *						Utilities					55
 *
 * @return:	a dictionary has an array of gainers and an array of decliners.
 *			The dictionary has a key "gainers" for object of gainers array, 
 *			and a key "decliners" for object of decliners array.
 */
- (NSDictionary *)GetSectorTopGainersDecliners:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter;
	NSArray *parameters;
	NSString *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)	
	sectorId = (NSString *)paramInfo.parameters;
	idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
	parameters = [[NSArray alloc] initWithObjects:idParameter, [NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service:@"getTopDailyGainersDecliners" paramInfo:paramInfo dataType:CVDataTypeSectorTopGainerDecliner];
	[parameters release];
	[idParameter release];
		
	return dict;
}

-(NSDictionary *)GetSectorSummaryAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter;
	NSArray *parameters;
	
	CVParamInfo *info;
	NSString *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)
	info = [[CVParamInfo alloc] init];
	parameters = nil;
	sectorId = (NSString *)paramInfo.parameters;
	info.minutes = paramInfo.minutes;
	if (nil != sectorId) {
		idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
		parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],
					  @"$format='xml'",@"$flush=false", nil];
		[idParameter release];
	} else {
		parameters = [[NSArray alloc] initWithObjects:@"''",[NSString stringWithFormat:@"$lang='%@'",langCode], nil];
	}
	info.parameters = parameters;
	dict = [self _cada_service:@"getSectorSummary" paramInfo:info dataType:CVDataTypeSectorSummary];
	
	[info release];
	[parameters release];
	
	return dict;
}

-(NSDictionary *)GetSectorAll{
	NSDictionary *dict;
	NSArray *parameters;
	
	CVParamInfo *info = [[CVParamInfo alloc] init];
	info.minutes = 15;
	parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	info.parameters = parameters;
	
	dict = [self _cada_service:@"getSectorAll" paramInfo:info dataType:CVDataTypeStockCodeList];
	
	[info release];
	[parameters release];
	
	return dict;
}

-(NSDictionary *)GetSectorTurnoverAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter, *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)
	sectorId = (NSString *)paramInfo.parameters;
	idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
	NSArray *parameters;
	parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service:@"getSectorTurnover" paramInfo:paramInfo dataType:CVDataTypeSectorTurnover];
	[parameters release];
	[idParameter release];
	
	return dict;
}

-(NSDictionary *)GetSectorVolumeAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter, *sectorId;
		
	// ($code=25,$lang='en',$format='xml',$flush=false)
	sectorId = (NSString *)paramInfo.parameters;
	idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
	NSArray *parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service:@"getSectorVolume" paramInfo:paramInfo dataType:CVDataTypeSectorTurnover];
	[parameters release];
	[idParameter release];
	
	return dict;
}

-(NSDictionary *)GetSectorTotalCapitalAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter, *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)
	sectorId = (NSString *)paramInfo.parameters;
	idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
	NSArray *parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service:@"getSectorTotalCap" paramInfo:paramInfo dataType:CVDataTypeSectorTotalCap];
	[parameters release];
	[idParameter release];
		
	return dict;
}

-(NSDictionary *)GetSectorTradableCapitalAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter, *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)
	sectorId = (NSString *)paramInfo.parameters;
	idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
	NSArray *parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service:@"getSectorTradableCap" paramInfo:paramInfo dataType:CVDataTypeSectorTradableCap];
	[parameters release];
	[idParameter release];
	
	return dict;
}

-(NSDictionary *)ReGetSectorSummaryAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter;
	NSArray *parameters;
	
	CVParamInfo *info;
	NSString *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)
	info = [[CVParamInfo alloc] init];
	parameters = nil;
	sectorId = (NSString *)paramInfo.parameters;
	info.minutes = paramInfo.minutes;
	if (nil != sectorId) {
		idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
		parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],
					  @"$format='xml'",@"$flush=false", nil];
		[idParameter release];
	} else {
		parameters = [[NSArray alloc] initWithObjects:@"''",[NSString stringWithFormat:@"$lang='%@'",langCode], nil];
	}
	info.parameters = parameters;
	dict = [self _cada_service_update:@"getSectorSummary" paramInfo:info dataType:CVDataTypeSectorSummary];
	
	[info release];
	[parameters release];
	
	return dict;
}

-(NSDictionary *)ReGetSectorTurnoverAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter, *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)
	sectorId = (NSString *)paramInfo.parameters;
	idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
	NSArray *parameters;
	parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service_update:@"getSectorTurnover" paramInfo:paramInfo dataType:CVDataTypeSectorTurnover];
	[parameters release];
	[idParameter release];
	
	return dict;
}

-(NSDictionary *)ReGetSectorVolumeAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter, *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)
	sectorId = (NSString *)paramInfo.parameters;
	idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
	NSArray *parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service_update:@"getSectorVolume" paramInfo:paramInfo dataType:CVDataTypeSectorTurnover];
	[parameters release];
	[idParameter release];
	
	return dict;
}

-(NSDictionary *)ReGetSectorTotalCapitalAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter, *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)
	sectorId = (NSString *)paramInfo.parameters;
	idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
	NSArray *parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service_update:@"getSectorTotalCap" paramInfo:paramInfo dataType:CVDataTypeSectorTotalCap];
	[parameters release];
	[idParameter release];
	
	return dict;
}

-(NSDictionary *)ReGetSectorTradableCapitalAtId:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *idParameter, *sectorId;
	
	// ($code=25,$lang='en',$format='xml',$flush=false)
	sectorId = (NSString *)paramInfo.parameters;
	idParameter = [[NSString alloc] initWithFormat:@"$code=%@", sectorId];
	NSArray *parameters = [[NSArray alloc] initWithObjects:idParameter,[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service_update:@"getSectorTradableCap" paramInfo:paramInfo dataType:CVDataTypeSectorTradableCap];
	[parameters release];
	[idParameter release];
	
	return dict;
}

-(NSArray *)GetMacroList {
	return nil;
}

/*
 * It retrieves the history data of an index of macro.
 *
 * @param:	leftAxis - the first parameter for retrieving the data, it shall not be nil.
 *			rightAxis - the second parameter for retrieving the data, it could be nil.
 * @return:	NSDcitionary-typed value. The dictionary has two objects with keys "head" and
 *			"data". Object of head is an array, element of which has the structure - name
 *			and value. Name is the key that exists in each NSDictionary-typed element of 
 *			object of data, and value is the readable title corresponding to key which
 *			can be shown on UI. Object of data is also an array carries elements holding keys
 *			that is defined in object of head, you can get the value by request for key 
 *			"DATE", "ZBZ_2" and "ZBZ" (ZBZ_2 - Growth, ZBZ - Value).
 */
-(NSDictionary *)GetMacroIndexData:(NSString *)leftAxis andArg:(NSString *)rightAxis {
	NSDictionary *dict;
	NSString *parameter1;
	NSString *parameter2;
	
	CVParamInfo *info;
	
	// ($leftAxis='Tertiary Industry Output (RMB 100 Million)',$rightAxis='Tertiary Industry Output Growth',$lang='en',$format='xml',$flush=false)
	info = [[CVParamInfo alloc] init];
	info.minutes = 24*60;
	parameter1 = [[NSString alloc] initWithFormat:@"$leftAxis='%@'", leftAxis];
	if (nil != rightAxis) {
		parameter2 = [[NSString alloc] initWithFormat:@"$rightAxis='%@'", rightAxis];
	} else {
		parameter2 = [[NSString alloc] initWithString:@"''"];
	}
	NSArray *parameters = [[NSArray alloc] initWithObjects:parameter1,parameter2,[NSString stringWithFormat:@"$lang='%@'",langCode],@"$format='xml'",@"$flush=false", nil];
	info.parameters = parameters;
	dict = [self _cada_service:@"getMacroData" paramInfo:info dataType:CVDataTypeMacroData];
	[info release];
	[parameters release];
	[parameter1 release];
	[parameter2 release];
	
	return dict;
}

/*
 * It gets the balance statistics of an equity
 *
 * @param:	paramInfo - equity code and lifecycle
 * @return:	balance statistics
 */
-(NSDictionary *)GetStockBlance:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *code;
	
	code = (NSString *)paramInfo.parameters;
	if (nil != code) {
		// ($gpdm='600600',$lang='en',$format='xml',$flush=false)
		NSString *arg1;
		NSString *arg2;
		
		arg1 = [[NSString alloc] initWithFormat:@"$gpdm='%@'", code];
		arg2 = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
		NSArray *parameters = [[NSArray alloc] initWithObjects:arg1, arg2, @"$format='xml'", @"$flush=false", nil];
		paramInfo.parameters = parameters;
		dict = [self _cada_service:@"getEquityBlanceSheet" paramInfo:paramInfo dataType:CVDataTypeEquityBalanceSheet];
		[arg1 release];
		[arg2 release];
		[parameters release];
	} else {
		dict = nil;
	}

	return dict;
}

-(NSDictionary *)GetStockIncomeStatement:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *code;
	
	code = (NSString *)paramInfo.parameters;
	if (nil != code) {
		// ($gpdm='600600',$lang='en',$format='xml',$flush=false)
		NSString *arg1;
		NSString *arg2;
		arg1 = [[NSString alloc] initWithFormat:@"$gpdm='%@'", code];
		if (nil == langCode) {
			langCode = @"en";
		}
		arg2 = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
		NSArray *parameters = [[NSArray alloc] initWithObjects:arg1, arg2, @"$format='xml'", @"$flush=false", nil];
		paramInfo.parameters = parameters;
		dict = [self _cada_service:@"getEquityIncomeStatement" paramInfo:paramInfo dataType:CVDataTypeEquityIncomeStatement];
		[arg1 release];
		[arg2 release];
		[parameters release];
	} else {
		dict = nil;
	}
	
	return dict;
}

- (NSDictionary *)GetStockCashFlow:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *code;
	
	code = (NSString *)paramInfo.parameters;
	if (nil != code) {
		// ($gpdm='600600',$lang='en',$format='xml',$flush=false)
		NSString *arg1;
		NSString *arg2;
		
		arg1 = [[NSString alloc] initWithFormat:@"$gpdm='%@'", code];
		if (nil == langCode) {
			langCode = @"en";
		}
		arg2 = [[NSString alloc] initWithFormat:@"$lang='%@'", langCode];
		NSArray *parameters = [[NSArray alloc] initWithObjects:arg1, arg2, @"$format='xml'", @"$flush=false", nil];
		paramInfo.parameters = parameters;
		dict = [self _cada_service:@"getEquityCashflowStatement" paramInfo:paramInfo dataType:CVDataTypeEquityCashFlow];
		[arg1 release];
		[arg2 release];
		[parameters release];
	} else {
		dict = nil;
	}
	
	return dict;
}

-(BOOL)IsCodeAvailable:(NSString *)code {
	return NO;
}

-(BOOL)IsNameAvailable:(NSString *)code {
	return NO;
}

-(NSUInteger)AddFavorite:(id)obj {
	return 0;
}


-(NSDictionary *)GetMostActivatedTurnover:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *code = (NSString *)paramInfo.parameters;
	NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$index_code='%@'",code],
						   [NSString stringWithFormat:@"$lang='%@'",langCode],
						   @"$limit=2",@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service:@"getLatestTurnover" paramInfo:paramInfo dataType:CVDataTypeSectorList];
	[parameters release];
	return dict;
}

-(NSDictionary *)GetMostActivatedMarketCap:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *code = (NSString *)paramInfo.parameters;
	NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$index_code='%@'",code],
						   [NSString stringWithFormat:@"$lang='%@'",langCode],
						   @"$limit=2",@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service:@"getLargestMarketCap" paramInfo:paramInfo dataType:CVDataTypeSectorList];
	[parameters release];
	return dict;
}


-(NSDictionary *)GetMostActivatedTopGainer:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *code = (NSString *)paramInfo.parameters;
	NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$index_code='%@'",code],
						   [NSString stringWithFormat:@"$lang='%@'",langCode],
						   @"$limit=2",@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service:@"getIndexTop10DailyGainersDecliners" paramInfo:paramInfo dataType:CVDataTypeSectorList];
	[parameters release];
	return dict;
}

// retrieves data directory from server.

-(NSDictionary *)RegetMostActivatedTurnover:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *code = (NSString *)paramInfo.parameters;
	NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$index_code='%@'",code],
						   [NSString stringWithFormat:@"$lang='%@'",langCode],
						   @"$limit=2",@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service_update:@"getLatestTurnover" paramInfo:paramInfo dataType:CVDataTypeSectorList];
	[parameters release];
	return dict;
}

- (NSDictionary *)RegetMostActivatedMarketCap:(CVParamInfo *)paramInfo {
	NSDictionary *dict;
	NSString *code = (NSString *)paramInfo.parameters;
	NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$index_code='%@'",code],
						   [NSString stringWithFormat:@"$lang='%@'",langCode],
						   @"$limit=2",@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service_update:@"getLargestMarketCap" paramInfo:paramInfo dataType:CVDataTypeSectorList];
	[parameters release];
	return dict;
}

-(NSDictionary *)RegetMostActivatedTopGainer:(CVParamInfo *)paramInfo
{
	NSDictionary *dict;
	NSString *code = (NSString *)paramInfo.parameters;
	NSArray *parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$index_code='%@'",code],
						   [NSString stringWithFormat:@"$lang='%@'",langCode],
						   @"$limit=2",@"$format='xml'",@"$flush=false", nil];
	paramInfo.parameters = parameters;
	dict = [self _cada_service_update:@"getIndexTop10DailyGainersDecliners" paramInfo:paramInfo dataType:CVDataTypeSectorList];
	[parameters release];
	return dict;
}
/*
 * Get the benchmark info
 *
 */
-(NSDictionary *)GetBenchmark:(CVDataProviderBenchmarkType)dataType WithParamInfo:(CVParamInfo *)paramInfo{
	NSDictionary *dict;
	
	switch (dataType) {
		case CVDataProviderBenchmarkTypeTopAShare:
		{
			NSString *strLimit = (NSString *)paramInfo.parameters;
			NSString *param1 = [NSString stringWithFormat:@"'%@'",langCode];
			NSString *param2 = [NSString stringWithFormat:@"%@",strLimit];
			NSString *param3 = [NSString stringWithFormat:@"'xml'"];
			NSString *param4 = [NSString stringWithFormat:@"false"];
			NSArray *paramArray = [[NSArray alloc] initWithObjects:param1, param2, param3, param4, nil];
			
			dict = [self _cada_service:@"GetTopAShares" withParams:paramArray dataType:CVDataTypeBenchmarkTopAShare];
			break;
		}
			
		case CVDataProviderBenchmarkTypeTopBlueChips:
		{
			NSString *strLimit = (NSString *)paramInfo.parameters;
			NSString *param1 = [NSString stringWithFormat:@"'%@'",langCode];
			NSString *param2 = [NSString stringWithFormat:@"%@",strLimit];
			NSString *param3 = [NSString stringWithFormat:@"'xml'"];
			NSString *param4 = [NSString stringWithFormat:@"false"];
			NSArray *paramArray = [[NSArray alloc] initWithObjects:param1, param2, param3, param4, nil];
			
			dict = [self _cada_service:@"GetTopBlueChips" withParams:paramArray dataType:CVDataTypeBenchmarkTopBlueChips];
			break;
		}
			
		default:
			break;
	}
	return dict;
}

/*
 * it retrieves the company log
 *
 * @param:	code -  company code
 * @reutrn:	the NSString-typed adress of the logo
 */
-(NSString *)GetCompanyLogo:(NSString *)code
{
	NSString *retStr;
	NSString *retPath;
	NSArray *parameters;
	NSDictionary *attribute;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *bundlePath = [[NSBundle mainBundle] pathForResource:code ofType:@"png"];
	NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
	NSString *documentPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",code]];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM"];
	

	attribute = [fileManager attributesOfItemAtPath:documentPath error:nil];
	if(!attribute)
		attribute = [fileManager attributesOfItemAtPath:bundlePath error:nil];
	NSDate *createDate = [attribute objectForKey:@"NSFileModificationDate"];
	NSDate *currentDate = [NSDate date];
	NSString *create = [dateFormatter stringFromDate:createDate];
	NSString *current = [dateFormatter stringFromDate:currentDate];
	
	//如果创建时间的月不同，则更新文件
	if(![create isEqualToString:current]){
		[fileManager removeItemAtPath:documentPath error:nil];
		parameters = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"$gpdm='%@'",code], nil];
		CVWebServiceAgent *agent = [[CVWebServiceAgent alloc] init];
		retStr = [agent serviceUrl:@"getCompanyLogo" args:parameters];
		NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:retStr]];
		if(data){
			[data writeToFile:documentPath atomically:NO];
			retPath = documentPath;
		}
		else{
			retPath = [[NSBundle mainBundle] pathForResource:@"CompanyDefaultLogo.png" ofType:nil];
		}
		[parameters release];
		[agent release];
	}
	else{
		if([fileManager fileExistsAtPath:documentPath])
			retPath = documentPath;
		else
			retPath = bundlePath;
	}
	
	[dateFormatter release];
	return retPath;
}

/*
 * it start a thread which updates the local cached data
 * at a given time span.
 */
-(void)startScheduledProcess {
	NSTimer *serviceTimer;
	NSInteger minites;
	NSTimeInterval scheduledInterval;
	//
	// minites = [s cvCachedDataLifecycle];
	//
	scheduledInterval = minites * 60;
	
	serviceTimer = [NSTimer timerWithTimeInterval:scheduledInterval target:self
						  selector:@selector(_scheduledProcess:) 
						  userInfo:nil repeats:YES];
	
	NSRunLoop *loop;
	loop = [NSRunLoop mainRunLoop];
	[loop addTimer:serviceTimer forMode:NSDefaultRunLoopMode];
}


/*
 *
 * Get Daily Market & Board Statistics
 *
 */
-(NSDictionary *)GetDailyMarketStatistics{
	NSDictionary *dict = nil;

	NSString *param1 = [NSString stringWithFormat:@"'%@'",langCode];
	NSString *param2 = [NSString stringWithFormat:@"'xml'"];
	NSString *param3 = [NSString stringWithFormat:@"false"];
	NSArray *paramArray = [[NSArray alloc] initWithObjects:param1, param2, param3, nil];
	
	dict = [self _cada_service:@"getDailyMarketStatistics" withParams:paramArray dataType:CVDataTypeBenchmarkTopAShare];
	
	return dict;
}

-(NSDictionary *)GetDailyBoardStatistics{
	NSDictionary *dict = nil;
	
	NSString *param1 = [NSString stringWithFormat:@"'%@'",langCode];
	NSString *param2 = [NSString stringWithFormat:@"'xml'"];
	NSString *param3 = [NSString stringWithFormat:@"false"];
	NSArray *paramArray = [[NSArray alloc] initWithObjects:param1, param2, param3, nil];
	
	dict = [self _cada_service:@"getDailyBoardStatistics" withParams:paramArray dataType:CVDataTypeBenchmarkTopAShare];
	
	return dict;
}
@end
