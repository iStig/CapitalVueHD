//
//  CVSectorGainerLoserPortletViewController.m
//  CapitalVueHD
//
//  Created by Dream on 10-9-17.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVSectorGainerLoserPortletViewController.h"

#import "CVSetting.h"

@implementation CVSectorGainerLoserPortletViewController
@synthesize dpGainerLoser;
@synthesize svLandscapeRate;
@synthesize svPortraitRate;
@synthesize imgvTopGainers;
@synthesize imgvTopLosers;
@synthesize sectorList;
@synthesize topList;
@synthesize aivList;
@synthesize aivTopGainerLoser;
@synthesize imgvGrayBackground;
@synthesize imgvBlueBackground;
@synthesize imgvLeftLabel;
@synthesize imgvRightLabel;
@synthesize imgvTopLabel;
@synthesize imgvBottomLabel;
@synthesize imgvRedArrow;
@synthesize imgvGreenArrow;
@synthesize lblGainersInfo1;
@synthesize lblGainersInfo2;
@synthesize lblLosersInfo1;
@synthesize lblLosersInfo2;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
//	NSString *configDictPath = [[NSBundle mainBundle] pathForResource:@"SectorConfigure" ofType:@"plist"];
//	configDict = [[NSDictionary alloc] initWithContentsOfFile:configDictPath];
//	
//	
//	
//	sectorIds = [[NSArray alloc] initWithArray:[configDict objectForKey:@"SectorIds"]];
//	
//	[configDict release];
	
	portletTitle = GainersLosersTitle;
	bLabelShow = NO;
	self.style = CVPortletViewStyleRefresh|CVPortletViewStyleBarVisible;
	iTimeCount = 0;
	
	ifLoaded = YES;
	
    [super viewDidLoad];
	UIActivityIndicatorView *acv1 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	acv1.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	acv1.center = CGPointMake(CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_WIDTH/2.0, CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_HEIGHT/2.0);
	[self.view addSubview:acv1];
	self.aivList = acv1;
	[acv1 release];
	
	UIActivityIndicatorView *acv2 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	acv2.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	acv2.center = CGPointMake(CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_WIDTH/2.0, CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_HEIGHT/2.0+80);
	[self.view addSubview:acv2];
	[acv2 stopAnimating];
	self.aivTopGainerLoser = acv2;
	[acv2 release];
	
	
	//Top Gainers
	UIView *imgvG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PortraitGainerWidth, PortraitGainerHeight)];
	imgvG.userInteractionEnabled = YES;
	imgvG.center = CGPointMake(PortraitGainerCenterX, PortraitGainerCenterY);
	//title 
	UILabel *titleLeft1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, RectImageWidth, RectImageHeight)];
	UILabel *titleCenter1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, RectImageWidth, RectImageHeight)];
	UILabel *titleRight1 = [[UILabel alloc] initWithFrame:CGRectMake(-10, 0, RectImageWidth, RectImageHeight)];
	titleLeft1.backgroundColor = [UIColor clearColor];
	titleCenter1.backgroundColor = [UIColor clearColor];
	titleRight1.backgroundColor = [UIColor clearColor];
	titleLeft1.textAlignment = UITextAlignmentLeft;
	titleCenter1.textAlignment = UITextAlignmentCenter;
	titleRight1.textAlignment = UITextAlignmentRight;
	titleLeft1.tag = 71;
	titleCenter1.tag = 72;
	titleRight1.tag = 73;

	titleLeft1.font = [UIFont systemFontOfSize:12];
	titleCenter1.font = [UIFont systemFontOfSize:12];
	titleRight1.font = [UIFont systemFontOfSize:12];
	//five rect image
	for (int i=0;i<5;i++)
	{
		RectImage *ri = [[RectImage alloc] initWithFrame:CGRectMake(0, RectImageHeight*(i+1)+5.0*(i+1)-5, RectImageWidth, RectImageHeight)];
		NSString *path = [[NSBundle mainBundle] pathForResource:GreenImageName ofType:@"png"];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
		[ri setImage:img];
		[img release];
		ri.tag = i;
		[imgvG addSubview:ri];
		ri.backgroundColor = [UIColor clearColor];
		[ri release];
	}

	[imgvG addSubview:titleLeft1];
	[imgvG addSubview:titleCenter1];
	[imgvG addSubview:titleRight1];
	
	
	[titleLeft1 release];
	[titleCenter1 release];
	[titleRight1 release];
	
	[self.view addSubview:imgvG];
	imgvG.opaque = NO;
	imgvG.backgroundColor = [UIColor clearColor];
	self.imgvTopGainers = imgvG;
	[imgvG release];
	
	
	
	//Top Losers
	UIView *imgvL = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PortraitLoserWidth, PortraitLoserHeight)];
	imgvL.userInteractionEnabled = YES;
	imgvL.center = CGPointMake(PortraitLoserCenterX, PortraitLoserCenterY);
	//title 
	UILabel *titleLeft2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, RectImageWidth, RectImageHeight)];
	UILabel *titleCenter2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, RectImageWidth, RectImageHeight)];
	UILabel *titleRight2 = [[UILabel alloc] initWithFrame:CGRectMake(-10, 0, RectImageWidth, RectImageHeight)];
	titleLeft2.backgroundColor = [UIColor clearColor];
	titleCenter2.backgroundColor = [UIColor clearColor];
	titleRight2.backgroundColor = [UIColor clearColor];
	titleLeft2.textAlignment = UITextAlignmentLeft;
	titleCenter2.textAlignment = UITextAlignmentCenter;
	titleRight2.textAlignment = UITextAlignmentRight;
	titleLeft2.tag = 71;
	titleCenter2.tag = 72;
	titleRight2.tag = 73;

	titleLeft2.font = [UIFont systemFontOfSize:12];
	titleCenter2.font = [UIFont systemFontOfSize:12];
	titleRight2.font = [UIFont systemFontOfSize:12];
	//five rect image
	for (int i=0;i<5;i++)
	{
		RectImage *ri = [[RectImage alloc] initWithFrame:CGRectMake(0, RectImageHeight*(i+1)+5.0*(i+1)-5, RectImageWidth, RectImageHeight)];
		NSString *path = [[NSBundle mainBundle] pathForResource:RedImageName ofType:@"png"];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
		[ri setImage:img];
		[img release];
		ri.tag = i;
		[imgvL addSubview:ri];
		ri.backgroundColor = [UIColor clearColor];
	//	ri.opaque = NO;
		[ri release];
	}
	
	
	[imgvL addSubview:titleLeft2];
	[imgvL addSubview:titleCenter2];
	[imgvL addSubview:titleRight2];

	
	[titleLeft2 release];
	[titleCenter2 release];
	[titleRight2 release];
	
	[self.view addSubview:imgvL];
	self.imgvTopLosers = imgvL;
	[imgvL release];
	
	
	//Red & Green Arrow
	NSString *path = [[NSBundle mainBundle] pathForResource:RedArrowName ofType:@"png"];
	UIImage *imgR = [[UIImage alloc] initWithContentsOfFile:path];
	UIImageView *imgvRed = [[UIImageView alloc] initWithImage:imgR];
	[imgvRed sizeToFit];
	[imgR release];
	UILabel *redLabel = [[UILabel alloc] init];
	redLabel.backgroundColor = [UIColor clearColor];
	redLabel.text = [langSetting localizedString:@"Top Decliners"];
	redLabel.textAlignment = UITextAlignmentCenter;
	[redLabel sizeToFit];
	redLabel.center = CGPointMake(imgvRed.frame.size.width/2.0, imgvRed.frame.size.height/2.0);
	[imgvRed addSubview:redLabel];
	[redLabel release];
	[self.view addSubview:imgvRed];
	self.imgvRedArrow = imgvRed;
	[imgvRed release];
	
	
	
	path = [[NSBundle mainBundle] pathForResource:GreenArrowName ofType:@"png"];
	UIImage *imgG = [[UIImage alloc] initWithContentsOfFile:path];
	UIImageView *imgvGreen = [[UIImageView alloc] initWithImage:imgG];
	[imgvGreen sizeToFit];
	[imgG release];
	UILabel *greenLabel = [[UILabel alloc] init];
	greenLabel.backgroundColor = [UIColor clearColor];
	greenLabel.text = [langSetting localizedString:@"Top Gainers"];
	greenLabel.textColor = [UIColor blackColor];
	[greenLabel sizeToFit];
	greenLabel.textAlignment = UITextAlignmentCenter;
	greenLabel.center = CGPointMake(imgvGreen.frame.size.width/2.0, imgvGreen.frame.size.height/2.0-5.);
	[imgvGreen addSubview:greenLabel];
	[greenLabel release];
	[self.view addSubview:imgvGreen];
	self.imgvGreenArrow = imgvGreen;
	[imgvGreen release];
	
	
	// play/stop button
	_btnPlayOrStop = [[UIButton alloc] initWithFrame:[self playButtonFrame]];
	NSString *pathPlay = [[NSBundle mainBundle] pathForResource:@"play.png" ofType:nil];
	UIImage *imgPlay = [[UIImage alloc] initWithContentsOfFile:pathPlay];
	[_btnPlayOrStop setImage:imgPlay forState:UIControlStateNormal];
	[_btnPlayOrStop addTarget:self action:@selector(btnPlayClick:) forControlEvents:UIControlEventTouchUpInside];
	[imgPlay release];
	[self.view addSubview:_btnPlayOrStop];
	
	self.imgvGrayBackground = [[UIImageView alloc] initWithFrame:CGRectMake(GrayBackPortraitX, GrayBackPortraitY, GrayBackPortraitWidth, GrayBackPortraitHeight)];
	[imgvGrayBackground release];
	self.imgvGrayBackground.backgroundColor = [UIColor colorWithRed:230./256. green:230./256. blue:230./256. alpha:1.0];								   
	[self.view addSubview:self.imgvGrayBackground];
	
	self.imgvBlueBackground = [[UIImageView alloc] initWithFrame:CGRectMake(BlueBackPortraitX, BlueBackPortraitY, BlueBackPortraitWidth, BlueBackPortraitHeight)];
	[imgvBlueBackground release];
	NSString *bluePaht = [[NSBundle mainBundle] pathForResource:@"BlueBackPortrait.png" ofType:nil];
	UIImage *imgBlue = [[UIImage alloc] initWithContentsOfFile:bluePaht];
	[self.imgvBlueBackground setImage:imgBlue];
	[self.view addSubview:self.imgvBlueBackground];
	[imgBlue release];
	
	//Portrait View Scroll
	UIScrollView *scvPortraitContent = [[UIScrollView alloc] initWithFrame:CGRectMake(ScrollPortraitX, ScrollPortraitY, PortraitWidth, PortraitHeight*5+1)];
	scvPortraitContent.delegate = self;
	scvPortraitContent.tag = 0;
	//	scvContent.bounces = NO;
	scvPortraitContent.showsVerticalScrollIndicator = NO;
	scvPortraitContent.showsHorizontalScrollIndicator = NO;
	scvPortraitContent.contentOffset = CGPointMake(0, 3*PortraitHeight);
	self.svPortraitRate = scvPortraitContent;
	[self.view addSubview:self.svPortraitRate];
	[scvPortraitContent release];
	
	//Landscape Scroll View
	UIScrollView *scvLandscapeContent = [[UIScrollView alloc] initWithFrame:CGRectMake(ScrollLandscapeX, ScrollLandscapeY, LandscapeWidth*5+1, LandscapeHeight)];
	scvLandscapeContent.delegate = self;
	scvLandscapeContent.tag = 1;
	//	scvContent.bounces = NO;
	scvLandscapeContent.showsVerticalScrollIndicator = NO;
	scvLandscapeContent.showsHorizontalScrollIndicator = NO;
	scvLandscapeContent.contentOffset = CGPointMake(6*LandscapeWidth,0);
	self.svLandscapeRate = scvLandscapeContent;
	[self.view addSubview:self.svLandscapeRate];
	[scvLandscapeContent release];
	
	//portrait percent : top
	UIImageView *topLabel = [[UIImageView alloc] initWithFrame:CGRectMake(PortraitLabelsX, PortraitLabelsY1, PortraitWidth, PortraitLabelsHeight)];
	for (int i=0;i<9;i++)
	{
		CGFloat distance = MidlineX/5.0;
		UILabel *lbl = [[UILabel alloc] init];
		lbl.text = [NSString stringWithFormat:@"%d%%",80-(20*i)];
		lbl.font = [UIFont systemFontOfSize:PercentFontSize];
		[lbl sizeToFit];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentCenter;
		lbl.textColor = [UIColor grayColor];
		lbl.opaque = NO;
		lbl.center = CGPointMake(distance*(i+1),PortraitLabelsHeight/2.0);
		[topLabel addSubview:lbl];
		[lbl release];
		if (8==i)
		{

			
			UIImageView *midLine = [[UIImageView alloc] initWithFrame:CGRectMake(BoldlineX, 0, 2, PortraitLabelsHeight)];
			midLine.backgroundColor = [UIColor grayColor];
			[topLabel addSubview:midLine];
			[midLine release];
		}
	}
	[self.view addSubview:topLabel];
	self.imgvTopLabel = topLabel;
	[topLabel release];
	//portrait percent : bottom
	UIImageView *bottomLabel = [[UIImageView alloc] initWithFrame:CGRectMake(PortraitLabelsX,PortraitLabelsY2,PortraitWidth,PortraitLabelsHeight)];
	for (int i=0;i<9;i++)
	{
		CGFloat distance = MidlineX/5.0;
		UILabel *lbl = [[UILabel alloc] init];
		lbl.text = [NSString stringWithFormat:@"%d%%",80-(20*i)];
		lbl.font = [UIFont systemFontOfSize:PercentFontSize];
		[lbl sizeToFit];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentCenter;
		lbl.textColor = [UIColor grayColor];
		lbl.opaque = NO;
		lbl.center = CGPointMake(distance*(i+1),PortraitLabelsHeight/2.0);
		[bottomLabel addSubview:lbl];
		[lbl release];
		if (8==i)
		{

			
			UIImageView *midLine = [[UIImageView alloc] initWithFrame:CGRectMake(BoldlineX, 0, 2, PortraitLabelsHeight)];
			midLine.backgroundColor = [UIColor grayColor];
			[bottomLabel addSubview:midLine];
			[midLine release];
		}
	}
	[self.view addSubview:bottomLabel];
	self.imgvBottomLabel = bottomLabel;
	[bottomLabel release];
	
	
	//landscape percent: left
	UIImageView *leftLabel = [[UIImageView alloc] initWithFrame:CGRectMake(LandscapeLabelsX1,LandscapeLabelsY,LandscapeLabelsWidth,LandscapeHeight)];
	for (int i=0;i<9;i++)
	{
		CGFloat distance = MidlineY/5.0;
		UILabel *lbl = [[UILabel alloc] init];
		lbl.text = [NSString stringWithFormat:@"%d%%",80-(20*i)];
		lbl.font = [UIFont systemFontOfSize:PercentFontSize];
		[lbl sizeToFit];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentCenter;
		lbl.textColor = [UIColor grayColor];
		lbl.opaque = NO;
		lbl.center = CGPointMake(LandscapeLabelsWidth/2.0,distance*(i+1));
		[leftLabel addSubview:lbl];
		[lbl release];
		if (8==i)
		{
			
			UIImageView *midLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, BoldlineY, LandscapeLabelsWidth, 2)];
			midLine.backgroundColor = [UIColor grayColor];
			[leftLabel addSubview:midLine];
			[midLine release];
		}
	}
	[self.view addSubview:leftLabel];
	self.imgvLeftLabel = leftLabel;
	[leftLabel release];
	//landscape percent: right
	UIImageView *rightLabel = [[UIImageView alloc] initWithFrame:CGRectMake(LandscapeLabelsX2,LandscapeLabelsY,LandscapeLabelsWidth,LandscapeHeight)];
	for (int i=0;i<9;i++)
	{
		CGFloat distance = MidlineY/5.0;
		UILabel *lbl = [[UILabel alloc] init];
		lbl.text = [NSString stringWithFormat:@"%d%%",80-(20*i)];
		lbl.font = [UIFont systemFontOfSize:PercentFontSize];
		[lbl sizeToFit];
		lbl.backgroundColor = [UIColor clearColor];
		lbl.textAlignment = UITextAlignmentCenter;
		lbl.textColor = [UIColor grayColor];
		lbl.opaque = NO;
		lbl.center = CGPointMake(LandscapeLabelsWidth/2.0,distance*(i+1));
		[rightLabel addSubview:lbl];
		[lbl release];
		if (8==i)
		{
			UIImageView *midLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, BoldlineY, LandscapeLabelsWidth, 2)];
			midLine.backgroundColor = [UIColor grayColor];
			[rightLabel addSubview:midLine];
			[midLine release];
		}
	}
	[self.view addSubview:rightLabel];
	self.imgvRightLabel = rightLabel;
	[rightLabel release];
	
	self.lblGainersInfo1  = [[UILabel alloc] initWithFrame:CGRectMake(kInfoLandscapeX, kInfoLandscapeY1, kInfoLandscapeWidth, kInfoLandscapeHeight)];
	[lblGainersInfo1 release];
	lblGainersInfo1.textAlignment = UITextAlignmentCenter;
	lblGainersInfo1.backgroundColor = [UIColor clearColor];
	lblGainersInfo1.textColor = [UIColor blackColor];
	lblGainersInfo1.font = [UIFont boldSystemFontOfSize:10];
	lblGainersInfo1.text = [langSetting localizedString:@"Up:"];
	
	self.lblGainersInfo2  = [[UILabel alloc] initWithFrame:CGRectMake(kInfoLandscapeX, kInfoLandscapeY1+15, kInfoLandscapeWidth, kInfoLandscapeHeight)];
	[lblGainersInfo2 release];
	lblGainersInfo2.textAlignment = UITextAlignmentCenter;
	lblGainersInfo2.backgroundColor = [UIColor clearColor];
	lblGainersInfo2.textColor = [UIColor blackColor];
	lblGainersInfo2.font = [UIFont boldSystemFontOfSize:10];
	lblGainersInfo2.text = @"--";
	
	self.lblLosersInfo1 = [[UILabel alloc] initWithFrame:CGRectMake(kInfoLandscapeX, kInfoLandscapeY2-15, kInfoLandscapeWidth, kInfoLandscapeHeight)];
	[lblLosersInfo1 release];
	lblLosersInfo1.textAlignment = UITextAlignmentCenter;
	lblLosersInfo1.backgroundColor = [UIColor clearColor];
	lblLosersInfo1.textColor = [UIColor blackColor];
	lblLosersInfo1.font = [UIFont boldSystemFontOfSize:10];
	lblLosersInfo1.text = [langSetting localizedString:@"Down:"];
	
	self.lblLosersInfo2 = [[UILabel alloc] initWithFrame:CGRectMake(kInfoLandscapeX, kInfoLandscapeY2, kInfoLandscapeWidth, kInfoLandscapeHeight)];
	[lblLosersInfo2 release];
	lblLosersInfo2.textAlignment = UITextAlignmentCenter;
	lblLosersInfo2.backgroundColor = [UIColor clearColor];
	lblLosersInfo2.textColor = [UIColor blackColor];
	lblLosersInfo2.font = [UIFont boldSystemFontOfSize:10];
	lblLosersInfo2.text = @"--";
	
	[self.view addSubview:lblLosersInfo1];
	[self.view addSubview:lblLosersInfo2];
	[self.view addSubview:lblGainersInfo1];
	[self.view addSubview:lblGainersInfo2];
	
	[self adjustSubviews:[UIApplication sharedApplication].statusBarOrientation];
	[self preStepForLoadData];
	[self performSelectorInBackground:@selector(getSectorListData:) withObject:[NSNumber numberWithBool:YES]];
	
	CVSetting *s;
	s = [CVSetting sharedInstance];
	dpGainerLoser = [CVDataProvider sharedInstance];
	[dpGainerLoser setDataIdentifier:@"IndustrialGainerLoser" lifecycle:[s cvCachedDataLifecycle:CVSettingIndustrialGainerLoser]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getScrollerNotificationFromPieChart:) name:kNotificationToScroller object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToStopAutoScroll:) name:kStopAutoScroll object:nil];
}


- (void) preStepForLoadData{
	ifLoaded = NO;
	
	[self.aivList startAnimating];
	
	self.aivList.hidden = NO;
	self.aivList.hidesWhenStopped = YES;
	self.aivTopGainerLoser.hidden = YES;
	self.aivTopGainerLoser.hidesWhenStopped = YES;
	
	self.imgvRedArrow.hidden = YES;
	self.imgvGreenArrow.hidden = YES;
	
	self.imgvTopGainers.hidden = YES;
	self.imgvTopLosers.hidden = YES;
	
	self.imgvTopLabel.hidden = YES;
	self.imgvBottomLabel.hidden = YES;
	self.imgvLeftLabel.hidden = YES;
	self.imgvRightLabel.hidden = YES;
	
	lblLosersInfo1.hidden = YES;
	lblLosersInfo2.hidden = YES;
	lblGainersInfo1.hidden = YES;
	lblGainersInfo2.hidden = YES;
	
	imgvGrayBackground.hidden = YES;
	imgvBlueBackground.hidden = YES;
	
	self.svPortraitRate.hidden = YES;
	self.svLandscapeRate.hidden = YES;
	for (UIView *subView in [self.svPortraitRate subviews]) {
		[subView removeFromSuperview];
	}
	for (UIView *subView in [self.svLandscapeRate subviews]) {
		[subView removeFromSuperview];
	}
}

- (void) afterLoadData{
	self.imgvRedArrow.hidden = NO;
	self.imgvGreenArrow.hidden = NO;
	
	self.imgvTopGainers.hidden = NO;
	self.imgvTopLosers.hidden = NO;
	
//	self.imgvTopLabel.hidden = NO;
//	self.imgvBottomLabel.hidden = NO;
//	self.imgvLeftLabel.hidden = NO;
//	self.imgvRightLabel.hidden = NO;
	
	lblLosersInfo1.hidden = NO;
	lblLosersInfo2.hidden = NO;
	lblGainersInfo1.hidden = NO;
	lblGainersInfo2.hidden = NO;
	
	[self.view bringSubviewToFront:lblGainersInfo1];
	[self.view bringSubviewToFront:lblLosersInfo1];
	[self.view bringSubviewToFront:lblGainersInfo2];
	[self.view bringSubviewToFront:lblLosersInfo2];
	
	imgvGrayBackground.hidden = NO;
	imgvBlueBackground.hidden = NO;
	
	[self updateSectorList];
	
	[aivList stopAnimating];
	ifLoaded = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dpGainerLoser release];
	[svLandscapeRate release];
	[svPortraitRate release];
	[imgvTop release];
	[imgvTopGainers release];
	[imgvTopLosers release];
	[sectorList release];
	[topList release];
	[aivList release];
	[aivTopGainerLoser release];
	
	[imgvGrayBackground release];
	[imgvBlueBackground release];
	
	[imgvLeftLabel release];
	[imgvRightLabel release];
	[imgvTopLabel release];
	[imgvBottomLabel release];
	
	[imgvRedArrow release];
	[imgvGreenArrow release];
	
	[configDict release];
	
	
	[lblGainersInfo1 release];
	[lblGainersInfo2 release];
	[lblLosersInfo1 release];
	[lblLosersInfo2 release];
	[_btnPlayOrStop release];
    [super dealloc];
}


#pragma mark Get Data Thread via Web Service
- (void) getSectorListData:(NSNumber *)isRefresh
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	BOOL forceRefresh = [isRefresh boolValue];
	CVSetting *s;
	CVDataProvider *dataProvider;
	CVParamInfo *paramInfo;
	
	dataProvider = [CVDataProvider sharedInstance];
	s = [CVSetting sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingIndustrialGainerLoser];
	if (forceRefresh) {
		self.sectorList = [dataProvider RefreshSectorList:(CVParamInfo *)paramInfo];
	}else {
		self.sectorList = [dataProvider GetSectorList:(CVParamInfo *)paramInfo];
	}
	
	if (self.sectorList && [sectorList objectForKey:@"data"]>0) {
		_valuedData = YES;
	} else {
		_valuedData = NO;
	}


	[paramInfo release];
	
	[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];
	[pool release];
}

-(void)updateSectorList{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSArray *array = [sectorList objectForKey:@"data"];
	NSInteger sectorCount = [array count];
	
	// set the title of portlet with appended date
	if ([sectorList count] > 0) {
		NSDictionary *element;
		NSString *strDate, *strTitle;
		
		element = [array objectAtIndex:0];
		strDate = [element objectForKey:@"当日日期"];
		strTitle = GainersLosersTitle;
		if (strDate && strTitle) {
			NSString *t = [[NSString alloc] initWithFormat:@"%@ %@", strTitle, strDate];
			self.portletTitle = t;
			[t release];
		}
	}
	
	self.svPortraitRate.contentSize = CGSizeMake(PortraitWidth, PortraitHeight*(10+sectorCount));
	self.svLandscapeRate.contentSize = CGSizeMake(LandscapeWidth*(10+sectorCount), LandscapeHeight);
	
	NSDictionary *dic;
	int i=0;
	int j=0;
	for (i=sectorCount-5;i<sectorCount;i++)
	{
		dic = [array objectAtIndex:i];
		NSString *imgvName = [dic objectForKey:@"行业名称"];
		NSString *strIn = [dic objectForKey:@"上涨股票数比例"];
		NSString *strDe = [dic objectForKey:@"下跌股票数比例"];
		NSString *strCh = [dic objectForKey:@"日涨跌幅"];
		UIImageViewEx *imgV = [[UIImageViewEx alloc] initWithName:imgvName increased:strIn decreased:strDe changed:strCh];
		imgV.frame = CGRectMake(0, PortraitHeight*j, PortraitWidth, PortraitHeight);
		[imgV updateOrientation:UIInterfaceOrientationPortrait];
		[self.svPortraitRate addSubview:imgV];
		[imgV release];
		j++;
	}
	for (i=0;i<sectorCount;i++)
	{
		dic = [array objectAtIndex:i];
		NSString *imgvName = [dic objectForKey:@"行业名称"];
		NSString *strIn = [dic objectForKey:@"上涨股票数比例"];
		NSString *strDe = [dic objectForKey:@"下跌股票数比例"];
		NSString *strCh = [dic objectForKey:@"日涨跌幅"];
		UIImageViewEx *imgV = [[UIImageViewEx alloc] initWithName:imgvName increased:strIn decreased:strDe changed:strCh];
		imgV.frame = CGRectMake(0, PortraitHeight*j, PortraitWidth, PortraitHeight);
		[imgV updateOrientation:UIInterfaceOrientationPortrait];
		[self.svPortraitRate addSubview:imgV];
		[imgV release];
		j++;
	}
	
	for (i=0;i<5;i++)
	{
		dic = [array objectAtIndex:i];
		NSString *imgvName = [dic objectForKey:@"行业名称"];
		NSString *strIn = [dic objectForKey:@"上涨股票数比例"];
		NSString *strDe = [dic objectForKey:@"下跌股票数比例"];
		NSString *strCh = [dic objectForKey:@"日涨跌幅"];
		UIImageViewEx *imgV = [[UIImageViewEx alloc] initWithName:imgvName increased:strIn decreased:strDe changed:strCh];
		imgV.frame = CGRectMake(0, PortraitHeight*j, PortraitWidth, PortraitHeight);
		[imgV updateOrientation:UIInterfaceOrientationPortrait];
		if (i==4)
			imgV.lblLine2.frame = CGRectMake(0, PortraitHeight-1, PortraitWidth, 1);
		[self.svPortraitRate addSubview:imgV];
		[imgV release];
		j++;
	}
	
	
	i=0;
	j=0;
	
	for (i=sectorCount-5;i<sectorCount;i++)
	{
		dic = [array objectAtIndex:i];
		NSString *imgvName = [dic objectForKey:@"行业名称"];
		NSString *strIn = [dic objectForKey:@"上涨股票数比例"];
		NSString *strDe = [dic objectForKey:@"下跌股票数比例"];
		NSString *strCh = [dic objectForKey:@"日涨跌幅"];
		UIImageViewEx *imgV = [[UIImageViewEx alloc] initWithName:imgvName increased:strIn decreased:strDe changed:strCh];
		imgV.frame = CGRectMake(LandscapeWidth*j, 0, LandscapeWidth, LandscapeHeight);
		[imgV updateOrientation:UIInterfaceOrientationLandscapeLeft];
		[self.svLandscapeRate addSubview:imgV];
		[imgV release];
		j++;
	}
	for (i=0;i<sectorCount;i++)
	{
		dic = [array objectAtIndex:i];
		NSString *imgvName = [dic objectForKey:@"行业名称"];
		NSString *strIn = [dic objectForKey:@"上涨股票数比例"];
		NSString *strDe = [dic objectForKey:@"下跌股票数比例"];
		NSString *strCh = [dic objectForKey:@"日涨跌幅"];
		UIImageViewEx *imgV = [[UIImageViewEx alloc] initWithName:imgvName increased:strIn decreased:strDe changed:strCh];
		imgV.frame = CGRectMake(LandscapeWidth*j, 0, LandscapeWidth, LandscapeHeight);
		[imgV updateOrientation:UIInterfaceOrientationLandscapeLeft];
		[self.svLandscapeRate addSubview:imgV];
		[imgV release];
		j++;
	}
	
	for (i=0;i<5;i++)
	{
		dic = [array objectAtIndex:i];
		NSString *imgvName = [dic objectForKey:@"行业名称"];
		NSString *strIn = [dic objectForKey:@"上涨股票数比例"];
		NSString *strDe = [dic objectForKey:@"下跌股票数比例"];
		NSString *strCh = [dic objectForKey:@"日涨跌幅"];
		UIImageViewEx *imgV = [[UIImageViewEx alloc] initWithName:imgvName increased:strIn decreased:strDe changed:strCh];
		imgV.frame = CGRectMake(LandscapeWidth*j, 0, LandscapeWidth, LandscapeHeight);
		[imgV updateOrientation:UIInterfaceOrientationLandscapeLeft];
		if (i==4)
			imgV.lblLine2.frame = CGRectMake(LandscapeWidth-1, 0, 1, LandscapeHeight);
		[self.svLandscapeRate addSubview:imgV];
		[imgV release];
		j++;
	}
	
	bLabelShow = YES;
	
	[self updateOrientation];
	[self performSelector:@selector(getTopGainerLoser:) withObject:[[array objectAtIndex:lastSelected] objectForKey:@"ICODE"]];
	
	if(sectorCount > 0){
		if ([autoTimer isValid]) {
			[autoTimer invalidate];
		}
		autoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
													 target:self
												   selector:@selector(autoScroll)
												   userInfo:nil
													repeats:YES];
	}
}


- (void) getTopGainerLoser:(NSString *)icode
{
	
	NSArray *array = [sectorList objectForKey:@"data"];
	for (NSDictionary*dict in array)
	{
		if([icode isEqualToString:[dict objectForKey:@"ICODE"]])
		{
			NSString *strGainer = [dict objectForKey:@"上涨股票数"];
			NSString *strLoser = [dict objectForKey:@"下跌股票数"];
			lblGainersInfo2.text = [NSString stringWithFormat:@"%@",strGainer];
			lblLosersInfo2.text = [NSString stringWithFormat:@"%@",strLoser];

			break;
		}
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CVSetting *s;
	CVDataProvider *dataProvider;
	CVParamInfo *paramInfo;
	
	s = [CVSetting sharedInstance];
	dataProvider = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingIndustrialGainerLoser];
	paramInfo.parameters = icode;
	self.topList = [dataProvider GetSectorTopGainersDecliners:paramInfo];
	[paramInfo release];
	
	[self performSelector:@selector(updateTopList) withObject:nil];
	
	[pool release];
}

#pragma mark -
#pragma mark notification connect with pie chart

- (void) postNotificationToScrollPieChart:(NSString *)icode{
	[[NSNotificationCenter defaultCenter] postNotificationName:kScrollNotificationToPieChart object:icode];
}

- (void) getNotificationToStopAutoScroll:(NSNotification *)notification{
	iTimeCount = 0;
}

- (void) getScrollerNotificationFromPieChart:(NSNotification *)notification{
	NSString *icode = [notification object];
	if ([sectorList count] == 0) {
		return;
	}
	float xOffset = svLandscapeRate.contentOffset.x;
	int index = (int)(xOffset/LandscapeWidth);
	
	NSArray *array = [self.sectorList objectForKey:@"data"];
	int selected = 0;
	int sectorCount = [array count];
	for (int i = 0; i < sectorCount; i++) {
		if ([[[array objectAtIndex:i] objectForKey:@"ICODE"] isEqualToString:icode]) {
			selected = i;
			break;
		}
	}
	// -2 is offset to compare with pie chart index
	selected -= 2;
	if (selected < 0) {
		selected += sectorCount;
	}
	int contentOffsetIndex = selected + 5;
	if (contentOffsetIndex - index > 5) {
		[svPortraitRate setContentOffset:CGPointMake(svPortraitRate.contentOffset.x, svPortraitRate.contentOffset.y+sectorCount*PortraitHeight-1) animated:NO];
		[svLandscapeRate setContentOffset:CGPointMake(svLandscapeRate.contentOffset.x+sectorCount*LandscapeWidth-1, svLandscapeRate.contentOffset.y) animated:NO];
	}else if (contentOffsetIndex - index < -5) {
		[svPortraitRate setContentOffset:CGPointMake(svPortraitRate.contentOffset.x, svPortraitRate.contentOffset.y-sectorCount*PortraitHeight+1) animated:NO];
		[svLandscapeRate setContentOffset:CGPointMake(svLandscapeRate.contentOffset.x-sectorCount*LandscapeWidth+1, svLandscapeRate.contentOffset.y) animated:NO];
	}

	if (svLandscapeRate.hidden) {
		[svPortraitRate setContentOffset:CGPointMake(svPortraitRate.contentOffset.x, contentOffsetIndex*PortraitHeight) animated:YES];
		[svLandscapeRate setContentOffset:CGPointMake(contentOffsetIndex*LandscapeWidth, svLandscapeRate.contentOffset.y) animated:NO];
	}else {
		[svPortraitRate setContentOffset:CGPointMake(svPortraitRate.contentOffset.x, contentOffsetIndex*PortraitHeight) animated:NO];
		[svLandscapeRate setContentOffset:CGPointMake(contentOffsetIndex*LandscapeWidth, svLandscapeRate.contentOffset.y) animated:YES];
	}
	
	selected+=2;
	if (sectorCount<=selected)
		selected-=sectorCount;
	if (lastSelected != selected) {
		imgvRedArrow.hidden = YES;
		imgvGreenArrow.hidden = YES;
		lastSelected=selected;
		imgvTopGainers.hidden = YES;
		imgvTopLosers.hidden = YES;
		[aivTopGainerLoser startAnimating];
		
		[self getTopGainerLoser:[[array objectAtIndex:selected] objectForKey:@"ICODE"]];
	}
}

#pragma mark -
#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	iTimeCount = 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	NSArray *array = [self.sectorList objectForKey:@"data"];
	NSInteger sectorCount = [array count];
	if (scrollView.tag==0)
	{
		CGFloat offset = scrollView.contentOffset.y;
		if (offset <= 0) {
			[svPortraitRate setContentOffset:CGPointMake(0, offset+PortraitHeight*sectorCount) animated:NO];
			[svLandscapeRate setContentOffset:CGPointMake(LandscapeWidth*sectorCount, 0) animated:NO];
		} else if (offset >= 15*PortraitHeight) {
			[svPortraitRate setContentOffset:CGPointMake(0, offset - PortraitHeight*sectorCount) animated:NO];
			[svLandscapeRate setContentOffset:CGPointMake(svLandscapeRate.contentOffset.x - LandscapeWidth*sectorCount, 0) animated:NO];
		}
	}
	else
	{
		CGFloat offset = scrollView.contentOffset.x;
		if (offset <= 0) {
			[svPortraitRate setContentOffset:CGPointMake(0, PortraitHeight*sectorCount) animated:NO];
			[svLandscapeRate setContentOffset:CGPointMake(offset+LandscapeWidth*sectorCount, 0) animated:NO];
		}else if (offset >= 15*LandscapeWidth) {
			[svPortraitRate setContentOffset:CGPointMake(0, svPortraitRate.contentOffset.y - PortraitHeight*sectorCount) animated:NO];
			[svLandscapeRate setContentOffset:CGPointMake(offset - LandscapeWidth*sectorCount, 0) animated:NO];
		}
	}

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	NSArray *array = [self.sectorList objectForKey:@"data"];
	NSInteger sectorCount = [array count];
	if (!decelerate) 
	{
		if (scrollView.tag==0)
		{
			CGFloat offset = scrollView.contentOffset.y;
			int index = (int)(offset/PortraitHeight);
			NSInteger selected=0;
			if (offset/PortraitHeight-index>0.5)
				selected = index+1;
			else
				selected = index;
			
			[scrollView setContentOffset:CGPointMake(0, PortraitHeight*selected) animated:YES];
			[svLandscapeRate setContentOffset:CGPointMake(LandscapeWidth*selected, 0) animated:NO];
			if (selected<5){
				selected+=sectorCount;
				selected -= 5;
			}
			else if(selected>=(sectorCount+5)){
				selected-=(sectorCount+5);
			}
			else{
				selected-=5;
			}
			selected+=2;
			if (sectorCount<=selected)
				selected-=sectorCount;
			if (lastSelected!=selected)
			{
				imgvRedArrow.hidden = YES;
				imgvGreenArrow.hidden = YES;
				lastSelected=selected;
				imgvTopGainers.hidden = YES;
				imgvTopLosers.hidden = YES;
				[aivTopGainerLoser startAnimating];
				[self performSelector:@selector(getTopGainerLoser:) withObject:[[array objectAtIndex:selected] objectForKey:@"ICODE"] afterDelay:0.4];		
			}
		}
		else
		{
			CGFloat offset = scrollView.contentOffset.x;
			int index = (int)(offset/LandscapeWidth);
			NSInteger selected=0;
			if (offset/LandscapeWidth-index>0.5)
				selected = index+1;
			else
				selected = index;
			[scrollView setContentOffset:CGPointMake(LandscapeWidth*selected, 0) animated:YES];
			[svPortraitRate setContentOffset:CGPointMake(0, PortraitHeight*selected) animated:NO];
			if (selected<5){
				selected+=sectorCount;
				selected -= 5;
			}
			else if(selected>=(sectorCount+5)){
				selected-=(sectorCount+5);
			}
			else{
				selected-=5;
			}
			selected+=2;
			if (sectorCount<=selected)
				selected-=sectorCount;
			if (lastSelected!=selected)
			{
				imgvRedArrow.hidden = YES;
				imgvGreenArrow.hidden = YES;
				lastSelected=selected;
				imgvTopGainers.hidden = YES;
				imgvTopLosers.hidden = YES;
				[aivTopGainerLoser startAnimating];
				[self performSelector:@selector(getTopGainerLoser:) withObject:[[array objectAtIndex:selected] objectForKey:@"ICODE"] afterDelay:0.4];
			}
		}
	}
	
	iTimeCount = 0;
	[self postNotificationToScrollPieChart:[[array objectAtIndex:lastSelected] objectForKey:@"ICODE"]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	
	NSArray *array = [self.sectorList objectForKey:@"data"];
	NSInteger sectorCount = [array count];
	if (scrollView.tag==0)
	{
		CGFloat offset = scrollView.contentOffset.y;
		
		int index = (int)(offset/PortraitHeight);
		NSInteger selected=0;
		if (offset/PortraitHeight-index>0.5)
			selected = index+1;
		else
			selected = index;
		
		[scrollView setContentOffset:CGPointMake(0, PortraitHeight*selected) animated:YES];
		[svLandscapeRate setContentOffset:CGPointMake(LandscapeWidth*selected, 0) animated:NO];
		
		if (selected<5){
			selected+=sectorCount;
			selected -= 5;
		}
		else if(selected>=(sectorCount+5)){
			selected-=(sectorCount+5);
		}
		else{
			selected-=5;
		}
		
		selected+=2;
		if (sectorCount<=selected)
			selected-=sectorCount;
		
		if (lastSelected!=selected)
		{
			imgvRedArrow.hidden = YES;
			imgvGreenArrow.hidden = YES;
			lastSelected=selected;
			imgvTopGainers.hidden = YES;
			imgvTopLosers.hidden = YES;
			[aivTopGainerLoser startAnimating];
			[self performSelector:@selector(getTopGainerLoser:) withObject:[[array objectAtIndex:selected] objectForKey:@"ICODE"] afterDelay:0.4];	
		}
	}
	else
	{
		CGFloat offset = scrollView.contentOffset.x;
		int index = (int)(offset/LandscapeWidth);
		NSInteger selected=0;
		if (offset/LandscapeWidth-index>0.5)
			selected = index+1;
		else
			selected = index;
		[scrollView setContentOffset:CGPointMake(LandscapeWidth*selected, 0) animated:YES];
		[svPortraitRate setContentOffset:CGPointMake(0, PortraitHeight*selected) animated:NO];
		
		if (selected<5){
			selected+=sectorCount;
			selected -= 5;
		}
		else if(selected>=(sectorCount+5)){
			selected-=(sectorCount+5);
		}
		else{
			selected-=5;
		}
		selected+=2;
		if (sectorCount<=selected)
			selected-=sectorCount;
		if (lastSelected!=selected)
		{
			imgvRedArrow.hidden = YES;
			imgvGreenArrow.hidden = YES;
			lastSelected=selected;
			imgvTopGainers.hidden = YES;
			imgvTopLosers.hidden = YES;
			[aivTopGainerLoser startAnimating];
			[self performSelector:@selector(getTopGainerLoser:) withObject:[[array objectAtIndex:selected] objectForKey:@"ICODE"] afterDelay:0.4];
		}
	}
	
	iTimeCount = 0;
	[self postNotificationToScrollPieChart:[[array objectAtIndex:lastSelected] objectForKey:@"ICODE"]];
}

#pragma mark -
#pragma mark Update Top Gainers/Losers
- (void) updateTopList
{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSArray *topGainers = [topList objectForKey:@"gainers"];
	NSArray *topLosers = [topList objectForKey:@"decliners"];
	UILabel *lblLeft1 = (UILabel *)[imgvTopGainers viewWithTag:71];
	UILabel *lblLeft2 = (UILabel *)[imgvTopLosers viewWithTag:71];
	UILabel *lblCenter1 = (UILabel *)[imgvTopGainers viewWithTag:72];
	UILabel *lblCenter2 = (UILabel *)[imgvTopLosers viewWithTag:72];
	UILabel *lblRight1 = (UILabel *)[imgvTopGainers viewWithTag:73];
	UILabel *lblRight2 = (UILabel *)[imgvTopLosers viewWithTag:73];
	
	BOOL isSimpleChinese;
	
	if ([[langSetting localizedString:@"LangCode"] isEqualToString:@"cn"]) {
		isSimpleChinese = YES;
	} else {
		isSimpleChinese = NO;
	}
	
	if (isSimpleChinese) {
		lblLeft1.text = [[[topList objectForKey:@"head"] lastObject] objectForKey:@"value"];
		lblLeft2.text = [[[topList objectForKey:@"head"] lastObject] objectForKey:@"value"];
	} else {
		lblLeft1.text = [[[topList objectForKey:@"head"] objectAtIndex:1] objectForKey:@"value"];
		lblLeft2.text = [[[topList objectForKey:@"head"] objectAtIndex:1] objectForKey:@"value"];
	}
	
	lblCenter1.text = [[[topList objectForKey:@"head"] objectAtIndex:0] objectForKey:@"value"];
	lblCenter2.text = [[[topList objectForKey:@"head"] objectAtIndex:0] objectForKey:@"value"];
	
	lblRight1.text =  [[[topList objectForKey:@"head"] objectAtIndex:3] objectForKey:@"value"];
	lblRight2.text =  [[[topList objectForKey:@"head"] objectAtIndex:3] objectForKey:@"value"];
	
	for (id sbview in imgvTopGainers.subviews)
	{
		if ([[sbview class] isSubclassOfClass:[RectImage class]])
		{
			RectImage *ri = (RectImage *)sbview;
			if ([topGainers count]>5)
			{
				NSDictionary *dict = [topGainers objectAtIndex:ri.tag];
				NSString *stock;
				NSString *close;
				NSString *change;
				
				if (isSimpleChinese) {
					stock = [dict objectForKey:@"股票名称"];
				} else {
					stock = [dict objectForKey:@"股票代码"];
				}

				close = [dict objectForKey:@"当日收盘价"];
				change = [dict objectForKey:@"日涨跌幅"];
				
				NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"CV_iPad_TopGL_Pos_%@",[langSetting localizedString:@"LangCode"]] ofType:@"png"];
				UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
				[ri setImage:img];
				[img release];
				ri.lblLeft.text = stock;
				ri.lblCenter.text = close;
				ri.lblRight.text = [NSString stringWithFormat:@"%@%%",change];
				ri.code = [dict objectForKey:@"股票代码"];
			}
			else
			{
				if (ri.tag<[topGainers count])
				{
					NSDictionary *dict = [topGainers objectAtIndex:ri.tag];
					NSString *stock;
					NSString *close;
					NSString *change;
					
					if (isSimpleChinese) {
						stock = [dict objectForKey:@"股票名称"];
					} else {
						stock = [dict objectForKey:@"股票代码"];
					}
					close = [dict objectForKey:@"当日收盘价"];
					change = [dict objectForKey:@"日涨跌幅"];
					
					NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"CV_iPad_TopGL_Pos_%@",[langSetting localizedString:@"LangCode"]] ofType:@"png"];
					UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
					[ri setImage:img];
					[img release];
					ri.lblLeft.text = stock;
					ri.lblCenter.text = close;
					ri.lblRight.text = [NSString stringWithFormat:@"%@%%",change];
					ri.code = [dict objectForKey:@"股票代码"];
				}
				else
				{
					NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"CV_iPad_TopGL_Pos_%@",[langSetting localizedString:@"LangCode"]] ofType:@"png"];
					UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
					[ri setImage:img];
					[img release];
					ri.lblLeft.text = @"--";
					ri.lblCenter.text = @"--";
					ri.lblRight.text = @"--";
					ri.code = nil;
				}
			}
		}			
	}
	for (id sbview in imgvTopLosers.subviews)
	{
		if ([[sbview class] isSubclassOfClass:[RectImage class]])
		{
			RectImage *ri = (RectImage *)sbview;
			if ([topLosers count]>5)
			{
				NSDictionary *dict = [topLosers objectAtIndex:ri.tag];
				NSString *stock;
				NSString *close;
				NSString *change;
				
				if (isSimpleChinese) {
					stock = [dict objectForKey:@"股票名称"];
				} else {
					stock = [dict objectForKey:@"股票代码"];
				}

				close = [dict objectForKey:@"当日收盘价"];
				change = [dict objectForKey:@"日涨跌幅"];
				
				NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"CV_iPad_TopGL_Neg_%@",[langSetting localizedString:@"LangCode"]] ofType:@"png"];
				UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
				[ri setImage:img];
				[img release];
				ri.lblLeft.text = stock;
				ri.lblCenter.text = close;
				ri.lblRight.text = [NSString stringWithFormat:@"%@%%",change];
				ri.code = [dict objectForKey:@"股票代码"];
			}
			else
			{
				if (ri.tag<[topLosers count])
				{
					NSDictionary *dict = [topLosers objectAtIndex:ri.tag];
					NSString *stock;
					NSString *close;
					NSString *change;
					
					if (isSimpleChinese) {
						stock = [dict objectForKey:@"股票名称"];
					} else {
						stock = [dict objectForKey:@"股票代码"];
					}
					close = [dict objectForKey:@"当日收盘价"];
					change = [dict objectForKey:@"日涨跌幅"];
					
					NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"CV_iPad_TopGL_Neg_%@",[langSetting localizedString:@"LangCode"]] ofType:@"png"];
					UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
					[ri setImage:img];
					[img release];
					ri.lblLeft.text = stock;
					ri.lblCenter.text = close;
					ri.lblRight.text = [NSString stringWithFormat:@"%@%%",change];
					ri.code = [dict objectForKey:@"股票代码"];
				}
				else
				{
					NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"CV_iPad_TopGL_Neg_%@",[langSetting localizedString:@"LangCode"]] ofType:@"png"];
					UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
					[ri setImage:img];
					[img release];
					ri.lblLeft.text = @"--";
					ri.lblCenter.text = @"--";
					ri.lblRight.text = @"--";
					ri.code = nil;
				}
			}
		}
	}
	[aivTopGainerLoser stopAnimating];
	[self updateOrientation];
	imgvRedArrow.hidden = NO;
	imgvGreenArrow.hidden = NO;
	
	imgvTopGainers.hidden = NO;
	imgvTopLosers.hidden = NO;
	
}

#pragma mark -
#pragma mark Refresh Button action
- (IBAction)clickFresh:(id)sender {
	if (!ifLoaded) {
		return;
	}
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		return;
	}
	[self preStepForLoadData];
	[[NSNotificationCenter defaultCenter] postNotificationName:kRefreshPieChartData object:nil userInfo:nil];
	[self performSelectorInBackground:@selector(getSectorListData:) withObject:[NSNumber numberWithBool:YES]];
}

#pragma mark -
#pragma mark Overriden
- (void)adjustSubviews:(UIInterfaceOrientation)orientation 
{
	self.portalInterfaceOrientation = orientation;
	[super adjustSubviews:orientation];
	[self updateOrientation];
}

- (void)reloadData {
	BOOL needReload = NO;
	if (_valuedData) {
		if ([dpGainerLoser isDataExpired:@"IndustrialGainerLoser"]) {
			needReload = YES;
		}
	} else {
		needReload = YES;
	}

	if (needReload) {
		if (!ifLoaded) {
			return;
		}
		CVSetting *setting = [CVSetting sharedInstance];
		if (![setting isReachable]) {
			return;
		}
		[self preStepForLoadData];
		[[NSNotificationCenter defaultCenter] postNotificationName:kRefreshPieChartData object:nil userInfo:nil];
		[self performSelectorInBackground:@selector(getSectorListData:) withObject:[NSNumber numberWithBool:YES]];
	}
}

- (void) updateOrientation
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation==UIInterfaceOrientationPortrait || orientation==UIInterfaceOrientationPortraitUpsideDown)
	{
		lblGainersInfo1.frame  = CGRectMake(kInfoPortraitX1, kInfoPortraitY, kInfoLandscapeWidth, kInfoLandscapeHeight);
		lblGainersInfo2.frame  = CGRectMake(kInfoPortraitX1, kInfoPortraitY+15, kInfoLandscapeWidth, kInfoLandscapeHeight);
		lblLosersInfo1.frame = CGRectMake(kInfoPortraitX2, kInfoPortraitY, kInfoLandscapeWidth, kInfoLandscapeHeight);
		lblLosersInfo2.frame = CGRectMake(kInfoPortraitX2, kInfoPortraitY+15, kInfoLandscapeWidth, kInfoLandscapeHeight);
		imgvBlueBackground.frame = CGRectMake(BlueBackPortraitX, BlueBackPortraitY, BlueBackPortraitWidth, BlueBackPortraitHeight);
		NSString *bluePaht = [[NSBundle mainBundle] pathForResource:@"BlueBackPortrait.png" ofType:nil];
		UIImage *imgBlue = [[UIImage alloc] initWithContentsOfFile:bluePaht];
		[imgvBlueBackground setImage:imgBlue];
		[imgBlue release];
		
		_btnPlayOrStop.frame = [self playButtonFrame];
		
		imgvGrayBackground.frame = CGRectMake(GrayBackPortraitX, GrayBackPortraitY, GrayBackPortraitWidth, GrayBackPortraitHeight);
		svPortraitRate.hidden = NO;
		svLandscapeRate.hidden = YES;
		imgvLeftLabel.hidden = YES;
		imgvRightLabel.hidden = YES;
//		if (bLabelShow)
//		{
//			imgvTopLabel.hidden = NO;
//			imgvBottomLabel.hidden = NO;
//			imgvTopGainers.hidden = NO;
//			imgvTopLosers.hidden = NO;
//		}
//		else
//		{
//			imgvTopLabel.hidden = YES;
//			imgvBottomLabel.hidden = YES;
//			imgvTopGainers.hidden = YES;
//			imgvTopLosers.hidden = YES;
//		}
		for (id sbview in imgvTopGainers.subviews)
		{
			if ([[sbview class] isSubclassOfClass:[RectImage class]])
			{
				RectImage *ri = (RectImage *)sbview;
				if (ri.tag>2)
					ri.hidden = YES;
			}
		}
		for (id sbview in imgvTopLosers.subviews)
		{
			if ([[sbview class] isSubclassOfClass:[RectImage class]])
			{
				RectImage *ri = (RectImage *)sbview;
				if (ri.tag>2)
					ri.hidden = YES;
			}
		}
		imgvTopGainers.frame = CGRectMake(0, 0, PortraitGainerWidth, PortraitGainerHeight);
		imgvTopLosers.frame = CGRectMake(0, 0, PortraitLoserWidth, PortraitLoserHeight);
		
		imgvTopGainers.center = CGPointMake(PortraitGainerCenterX, PortraitGainerCenterY);
		imgvTopLosers.center = CGPointMake(PortraitLoserCenterX, PortraitLoserCenterY);
		
		aivList.center = CGPointMake(CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_WIDTH/2.0, CVPORTLET_SECTOR_GAINERLOSER_PORTRAIT_HEIGHT/2.0);
		aivTopGainerLoser.center = CGPointMake(587.0, 253.0);
		
		imgvRedArrow.center = CGPointMake(PortraitRedArrowX, PortraitRedArrowY);
		imgvGreenArrow.center = CGPointMake(PortraitGreenArrowX, PortraitGreenArrowY);
	}
	else
	{
		lblGainersInfo1.frame  = CGRectMake(kInfoLandscapeX, kInfoLandscapeY1, kInfoLandscapeWidth, kInfoLandscapeHeight);
		lblGainersInfo2.frame  = CGRectMake(kInfoLandscapeX, kInfoLandscapeY1+15, kInfoLandscapeWidth, kInfoLandscapeHeight);
		lblLosersInfo1.frame = CGRectMake(kInfoLandscapeX, kInfoLandscapeY2-15, kInfoLandscapeWidth, kInfoLandscapeHeight);
		lblLosersInfo2.frame = CGRectMake(kInfoLandscapeX, kInfoLandscapeY2, kInfoLandscapeWidth, kInfoLandscapeHeight);
		
		imgvBlueBackground.frame = CGRectMake(BlueBackLandscapeX, BlueBackLandscapeY, BlueBackLandscapeWidth, BlueBackLandscapeHeight);
		NSString *bluePaht = [[NSBundle mainBundle] pathForResource:@"BlueBackLandscape.png" ofType:nil];
		UIImage *imgBlue = [[UIImage alloc] initWithContentsOfFile:bluePaht];
		[imgvBlueBackground setImage:imgBlue];
		[imgBlue release];
		
		_btnPlayOrStop.frame = [self playButtonFrame];
		
		imgvGrayBackground.frame = CGRectMake(GrayBackLandscapeX, GrayBackLandscapeY, GrayBackLandscapeWidth, GrayBackLandscapeHeight);
		svPortraitRate.hidden = YES;
		svLandscapeRate.hidden = NO;
//		imgvTopLabel.hidden = YES;
//		imgvBottomLabel.hidden = YES;
//		if (bLabelShow)
//		{
//			imgvLeftLabel.hidden = NO;
//			imgvRightLabel.hidden = NO;
//		}
//		else
//		{
//			imgvLeftLabel.hidden = YES;
//			imgvRightLabel.hidden = YES;
//		}
		for (id sbview in imgvTopGainers.subviews)
		{
			if ([[sbview class] isSubclassOfClass:[RectImage class]])
			{
				RectImage *ri = (RectImage *)sbview;
				if (ri.tag>2)
					ri.hidden = NO;
			}
		}
		for (id sbview in imgvTopLosers.subviews)
		{
			if ([[sbview class] isSubclassOfClass:[RectImage class]])
			{
				RectImage *ri = (RectImage *)sbview;
				if (ri.tag>2)
					ri.hidden = NO;
			}
		}
		imgvTopGainers.frame = CGRectMake(0, 0, LandscapeGainerWidth, LandscapeGainerHeight);
		imgvTopLosers.frame = CGRectMake(0, 0, LandscapeLoserWidth, LandscapeLoserHeight);
		
		imgvTopGainers.center = CGPointMake(LandscapeGainerCenterX, LandscapeGainerCenterY);
		imgvTopLosers.center = CGPointMake(LandscapeLoserCenterX, LandscapeLoserCenterY);
		
		imgvGreenArrow.center = CGPointMake(LandscapeGreenArrowX, LandscapeGreenArrowY);
		imgvRedArrow.center = CGPointMake(LandscapeRedArrowX, LandscapeRedArrowY);
		
		aivList.center = CGPointMake(CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_WIDTH/2.0, CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_HEIGHT/2.0);
		aivTopGainerLoser.center = CGPointMake(CVPORTLET_SECTOR_GAINERLOSER_LANDSCAPE_WIDTH/2.0, 515.0);
	}
	
}

- (CGRect) playButtonFrame{
	CGRect rect;
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		rect = CGRectMake(645, 5, CVPORTLET_BUTTON_WIDTH, CVPORTLET_BUTTON_HEIGHT);
	}else {
		rect = CGRectMake(415, 5, CVPORTLET_BUTTON_WIDTH, CVPORTLET_BUTTON_HEIGHT);
	}
	return rect;
}

#pragma mark -
#pragma mark Auto Scroll
- (void) btnPlayClick:(id)sender{
	if (!_canPlay) {
		_canPlay = YES;
		iTimeCount = 4;
		NSString *pathPlay = [[NSBundle mainBundle] pathForResource:@"stop.png" ofType:nil];
		UIImage *imgPlay = [[UIImage alloc] initWithContentsOfFile:pathPlay];
		[_btnPlayOrStop setImage:imgPlay forState:UIControlStateNormal];
		[imgPlay release];
	}else {
		_canPlay = NO;
		NSString *pathPlay = [[NSBundle mainBundle] pathForResource:@"play.png" ofType:nil];
		UIImage *imgPlay = [[UIImage alloc] initWithContentsOfFile:pathPlay];
		[_btnPlayOrStop setImage:imgPlay forState:UIControlStateNormal];
		[imgPlay release];
	}

}

- (void) autoScroll
{
	if (!_canPlay) {
		return;
	}
	NSInteger sectorCount = [[self.sectorList objectForKey:@"data"] count];
	
	iTimeCount++;
	if(iTimeCount < 5)
		return;
	if (!bLabelShow)
	{
		iTimeCount = 0;
		return;
	}
	iTimeCount = 0;
	float xOffset = svLandscapeRate.contentOffset.x;
	int index = (int)(xOffset/LandscapeWidth);
	
	NSArray *array = [self.sectorList objectForKey:@"data"];
	
	//next index
	int selected = (index-5) +1;
	if (selected > sectorCount-1) {
		selected -= sectorCount;
	}
	
	// -2 is offset to compare with pie chart index
	selected -= 2;
	if (selected < 0) {
		selected += sectorCount;
	}
	int contentOffsetIndex = selected + 5;
	if (contentOffsetIndex - index > 5) {
		[svPortraitRate setContentOffset:CGPointMake(svPortraitRate.contentOffset.x, svPortraitRate.contentOffset.y+sectorCount*PortraitHeight-1) animated:NO];
		[svLandscapeRate setContentOffset:CGPointMake(svLandscapeRate.contentOffset.x+sectorCount*LandscapeWidth-1, svLandscapeRate.contentOffset.y) animated:NO];
	}else if (contentOffsetIndex - index < -5) {
		[svPortraitRate setContentOffset:CGPointMake(svPortraitRate.contentOffset.x, svPortraitRate.contentOffset.y-sectorCount*PortraitHeight+1) animated:NO];
		[svLandscapeRate setContentOffset:CGPointMake(svLandscapeRate.contentOffset.x-sectorCount*LandscapeWidth+1, svLandscapeRate.contentOffset.y) animated:NO];
	}
	
	
	if (svLandscapeRate.hidden) {
		[svPortraitRate setContentOffset:CGPointMake(svPortraitRate.contentOffset.x, contentOffsetIndex*PortraitHeight) animated:YES];
		[svLandscapeRate setContentOffset:CGPointMake(contentOffsetIndex*LandscapeWidth, svLandscapeRate.contentOffset.y) animated:NO];
	}else {
		[svPortraitRate setContentOffset:CGPointMake(svPortraitRate.contentOffset.x, contentOffsetIndex*PortraitHeight) animated:NO];
		[svLandscapeRate setContentOffset:CGPointMake(contentOffsetIndex*LandscapeWidth, svLandscapeRate.contentOffset.y) animated:YES];
	}
	selected+=2;
	if (sectorCount<=selected){
		selected-=sectorCount;
	}
	
	if (lastSelected!=selected)
	{
		imgvRedArrow.hidden = YES;
		imgvGreenArrow.hidden = YES;
		lastSelected=selected;
		imgvTopGainers.hidden = YES;
		imgvTopLosers.hidden = YES;
		[aivTopGainerLoser startAnimating];
		[self performSelector:@selector(getTopGainerLoser:) withObject:[[array objectAtIndex:lastSelected] objectForKey:@"ICODE"] afterDelay:0.4];
		[self postNotificationToScrollPieChart:[[array objectAtIndex:lastSelected] objectForKey:@"ICODE"]];
	}
	
}

@end
