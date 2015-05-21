//
//  CVTableView.h
//  TableDesign
//
//  Created by ANNA on 10-8-10.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVTableDataView.h"

@protocol CVFormViewDelegate

- (void)didSelectRow:(int)row;

@end


@class CVTableDataView;
@class CVHeaderView;
@class CVIndexButton;
@interface CVFormView : UIView <CVTableDataViewDataSource>
{
	NSMutableArray*	_dataArray;
	NSMutableArray* _styleArray;
	NSMutableArray* _headerArray;
	NSMutableArray* _headerStyleArray;
	NSMutableArray* _buttonArray;
	NSMutableArray* _widthArray;
	NSMutableArray* _spaceArray;
	NSMutableArray* _accumArray;
	NSMutableArray* _rowButtonArray;
	
	NSArray*		_filterArray;
	NSString*		_filterPath;
	
	float			_rowHeight;
	float			_headerHeight;
	CVTableDataView* _dataView;
	CVHeaderView*	_headerView;
	BOOL			_ascending;
	
	BOOL			_selfAdjust;
	id<CVFormViewDelegate> _formDelegate;
	
	// added by jishen for temperarily resolving the bug
	// Li Chuan will fix it.
	BOOL isFiltered;
}

@property (nonatomic, retain) NSMutableArray* dataArray;
@property (nonatomic, retain) NSMutableArray* styleArray;
@property (nonatomic, retain) NSMutableArray* headerArray;
@property (nonatomic, retain) NSMutableArray* headerStyleArray;
@property (nonatomic, retain) NSMutableArray* widthArray;
@property (nonatomic, retain) NSMutableArray* spaceArray;
@property (nonatomic, retain) NSArray*		  filterArray;
@property (nonatomic, copy)   NSString*		  filterPath;
@property (nonatomic, assign) float			  rowHeight;
@property (nonatomic, assign) float			  headerHeight;
@property (nonatomic, assign) BOOL			  selfAdjust;
@property (nonatomic, assign) id<CVFormViewDelegate> formDelegate;

@property (nonatomic, assign) BOOL isFiltered;

- (void)illustrateAll;
- (void)sortData:(CVIndexButton *)button;
- (void)jumpForRow:(CVIndexButton *)button;
- (void)drawInContext:(CGContextRef)context;

+ (NSMutableArray *)dataArrayFromDict:(NSDictionary *)dict;
+ (NSMutableArray *)headerArrayFromDict:(NSDictionary *)dict;

@end
