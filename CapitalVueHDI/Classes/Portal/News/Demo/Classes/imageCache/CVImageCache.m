//
//  GWImageCache.m
//  GWMain
//
//  Created by ANNA on 10-7-24.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVImageCache.h"
#import "CVImageLoaderOperation.h"

static CVImageCache* gImageCache = NULL;
static NSString* dictCache = @"imageDict";

#define kMaxImageCache	100

@interface CVImageCache()

- (NSString *)cacheFilePathForUrl:(NSString*)url;

@end


@implementation CVImageCache

+ (CVImageCache *)defaultCache
{
	if ( !gImageCache )
	{
		gImageCache = [[CVImageCache alloc] init];
	}
	return gImageCache;
}

+ (void)CloseCache
{
	[gImageCache release];
	gImageCache = nil;
}

- (id)init
{
	if ( self = [super init] )
	{
		_imageLoadindQueue = [NSOperationQueue new];
		_requestorDict = [NSMutableDictionary new];
		[self readDict];
		
		_instanceLock = [[NSLock alloc] init];
	}
	return self;
}

- (UIImage *)requestor:(id<CVImageCacheDelegate>)requestor imageUrl:(NSString *)url
{

	NSString *imagePath = [_imageDict objectForKey:url];

	
	if (imagePath)
	{
		NSData* imageData = [NSKeyedUnarchiver unarchiveObjectWithFile:imagePath];
		UIImage* image = [UIImage imageWithData:imageData];
		if ( !image )
		{
			image = [UIImage imageNamed:@"default.jpg"];
		}
		return image;
	}
	else 
	{
		[_requestorDict setObject:requestor forKey:url];
		CVImageLoaderOperation* imageLoaderOp = [CVImageLoaderOperation new];
		imageLoaderOp.imageUrl = url;
		imageLoaderOp.operationDelegate = self;
		[_imageLoadindQueue addOperation:imageLoaderOp];
		[imageLoaderOp release];
		return nil;
		//return [UIImage imageNamed:@"default.jpg"];
	}
}

- (void)cancelAllRequest
{
	[_imageLoadindQueue cancelAllOperations];
}

- (void)removeAll
{
	NSArray* urlArray = [_imageDict allKeys];
	[self removeCacheImages:urlArray];
}

- (void)removeCacheImages:(NSArray *)array;
{
	for ( NSString* imageUrl in array )
	{
		[self removeCacheImage:imageUrl];
	}
}

- (void)removeCacheImage:(NSString *)imageUrl
{
	NSString* imagePath = [_imageDict objectForKey:imageUrl];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL result = [fileManager removeItemAtPath:imagePath error:NULL];
	if (result)
	{
		[_imageDict removeObjectForKey:imageUrl];
	}
	[fileManager release];
}

#pragma mark -
#pragma mark Private Method
- (NSString *)cacheFilePathForUrl:(NSString*)url
{
	NSArray* urlComponets = [url componentsSeparatedByString:@"/"];
	NSArray* filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* filePath = [filePaths objectAtIndex:0];
	filePath = [filePath stringByAppendingPathComponent:[urlComponets lastObject]];
	return filePath;
}

#pragma mark -
#pragma mark GWImageLoaderOperation delegate
- (void)didReceiveImage:(NSData *)imageData forUrl:(NSString *)url
{
	[_instanceLock lock];
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	NSString* filePath = [self cacheFilePathForUrl:url];
	BOOL result = [NSKeyedArchiver archiveRootObject:imageData toFile:filePath];
	if ( result )
	{
		[_imageDict setObject:filePath forKey:url];
		
		if ( [[_imageDict allKeys] count] > kMaxImageCache )
		{
			NSString* firstImageUrl = [[_imageDict allKeys] objectAtIndex:0];
			[self removeCacheImage:firstImageUrl];
			[_imageDict removeObjectForKey:firstImageUrl];
		}
	}
	id<CVImageCacheDelegate> delegate = [_requestorDict objectForKey:url];
	[delegate didRecievedImage:[UIImage imageWithData:imageData] forUrl:url];
	[_requestorDict removeObjectForKey:url];
	
	[pool release];
	[_instanceLock unlock];
}

- (void)didReveivedError:(NSError *)error forUrl:(NSString *)url
{
	id<CVImageCacheDelegate> delegate = [_requestorDict objectForKey:url];
	[delegate didRunIntoError:error forUrl:url];
	[_requestorDict removeObjectForKey:url];
}

- (void)cacheDict
{
	NSString* filePath = [self cacheFilePathForUrl:dictCache];
	[NSKeyedArchiver archiveRootObject:_imageDict toFile:filePath];
}

- (void)readDict
{
	NSString* filePath = [self cacheFilePathForUrl:dictCache];
	_imageDict = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	if (_imageDict)
	{
		[_imageDict retain];
	}
	else 
	{
		_imageDict = [NSMutableDictionary new];
	}
}

- (void)dealloc
{
	[_imageDict release];
	[_imageLoadindQueue release];
	[_requestorDict release];
	[_instanceLock release];
	
	[super dealloc];
}

@end
