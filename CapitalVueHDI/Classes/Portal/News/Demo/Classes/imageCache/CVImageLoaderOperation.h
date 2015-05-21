//
//  CVImageLoaderOperation.h
//  
//
//  Created by ANNA on 10-6-24.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CVImageLoaderOperationDelegate<NSObject>

- (void)didReceiveImage:(NSData *)image forUrl:(NSString *)url;
- (void)didReveivedError:(NSError *)error forUrl:(NSString *)url;

@end


@interface CVImageLoaderOperation : NSOperation
{
	NSString*	_imageUrl;
	int			_imageIndex;
	UIImage*	_defaulImage;
	
	id<CVImageLoaderOperationDelegate> _operationDelegate;
}

@property (nonatomic, retain) NSString*	imageUrl;
@property (nonatomic, assign) int		imageIndex;

@property (nonatomic, retain) id<CVImageLoaderOperationDelegate> operationDelegate;

@end
