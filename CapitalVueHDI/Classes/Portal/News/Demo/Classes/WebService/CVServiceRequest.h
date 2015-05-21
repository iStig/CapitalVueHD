//
//  CVServiceRequest.h
//  dfdaily
//
//  Created by leon on 8/14/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ServiceRequestListCategory,
	ServiceRequestGetPost,
	ServiceRequestInvalid
} ServiceRequestType;

@interface ServiceRequest : NSObject {
	ServiceRequestType type;
	NSString *url;
}

@property (nonatomic) ServiceRequestType type;
@property (nonatomic, retain) NSString *url;
- (NSString *)getServiceURL;
- (NSString *)getTodaysNewsUrl:(NSString *)str;
@end
