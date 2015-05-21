    //
//  CVContentScrollPageView.m
//  CapitalValDemo
//
//  Created by leon on 10-8-11.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
/*
 放置在portlet上，显示一系列的视图，用户可以进行水平翻页
 自定义Page页数，显示内容和Scroll View的大小
 */

#import "CVContentScrollPageView.h"


@implementation CVContentScrollPageView
@synthesize NumberOfPages = _NumberOfPages;
//@synthesize m_pageControl;

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.pagingEnabled = YES;
		self.contentSize = CGSizeMake(self.frame.size.width * 8, self.frame.size.height);
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.scrollsToTop = NO;
	}
	return self;
}

- (void)dealloc {
	//[m_pageControl release];
    [super dealloc];
}


@end
