//
//  CVFinancialSummaryCompositeIndexFormView.h
//  CapitalVueHD
//
//  Created by jishen on 9/12/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVIndexFormView.h"

@interface CVFinancialSummaryCompositeIndexFormView : CVIndexFormView {
	NSMutableArray *compareArray;
}

@property (nonatomic, retain) NSMutableArray *compareArray;

@end
