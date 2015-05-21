//
//  CVTodayNewsTitleLinkView.m
//  CapitalVueHD
//
//  Created by jishen on 9/11/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVTodayNewsTitleLinkView.h"
#import "CVPortal.h"

@implementation CVTodayNewsTitleLinkView

@synthesize newsTitle1;
@synthesize newsTitle2;
@synthesize postId1;
@synthesize postId2;

@synthesize linkButton1;
@synthesize linkButton2;
@synthesize lineImageView;

@synthesize point1;
@synthesize point2;

@synthesize labelTitle1;
@synthesize labelTitle2;

@synthesize dictNews1;
@synthesize dictNews2;

/*
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
    }
    return self;
}
 */

- (void)createButton{
	labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, 435, 21)];
	labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(33, 39, 435, 21)];
	labelTitle1.text = newsTitle1;
	labelTitle2.text = newsTitle2;
	labelTitle1.font = [UIFont systemFontOfSize:14];
	labelTitle2.font = [UIFont systemFontOfSize:14];
	labelTitle1.userInteractionEnabled = YES;
	labelTitle2.userInteractionEnabled = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[newsTitle1 release];
	[newsTitle2 release];
	[postId1 release];
	[postId2 release];
	
	[linkButton1 release];
	[linkButton2 release];
	[lineImageView release];
	[point1 release];
	[point2 release];
	
	[labelTitle1 release];
	[labelTitle2 release];
	
	[dictNews1 release];
	[dictNews2 release];
    [super dealloc];
}

/*
 * It responds the tapping and switches to news portalset
 * where article of news is shown.
 *
 * @param: sender - the obj recieves the event of tap. Here is the linkButton1 and linkButton2.
 * @return: none
 */

- (IBAction)goNewsArticle:(id)sender {
	UIButton *button = sender;
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[NSNumber numberWithInt:4] forKey:@"Number"];
	if (button.tag == 1001) {
		if (dictNews1 == nil) {
			[dict release];
			return;
		}
		[dict setObject:dictNews1 forKey:@"dictContent"];
	}
	else {
		if (dictNews2 == nil) {
			[dict release];
			return;
		}
		[dict setObject:dictNews2 forKey:@"dictContent"];
	}

	
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
	[dict release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	NSLog(@"title link view touched");
}

@end
