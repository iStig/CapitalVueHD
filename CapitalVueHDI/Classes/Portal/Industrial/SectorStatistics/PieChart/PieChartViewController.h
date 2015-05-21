//
//  PieChartViewController.h
//  PieChart
//
//  Created by ANNA on 10-8-12.
//  Copyright Smiling Mobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPieChart.h"

@class CVShareInfoView;
@interface PieChartViewController : UIViewController
{
	CVPieChart* _chartView;
	
	CVShareInfoView* _shareInfoView;
}

@end

