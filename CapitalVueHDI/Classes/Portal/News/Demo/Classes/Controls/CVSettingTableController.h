//
//  CVSettingTableController.h
//  CapitalValDemo
//
//  Created by leon on 10-8-7.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVSettingTableController : UITableViewController {
	NSMutableArray *_arraySetting;
}
@property (nonatomic, retain) NSMutableArray *arraySetting;

-(IBAction) clickSelectedButton:(id)sender;

@end
