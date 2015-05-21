//
//  CVTodaysNewsContentView.m
//  CapitalValDemo
//
//  Created by leon on 10-8-12.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVTodaysNewsContentView.h"


@implementation CVTodaysNewsContentView

@synthesize imageFirThumb = _imageFirThumb;
@synthesize imageSecThumb = _imageSecThumb;
@synthesize imageThiThumb = _imageThiThumb;
@synthesize labelFirTitle = _labelFirTitle;
@synthesize labelSecTitle = _labelSecTitle;
@synthesize labelThiTitle = _labelThiTitle;
@synthesize labelFouTitle = _labelFouTitle;
@synthesize imagePoint1   = _imagePoint1;
@synthesize imagePoint2   = _imagePoint2;
@synthesize imageLine     = _imageLine;
@synthesize buttonFirst   = _buttonFirst;
@synthesize buttonSecond  = _buttonSecond;
@synthesize buttonThird   = _buttonThird;
@synthesize buttonForth   = _buttonForth;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) 
	{
		//self.frame = CGRectMake(0.0, 0.0, 300.0, 50.0);
		
		_imageFirThumb = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 5.0, 230.0, 160.0)];
		_imageSecThumb = [[UIImageView alloc] initWithFrame:CGRectMake(252.0, 5.0, 230.0, 160.0)];
		_imageThiThumb = [[UIImageView alloc] initWithFrame:CGRectMake(475.0, 5.0, 230.0, 160.0)];
		
		_labelFirTitle = [[UILabel alloc] initWithFrame:CGRectMake(9.0, 170.0, 220.0, 40.0)];
		_labelSecTitle = [[UILabel alloc] initWithFrame:CGRectMake(252.0, 170.0, 220.0, 40.0)];
		_labelThiTitle = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 250.0, 400.0, 20.0)];
		_labelFouTitle = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 280.0, 400.0, 20.0)];
		
		_labelFirTitle.numberOfLines = 0;
		_labelSecTitle.numberOfLines = 0;
		_labelThiTitle.numberOfLines = 0;
		
		_labelFirTitle.font = [UIFont systemFontOfSize:15.0];
		_labelSecTitle.font = [UIFont systemFontOfSize:15.0];
		_labelThiTitle.font = [UIFont systemFontOfSize:15.0];
		_labelFouTitle.font = [UIFont systemFontOfSize:15.0];
		
		_imagePoint1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 250.0, 4.0, 5.0)];
		_imagePoint2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 280.0, 4.0, 5.0)];
		_imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 265.0, 435.0, 2.0)];
		
		_buttonFirst  = [UIButton buttonWithType:UIButtonTypeCustom];
		_buttonSecond = [UIButton buttonWithType:UIButtonTypeCustom];
		_buttonThird  = [UIButton buttonWithType:UIButtonTypeCustom];
		_buttonForth  = [UIButton buttonWithType:UIButtonTypeCustom];
		
		[_buttonFirst  setFrame:CGRectMake(10.0, 5.0, 230.0, 210.0)];
		[_buttonSecond setFrame:CGRectMake(252.0, 5.0, 230.0, 210.0)];
		[_buttonThird  setFrame:CGRectMake(30.0, 250.0, 400.0, 20.0)];
		[_buttonForth  setFrame:CGRectMake(30.0, 280.0, 400.0, 20.0)];
		
		[self addSubview:_imageFirThumb];
		[self addSubview:_imageSecThumb];
		[self addSubview:_imageThiThumb];
		
		[self addSubview:_labelFirTitle];
		[self addSubview:_labelSecTitle];
		[self addSubview:_labelThiTitle];
		[self addSubview:_labelFouTitle];
		
		[self addSubview:_buttonFirst];
		[self addSubview:_buttonSecond];
		[self addSubview:_buttonThird];
		[self addSubview:_buttonForth];
		
		[self addSubview:_imagePoint1];
		[self addSubview:_imagePoint2];
		[self addSubview:_imageLine];
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
	[_imageFirThumb release];
	[_imageSecThumb release];
	[_imageThiThumb release];
	[_labelFirTitle release];
	[_labelSecTitle release];
	[_labelThiTitle release];
	[_labelFouTitle release];
//	[_buttonFirst release];
//	[_buttonSecond release];
//	[_buttonThird release];
//	[_buttonForth release];
	
	[_imagePoint1 release];
	[_imagePoint2 release];
	[_imageLine release];
	
    [super dealloc];
}


@end
