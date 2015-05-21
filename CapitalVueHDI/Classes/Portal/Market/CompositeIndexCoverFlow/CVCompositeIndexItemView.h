//
//  CVCompositeIndexItemView.h
//  CapitalVueHD
//
//  Created by jishen on 9/16/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cvChartView.h"

@interface CVCompositeIndexItemView : UIView <StockChartDataSource> {
	UIImageView *backgroundView;
	UIImageView *chartBackground;
	
	UILabel *nameLabel;
	
	UILabel *dateValueLabel;
	UIImageView *arrowImageView;
	UILabel *changeValueLabel;
	UILabel *percentageLabel;
		
	UILabel *closeLabel;
	UILabel *volumenLabel;
	UILabel *rangeLabel;
	UILabel *turnoverLabel;
	
	UILabel *closeValueLabel;
	UILabel *volumenValueLabel;
	UILabel *rangeValueLabel;
	UILabel *turnoverValueLabel;
	
	NSArray *indexArray;
	
	BOOL isGainer;
	BOOL loadingFinished;
@private
	NSArray *chartDataSource;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundView;
@property (nonatomic, retain) IBOutlet UIImageView *chartBackground;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@property (nonatomic, retain) IBOutlet UILabel *dateValueLabel;
@property (nonatomic, retain) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, retain) IBOutlet UILabel *changeValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *percentageLabel;

@property (nonatomic, retain) IBOutlet UILabel *closeLabel;
@property (nonatomic, retain) IBOutlet UILabel *volumenLabel;
@property (nonatomic, retain) IBOutlet UILabel *rangeLabel;
@property (nonatomic, retain) IBOutlet UILabel *turnoverLabel;

@property (nonatomic, retain) IBOutlet UILabel *closeValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *volumenValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *rangeValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *turnoverValueLabel;

@property (nonatomic, retain) NSArray *indexArray;
@property (nonatomic, assign) BOOL isGainer;
@property (nonatomic, assign) BOOL loadingFinished;

@end
