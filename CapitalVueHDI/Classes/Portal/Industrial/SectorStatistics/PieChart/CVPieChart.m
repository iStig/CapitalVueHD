//
//  CVPieChartView.m
//  PieChart
//
//  Created by ANNA on 10-8-13.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVPieChart.h"
#import "CVTextLayer.h"
#import "CVPieUtil.h"
#import "CVLocalizationSetting.h"

#define kRotateSpeed	0.5
#define kRepaintInterval	0.05
#define kStopAngle		0.1
#define kAngleDecStep	0.02
#define kInfoLabelWidth	200.0
#define kInfoLabelHeight 100.0


@implementation CVPieChart

@synthesize pieLayer = _pieLayer;
@synthesize total = _total;
@synthesize shareArray = _shareArray;
@synthesize viewType = _viewType;
@synthesize isMoving;
@synthesize shareAccumArray = _shareAccumArray;
- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
		isMoving = NO;
		_pieLayer = [[CVPieChartLayer alloc] init];
		_pieLayer.frame = self.bounds;
		NSString *path;
		UIImage *img;
		//Bottom Background
		path = [[NSBundle mainBundle] pathForResource:@"Pie_Bottom.png" ofType:nil];
		img = [[UIImage alloc] initWithContentsOfFile:path];
		imgvPieBottom = [[UIImageView alloc] initWithFrame:self.bounds];
		[imgvPieBottom setImage:img];
		[img release];
		[self.layer addSublayer:imgvPieBottom.layer];
		[self.layer addSublayer:_pieLayer];
		path = [[NSBundle mainBundle] pathForResource:@"Pie_Cover.png" ofType:nil];
		img = [[UIImage alloc] initWithContentsOfFile:path];
		imgvPieCover = [[UIImageView alloc] initWithFrame:self.bounds];
		[imgvPieCover setImage:img];
		[self.layer addSublayer:imgvPieCover.layer];
		[img release];
		

		
		CGPoint centerPos = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		_sumInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerPos.x - kInfoLabelWidth/2, 
																  centerPos.y - kInfoLabelHeight/2, kInfoLabelWidth, kInfoLabelHeight)];
		_sumInfoLabel.backgroundColor = [UIColor clearColor];
		_sumInfoLabel.numberOfLines = 2;
		_sumInfoLabel.textColor = [UIColor whiteColor];
		_sumInfoLabel.textAlignment = UITextAlignmentCenter;
		_sumInfoLabel.font = [UIFont boldSystemFontOfSize:15];
		[self addSubview:_sumInfoLabel];
		self.viewType = CVPiewViewVertical;
    }
	
    return self;
}

- (void)dealloc 
{
	[_pieLayer release];
	[_timer release];
	[_sumInfoLabel release];
	[_total release];
	[imgvPieCover release];
	[imgvPieBottom release];
	[_shareAccumArray release];
	[_shareArray release];
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	CGRect littleCircle = self.bounds;
	littleCircle.origin.x+=20;
	littleCircle.origin.y+=20;
	littleCircle.size.width-=40;
	littleCircle.size.height-=40;
	imgvPieBottom.frame = self.bounds;
	imgvPieCover.frame = littleCircle;
	_pieLayer.frame = littleCircle;	
	[_pieLayer setNeedsDisplay];
}

- (void)setViewType:(CVPieViewType)viewType
{
	_viewType = viewType;
	if (viewType == CVPieViewHorizonal)
	{
		_pieLayer.orietationOffset = 0.0;
	}
	else 
	{
		_pieLayer.orietationOffset = M_PI_2;
	}
//	[_pieLayer adjustAngle];
	_sumInfoLabel.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
	

	_pieLayer.rotateAngle += _pieLayer.orietationOffset;
	_pieLayer.transform = CATransform3DRotate(_pieLayer.transform, _pieLayer.orietationOffset, 0, 0, -1);
	
	
}

- (void)changeViewTypeTo:(CVPieViewType)viewType
{	
	if ( _viewType != viewType )
	{
		if ( _viewType == CVPieViewHorizonal )
		{
			[_pieLayer rotate:-M_PI_2];
		}
		else 
		{
			[_pieLayer rotate:M_PI_2];
		}
	}
	[self setViewType:viewType];
}

- (void)setShareArray:(NSMutableArray *)shareArray
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[_shareArray release];
	_shareArray = [shareArray retain];
	
	self.shareAccumArray = [[NSMutableArray alloc] init];
	[self.shareAccumArray release];
	
	[self.shareAccumArray addObject:[NSNumber numberWithFloat:0.0]];
	for (int i = 0; i < [_shareArray count]; ++i)
	{
		float shareInc = [[_shareArray objectAtIndex:i] floatValue]*M_PI*2 + [[_shareAccumArray objectAtIndex:i] floatValue];
		[self.shareAccumArray addObject:[NSNumber numberWithFloat:shareInc]];
	}
	
	[pool release];
}

- (void)illustrateShare:(NSMutableArray *)shArray color:(NSMutableArray *)colorArray
{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self.shareArray = shArray;
	_pieLayer.shareArray = _shareArray;
	_pieLayer.shareAccumArray = self.shareAccumArray;
	_pieLayer.colorArray = colorArray;
	[_pieLayer addInfoLayers];
	
	assert(_total!=nil);
	
	_sumInfoLabel.text = [NSString stringWithFormat:@"%@\n%@",[langSetting localizedString:@"Total"], _total];
	_sumInfoLabel.font = [UIFont boldSystemFontOfSize:18];
	[_pieLayer setNeedsDisplay];
	[_pieLayer adjustAngle];
}

- (void)timerAlert:(NSTimer *)timer
{
	if ( _lastAngle > 0 )
	{
		_lastAngle = (fabs(_lastAngle) - kAngleDecStep);
	}
	else 
	{
		_lastAngle = -(fabs(_lastAngle) - kAngleDecStep);
	}
	
	if ( fabs(_lastAngle) > kStopAngle )
	{
		[_pieLayer rotate:_lastAngle];
	}
	else 
	{
		[_pieLayer adjustAngle];
		[_timer invalidate];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	isMoving = YES;
	UITouch* touch = [touches anyObject];	
	if ( _timer && [_timer isValid] )
	{
		[_timer invalidate];
		NSLogv(@"touch begin, invalidate timer", nil);
	}

	_startPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	isMoving = YES;
	UITouch* touch = [touches anyObject];
	CGPoint movePoint = [touch locationInView:self];
	
	CGPoint origin = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	float startAngle = getAngle( _startPoint, origin );
	float endAngle = getAngle( movePoint, origin );
	_lastAngle = (startAngle - endAngle);
	
	if ( _lastAngle < -M_PI_2 )
	{
		_lastAngle += 2*M_PI;
	}
	if ( _lastAngle > M_PI_2 )
	{
		_lastAngle -= 2*M_PI;
	}
	_lastAngle *= kRotateSpeed;
	[_pieLayer rotate:_lastAngle];
	_startPoint = movePoint;
	
	_moved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	isMoving = NO;
	_startPoint = CGPointZero;
	
	if ( _moved )
	{
		[_timer release];
		_timer = [NSTimer timerWithTimeInterval:kRepaintInterval target:self selector:@selector(timerAlert:) userInfo:nil repeats:YES];
		[_timer retain];
		[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
		_moved = NO;
	}
	else 
	{
		[_pieLayer adjustAngle];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	isMoving = NO;
	_startPoint = CGPointZero;
	NSLog(@"touch cancelled");

	if ( _moved )
	{
		[_timer release];
		_timer = [NSTimer timerWithTimeInterval:kRepaintInterval target:self selector:@selector(timerAlert:) userInfo:nil repeats:YES];
		[_timer retain];
		[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
		_moved = NO;
	}
	else 
	{
		[_pieLayer adjustAngle];
	}
}


//dream's
- (void) adjustToIndex:(int)index
{
	[_pieLayer adjustToIndex:index];
}


@end
