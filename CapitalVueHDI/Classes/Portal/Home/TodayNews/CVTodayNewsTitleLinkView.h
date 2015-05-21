//
//  CVTodayNewsTitleLinkView.h
//  CapitalVueHD
//
//  Created by jishen on 9/11/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CVPORTLET_TODAYS_NEWS_TITLE_LINK_WIDTH 480
#define CVPORTLET_TODAYS_NEWS_TITLE_LINK_HEIGHT 60
#define CVPORTLET_TODAYS_NEWS_TITLE_LINK_BORDER 6

@interface CVTodayNewsTitleLinkView : UIView {
	NSString *newsTitle1;
	NSString *newsTitle2;
	NSString *postId1;
	NSString *postId2;
	
	UIButton *linkButton1;
	UIButton *linkButton2;
	UIImageView *lineImageView;
	UIImageView *point1;
	UIImageView *point2;
	
	UILabel *labelTitle1;
	UILabel *labelTitle2;
	
	NSDictionary *dictNews1;
	NSDictionary *dictNews2;
}

@property(nonatomic, retain) NSString *newsTitle1;
@property(nonatomic, retain) NSString *newsTitle2;

@property(nonatomic, retain) NSString *postId1;
@property(nonatomic, retain) NSString *postId2;

@property(nonatomic, retain) IBOutlet UIButton *linkButton1;
@property(nonatomic, retain) IBOutlet UIButton *linkButton2;
@property(nonatomic, retain) IBOutlet UIImageView *lineImageView;

@property(nonatomic, retain) IBOutlet UIImageView *point1;
@property(nonatomic, retain) IBOutlet UIImageView *point2;


@property(nonatomic, retain) IBOutlet UILabel *labelTitle1;
@property(nonatomic, retain) IBOutlet UILabel *labelTitle2;

@property(nonatomic, retain) NSDictionary *dictNews1;
@property(nonatomic, retain) NSDictionary *dictNews2;


/*
 * It responds the tapping and switches to news portalset
 * where article of news is shown.
 *
 * @param: sender - the obj recieves the event of tap. Here is the linkButton1 and linkButton2.
 * @return: none
 */
- (IBAction)goNewsArticle:(id)sender;

@end
