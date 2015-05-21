//
//  CVTableDataView.h
//  TableDesign
//
//  Created by ANNA on 10-8-10.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CVLabelStyle;

@protocol CVTableDataViewDataSource

- (int)rowNumber;
- (int)columnNumber;
- (CGRect)rectAtRow:(int)row Column:(int)column;
- (NSString *)dataAtRow:(int)row Column:(int)column;
- (CVLabelStyle *)styleAtRow:(int)row Column:(int)column;

@end


@interface CVTableDataView : UIView
{
	NSMutableArray*	_labelArray;
	
	id<CVTableDataViewDataSource> _dataSource;
}

@property (nonatomic, assign) id<CVTableDataViewDataSource> dataSource;

- (void)reloadData;

@end
