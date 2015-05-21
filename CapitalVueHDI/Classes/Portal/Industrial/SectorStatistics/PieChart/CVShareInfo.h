//
//  CVShareInfo.h
//  PieChart
//
//  Created by ANNA on 10-9-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CVShareInfo : NSObject 
{
	NSString* sectorCode;
	
	NSString* coTitle;
	NSString* chgTitle;
	NSString* gainersTitle;
	NSString* declinersTitle;
	NSString* tradableTitle;
	NSString* netmarginTitle;
	NSString* roeTitle;
	NSString* peTitle;
	NSString* pbTitle;
	
	NSString* co;
	NSString* chg;
	NSString* gainers;
	NSString* decliners;
	NSString* tradable;
	NSString* netmargin;
	NSString* roe;
	NSString* pe;
	NSString* pb;
	
	NSString* date;
	NSString* title;
}

@property (nonatomic, copy) NSString* sectorCode;
@property (nonatomic, copy) NSString* coTitle;
@property (nonatomic, copy) NSString* chgTitle;
@property (nonatomic, copy) NSString* gainersTitle;
@property (nonatomic, copy) NSString* declinersTitle;
@property (nonatomic, copy) NSString* netmarginTitle;
@property (nonatomic, copy) NSString* tradableTitle;
@property (nonatomic, copy) NSString* roeTitle;
@property (nonatomic, copy) NSString* peTitle;
@property (nonatomic, copy) NSString* pbTitle;

@property (nonatomic, copy) NSString* co;
@property (nonatomic, copy) NSString* chg;
@property (nonatomic, copy) NSString* gainers;
@property (nonatomic, copy) NSString* decliners;
@property (nonatomic, copy) NSString* netmargin;
@property (nonatomic, copy) NSString* tradable;
@property (nonatomic, copy) NSString* roe;
@property (nonatomic, copy) NSString* pe;
@property (nonatomic, copy) NSString* pb;

@property (nonatomic, copy) NSString* date;
@property (nonatomic, copy) NSString* title;

@end
