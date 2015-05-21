//
//  CVShareInfoView.m
//  PieChart
//
//  Created by ANNA on 10-8-13.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import "CVShareInfoView.h"
#import "CVShareInfoLabel.h"
#import "CVShareInfoContentView.h"
#import "CVPieChartConstants.h"
#import "UIView+FrameInfo.h"

#import "CVPortal.h"
#import "CVLocalizationSetting.h"
@interface CVShareInfoView()

- (IBAction)actionButton:(id)sender;
- (void)setDefaultText;

@end

@implementation CVShareInfoView

@synthesize viewType = _viewType;

@synthesize _sectorCode;

- (id)initWithFrame:(CGRect)frame 
{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	positiveColor = [[langSetting getColor:@"GainersRate"] retain];
	negtiveColor = [[langSetting getColor:@"LosersRate"] retain];
	
    if ((self = [super initWithFrame:frame])) 
	{
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		float colors[] = 
		{
			255/255.0, 255/255.0, 255/255.0, 1.0,
			125/255.0, 125/255.0, 125/255.0, 1.0
		};
        _gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, sizeof(colors)/(4*sizeof(colors[0])) );
		CGColorSpaceRelease(colorSpace);
		
		_contentView = [[CVShareInfoContentView alloc] init];
		_contentView.backgroundColor = [UIColor clearColor];
		[self addSubview:_contentView];
		
		_titleLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.font = [UIFont boldSystemFontOfSize:25];
		_titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_titleButton.autoresizingMask = NO;
		[_titleButton addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
		
		_dateLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.font = [UIFont boldSystemFontOfSize:20];
		
		_coMarkLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_coMarkLabel.backgroundColor = [UIColor clearColor];
		_coMarkLabel.font = [UIFont systemFontOfSize:kMarkLabelFont];
		
		_coValueLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_coValueLabel.backgroundColor = [UIColor clearColor];
		_coValueLabel.font = [UIFont boldSystemFontOfSize:kValueLabelFont];
		
		_chgMarkLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_chgMarkLabel.backgroundColor = [UIColor clearColor];
		_chgMarkLabel.font = [UIFont systemFontOfSize:kMarkLabelFont];
		
		_chgValueLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_chgValueLabel.backgroundColor = [UIColor clearColor];
		_chgValueLabel.font = [UIFont boldSystemFontOfSize:kValueLabelFont];
		
		_gainerMarkLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_gainerMarkLabel.backgroundColor = [UIColor clearColor];
		_gainerMarkLabel.font = [UIFont systemFontOfSize:kMarkLabelFont];
		
		_gainerValueLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_gainerValueLabel.backgroundColor = [UIColor clearColor];
		_gainerValueLabel.font = [UIFont boldSystemFontOfSize:kValueLabelFont];
		
		_declineMarkLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_declineMarkLabel.backgroundColor = [UIColor clearColor];
		_declineMarkLabel.font = [UIFont systemFontOfSize:kMarkLabelFont];
		
		_declineValueLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_declineValueLabel.backgroundColor = [UIColor clearColor];
		_declineValueLabel.font = [UIFont boldSystemFontOfSize:kValueLabelFont];
		
		_tradeMarkLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_tradeMarkLabel.backgroundColor = [UIColor clearColor];
		_tradeMarkLabel.font = [UIFont systemFontOfSize:kMarkLabelFont];
		
		_tradeValueLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_tradeValueLabel.backgroundColor = [UIColor clearColor];
		_tradeValueLabel.font = [UIFont boldSystemFontOfSize:kValueLabelFont];
		
		_netmarginMarkLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_netmarginMarkLabel.backgroundColor = [UIColor clearColor];
		_netmarginMarkLabel.font = [UIFont systemFontOfSize:kMarkLabelFont];
		
		_netmarginValueLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_netmarginValueLabel.backgroundColor = [UIColor clearColor];
		_netmarginValueLabel.font = [UIFont boldSystemFontOfSize:kValueLabelFont];
		
		_roeMarkLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_roeMarkLabel.backgroundColor = [UIColor clearColor];
		_roeMarkLabel.font = [UIFont systemFontOfSize:kMarkLabelFont];
		
		_roeValueLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_roeValueLabel.backgroundColor = [UIColor clearColor];
		_roeValueLabel.font = [UIFont boldSystemFontOfSize:kValueLabelFont];
		
		_peMarkLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_peMarkLabel.backgroundColor = [UIColor clearColor];
		_peMarkLabel.font = [UIFont systemFontOfSize:kMarkLabelFont];
		
		_peValueLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_peValueLabel.backgroundColor = [UIColor clearColor];
		_peValueLabel.font = [UIFont boldSystemFontOfSize:kValueLabelFont];
		
		_pbMarkLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_pbMarkLabel.backgroundColor = [UIColor clearColor];
		_pbMarkLabel.font = [UIFont systemFontOfSize:kMarkLabelFont];
		
		_pbValueLabel = [[CVShareInfoLabel alloc] initWithFrame:CGRectZero];
		_pbValueLabel.backgroundColor = [UIColor clearColor];
		_pbValueLabel.font = [UIFont boldSystemFontOfSize:kValueLabelFont];
		
		[_contentView addSubview:_titleLabel];
		[_contentView addSubview:_dateLabel];
		[_contentView addSubview:_coMarkLabel];
		[_contentView addSubview:_coValueLabel];
		[_contentView addSubview:_chgMarkLabel];
		[_contentView addSubview:_chgValueLabel];
		[_contentView addSubview:_gainerMarkLabel];
		[_contentView addSubview:_gainerValueLabel];
		[_contentView addSubview:_declineMarkLabel];
		[_contentView addSubview:_declineValueLabel];
		[_contentView addSubview:_tradeMarkLabel];
		[_contentView addSubview:_tradeValueLabel];
		[_contentView addSubview:_netmarginMarkLabel];
		[_contentView addSubview:_netmarginValueLabel];
		[_contentView addSubview:_roeMarkLabel];
		[_contentView addSubview:_roeValueLabel];
		[_contentView addSubview:_peMarkLabel];
		[_contentView addSubview:_peValueLabel];
		[_contentView addSubview:_pbMarkLabel];
		[_contentView addSubview:_pbValueLabel];
		[self addSubview:_titleButton];
    }
    return self;
}


- (void)dealloc
{
	[_sectorCode release];
	
	CGGradientRelease(_gradient);
	[_contentView release];
	[_titleLabel release];
	[_titleButton release];
	[_dateLabel release];
	[_coMarkLabel release];
	[_coValueLabel release];
	[_chgMarkLabel release];
	[_chgValueLabel release];
	[_gainerMarkLabel release];
	[_gainerValueLabel release];
	[_declineMarkLabel release];
	[_declineValueLabel release];
	[_tradeMarkLabel release];
	[_tradeValueLabel release];
	[_netmarginMarkLabel release];
	[_netmarginValueLabel release];
	[_roeMarkLabel release];
	[_roeValueLabel release];
	[_peMarkLabel release];
	[_peValueLabel release];
	[_pbMarkLabel release];
	[_pbValueLabel release];
	
	[positiveColor release];
	[negtiveColor release];
	
    [super dealloc];
}

- (void)setDefaultText{
	_titleLabel.text = @"-";
	_dateLabel.text = @"-";
	_coValueLabel.text = @"-";
	_chgValueLabel.text = @"-";
	_gainerValueLabel.text = @"-";
	_declineValueLabel.text = @"-";
	_tradeValueLabel.text = @"-";
	_netmarginValueLabel.text = @"-";
	_roeValueLabel.text = @"-";
	_peValueLabel.text = @"-";
	_pbValueLabel.text = @"-";
	
	_coMarkLabel.text = @"-";
	_chgMarkLabel.text = @"-";
	_gainerMarkLabel.text = @"-";
	_declineMarkLabel.text = @"-";
	_tradeMarkLabel.text = @"-";
	_netmarginMarkLabel.text = @"-";
	_roeMarkLabel.text = @"-";
	_peMarkLabel.text = @"-";
	_pbMarkLabel.text = @"-";
}

- (void)showData:(CVShareInfo *)shareInfo
{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	[self setDefaultText];
	if (shareInfo == nil) {
		return;
	}
	self._sectorCode = shareInfo.sectorCode;
	
	_titleLabel.text = shareInfo.title;
	_dateLabel.text = [NSString stringWithFormat:[langSetting localizedString:@"DATE: %@"],shareInfo.date];
	_coValueLabel.text = shareInfo.co;
	_chgValueLabel.text = [NSString stringWithFormat:@"%@%%",shareInfo.chg];
	if ( [shareInfo.chg characterAtIndex:0] == '-')
	{
		_chgValueLabel.textColor = negtiveColor;
	}
	else 
	{
		_chgValueLabel.textColor = positiveColor;
	}
	_gainerValueLabel.textColor = positiveColor;
	_declineValueLabel.textColor = negtiveColor;
	_gainerValueLabel.text = shareInfo.gainers;
	_declineValueLabel.text = shareInfo.decliners;
	_tradeValueLabel.text = shareInfo.tradable;
	_netmarginValueLabel.text = shareInfo.netmargin;
	_roeValueLabel.text = shareInfo.roe;
	_peValueLabel.text = shareInfo.pe;
	_pbValueLabel.text = shareInfo.pb;
	
	_coMarkLabel.text = shareInfo.coTitle;
	_chgMarkLabel.text = shareInfo.chgTitle;
	_gainerMarkLabel.text = shareInfo.gainersTitle;
	_declineMarkLabel.text = shareInfo.declinersTitle;
	_tradeMarkLabel.text = shareInfo.tradableTitle;
	_netmarginMarkLabel.text = shareInfo.netmarginTitle;
	_roeMarkLabel.text = shareInfo.roeTitle;
	_peMarkLabel.text = shareInfo.peTitle;
	_pbMarkLabel.text = shareInfo.pbTitle;
	
	[_dateLabel sizeToFit];
	
	[_coValueLabel sizeToFit];
	[_chgValueLabel sizeToFit];
	[_gainerValueLabel sizeToFit];
	[_declineValueLabel sizeToFit];
	[_tradeValueLabel sizeToFit];
	[_netmarginValueLabel sizeToFit];
	[_roeValueLabel sizeToFit];
	[_peValueLabel sizeToFit];
	[_pbValueLabel sizeToFit];
	
	[_coMarkLabel sizeToFit];
	[_chgMarkLabel sizeToFit];
	[_gainerMarkLabel sizeToFit];
	[_declineMarkLabel sizeToFit];
	[_tradeMarkLabel sizeToFit];
	[_netmarginMarkLabel sizeToFit];
	[_roeMarkLabel sizeToFit];
	[_peMarkLabel sizeToFit];
	[_pbMarkLabel sizeToFit];
}

- (void)setViewType:(CVPieViewType)viewType
{
	_viewType = viewType;
	[self setNeedsDisplay];
	UIFont *fontTitle = [UIFont systemFontOfSize:12];
	_coMarkLabel.font = fontTitle;
	_chgMarkLabel.font = fontTitle;
	_gainerMarkLabel.font = fontTitle;
	_declineMarkLabel.font = fontTitle;
	_tradeMarkLabel.font = fontTitle;
	_netmarginMarkLabel.font = fontTitle;
	_roeMarkLabel.font = fontTitle;
	_peMarkLabel.font = fontTitle;
	_pbMarkLabel.font = fontTitle;
	
	_titleLabel.font = [UIFont boldSystemFontOfSize:12];
	_dateLabel.font = [UIFont boldSystemFontOfSize:21];
	if ( viewType == CVPiewViewVertical )
	{
		_contentView.frame = CGRectMake(kFLPosx, kArrowHeight, self.frame.size.width-2*kFLPosx, self.frame.size.height - kArrowHeight);
		[_contentView setNeedsDisplay];
		_titleLabel.frame = CGRectMake(0, -32, 300, 25);
		_titleButton.frame = CGRectMake(0, 32, 300, 30);
		
		_dateLabel.frame = CGRectMake(0, -2, 300, 25);
		_titleLabel.font = [UIFont boldSystemFontOfSize:18];
		_dateLabel.font = [UIFont boldSystemFontOfSize:13];
		
		int i = 0;
		_coMarkLabel.frame = CGRectMake(0, kTableInitPosL+i*kLabelHeightL-28, 80, kLabelHeightL);
		[_coMarkLabel sizeToFit];
		_coValueLabel.frame = CGRectMake([_coMarkLabel width] + 10., kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_coValueLabel sizeToFit];
		_chgMarkLabel.frame = CGRectMake(kSLPosx-50, kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_chgMarkLabel sizeToFit];
		_chgValueLabel.frame = CGRectMake(kSLPosx+[_chgMarkLabel width] + 10.-50, kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_chgValueLabel sizeToFit];
		
		i++;
		_gainerMarkLabel.frame = CGRectMake(0, kTableInitPosL+i*kLabelHeightL-28, 120., kLabelHeightL);
		[_gainerMarkLabel sizeToFit];
		_gainerValueLabel.frame = CGRectMake([_gainerMarkLabel width] + 10., kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_gainerValueLabel sizeToFit];
		_declineMarkLabel.frame = CGRectMake(kSLPosx-50, kTableInitPosL+i*kLabelHeightL-28, 150, kLabelHeightL);
		[_declineMarkLabel sizeToFit];
		_declineValueLabel.frame = CGRectMake(kSLPosx+[_declineMarkLabel width] + 10.-50, kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_declineValueLabel sizeToFit];
		
		i++;
		_tradeMarkLabel.frame = CGRectMake(0, kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_tradeMarkLabel sizeToFit];
		_tradeValueLabel.frame = CGRectMake([_tradeMarkLabel width] + 10., kTableInitPosL+i*kLabelHeightL-28, 200, kLabelHeightL);
		[_tradeValueLabel sizeToFit];
		
		i++;
		_netmarginMarkLabel.frame = CGRectMake(0, kTableInitPosL+i*kLabelHeightL-28, 150, kLabelHeightL);
		[_netmarginMarkLabel sizeToFit];
		_netmarginValueLabel.frame = CGRectMake([_netmarginMarkLabel width] + 10., kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_netmarginValueLabel sizeToFit];
		_roeMarkLabel.frame = CGRectMake(kSLPosx-50, kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_roeMarkLabel sizeToFit];
		_roeValueLabel.frame = CGRectMake(kSLPosx+[_roeMarkLabel width] + 10.-50, kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_roeValueLabel sizeToFit];
		
		i++;
		_peMarkLabel.frame = CGRectMake(0, kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_peMarkLabel sizeToFit];
		_peValueLabel.frame = CGRectMake([_peMarkLabel width] + 10., kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_peValueLabel sizeToFit];
		_pbMarkLabel.frame = CGRectMake(kSLPosx-50, kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_pbMarkLabel sizeToFit];
		_pbValueLabel.frame = CGRectMake(kSLPosx+[_pbMarkLabel width] + 10.-50, kTableInitPosL+i*kLabelHeightL-28, 100, kLabelHeightL);
		[_pbValueLabel sizeToFit];
	}
	else 
	{
		_contentView.frame = CGRectMake(kArrowHeight + kFLPosx, 0, self.frame.size.width-kArrowHeight-kFLPosx*2, self.frame.size.height);
		[_contentView setNeedsDisplay];
		_titleLabel.frame = CGRectMake(0, 32, 300, 25);
		_titleButton.frame = CGRectMake(40, 32, 300, 30);
		_dateLabel.frame = CGRectMake(0, 59, 300, 25);
		_titleLabel.font = [UIFont boldSystemFontOfSize:18];
		_dateLabel.font = [UIFont boldSystemFontOfSize:13];
		int i = 0;
		_coMarkLabel.frame = CGRectMake(-10, kTableInitPosP+i*kLabelHeightP+34, 80, kLabelHeightP);
		[_coMarkLabel sizeToFit];
		_coValueLabel.frame = CGRectMake([_coMarkLabel width] + 10 -10, kTableInitPosP+i*kLabelHeightP+34, 100, kLabelHeightP);
		[_coValueLabel sizeToFit];
		_chgMarkLabel.frame = CGRectMake(kSLPosx-50-38, kTableInitPosP+i*kLabelHeightP+34, 100, kLabelHeightP);
		[_chgMarkLabel sizeToFit];
		_chgValueLabel.frame = CGRectMake(kSLPosx+[_chgMarkLabel width] + 10.0-50-38, kTableInitPosP+i*kLabelHeightP+34, 100, kLabelHeightP);
		[_chgValueLabel sizeToFit];
		
		i++;
		_gainerMarkLabel.frame = CGRectMake(-10, kTableInitPosP+i*kLabelHeightP+26, 120., kLabelHeightP);
		[_gainerMarkLabel sizeToFit];
		_gainerValueLabel.frame = CGRectMake([_gainerMarkLabel width] +10 -10, kTableInitPosP+i*kLabelHeightP+26, 100, kLabelHeightP);
		[_gainerValueLabel sizeToFit];
		_declineMarkLabel.frame = CGRectMake(kSLPosx-50-38, kTableInitPosP+i*kLabelHeightP+26, 150, kLabelHeightP);
		[_declineMarkLabel sizeToFit];
		_declineValueLabel.frame = CGRectMake(kSLPosx+[_declineMarkLabel width] + 10.0-50-38, kTableInitPosP+i*kLabelHeightP+26, 100, kLabelHeightP);
		[_declineValueLabel sizeToFit];
		
		i++;
		_tradeMarkLabel.frame = CGRectMake(-10, kTableInitPosP+i*kLabelHeightP+23, 100, kLabelHeightP);
		[_tradeMarkLabel sizeToFit];
		_tradeValueLabel.frame = CGRectMake([_tradeMarkLabel width] +10 -10, kTableInitPosP+i*kLabelHeightP+23, 200, kLabelHeightP);
		[_tradeValueLabel sizeToFit];
		
		i++;
		_netmarginMarkLabel.frame = CGRectMake(-10, kTableInitPosP+i*kLabelHeightP+21, 150, kLabelHeightP);
		[_netmarginMarkLabel sizeToFit];
		_netmarginValueLabel.frame = CGRectMake([_netmarginMarkLabel width] + 10 -10, kTableInitPosP+i*kLabelHeightP+21, 100, kLabelHeightP);
		[_netmarginValueLabel sizeToFit];
		_roeMarkLabel.frame = CGRectMake(kSLPosx-50-38, kTableInitPosP+i*kLabelHeightP+21, 100, kLabelHeightP);
		[_roeMarkLabel sizeToFit];
		_roeValueLabel.frame = CGRectMake(kSLPosx+[_roeMarkLabel width] + 10.0-88, kTableInitPosP+i*kLabelHeightP+21, 100, kLabelHeightP);
		[_roeValueLabel sizeToFit];
		
		i++;
		_peMarkLabel.frame = CGRectMake(-10, kTableInitPosP+i*kLabelHeightP+16, 100, kLabelHeightP);
		[_peMarkLabel sizeToFit];
		_peValueLabel.frame = CGRectMake([_peMarkLabel width] +10 -10, kTableInitPosP+i*kLabelHeightP+16, 100, kLabelHeightP);
		[_peValueLabel sizeToFit];
		_pbMarkLabel.frame = CGRectMake(kSLPosx-50-38, kTableInitPosP+i*kLabelHeightP+16, 100, kLabelHeightP);
		[_pbMarkLabel sizeToFit];
		_pbValueLabel.frame = CGRectMake(kSLPosx+[_pbMarkLabel width] + 10.0-88, kTableInitPosP+i*kLabelHeightP+16, 100, kLabelHeightP);
		[_pbValueLabel sizeToFit];		
	}
}

- (void)drawRect:(CGRect)rect 
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
	return;
	CGContextSetLineWidth(context, 1.0);
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGMutablePathRef trianglePath = CGPathCreateMutable();
	if ( _viewType == CVPiewViewVertical )
	{
		CGPathMoveToPoint(path, NULL, self.frame.size.width/2+kArrowWidth/2, kArrowHeight);
		CGPathAddArcToPoint(path, NULL, self.frame.size.width, kArrowHeight, self.frame.size.width, self.frame.size.height/2, kCornerRadius);
		CGPathAddArcToPoint(path, NULL, self.frame.size.width, self.frame.size.height, self.frame.size.width/2, self.frame.size.height, kCornerRadius);
		CGPathAddArcToPoint(path, NULL, 0, self.frame.size.height, 0, self.frame.size.height/2, kCornerRadius);
		CGPathAddArcToPoint(path, NULL, 0, kArrowHeight, self.frame.size.width/2-kArrowWidth, kArrowHeight, kCornerRadius);
		CGPathAddLineToPoint(path, NULL, self.frame.size.width/2-kArrowWidth/2, kArrowHeight);
		CGPathAddLineToPoint(path, NULL, self.frame.size.width/2, 0);
		CGPathCloseSubpath(path);
		
		//create the blue triangle in the arrow
		CGPathMoveToPoint(trianglePath, NULL, self.frame.size.width/2, kTriangleWidth);
		CGPathAddLineToPoint(trianglePath, NULL, self.frame.size.width/2 + kTriangleWidth, kTriangleWidth + 2*kTriangleWidth*kArrowHeight/kArrowWidth);
		CGPathAddLineToPoint(trianglePath, NULL, self.frame.size.width/2 - kTriangleWidth, kTriangleWidth + 2*kTriangleWidth*kArrowHeight/kArrowWidth);
		CGPathCloseSubpath(trianglePath);
	}
	else 
	{
		CGPathMoveToPoint(path, NULL, kArrowHeight, self.frame.size.height/2-kArrowWidth/2);
		CGPathAddArcToPoint(path, NULL, kArrowHeight, 0, self.frame.size.width/2, 0, kCornerRadius);
		CGPathAddArcToPoint(path, NULL, self.frame.size.width, 0, self.frame.size.width, self.frame.size.height/2, kCornerRadius);
		CGPathAddArcToPoint(path, NULL, self.frame.size.width, self.frame.size.height, self.frame.size.width/2, self.frame.size.height, kCornerRadius);
		CGPathAddArcToPoint(path, NULL, kArrowHeight, self.frame.size.height, kArrowHeight, self.frame.size.height/2+kArrowWidth/2, kCornerRadius);
		CGPathAddLineToPoint(path, NULL, kArrowHeight, self.frame.size.height/2+kArrowWidth/2);
		CGPathAddLineToPoint(path, NULL, 0, self.frame.size.height/2);
		CGPathCloseSubpath(path);
		
		//create the blue triangle in the arrow
		CGPathMoveToPoint(trianglePath, NULL, kTriangleWidth, self.frame.size.height/2);
		CGPathAddLineToPoint(trianglePath, NULL, kTriangleWidth + 2*kTriangleWidth*kArrowHeight/kArrowWidth, self.frame.size.height/2 + kTriangleWidth);
		CGPathAddLineToPoint(trianglePath, NULL, kTriangleWidth + 2*kTriangleWidth*kArrowHeight/kArrowWidth, self.frame.size.height/2 - kTriangleWidth);
		CGPathCloseSubpath(trianglePath);
	}
	
	CGContextAddPath(context, path);
	CGContextClip(context);
	
	CGPoint startPoint = CGPointZero;
	CGPoint endPoint = CGPointMake(self.frame.size.width, self.frame.size.height);
	CGContextDrawLinearGradient(context, _gradient, startPoint, endPoint, 0);
	
	CGContextAddPath(context, trianglePath);
	CGContextFillPath(context);
	CGPathRelease(trianglePath);
	
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
}


- (IBAction)actionButton:(id)sender {
	NSMutableDictionary *notificationDict;
	
	notificationDict = [[NSMutableDictionary alloc] initWithCapacity:1];
	[notificationDict setObject:[NSNumber numberWithInt:CVPortalSetTypeMyStock] forKey:@"Number"];
		
	[notificationDict setObject:[NSNumber numberWithBool:NO] forKey:@"isEquity"];
	if ([_sectorCode isEqualToString:@"10"]) {
		[notificationDict setObject:@"399908" forKey:@"code"];
	} else if ([_sectorCode isEqualToString:@"Materials"]) {
		[notificationDict setObject:@"399909" forKey:@"code"];
	} else if ([_sectorCode isEqualToString:@"20"]) {
		[notificationDict setObject:@"399910" forKey:@"code"];
	} else if ([_sectorCode isEqualToString:@"25"]) {
		[notificationDict setObject:@"399911" forKey:@"code"];
	} else if ([_sectorCode isEqualToString:@"30"]) {
		[notificationDict setObject:@"399912" forKey:@"code"];
	} else if ([_sectorCode isEqualToString:@"35"]) {
		[notificationDict setObject:@"399913" forKey:@"code"];
	} else if ([_sectorCode isEqualToString:@"40"]) {
		[notificationDict setObject:@"399914" forKey:@"code"];
	} else if ([_sectorCode isEqualToString:@"45"]) {
		[notificationDict setObject:@"399915" forKey:@"code"];
	} else if ([_sectorCode isEqualToString:@"50"]) {
		[notificationDict setObject:@"399916" forKey:@"code"];
	} else if ([_sectorCode isEqualToString:@"55"]) {
		[notificationDict setObject:@"399917" forKey:@"code"];
	}
	if (_titleLabel.text) {
		[notificationDict setObject:_titleLabel.text forKey:@"name"];
	}
	
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:[notificationDict autorelease]];
}

@end
