//
//  CVServiceRequest.m
//  dfdaily
//
//  Created by jishen on 6/5/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVServiceRequest.h"



@implementation ServiceRequest

@synthesize url;
@synthesize type;

#define CVNEWS_BASE_URL @"http://data.capitalvue.com/soap.php?m=service&method=genEncrptyUrl&cmd=CV_Services."

- (NSString *)getServiceURL {
//	NSMutableString *stringURL = [[[NSMutableString alloc] initWithCapacity:128] autorelease];
//	
//	[stringURL appendFormat:@"%@%@", DFDAILY_BASE_URL, url];
//	
//	//NSLog(stringURL);
	NSMutableString *stringURL = [[[NSMutableString alloc] initWithCapacity:128] autorelease];
	[stringURL appendFormat:@"%@%@", CVNEWS_BASE_URL, url];
	NSURL *urlAddress;
    NSMutableURLRequest *urlRequest;
	urlAddress = [NSURL URLWithString:stringURL];
	//urlAddress = [NSURL URLWithString:@"http://data.capitalvue.com/soap.php?m=service&method=genEncrptyUrl&cmd=CV_Services.GetTodayNews%280,32%29"];
	urlRequest = [[[NSMutableURLRequest alloc] initWithURL:urlAddress] autorelease];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSString *strTodaysNewsUrl = [self getTodaysNewsUrl:result];	
	return strTodaysNewsUrl;
}

- (NSString *)getTodaysNewsUrl:(NSString *)str{
	int strlength = ([str length]-36)/2;
	str = [str substringWithRange:NSMakeRange(strlength + 27, strlength)];
	//NSLog(str);
	return str;
}

- (void)dealloc {
	[url release];
	[super dealloc];
}
@end
