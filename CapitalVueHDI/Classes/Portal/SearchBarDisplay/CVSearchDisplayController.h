//
//  CVSearchDisplayController.h
//  CapitalVueHD
//
//  Created by jishen on 10/28/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CVSearchProtocol

- (void)selectedSearchItem:(NSString *)code;

@end


@interface CVSearchDisplayController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	NSMutableArray *_displayList;
@private
	id <CVSearchProtocol> searchDelegate;
	IBOutlet UITableView *_tableView;
	NSArray *_stockList;
	
	NSString *_code;
}

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSMutableArray *displayList;
- (void)setDelegate:(id)delegate;
@end
