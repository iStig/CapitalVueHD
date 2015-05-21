//
//  CVSettingTableView.h
//  CapitalValDemo
//
//  Created by leon on 10-8-7.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVSettingTableController.h"


@interface CVSettingTableView : UIView {
	CVSettingTableController *_tableControllerSetting;
}
@property (nonatomic, retain) CVSettingTableController *tableControllerSetting;

@end
