//
//  NormalCell.h
//  CapitalVueHD
//
//  Created by jishen on 10/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NormalCell : UITableViewCell {
	UILabel *titleLabel;
	UIImageView *delimiter;
	UILabel *valueLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *delimiter;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat titleIndent;

@end
