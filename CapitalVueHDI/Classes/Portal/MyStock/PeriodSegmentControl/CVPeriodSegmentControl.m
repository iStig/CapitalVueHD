//
//  CVPeriodSegmentControl.m
//  CapitalVueHD
//
//  Created by jishen on 10/27/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPeriodSegmentControl.h"
#import "CVPeriodSegment.h"
#import "CVLocalizationSetting.h"
@interface CVPeriodSegmentControl()

@property (nonatomic, retain) NSMutableArray *_segemnts;
@property (nonatomic, retain) UIImage *_leftHighlight;
@property (nonatomic, retain) UIImage *_normalHighlight;
@property (nonatomic, retain) UIImage *_rightHighlight;

- (IBAction)changeButtonBackground:(id)sender;

@end

#define BACKGROUND_SIZE_WIDTH 318
#define BACKGROUND_SIZE_HEIGHT 21

#define SEGMENT_COUNT 6
#define SEGMENT_BORDER 1

#define SEGMENT_SIZE_WIDTH 52
#define SEGMENT_SIZE_HEIGHT 19

@implementation CVPeriodSegmentControl

@synthesize delegate;
@synthesize index;

@synthesize _segemnts;
@synthesize _leftHighlight, _normalHighlight, _rightHighlight;


- (id)initWithFrame:(CGRect)frame {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		// set its frame
		self.frame = CGRectMake(frame.origin.x, 
								frame.origin.y, 
								BACKGROUND_SIZE_WIDTH, 
								BACKGROUND_SIZE_HEIGHT);
		// set background image
		UIImageView *imageView;
		UIImage *image;
		NSString *path = [[NSBundle mainBundle] pathForResource:@"mystock_chart_segment_background.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:path];
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BACKGROUND_SIZE_WIDTH, BACKGROUND_SIZE_HEIGHT)];
		imageView.image = image;
		[image release];
		[self addSubview:imageView];
		[imageView release];
		
		// image for highlighting
		path = [[NSBundle mainBundle] pathForResource:@"mystock_chart_segment_highlight_left.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:path];
		self._leftHighlight = image;
		[image release];
		path = [[NSBundle mainBundle] pathForResource:@"mystock_chart_segment_highlight_normal.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:path];
		self._normalHighlight = image;
		[image release];
		path = [[NSBundle mainBundle] pathForResource:@"mystock_chart_segment_highlight_right.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:path];
		self._rightHighlight = image;
		[image release];
		
		
		// set controls of segments
		NSMutableArray *array;
		array = [[NSMutableArray alloc] initWithCapacity:1];
		self._segemnts = array;
		[array release];
		NSUInteger i;
		CVPeriodSegment *segment;
		for (i = 0; i < SEGMENT_COUNT; i++) {
			segment = [CVPeriodSegment buttonWithType:UIButtonTypeCustom];
			segment.index = i;
			segment.frame = CGRectMake(
									   SEGMENT_BORDER * (i + 1) + i * SEGMENT_SIZE_WIDTH,
									   SEGMENT_BORDER,
									   SEGMENT_SIZE_WIDTH,
									   SEGMENT_SIZE_HEIGHT);
			segment.titleLabel.font = [UIFont systemFontOfSize:10];

			switch (i) {
				case 0:
					[segment setTitle:[langSetting localizedString:@"Intraday"] forState:UIControlStateNormal];
					[segment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
					break;
				case 1:
					[segment setTitle:[langSetting localizedString:@"5 days"] forState:UIControlStateNormal];
					[segment setBackgroundImage:_normalHighlight forState:UIControlStateNormal];
					[segment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					break;
				case 2:
					[segment setTitle:[langSetting localizedString:@"1 month"] forState:UIControlStateNormal];
					[segment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
					break;
				case 3:
					[segment setTitle:[langSetting localizedString:@"3 months"] forState:UIControlStateNormal];
					[segment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
					break;
				case 4:
					[segment setTitle:[langSetting localizedString:@"1 year"] forState:UIControlStateNormal];
					[segment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
					break;
				case 5:
					[segment setTitle:[langSetting localizedString:@"2 years"] forState:UIControlStateNormal];
					[segment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal]; 
					break;
				default:
					break;
			}
			[segment addTarget:self action:@selector(changeButtonBackground:) forControlEvents:UIControlEventTouchUpInside];
			[_segemnts addObject:segment];
			[self addSubview:segment];
		}
		
		self.autoresizingMask = UIViewAutoresizingNone;
		self.autoresizesSubviews = NO;
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
	[_segemnts release];
	
	[_leftHighlight release];
	[_normalHighlight release];
	[_rightHighlight release];
    [super dealloc];
}

#pragma mark -
#pragma mark private method
- (IBAction)changeButtonBackground:(id)sender {
	CVPeriodSegment *segment, *element;
	
	segment = (CVPeriodSegment *)sender;
	[delegate touchSegmentAtIndex:segment.index];
	for (element in _segemnts) {
		if (element.index == segment.index && 0 == segment.index) {
			[element setBackgroundImage:_leftHighlight forState:UIControlStateNormal];
			[element setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
		} else if (element.index == segment.index && ([_segemnts count] - 1) == segment.index) {
			[element setBackgroundImage:_rightHighlight forState:UIControlStateNormal];
			[element setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
		} else if (element.index == segment.index) {
			[element setBackgroundImage:_normalHighlight forState:UIControlStateNormal];
			[element setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
		} else {
			[element setBackgroundImage:nil forState:UIControlStateNormal];
			[element setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal]; 
		}
	}
}

- (void)setIndex:(NSUInteger)i {
	CVPeriodSegment *element;

	for (element in _segemnts) {
		if (element.index == i && 0 == i) {
			[element setBackgroundImage:_leftHighlight forState:UIControlStateNormal];
			[element setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
		} else if (element.index == i && ([_segemnts count] - 1) == i) {
			[element setBackgroundImage:_rightHighlight forState:UIControlStateNormal];
			[element setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
		} else if (element.index == i) {
			[element setBackgroundImage:_normalHighlight forState:UIControlStateNormal];
			[element setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
		} else {
			[element setBackgroundImage:nil forState:UIControlStateNormal];
			[element setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal]; 
		}
	}
}


@end
