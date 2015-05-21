//
//  DreamScroll.h
//  CapitalVueHD
//
//  Created by Stan Wu on 10-10-22.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "CVPageControlView.h"

#define CVSCROLLPAGE_INDICTOR_WIDTH  150
#define CVSCROLLPAGE_INDICTOR_HEIGHT 18

@protocol CVScrollPageViewDeleage

- (NSUInteger)numberOfPagesInScrollPageView;
- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index;
- (void)didScrollToPageAtIndex:(NSUInteger)index;

@end


@interface DreamScroll : UIViewController <UIScrollViewDelegate> {
	id<CVScrollPageViewDeleage> pageViewDelegate;
	NSUInteger pageCount;
	UIScrollView *scrollView;
	CVPageControlView *pageControl;
@private
	CGRect _frame;
	CGRect _pageControlFrame;
	
	
    NSMutableArray *viewControllers;
	NSMutableArray *arrayViewCache;
	
	// FIXME, cacheIndex should moved;
	NSUInteger cacheSize;
	NSUInteger cacheIndex;
	
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property (nonatomic) CGRect frame;
@property (nonatomic) CGRect pageControlFrame;
@property (nonatomic) NSUInteger pageCount;
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UIPageControl *pageControl;
- (void)reloadData;
- (void)setDelegate:(id)delegate;
- (void)enqueueReusablePage:(UIView *)pageView atIndex:(NSUInteger)index;
- (UIView *)dequeueReusablePage:(NSUInteger)index;
- (void)clearReusablePage;
- (void) scrollToPage:(NSUInteger)index;

@end
