//
//  CVCompositeIndexProfileViewController.h
//  CapitalVueHD
//
//  Created by jishen on 11/3/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVCompanyProfileViewController.h"


@interface CVCompositeIndexProfileViewController : CVCompanyProfileViewController {
	UILabel *nameOfIndex;
	UILabel *nameOfIndexValue;
	UILabel *chineseNameOfIndex;
	UILabel *chineseNameOfIndexValue;
	UILabel *chineseIndexPinyin;
	UILabel *chineseIndexPinyinValue;
	UILabel *countryAndRegion;
	UILabel *countryAndRegionValue;
	UILabel *indexClassification;
	UILabel *indexClassificationValue;
	UILabel *indexCode;
	UILabel *indexCodeValue;
	UILabel *indexBaseValue;
	UILabel *indexBaseValueValue;
	UILabel *indexBaseDate;
	UILabel *indexBaseDateValue;
}

@property (nonatomic, retain) IBOutlet UILabel *nameOfIndex;
@property (nonatomic, retain) IBOutlet UILabel *nameOfIndexValue;
@property (nonatomic, retain) IBOutlet UILabel *chineseNameOfIndex;
@property (nonatomic, retain) IBOutlet UILabel *chineseNameOfIndexValue;
@property (nonatomic, retain) IBOutlet UILabel *chineseIndexPinyin;
@property (nonatomic, retain) IBOutlet UILabel *chineseIndexPinyinValue;
@property (nonatomic, retain) IBOutlet UILabel *countryAndRegion;
@property (nonatomic, retain) IBOutlet UILabel *countryAndRegionValue;
@property (nonatomic, retain) IBOutlet UILabel *indexClassification;
@property (nonatomic, retain) IBOutlet UILabel *indexClassificationValue;
@property (nonatomic, retain) IBOutlet UILabel *indexCode;
@property (nonatomic, retain) IBOutlet UILabel *indexCodeValue;
@property (nonatomic, retain) IBOutlet UILabel *indexBaseValue;
@property (nonatomic, retain) IBOutlet UILabel *indexBaseValueValue;
@property (nonatomic, retain) IBOutlet UILabel *indexBaseDate;
@property (nonatomic, retain) IBOutlet UILabel *indexBaseDateValue;

@end
