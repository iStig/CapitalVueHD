//
//  CVMacroNavigatorViewController.h
//  CapitalVueHD
//
//  Created by jishen on 9/25/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPortletViewController.h"

@protocol CVMacroNavigatorViewControllerDelegate

/*
 * It tells the delegate that the item of a group is selected. An item represents an index of macro
 * If you want to do anything connecting to the item, you have to implement this method.
 *
 * @param:	group - the name of group
 *			item - a 3-key dictionary. "title", the name of the macro index; "leftAxis" and "rightAxis,
 *                 first parameter and second parameter for loading the macro data.
 * @return: none
 */
- (void)didReceiveNavigatorRequest:(NSString *)group forItem:(NSDictionary *)item indexPath:(NSIndexPath *)indexPath;

@end

@interface CVMacroNavigatorViewController : CVPortletViewController <UITableViewDelegate> {
	id <CVMacroNavigatorViewControllerDelegate> delegate;
	
@private
	IBOutlet UITableView *_tableView;
	NSArray *_navigatorGroups;
	NSMutableArray *flagArray;
	NSDictionary *currentGroupDict;
	NSDictionary *currentItem;
	@protected
	UIPopoverController *parent;
}

@property (nonatomic, assign) id <CVMacroNavigatorViewControllerDelegate> delegate;
@property (nonatomic, assign) UIPopoverController *parent;
@property (nonatomic, assign) NSDictionary *currentGroupDict;
@property (nonatomic, assign) NSDictionary *currentItem;
- (void) headerClicked:(id)sender;
- (NSInteger) numberOfRowsInSection:(NSInteger)section;
- (void)reloadCurrentItem;


@end
