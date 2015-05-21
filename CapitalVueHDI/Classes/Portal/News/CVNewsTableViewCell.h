//
//  CVNewsTableViewCell.h
//  CapitalValDemo
//
//  Created by leon on 10-8-21.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"


@interface CVNewsTableViewCell : UITableViewCell {
	NSString *_strTitle;
	NSString *_strTime;
	NSString *_strThumbnail;
	UILabel *_labelTitle;
	UILabel *_labelTime;
	UIImageView *_imageThumbnail;
}
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) NSString *strTime;
@property (nonatomic, retain) NSString *strThumbnail;
@property (nonatomic, retain) UILabel *labelTitle;
@property (nonatomic, retain) UILabel *labelTime;
@property (nonatomic, retain) UIImageView *imageThumbnail;

- (void) loadLabel;
- (void) removeElement;
- (void) addElement;
@end
