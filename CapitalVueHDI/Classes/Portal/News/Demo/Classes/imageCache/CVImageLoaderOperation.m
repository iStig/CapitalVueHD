//
//  CVImageLoaderOperation.m

//
//  Created by ANNA on 10-6-24.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVImageLoaderOperation.h"
//#import "CVDataProvider.h"

@implementation CVImageLoaderOperation

@synthesize imageUrl = _imageUrl;
@synthesize imageIndex = _imageIndex;
@synthesize operationDelegate = _operationDelegate;

- (id)init
{
	if (self = [super init] )
	{
		_defaulImage = [UIImage imageNamed:@"default.jpg"];
	}
	return self;
}

- (void)main 
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	NSURL*	  requestImageUrl = [NSURL URLWithString:self.imageUrl];
	
	if (requestImageUrl) 
	{
		NSData *photoData = [NSData dataWithContentsOfURL:requestImageUrl];
//		UIImage *photo = [UIImage imageWithData:photoData];
		
		if (photoData)
		{
			[_operationDelegate didReceiveImage:photoData forUrl:self.imageUrl];
		}
		else 
		{
			[_operationDelegate didReveivedError:nil forUrl:self.imageUrl];
		}
	} 
	else 
	{
		[_operationDelegate didReveivedError:nil forUrl:self.imageUrl];
	}
	
	[pool release];
}

- (void)dealloc
{
	[_imageUrl release];
	[_operationDelegate release];
	
	[super dealloc];
}

@end
