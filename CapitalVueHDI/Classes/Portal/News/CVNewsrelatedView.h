//
//  CVNewsrelatedView.h
//  CapitalVueHD
//
//  Created by leon on 10-9-26.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVRotationView.h"

#define CV_NEWS_MAX_PAGE 10
#define CV_NEWS_PAGECAPACITY 10

@protocol CVNewsGoWebDetailProtocal

-(void)goWebDetail:(NSDictionary *)dict;

@end

@protocol CVLoadNewsDelegate

/*
 *	create new NSMutableArray for 10 more news
 */
-(NSMutableArray *)attachNewsAtPage:(NSInteger)pageNumber;

@end


enum {
	CVClassNews       = 1,
	CVClassMystock    = 2,
	CVClassMacro	  = 3,
};
@interface CVNewsrelatedView : CVRotationView<UITableViewDelegate,UITableViewDataSource> {
	id<CVNewsGoWebDetailProtocal,CVLoadNewsDelegate> relatedDelegate;
	UITableView *_tableView;
	NSUInteger newsClass;
@private
	// FIXME
	// the different purpose of @synthesize xxx = _xxx
	NSMutableArray *_tempArray;
	UILabel *_noEntryLabel;
	
	UIActivityIndicatorView *activityIndicator;
	
	NSInteger _currentPage;
	BOOL _isLoading;//value to check if this time is loading;
}
@property (nonatomic) NSUInteger newsClass;
@property (nonatomic, retain) UITableView *tableView;

-(void)setDelegate:(id)delegate;
-(NSString *)stampchangetime:(NSString *)timestamp;
-(void)appendNewsForCurrentPage;
@end
