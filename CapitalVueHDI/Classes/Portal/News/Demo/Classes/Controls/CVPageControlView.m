//
//  CVPageControlView.m
//  CapitalValDemo
//
//  Created by leon on 10-8-23.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPageControlView.h"


@implementation CVPageControlView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	[self changeIcoImage];
}

- (void)changeIcoImage{
	for (int i=0; i<self.numberOfPages; i++) {
		UIImageView *pageIcon = [self.subviews objectAtIndex:i];
		if ([pageIcon isKindOfClass:[UIImageView class]]) {
			if (i == self.currentPage) {
				pageIcon.image = [UIImage imageNamed:@"black_pageicon.png"];
			}
			else {
				pageIcon.image = [UIImage imageNamed:@"gray_pageicon.png"];
			}
			
		}
	}
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	NSLog(@"gbgbgb");
//}


- (void)dealloc {
    [super dealloc];
}


@end
