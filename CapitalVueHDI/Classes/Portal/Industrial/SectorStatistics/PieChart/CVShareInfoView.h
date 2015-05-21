//
//  CVShareInfoView.h
//  PieChart
//
//  Created by ANNA on 10-8-13.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVShareInfo.h"
#import "CVPieChartConstants.h"

@class CVShareInfoLabel;
@class CVShareInfoContentView;
@interface CVShareInfoView : UIView 
{
	NSString* _sectorCode;
	CVPieViewType		_viewType;
	CGGradientRef		_gradient;
	
	CVShareInfoContentView*		_contentView;
	CVShareInfoLabel*			_titleLabel;
	UIButton*					_titleButton;
	CVShareInfoLabel*			_dateLabel;
	CVShareInfoLabel*			_coMarkLabel;
	CVShareInfoLabel*			_coValueLabel;
	CVShareInfoLabel*			_chgMarkLabel;
	CVShareInfoLabel*			_chgValueLabel;
	CVShareInfoLabel*			_gainerMarkLabel;
	CVShareInfoLabel*			_gainerValueLabel;
	CVShareInfoLabel*			_declineMarkLabel;
	CVShareInfoLabel*			_declineValueLabel;
	CVShareInfoLabel*			_tradeMarkLabel;
	CVShareInfoLabel*			_tradeValueLabel;
	CVShareInfoLabel*			_netmarginMarkLabel;
	CVShareInfoLabel*			_netmarginValueLabel;
	CVShareInfoLabel*			_roeMarkLabel;
	CVShareInfoLabel*			_roeValueLabel;
	CVShareInfoLabel*			_peMarkLabel;
	CVShareInfoLabel*			_peValueLabel;
	CVShareInfoLabel*			_pbMarkLabel;
	CVShareInfoLabel*			_pbValueLabel;
	
	UIColor *positiveColor;
	UIColor *negtiveColor;
}

@property (nonatomic, assign) CVPieViewType	viewType;
@property (nonatomic, retain) NSString* _sectorCode;

- (void)drawInContext:(CGContextRef)context;

- (void)showData:(CVShareInfo *)shareInfo;

@end
