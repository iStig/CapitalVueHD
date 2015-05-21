//
//  CVPortalSetIndustryController.h
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPortalSetController.h"

#import "CVSectorStatisticsPortletViewController.h"
#import "CVSectorGainerLoserPortletViewController.h"


@interface CVPortalSetIndustryController : CVPortalSetController {
	CVSectorStatisticsPortletViewController *statisticsController;
	CVSectorGainerLoserPortletViewController *vcGainerLoser;

}

@property (nonatomic, retain) CVSectorStatisticsPortletViewController *statisticsController;
@property (nonatomic, retain) CVSectorGainerLoserPortletViewController *vcGainerLoser;

@end
