//
//  CVTodayNewsSnapshotView.h
//  CapitalVueHD
//
//  Created by jishen on 9/10/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"

#define CVPORTLET_TODAYS_NEWS_SNAP_WIDTH 230
#define CVPORTLET_TODAYS_NEWS_SNAP_HEIGHT 206
#define CVPORTLET_TODAYS_NEWS_SNAP_BORDER 6

@interface CVTodayNewsSnapshotView : UIView {
	NSString *imageUrl;
	NSString *postId;
	
	UIImageView *thumbnailView;
	UILabel *newsTitleLabel;
	UIButton *articleButton;
	
	NSDictionary *dictNews;
}

@property(nonatomic, retain) NSString *imageUrl;
@property(nonatomic, retain) NSString *postId;

@property(nonatomic, retain) UIImageView *thumbnailView;
@property(nonatomic, retain) UILabel *newsTitleLabel;
@property(nonatomic, retain) UIButton *articleButton;

@property(nonatomic, retain) NSDictionary *dictNews;

/*
 *	reset title label
 */
-(void)adjustTitleLabel;

/*
 * It responds the tapping and switches to news portalset
 * where article of news is shown.
 *
 * @param: sender - the obj recieves the event of tap. Here is the articleButton.
 * @return: none
 */
- (void)goNewsArticle;

@end
