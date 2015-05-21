//  CVMenuController.h
//  CapitalVueHD
//
//  Renamed by Ji Shen on 10-9-3
//
//  CVMenuController.h
//  CapitalValDemo
//
//  Created by leon on 10-8-7.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CVMenuControllerDelegate

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface CVMenuController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	id<CVMenuControllerDelegate> menuDelegate;
	UITableView *tableMenu;
	NSMutableArray *_arraySetting;
}

@property (nonatomic, retain) UITableView *tableMenu;
@property (nonatomic, retain) NSMutableArray *arraySetting;

- (void) setDelegate:(id)delegate;

@end
