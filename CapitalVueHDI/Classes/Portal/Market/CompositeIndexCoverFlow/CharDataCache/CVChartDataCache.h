//
//  CVChartDataCache.h
//  CapitalVueHD
//
//  Created by jishen on 9/15/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CVChartDataLoadOperation.h"

@protocol CVChartDataCacheDelegate <NSObject>

- (void)didRecievedData:(NSDictionary *)dictionary forIdentifier:(NSString *)identifier;
- (void)didRunIntoError:(NSError *)error forIdentifier:(NSString *)identifier;

@end

@interface CVChartDataCache : NSObject <CVChartDataLoadOperationDelegate> {
	NSMutableDictionary*	_chartDataDict;
	NSOperationQueue*		_dataLoadindQueue;
	NSMutableDictionary*	_requestorDict;
@private
	NSLock*					_instanceLock;
}

+ (CVChartDataCache *)defaultCache;
+ (void)CloseCache;

- (NSDictionary *)requestor:(id<CVChartDataCacheDelegate>)requestor forIdentifier:(NSString *)identifier;
- (void)cacheDict;
- (void)readDict;
- (void)cancelAllRequest;
- (void)removeAll;
- (void)removeCacheData:(NSArray *)array;
- (void)removeCacheDataWithIdentifier:(NSString *)indentifier;

@end
