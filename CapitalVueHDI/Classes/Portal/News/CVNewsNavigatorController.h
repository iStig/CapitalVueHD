//
//  CVNewsNavigatorController.h
//  CapitalVueHD
//
//  Created by leon on 10-9-26.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CVNewsNavigatorControllerDelegate

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath item:(NSDictionary *)item;

- (void)selectedNextPage;

@end


@interface CVNewsNavigatorController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	id<CVNewsNavigatorControllerDelegate> navigatorDelegate;
	UITableView *_tableView;
	NSMutableArray *_arrayNews;
	BOOL _isFinished;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *arrayNews;

- (void)setDelegate:(id)delegate;
- (NSString *)stampchangetime:(NSString *)timestamp isDetail:(BOOL)isDetail;
@end
