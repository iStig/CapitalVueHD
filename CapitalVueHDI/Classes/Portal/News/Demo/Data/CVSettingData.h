//
//  CVSettingData.h
//  CapitalValDemo
//
//  Created by leon on 10-8-9.
//  Copyright 2010 SmilingMobile. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CVSettingData : NSObject {
	NSMutableArray *_arrayData;
	NSString *_filePath;  //初始化文件的路径
}
@property (nonatomic, retain) NSMutableArray *arrayData;
@property (nonatomic, retain) NSString *filePath;

+ (CVSettingData *)sharedSettingData;
- (NSMutableArray *)getArrayData;
- (void) setArrayData: (NSMutableArray *)array; 

@end
