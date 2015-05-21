//
//  CVChartDataCache.m
//  CapitalVueHD
//
//  Created by jishen on 9/15/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVChartDataCache.h"

static CVChartDataCache *_gDataCache = NULL;
static NSString* _dictCache = @"charDataDictionary";

#define kMaxCacheSize 20

@interface CVChartDataCache()

- (NSString *)cacheFilePathForIdentifier:(NSString *)indentifier;

@end

@implementation CVChartDataCache

+ (CVChartDataCache *)defaultCache
{
	if ( !_gDataCache )
	{
		_gDataCache = [[CVChartDataCache alloc] init];
	}
	return _gDataCache;
}

+ (void)CloseCache
{
	[_gDataCache release];
	_gDataCache = nil;
}

- (id)init
{
	if ( self = [super init] )
	{
		_dataLoadindQueue = [NSOperationQueue new];
		_requestorDict = [NSMutableDictionary new];
		[self readDict];
		
		_instanceLock = [[NSLock alloc] init];
	}
	return self;
}


- (void)dealloc
{
	[_chartDataDict release];
	[_dataLoadindQueue release];
	[_requestorDict release];
	[_instanceLock release];
	
	[super dealloc];
}


- (NSDictionary *)requestor:(id<CVChartDataCacheDelegate>)requestor forIdentifier:(NSString *)identifier {
	NSString *dataPath = [_chartDataDict objectForKey:identifier];
	NSDictionary *returnDict;
	
	returnDict = nil;
	if (dataPath) {
		NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
		
		if (nil != dataDict) {
			returnDict = [[[NSDictionary alloc] initWithDictionary:dataDict] autorelease];
		}
	}
	else 
	{
		[_requestorDict setObject:requestor forKey:identifier];
		CVChartDataLoadOperation *loadingOp = [CVChartDataLoadOperation new];
		loadingOp.symbol = identifier;
		loadingOp.code = identifier;
		loadingOp.delegate = self;
		[_dataLoadindQueue addOperation:loadingOp];
		[loadingOp release];
	}
	
	return returnDict;
}


- (void)cancelAllRequest
{
	[_dataLoadindQueue cancelAllOperations];
}


- (void)removeAll {
	NSArray* array = [_chartDataDict allKeys];
	[self removeCacheData:array];
}

- (void)removeCacheData:(NSArray *)array {
	for ( NSString* identifier in array )
	{
		[self removeCacheDataWithIdentifier:identifier];
	}
}

- (void)removeCacheDataWithIdentifier:(NSString *)identifier {
	NSString* dataPath = [_chartDataDict objectForKey:identifier];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL result = [fileManager removeItemAtPath:dataPath error:NULL];
	if (result)
	{
		[_chartDataDict removeObjectForKey:identifier];
	}

}

#pragma mark -
#pragma mark Private Method
- (NSString *)cacheFilePathForIdentifier:(NSString*)url
{
	NSArray* urlComponets = [url componentsSeparatedByString:@"/"];
	NSArray* filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* filePath = [filePaths objectAtIndex:0];
	filePath = [filePath stringByAppendingPathComponent:[urlComponets lastObject]];
	return filePath;
}

#pragma mark -
#pragma mark CVChartDataLoadOperationDelegate delegate
- (void)didReceiveData:(NSDictionary *)data forIdentifier:(NSString *)identifier {
	[_instanceLock lock];
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	NSString* filePath = [self cacheFilePathForIdentifier:identifier];
	BOOL result = [NSKeyedArchiver archiveRootObject:data toFile:filePath];
	if ( result ) {
		[_chartDataDict setObject:filePath forKey:identifier];
		
		if ( [[_chartDataDict allKeys] count] > kMaxCacheSize ) {
			NSString* firstIndentifier = [[_chartDataDict allKeys] objectAtIndex:0];
			[self removeCacheDataWithIdentifier:firstIndentifier];
			[_chartDataDict removeObjectForKey:firstIndentifier];
		}
	}
	id<CVChartDataCacheDelegate> delegate = [_requestorDict objectForKey:identifier];
	[delegate didRecievedData:data forIdentifier:identifier];
	[_requestorDict removeObjectForKey:identifier];
	
	[pool release];
	[_instanceLock unlock];
}

- (void)didReveivedError:(NSError *)error forIdentifier:(NSString *)identifier {
	id<CVChartDataCacheDelegate> delegate = [_requestorDict objectForKey:identifier];
	[delegate didRunIntoError:error forIdentifier:identifier];
	[_requestorDict removeObjectForKey:identifier];
}

- (void)cacheDict {
	NSString* filePath = [self cacheFilePathForIdentifier:_dictCache];
	[NSKeyedArchiver archiveRootObject:_chartDataDict toFile:filePath];
}

- (void)readDict {
	NSString* filePath = [self cacheFilePathForIdentifier:_dictCache];
	_chartDataDict = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	if (_chartDataDict)
	{
		[_chartDataDict retain];
	}
	else 
	{
		_chartDataDict = [NSMutableDictionary new];
	}
}

@end
