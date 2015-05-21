//
//  CVIndexFormView.h
//  TableDesign
//
//  Created by ANNA on 10-8-12.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVFormView.h"

enum CVIndexFormType
{
	CVIndexGreen,
	CVIndexRed
};

typedef NSUInteger CVIndexFormType;

@interface CVIndexFormView : CVFormView
{
	CVIndexFormType _indexType;
}

@property (nonatomic, assign) CVIndexFormType indexType;

@end
