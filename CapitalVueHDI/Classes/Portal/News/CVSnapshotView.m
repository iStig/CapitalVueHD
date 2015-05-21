//
//  CVSnapshotView.m
//  CapitalVueHD
//
//  Created by leon on 10-10-19.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVSnapshotView.h"


@implementation CVSnapshotView
@synthesize snapshotContentView = _snapshotContentView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		//_snapshotContentView = [[CVSnapshotContentView alloc] initWithFrame:CGRectMake(0, 20, 460, 280)];
		// allocate a snap view of news
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CVSnapshotContentView" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[CVSnapshotContentView class]]) {
				self.snapshotContentView =  (CVSnapshotContentView *) currentObject;
				break;
			}
		}
		
		_snapshotContentView.backgroundColor = [UIColor clearColor];
		_snapshotContentView.frame = CGRectMake(7,
									50,
									_snapshotContentView.frame.size.width,
									_snapshotContentView.frame.size.height);
		
		[_imageBackground addSubview:_snapshotContentView];
		[_snapshotContentView createLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[_snapshotContentView release];
    [super dealloc];
}


@end
