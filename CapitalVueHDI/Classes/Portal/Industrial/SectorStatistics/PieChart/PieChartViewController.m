//
//  PieChartViewController.m
//  PieChart
//
//  Created by ANNA on 10-8-12.
//  Copyright Smiling Mobile 2010. All rights reserved.
//

#import "PieChartViewController.h"

#import "CVShareInfoView.h"
#import "CVShareInfo.h"

@implementation PieChartViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_chartView = [[CVPieChart alloc] initWithFrame:CGRectMake(100, 40, 500, 500)];
	_chartView.userInteractionEnabled = YES;
	_chartView.total = @"204.5B";
	NSMutableArray* shareArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.4],
						   [NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.1], nil];
	NSMutableArray* colorArray = [NSMutableArray arrayWithObjects:[UIColor redColor], [UIColor yellowColor], [UIColor blueColor], [UIColor cyanColor], nil];
	
	[_chartView illustrateShare:shareArray color:colorArray];
	[self.view addSubview:_chartView];
	_chartView.backgroundColor = [UIColor purpleColor];
//	_chartView.viewType = CVPiewViewVertical;
	
	_shareInfoView = [[CVShareInfoView alloc] initWithFrame:CGRectMake(100, 500, 500, 400)];
	CVShareInfo* shareInfo = [[CVShareInfo alloc] init];
	shareInfo.date = [[[NSDate date] description] substringToIndex:10];
	shareInfo.title = @"Consumer";
	shareInfo.chg = @"-1.5%";
	shareInfo.co = @"326";
	shareInfo.gainers = @"188";
	shareInfo.decliners = @"138";
	shareInfo.tradable = @"12121212";
	shareInfo.netmargin = @"3.59";
	shareInfo.roe = @"2.80";
	shareInfo.pe = @"26.03";
	shareInfo.pb = @"3.55";
	[_shareInfoView showData:shareInfo];
	[shareInfo release];
	_shareInfoView.viewType = CVPiewViewVertical;
	_shareInfoView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:_shareInfoView];
	[_shareInfoView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
//	if (UIInterfaceOrientationPortrait == toInterfaceOrientation ||
//		UIInterfaceOrientationPortraitUpsideDown == toInterfaceOrientation)
//	{
//		_chartView.viewType = CVPiewViewVertical;
//	}
//	else 
//	{
//		_chartView.viewType = CVPieViewHorizonal;
//	}
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if ( UIInterfaceOrientationLandscapeLeft == toInterfaceOrientation ||
			UIInterfaceOrientationLandscapeRight == toInterfaceOrientation)
	{
		_shareInfoView.frame = CGRectMake(500, 100, 500, 400);
		_shareInfoView.viewType = CVPieViewHorizonal;
		[_chartView changeViewTypeTo:CVPieViewHorizonal];
	}
	else
	{
		_shareInfoView.frame = CGRectMake(100, 500, 500, 400);
		_shareInfoView.viewType = CVPiewViewVertical;
		[_chartView changeViewTypeTo:CVPiewViewVertical];
	}

}

- (void)dealloc
{
	[_chartView release];
	[_shareInfoView release];
	
    [super dealloc];
}

@end
