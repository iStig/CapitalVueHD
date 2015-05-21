//
//  CVChartDataLoadOperation.h
//  CapitalVueHD
//
//  Created by jishen on 9/15/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CVChartDataLoadOperationDelegate<NSObject>

- (void)didReceiveData:(NSDictionary *)data forIdentifier:(NSString *)identifier;
- (void)didReveivedError:(NSError *)error forIdentifier:(NSString *)identifier;

@end

@interface CVChartDataLoadOperation : NSOperation {
	NSString *code;
	NSString *symbol;
	NSInteger index;
	UIImage *defaulImage;
	
	id<CVChartDataLoadOperationDelegate> delegate;
}

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *symbol;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIImage *defaultImage;

@property (nonatomic, assign) id<CVChartDataLoadOperationDelegate> delegate;

@end
