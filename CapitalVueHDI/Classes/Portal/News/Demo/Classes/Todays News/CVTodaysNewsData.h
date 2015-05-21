//
//  CVTodaysNewsData.h
//  CapitalValDemo
//
//  Created by leon on 10-8-11.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVTodaysNewsServiceResponse.h"

@protocol TodaysNewsDataDelegate

- (void)getDataFinished:(NSMutableArray *)array;

@end


@interface CVTodaysNewsData : NSObject {
	id<TodaysNewsDataDelegate> _dataDelegate;
	//NSMutableArray *_arrayTodaysNews;
	CVTodaysNewsServiceResponse *_response;
}
//@property (nonatomic, retain) NSMutableArray *arrayTodaysNews;
@property (nonatomic, retain) CVTodaysNewsServiceResponse *response;
+ (CVTodaysNewsData *)sharedSettingData;
- (void)getData;
- (NSString *)getTodaysNewsUrl:(NSString *)str;
- (void)setDelegate:(id)delegate;
- (NSMutableArray *)getArrayData;
@end
