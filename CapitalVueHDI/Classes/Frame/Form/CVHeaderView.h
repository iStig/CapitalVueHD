//
//  CVHeaderView.h
//  TableDesign
//
//  Created by ANNA on 10-8-11.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVHeaderView : UIView 
{
	NSMutableArray* _dataArray;
	NSMutableArray* _styleArray;
	NSMutableArray*	_widthArray;
	NSMutableArray* _accumArray;
	NSMutableArray* _labelArray;
	
	float			_height;
}

@property (nonatomic, retain) NSMutableArray* dataArray;
@property (nonatomic, retain) NSMutableArray* styleArray;
@property (nonatomic, retain) NSMutableArray* widthArray;
@property (nonatomic, retain) NSMutableArray* accumArray;

@property (nonatomic, assign) float			  height;

- (void)illustrateHeader:(NSMutableArray *)dataArray withStyle:(NSMutableArray *)styleArray;
@end
