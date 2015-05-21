//
//  CVContentScrollPageView.h
//  CapitalValDemo
//
//  Created by leon on 10-8-11.
//  Copyright 2010 SmilingMobile. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface CVContentScrollPageView : UIScrollView {
	NSUInteger _NumberOfPages;
	
	//UIPageControl *m_pageControl;
}
@property NSUInteger NumberOfPages;
//@property (nonatomic, retain) UIPageControl *m_pageControl;
@end
