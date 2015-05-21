    //
//  SplashViewController.m
//  CapitalVueHD
//
//  Created by Dream on 10-11-2.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "SplashViewController.h"
#import "CVDataProvider.h"
#import "CVPortalViewController.h"
#import "CVSetting.h"
@interface SplashViewController()

- (void)commitAnimationPart:(NSNumber *)number;

@end

@implementation SplashViewController
@synthesize imgvBar = imgvBar;

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
    [super viewDidLoad];
	[NSThread detachNewThreadSelector:@selector(preloadData) toTarget:self withObject:nil];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	industryLoaded = NO;
	marketLoaded = NO;
	homeLoaded = NO;
	defaultAnimated = NO;
	homeAnimated = NO;
	marketAnimated = NO;
	industryAnimated = NO;
	dp = [CVDataProvider sharedInstance];
	self.view.backgroundColor = [UIColor blackColor];

	
	NSString *labelsPath = [[NSBundle mainBundle] pathForResource:@"SplashLabels.plist" ofType:nil];
	labels = [[NSDictionary alloc] initWithContentsOfFile:labelsPath];
	portraitFrame = CGRectMake(SplashPortraitX, SplashPortraitY, SplashPortraitWidth, SplashPortraitHeight);
	landscapeFrame = CGRectMake(SplashLandscapeX, SplashLandscapeY, SplashLandscapeWidth, SplashLandscapeHeight);
	self.view.frame = CGRectMake(0, 20, 768, 1004);
	imgvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1004)];
	NSString *pathPortrait = [[NSBundle mainBundle] pathForResource:@"Default-Portrait.png" ofType:nil];
	UIImage *imgPortrait = [[UIImage alloc] initWithContentsOfFile:pathPortrait];
	[imgvBackground setImage:imgPortrait];
	[imgPortrait release];
	[self.view addSubview:imgvBackground];
	
	//progress bar view
	imgvBarBack = [[UIImageView alloc] initWithFrame:portraitFrame];
	self.imgvBar = [[UIImageView alloc] initWithFrame:CGRectMake(3, 2, 0, 6.0)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProgressBarOn.png" ofType:nil];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
    UIImage *cropedImg = [img croppedImage:CGRectMake(0, 0, imgvBar.frame.size.width, 6.0)];
	[img release];
	
	NSString *pathBack = [[NSBundle mainBundle] pathForResource:@"ProgressBarBack.png" ofType:nil];
	UIImage *imgBack = [[UIImage alloc] initWithContentsOfFile:pathBack];
	[imgvBarBack setImage:imgBack];
	[imgBack release];
	[imgvBar setImage:cropedImg];
	
	[imgvBarBack addSubview:imgvBar];
	[self.view addSubview:imgvBarBack];
	
	lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(0, SplashPortraitY+10, 768, 20)];
	lblLoading.backgroundColor = [UIColor clearColor];
	lblLoading.textColor = [UIColor whiteColor];
	lblLoading.font = [UIFont boldSystemFontOfSize:12];
	lblLoading.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:lblLoading];
	
	[pool release];
	
	labelTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showLabel) userInfo:nil repeats:YES];

	[self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
    [super dealloc];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self updateOrientation:toInterfaceOrientation];
}

- (void) updateOrientation:(UIInterfaceOrientation)orientation
{	
	if (UIInterfaceOrientationPortrait==orientation
		|| UIInterfaceOrientationPortraitUpsideDown==orientation)
	{
		self.view.frame = CGRectMake(0, 20, 768, 1004);
		imgvBackground.frame = CGRectMake(0, 0, 768, 1004);
		lblLoading.frame = CGRectMake(0, SplashPortraitY+10, 768, 20);
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"Default-Portrait.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		[imgvBackground setImage:imgx];
		[imgx release];
		
		[imgvBar setFrame:CGRectMake(imgvBar.frame.origin.x, imgvBar.frame.origin.y, imgvBar.frame.size.width/(imgvBarBack.frame.size.width-6)*(SplashPortraitWidth-6), imgvBar.frame.size.height)];
		[imgvBarBack setFrame:portraitFrame];
	}
	else
	{
		self.view.frame = CGRectMake(0, 20, 1024, 748);
		imgvBackground.frame = CGRectMake(0, 0, 1024, 748);
		lblLoading.frame = CGRectMake(0, SplashLandscapeY+10, 1024, 20);
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"Default-Landscape.png" ofType:nil];
		UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		[imgvBackground setImage:imgx];
		[imgx release];
		[imgvBar setFrame:CGRectMake(imgvBar.frame.origin.x, imgvBar.frame.origin.y, imgvBar.frame.size.width/(imgvBarBack.frame.size.width-6)*(SplashLandscapeWidth-6), imgvBar.frame.size.height)];
		[imgvBarBack setFrame:landscapeFrame];

	}
}



#pragma mark -
#pragma mark Loading Progress and Animations
-(void)preloadData{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	//load industry pie chart
//	NSNumber *isRefresh = [NSNumber numberWithBool:YES];
//	[NSThread detachNewThreadSelector:@selector(getSectorData:) 
//							 toTarget:self 
//						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:isRefresh,@"update",[NSNumber numberWithUnsignedInteger:0],@"type",nil]];
//	[NSThread detachNewThreadSelector:@selector(getSectorData:) 
//							 toTarget:self 
//						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:isRefresh,@"update",[NSNumber numberWithUnsignedInteger:1],@"type",nil]];
//	[NSThread detachNewThreadSelector:@selector(getSectorData:) 
//							 toTarget:self 
//						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:isRefresh,@"update",[NSNumber numberWithUnsignedInteger:2],@"type",nil]];
//	[NSThread detachNewThreadSelector:@selector(getSectorData:) 
//							 toTarget:self 
//						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:isRefresh,@"update",[NSNumber numberWithUnsignedInteger:3],@"type",nil]];
//	
//	
	
	dp = [CVDataProvider sharedInstance];
	NSDictionary *dd = [dp  GetSectorAll];
//	NSLog(@"Sector All:%@",dd);
	[pool release];
}


- (void) loadData
{
	[self performSelector:@selector(commitAnimationPart:) withObject:[NSNumber numberWithUnsignedInt:2] afterDelay:0.001];
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	CVParamInfo *paramInfo;
//	CVSetting *s = [CVSetting sharedInstance];
//	
//	BOOL isReachable = [s isReachable];
//	
//	[NSThread detachNewThreadSelector:@selector(commitAnimationPart:) toTarget:self withObject:[NSNumber numberWithUnsignedInt:0]];
//	
//	//step 1.load home data
//	homeLoaded = NO;
//	currentLoading = LoadingHome;
//	
//	homeLoaded = YES;
//	if (defaultAnimated)
//		[self performSelector:@selector(commitAnimationPart:) withObject:[NSNumber numberWithUnsignedInt:1] afterDelay:0.001];
//	else
//		[self performSelector:@selector(commitAnimationPart:) withObject:[NSNumber numberWithUnsignedInt:1] afterDelay:1.0];
//	
//	
//	
//	
//	//step 2.load market data
//	marketLoaded = NO;
//	currentLoading = LoadingMarket;
//	if (isReachable)
//	{
//		paramInfo = [[CVParamInfo alloc] init];
//		paramInfo.minutes = 15;
//		paramInfo.parameters = @"000001";
//		dict = [dp GetStockList:CVDataProviderStockListTypeMostActive withParams:paramInfo];
//		dict = [dp GetStockList:CVDataProviderStockListTypeTopMarketCapital withParams:nil];
//		[paramInfo release];
//	}
//	marketLoaded = YES;
//	if (homeAnimated)
//		[self performSelector:@selector(commitAnimationPart:) withObject:[NSNumber numberWithUnsignedInt:2] afterDelay:0.001];
//	else
//		[self performSelector:@selector(commitAnimationPart:) withObject:[NSNumber numberWithUnsignedInt:2] afterDelay:2.0];
//	
//	
//	
//	
//	
//	//setp 3.load industry data
//	industryLoaded = NO;
//	currentLoading = LoadingIndustry;
//	
//	if (marketAnimated)
//		[self performSelector:@selector(commitAnimationPart:) withObject:[NSNumber numberWithUnsignedInt:3] afterDelay:0.001];
//	else
//		[self performSelector:@selector(commitAnimationPart:) withObject:[NSNumber numberWithUnsignedInt:3] afterDelay:3.0];
//	
//	industryLoaded = YES;
//	
//	[pool release];
}

- (void)progress:(NSUInteger)step {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CGRect before, after;
	
	before = CGRectMake(imgvBar.frame.origin.x,
						imgvBar.frame.origin.y, 
						0.25* 3 * (imgvBarBack.frame.size.width-6),
						imgvBar.frame.size.height);
	after = CGRectMake(before.origin.x,
					   before.origin.y,
					   before.size.width + step * 3,
					   before.size.height);
	
	NSString *strID = [NSString stringWithFormat:@"industrystep%d",step];
	imgvBar.frame = before;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProgressBarOn.png" ofType:nil];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
    
    
	[UIView beginAnimations:strID context:nil];
	[UIView setAnimationDuration:0.5];
	imgvBar.frame = after;
    UIImage *cropedImg = [img croppedImage:CGRectMake(0,0,imgvBar.bounds.size.width,9)];
	imgvBar.image = cropedImg;
    [img release];
	[UIView commitAnimations];
	[pool release];
	
}

- (void) commitAnimationPart:(NSNumber *)number
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSUInteger index = [number unsignedIntValue];
	
	CGRect before = CGRectMake(imgvBar.frame.origin.x, imgvBar.frame.origin.y, 0.0f * (imgvBarBack.frame.size.width-6), imgvBar.frame.size.height);
	CGRect after = CGRectMake(imgvBar.frame.origin.x, imgvBar.frame.origin.y, 1.0f * (imgvBarBack.frame.size.width-6), imgvBar.frame.size.height);
	NSString *strID = [NSString stringWithFormat:@"%d",index];
	imgvBar.frame = before;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProgressBarOn.png" ofType:nil];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
    
    
	[UIView beginAnimations:strID context:nil];
	[UIView setAnimationDuration:2.0];
	imgvBar.frame = after;
    UIImage *cropedImg = [img croppedImage:CGRectMake(0,0,imgvBar.bounds.size.width,9)];
    [imgvBar setImage:cropedImg];
    [img release];
	[UIView commitAnimations];
	[self performSelector:@selector(updateAnimationStatus:) withObject:[NSNumber numberWithUnsignedInt:index] afterDelay:2.0];
	[pool release];
}

- (void) updateAnimationStatus:(NSNumber *)number
{
//	NSUInteger index = [number unsignedIntValue];
//	if (0==index) {
//		defaultAnimated = YES;
//	} else if (1==index) {
//		homeAnimated = YES;
//	} else if (2==index) {
//		marketAnimated = YES;
//	} else if (3==index) {
	[labelTimer invalidate];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"LoadMainView" object: nil];
//	}
}

- (void) showLabel
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	int random = arc4random()%12;
	
	lblLoading.text = [NSString stringWithFormat:[langSetting localizedString:@"Loading %@"],[[labels objectForKey:@"Labels"] objectAtIndex:random]];
	[pool release];
}


-(void)getSectorData:(NSDictionary *)param{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray *SectorIds = [[NSArray alloc] initWithObjects:@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",nil];
	

	NSUInteger dataType = [[param objectForKey:@"type"] unsignedIntegerValue];
	
	CVSetting *s;

	CVParamInfo *paramInfo;

	
	NSDictionary *tempDict;
	s = [CVSetting sharedInstance];
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = [s cvCachedDataLifecycle:CVSettingIndustrialMarketStatistics];
	
	
	
	
	for (int i=0;i<10;i++){
		
		paramInfo.parameters = [SectorIds objectAtIndex:i];
		
		switch (dataType) {
			case 0:
				tempDict = [dp GetSectorTurnoverAtId:paramInfo];
				break;
			case 1:
				tempDict = [dp GetSectorVolumeAtId:paramInfo];
				break;
			case 2:
				tempDict = [dp GetSectorTotalCapitalAtId:paramInfo];
				break;
			case 3:
				tempDict = [dp GetSectorTradableCapitalAtId:paramInfo];
				break;
			default:
				break;
		}
		
		
	}
	
	[paramInfo release];
	[SectorIds release];
	[pool release];
}

@end
