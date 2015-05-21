//
//  CVBlanceSheetFormViewController.h
//  CapitalVueHD
//
//  Created by jishen on 10/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVBlanceSheetFormViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	id _pageData;
	UITableView *sheetTableView;
@private
	NSArray *_list;
}

@property (nonatomic, retain) IBOutlet UITableView *sheetTableView;
@property (nonatomic, retain) id pageData;


@end
