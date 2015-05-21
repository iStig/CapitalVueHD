//
//  CapitalValDemoViewController.h
//  CapitalValDemo
//
//  Created by leon on 10-7-30.
//  Copyright SmilingMobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CVTodaysNewsController.h"
@class CVTodaysNewsView;
@interface CapitalValDemoViewController : UIViewController {
	UIImageView *_imageBackground;
	CVTodaysNewsView *_todaysnewsview;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageBackground;
@property (nonatomic, retain) CVTodaysNewsView *todaysnewsview;

-(void)changeViewMode;
- (void)adjustSubviews:(UIInterfaceOrientation)orientation;

@end

