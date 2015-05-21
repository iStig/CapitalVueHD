//
//  CVImageCache.h
//  
//
//  Created by ANNA on 10-7-24.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVImageLoaderOperation.h"
#define kMaxImageCount	30

@protocol CVImageCacheDelegate<NSObject>

- (void)didRecievedImage:(UIImage *)image forUrl:(NSString *)url;
- (void)didRunIntoError:(NSError *)error forUrl:(NSString *)url;

@end


@interface CVImageCache : NSObject <CVImageLoaderOperationDelegate>
{
	NSMutableDictionary*	_imageDict;
	NSOperationQueue*		_imageLoadindQueue;
	NSMutableDictionary*	_requestorDict;
	
	NSLock*					_instanceLock;
}

+ (CVImageCache *)defaultCache;
+ (void)CloseCache;

- (UIImage *)requestor:(id<CVImageCacheDelegate>)requestor imageUrl:(NSString *)url;
- (void)cacheDict;
- (void)readDict;
- (void)cancelAllRequest;
- (void)removeAll;
- (void)removeCacheImages:(NSArray *)array;
- (void)removeCacheImage:(NSString *)imageUrl;

@end
