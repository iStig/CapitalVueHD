//
//  CVDataNews.h
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CVDataNews : NSObject {
	NSString *postId;
	NSString *title;
	NSString *body;
	NSString *ownerId;
	NSInteger timeStamp;
	NSString *setId;
	NSString *groupId;
	NSString *groupDn;
	NSString *summary;
	NSString *typeId;
	NSArray *tagList;
	NSString *url;
	NSString *textBody;
	NSString *thumbUrl;
	NSString *smallThumbUrl;
	CGSize thumbSize;
	CGSize smallThumbSize;
	NSString *tagListText;
}

@property(nonatomic, retain) NSString *postId;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *body;
@property(nonatomic, retain) NSString *ownerId;
@property(nonatomic) NSInteger timeStamp;
@property(nonatomic, retain) NSString *setId;
@property(nonatomic, retain) NSString *groupId;
@property(nonatomic, retain) NSString *groupDn;
@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSString *typeId;
@property(nonatomic, retain) NSArray *tagList;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSString *textBody;
@property(nonatomic, retain) NSString *thumbUrl;
@property(nonatomic, retain) NSString *smallThumbUrl;
@property(nonatomic) CGSize thumbSize;
@property(nonatomic) CGSize smallThumbSize;
@property(nonatomic, retain) NSString *tagListText;

@end
