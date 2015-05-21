//
//  CVMacroFormHeaderView.h
//  CapitalVueHD
//
//  Created by jishen on 11/1/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVMacroFormHeaderView : UIView {
	UILabel *header1;
	UILabel *header2;
	UILabel *header3;
	NSInteger _columnNumber;
	UIImageView *_imgvBack;
}

@property (nonatomic, retain) IBOutlet UILabel *header1;
@property (nonatomic, retain) IBOutlet UILabel *header2;
@property (nonatomic, retain) IBOutlet UILabel *header3;

@property (nonatomic, assign) NSInteger columnNumber;
@end
