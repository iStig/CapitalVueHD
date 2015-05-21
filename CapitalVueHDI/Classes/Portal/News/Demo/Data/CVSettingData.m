//
//  CVSettingData.m
//  CapitalValDemo
//
//  Created by leon on 10-8-9.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
/*
 设置数据类，用来保存和读取Setting.plist数据
 Setting.plist用于存放用户设置模块的相关信息
 */

#import "CVSettingData.h"
#define SETTING_FILE       @"Setting.plist"

@implementation CVSettingData
@synthesize arrayData = _arrayData;
@synthesize filePath = _filePath;

static CVSettingData *sharedInstance = nil;

+ (CVSettingData *)sharedSettingData{
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

- (NSMutableArray *)getArrayData{
	return _arrayData;
}

//讲array保存到Setting.plist文件中
- (void) setArrayData: (NSMutableArray *)array{
	_arrayData = array;
	[_arrayData writeToFile:_filePath atomically:NO];
}

//由Setting.plist初始化类,从plist里面读取Array放到m_arrayData里面
- (id)init {
	if (self = [super init]) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSError *error;
		NSArray *arrayDocPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *strDocPath = [arrayDocPaths objectAtIndex:0]  ;
		
		_filePath = [strDocPath stringByAppendingPathComponent:SETTING_FILE];
		
		if ([fileManager fileExistsAtPath:_filePath] == NO) {
			NSString *pathToDefaultPlist = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
			if ([fileManager copyItemAtPath:pathToDefaultPlist toPath:_filePath error:&error] == NO) {
				NSAssert1(0, @"Failed to copy data with error message '%@'.", [error localizedDescription]);
			}
		}
		_arrayData = [NSMutableArray arrayWithContentsOfFile:_filePath];
	}
	
	return self;
}

- (void)dealloc {
	[_arrayData release];
	[_filePath release];
	[super dealloc];
}
@end
