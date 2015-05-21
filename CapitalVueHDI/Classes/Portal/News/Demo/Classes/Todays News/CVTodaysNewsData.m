//
//  CVTodaysNewsData.m
//  CapitalValDemo
//
//  Created by leon on 10-8-11.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
/*
 Today's News数据类，从webservice获取数据，存放在m_arrayTodaysNews中
 */

#import "CVTodaysNewsData.h"


@implementation CVTodaysNewsData
//@synthesize arrayTodaysNews = _arrayTodaysNews;
@synthesize response = _response;

static CVTodaysNewsData *sharedInstance = nil;
static NSMutableArray *_arrayTodaysNews;

+ (CVTodaysNewsData *)sharedSettingData{
	@synchronized(self) {
		if (sharedInstance == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return sharedInstance;
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

- (id)init {
	if (self = [super init]) {
		[NSThread detachNewThreadSelector:@selector(getData) toTarget:self withObject:nil];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
	// NSLog( @"MetroData.release" ) ; 
	//do nothing
}

- (id)autorelease {
	return self;
}

//通过url，向服务器请求Today's News数据
//先通过GetTodayNews获取加密后的url,然后再用get方法得到数据
- (void)getData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	ServiceRequest *request;
	
	request = [[ServiceRequest alloc] init];
	request.url = @"GetTodayNews%280,32%29";
	_response  = [[CVTodaysNewsServiceResponse alloc] init];

	[_response setDelegate:self];
	[_response startQueryAndParse:request];//returnData2];
	
	
	[pool release];
}

- (NSString *)getTodaysNewsUrl:(NSString *)str{
	int strlength = ([str length]-36)/2;
	str = [str substringWithRange:NSMakeRange(strlength + 27, strlength)];
	//NSLog(str);
	return str;
}

//通过xml解析后，返回结果
- (void)queryFinished:(NSDictionary *)data {
	_arrayTodaysNews = [data valueForKey:@"TodaysNewsDataSet"];
	
	if (_dataDelegate != nil) {
		[_dataDelegate getDataFinished:_arrayTodaysNews];
	}
}

- (NSMutableArray *)getArrayData{
	return _arrayTodaysNews;
}

- (void)setDelegate:(id)delegate{
	_dataDelegate = delegate;
}

- (void)dealloc {
	//[_arrayTodaysNews release];
	[_response release];
	[super dealloc];
}

@end
