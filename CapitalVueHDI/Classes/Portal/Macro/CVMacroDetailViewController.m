    //
//  CVMacroDetailViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/25/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMacroDetailViewController.h"
#import "CVDataProvider.h"
#import "CVMacroFormRowView.h"
#import "CVPortal.h"
#import "NoConnectionAlert.h"
#import "CVSetting.h"
#import "cvChart.h"

@interface CVMacroDetailViewController()

@property (nonatomic, retain) UIButton *_addButton;
@property (nonatomic, retain) UILabel *_titleLabel;
@property (nonatomic, retain) UIImageView *_backgroundImageView;
@property (nonatomic, retain) UIImage *_bgImagePortrait;
@property (nonatomic, retain) UIImage *_bgImageLandscape;

@property (nonatomic, retain) UIActivityIndicatorView *_activityIndicator;

@property (nonatomic, retain) NSArray *_headArray;
@property (nonatomic, retain) NSArray *_dataArray;

@property (nonatomic, retain) cvChartView *_macroChartView;
@property (nonatomic, retain) CVMacroFormHeaderView *_macroFormHeaderView;
@property (nonatomic, retain) UITableView *_macroTableView;

@property (nonatomic, retain) NSLock *_threadMutex;

/*
 * It loads the data of current macro index.
 *
 * @param:	obj - NSDictionary-typed object consists of leftAxis and rightAxis
 * @return:	none
 */
- (void)loadData:(NSDictionary *)obj;

/*
 * It returns the origin point and size of background image view
 *
 * @param:	orientation - the device orientation
 * @return: the frame of macro chart view
 */
- (CGRect)backgroundImageViewFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the origin point and size of macro chart view
 *
 * @param:	orientation - the device orientation
 * @return: the frame of macro chart view
 */
- (CGRect)macroChartViewFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the origin point and size of header view of macro form
 *
 * @param:	orientation - the device orientation
 * @return:	the frame of macro form view
 */
- (CGRect)macroFormHeaderViewFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the origin point and size of macro form view
 *
 * @param:	orientation - the device orientation
 * @return:	the frame of macro form view
 */
- (CGRect)macroFormViewFrame:(UIInterfaceOrientation)orientation;

@end

@implementation CVMacroDetailViewController

@synthesize _addButton;
@synthesize _titleLabel;
@synthesize _backgroundImageView;
@synthesize _bgImagePortrait;
@synthesize _bgImageLandscape;
@synthesize _activityIndicator;
@synthesize _headArray;
@synthesize _dataArray;
@synthesize _macroChartView;
@synthesize _macroFormHeaderView;
@synthesize _macroTableView;
@synthesize _threadMutex;
@synthesize valuedData = _valuedData;

#define CVMACRO_DETAIL_LABEL_PORTRAIT_X  70
#define CVMACRO_DETAIL_LABEL_LANDSCAPE_X 13
#define CVMACRO_DETAIL_LABEL_WIDTH       450

UIInterfaceOrientation currentInterfaceOrientation;

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
	self.style = CVPortletViewStyleBarVisible | CVPortletViewStyleContentTransparent;
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setButtonImage)
												 name:@"setButtonImage"
											   object:nil];
	CGRect rect;

	UIImage *image;
	// make that it is portrait mode
	UIImageView *imageView;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"portlet_macro_detail_landscape_background.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:path];
	self._bgImageLandscape = image;
	[image release];
	path = [[NSBundle mainBundle] pathForResource:@"portlet_macro_detail_portrait_background.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:path];
	self._bgImagePortrait = image;
	[image release];
	rect = [self backgroundImageViewFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	imageView = [[UIImageView alloc] initWithFrame:rect];
	self._backgroundImageView = imageView;
	[imageView release];
	_backgroundImageView.image = _bgImagePortrait;
	[self.view addSubview:_backgroundImageView];
	
	UIButton *button;
	button = [[UIButton alloc] initWithFrame:CGRectMake(27, 9, 24, 24)];
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"detail_show_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	button.tag = tagButtonShow;
	[button setImage:image forState:UIControlStateNormal];
	[image release];
	self._addButton = button;
	[button release];
	[self.view addSubview: button];
	
	UILabel *lable;
	lable = [[UILabel alloc] initWithFrame:CGRectMake(CVMACRO_DETAIL_LABEL_PORTRAIT_X, 0, CVMACRO_DETAIL_LABEL_WIDTH, CVPORTLET_BAR_HEIGHT)];
	lable.backgroundColor = [UIColor clearColor];
	lable.textColor = [UIColor whiteColor];
	self._titleLabel = lable;
	[lable release];
	[self.view addSubview:_titleLabel];
	
	currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	// if it is landscape mode
	if (UIInterfaceOrientationLandscapeLeft == [[UIApplication sharedApplication] statusBarOrientation] ||
		UIInterfaceOrientationLandscapeRight == [[UIApplication sharedApplication] statusBarOrientation]) {
		_backgroundImageView.image = _bgImageLandscape;
		_addButton.hidden = YES;
		_titleLabel.frame = CGRectMake(CVMACRO_DETAIL_LABEL_LANDSCAPE_X, 0, CVMACRO_DETAIL_LABEL_WIDTH, CVPORTLET_BAR_HEIGHT);
	}
	
	// create activity indcator
	UIActivityIndicatorView *aIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	aIndicator.hidden = YES;
	self._activityIndicator = aIndicator;
	[aIndicator release];
	[self.view addSubview:aIndicator];
	
	_threadMutex = [[NSLock alloc] init];
	
	// create chart view
	cvChartView *aChart;
	NSString *cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"MacroChart_%@",[langSetting localizedString:@"LangCode"]] ofType:@"plist"];
	rect = [self macroChartViewFrame:[[UIApplication sharedApplication] statusBarOrientation]];
    aChart = [[cvChartView alloc] initWithFrame:rect FormatFile:cfgFilePath];
	aChart.frame = [self macroChartViewFrame:[[UIApplication sharedApplication] statusBarOrientation]];
    aChart.dataProvider = self;
	self._macroChartView = aChart;
	[aChart release];
	[self.view addSubview:_macroChartView];
	
	// create table for macro form view
	CVMacroFormHeaderView *headerView;
	rect = [self macroFormHeaderViewFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	headerView =  [[CVMacroFormHeaderView alloc] initWithFrame:rect];
	self._macroFormHeaderView = headerView;
	[self.view addSubview:_macroFormHeaderView];
	[headerView release];
	
	rect = [self macroFormViewFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	UITableView *aTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
	aTable.separatorColor = [UIColor colorWithRed:54.0f/255.0f green:79.0f/255.0f blue:96.0f/255.0f alpha:1.0];
	aTable.delegate = self;
	aTable.dataSource = self;
	aTable.backgroundColor = [UIColor clearColor];
	self._macroTableView = aTable;
	[aTable release];
	[self.view addSubview:_macroTableView];
	
	_relatedNewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
	[_relatedNewsButton setBackgroundImage:imgx forState:UIControlStateNormal];
	[imgx release];
	[_relatedNewsButton sizeToFit];
	
	UILabel *labelNews = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 100, 20)];
	labelNews.backgroundColor = [UIColor clearColor];
	labelNews.font = [UIFont boldSystemFontOfSize:13];
	labelNews.textAlignment = UITextAlignmentCenter;
	labelNews.center = CGPointMake(_relatedNewsButton.bounds.size.width/2.0, _relatedNewsButton.bounds.size.height/2.0+7);
	labelNews.textColor = [UIColor whiteColor];
	labelNews.text = [langSetting localizedString:@"Related News"];
	labelNews.userInteractionEnabled = NO;
	[_relatedNewsButton addSubview:labelNews];
	[labelNews release];
	_relatedNewsButton.tag = 2;
	[_relatedNewsButton setCenter:CGPointMake(_backgroundImageView.frame.size.width/2.0-35+100, _backgroundImageView.frame.size.height-28)];
	[_relatedNewsButton addTarget:self action:@selector(clickRelatedNewsButton) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_relatedNewsButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dismissRotationView)
												 name:CVPortalDismissRotationViewNotification object:nil];
}

- (void)dismissRotationView{
	if (_newsrelatedView) 
	{
		[_newsrelatedView removeFromSuperview];
		[_newsrelatedView release];
		_newsrelatedView = nil;
	}
}

- (void)clickRelatedNewsButton{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]){
		[NoConnectionAlert alert];
		return;
	}
//	[self dismissRotationView];
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_highlight_button.png" ofType:nil];
	UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
	[_relatedNewsButton setBackgroundImage:imgx forState:UIControlStateNormal];
	[imgx release];
	if (!_newsrelatedView) {
		_newsrelatedView = [[CVNewsrelatedView alloc] initWithFrame:CGRectMake(
																			   _backgroundImageView.frame.origin.x + _backgroundImageView.frame.size.width/2 - 285,
																			   _backgroundImageView.frame.size.height - 461 + 20, 571, 461)];
		[_newsrelatedView setDelegate:self];
		[self.view addSubview:_newsrelatedView];
	}
	else
	{
		[_newsrelatedView removeFromSuperview];
		[_newsrelatedView release];
		_newsrelatedView = nil;
		pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
		imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
		[_relatedNewsButton setBackgroundImage:imgx forState:UIControlStateNormal];
		[imgx release];
		return;
		
	}
	_newsrelatedView.rotationInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
	_newsrelatedView.labelTitle.text = [langSetting localizedString:@"News"];
	_newsrelatedView.newsClass = CVClassMacro;
	[_newsrelatedView startRotationView];
	
	[_newsrelatedView setHidden:NO];
}

#pragma mark -
#pragma mark CVLoadNewsDelegate method

-(NSMutableArray *)attachNewsAtPage:(NSInteger)pageNumber{
	NSMutableArray *ary = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
	CVDataProvider *dp;
	NSDictionary *dict;
	dp = [CVDataProvider sharedInstance];
	NSString *strPage = [NSString stringWithFormat:@"%d",pageNumber];
	NSString *pageCapacity = [NSString stringWithFormat:@"%d",CV_NEWS_PAGECAPACITY];
	NSArray *array = [[NSArray alloc] initWithObjects:strPage,pageCapacity,nil];
	dict = [dp GetNewsList:CVDataProviderNewsListTypeMacroNews withParams:array forceRefresh:NO];
	[array release];
	if (!dict){
		return ary;
	}
	NSMutableArray *arrayData = [dict valueForKey:@"data"];
	if (arrayData)
		ary = arrayData;

	[_newsrelatedView performSelectorOnMainThread:@selector(changeIndicator:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
	
	return ary;
}

#pragma mark -

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
	[_addButton release];
	[_titleLabel release];
	[_backgroundImageView release];
	[_bgImagePortrait release];
	[_bgImageLandscape release];
	
	[_activityIndicator release];
	
	[_headArray release];
	[_dataArray release];
	
	[_threadMutex  release];
	
	[_macroChartView release];
	[_macroFormHeaderView release];
	[_macroTableView release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark private method
/*
 * It loads the data of current macro index.
 *
 * @param:	obj - NSDictionary-typed object consists of leftAxis and rightAxis
 * @return:	none
 */
- (void)loadData:(NSDictionary *)obj {
	[_threadMutex lock];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *leftAxis, *rightAxis;
	CVDataProvider *dp;
	NSDictionary *dict;
	
	leftAxis = [obj objectForKey:@"leftAxis"];
	rightAxis = [obj objectForKey:@"rightAxis"];
		
	dp = [CVDataProvider sharedInstance];
	dict = [dp GetMacroIndexData:leftAxis andArg:rightAxis];
	
	// form header
	self._headArray = [dict objectForKey:@"head"];
	// form rows
	self._dataArray = [dict objectForKey:@"data"];
	[pool release];
	
	if (_dataArray && [_dataArray count] > 0) {
		_valuedData = YES;
	}else {
		_valuedData = NO;
	}

	
	[_threadMutex unlock];
	[self performSelectorOnMainThread:@selector(afterLoadData:) withObject:obj waitUntilDone:NO];
}

- (void) afterLoadData:(NSDictionary *)obj{
	[_threadMutex lock];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray *titles = [obj objectForKey:@"titles"];
	if (titles) {
		[self._macroChartView setTitles:titles];
		
		_macroFormHeaderView.header1.text = [titles objectAtIndex:0];
		_macroFormHeaderView.header2.text = [titles objectAtIndex:1];
		_macroFormHeaderView.header3.text = [titles objectAtIndex:2];
	}
	
	if ([_dataArray count] > 0) {
		NSDictionary *item = [_dataArray objectAtIndex:0];
		if ([item objectForKey:@"ZBZ_2"] != nil) {
			_macroFormHeaderView.columnNumber = 3;
		} else {
			_macroFormHeaderView.columnNumber = 2;
		}
	}
	
	
	[_macroTableView reloadData];
	
	if (nil != _dataArray && 0 != [_dataArray count]) {
		[_macroChartView drawChart:[obj objectForKey:@"title"] timeFrame:StockDataTwoYears];
		[_macroChartView resize:[self macroChartViewFrame:currentInterfaceOrientation]];
	}
	
	_macroChartView.hidden = NO;
	_macroFormHeaderView.hidden = NO;
	_macroTableView.hidden = NO;
	
	[_activityIndicator stopAnimating];
	_activityIndicator.hidden = YES;
	[pool release];
	[_threadMutex unlock];
}

/*
 * It returns the origin point and size of background image view
 *
 * @param:	orientation - the device orientation
 * @return: the frame of macro chart view
 */
- (CGRect)backgroundImageViewFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(0, CVPORTLET_BAR_HEIGHT,
						  CVMACRO_NAVIGATOR_DETAIL_PORTRAIT_WIDTH, 
						  CVMACRO_NAVIGATOR_DETAIL_PORTRAIT_HEIGHT - CVPORTLET_BAR_HEIGHT);
	} else {
		rect = CGRectMake(0, CVPORTLET_BAR_HEIGHT, 
						  CVMACRO_NAVIGATOR_DETAIL_LANDSCAPE_WIDTH - CVMACRO_NAVIGATOR_LANDSCAPE_WIDTH, 
						  CVMACRO_NAVIGATOR_DETAIL_LANDSCAPE_HEIGHT - CVPORTLET_BAR_HEIGHT);
	}
	
	return rect;
}

/*
 * It returns the origin point and size of macro chart view
 *
 * @param:	orientation - the device orientation
 * @return: the frame of macro chart view
 */
- (CGRect)macroChartViewFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(20, 63, 692, 270);
	} else {
		rect = CGRectMake(20, 63, 646, 253);
	}
	
	return rect;
}

/*
 * It returns the origin point and size of header view of macro form
 *
 * @param:	orientation - the device orientation
 * @return:	the frame of macro form view
 */
- (CGRect)macroFormHeaderViewFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(20, 360, 647, 30);
	} else {
		rect = CGRectMake(20, 340, 647, 30);
	}
	
	return rect;
}

/*
 * It returns the origin point and size of macro form view
 *
 * @param:	orientation - the device orientation
 * @return:	the frame of macro form view
 */
- (CGRect)macroFormViewFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(20, 390, 647, 406);
	} else {
		rect = CGRectMake(20, 370, 647, 276);
	}
	
	return rect;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self dismissRotationView];
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
	[_relatedNewsButton setBackgroundImage:imgx forState:UIControlStateNormal];
	[imgx release];
}

#pragma mark -
#pragma mark CVNavigatorDetailControllerDelegate
- (BOOL)navigatorDetailController:(CVNavigatorDetailController *)ndc allowPopOverByButton:(id)button {
	UIButton *btn = button;
	if (btn.tag == 2) {
		return NO;
	}
	return YES;
}

- (void)navigatorDetailController:(CVNavigatorDetailController*)ndc 
				popoverController:(UIPopoverController*)pc 
		willPresentViewController:(UIViewController *)aViewController {
}

- (void)navigatorDetailController:(CVNavigatorDetailController*)ndc 
		   willHideViewController:(UIViewController *)aViewController
			 forPopoverController:(UIPopoverController*)pc {
	self.portalInterfaceOrientation = UIInterfaceOrientationPortrait;
	_addButton.hidden = NO;
	_titleLabel.frame = CGRectMake(CVMACRO_DETAIL_LABEL_PORTRAIT_X, 0, CVMACRO_DETAIL_LABEL_WIDTH, CVPORTLET_BAR_HEIGHT);
	_backgroundImageView.frame = [self backgroundImageViewFrame:UIInterfaceOrientationPortrait];
	[self dismissRotationView];
	//[_relatedNewsButton setCenter:CGPointMake(_backgroundImageView.frame.size.width/2-35, _backgroundImageView.frame.size.height-28)];
	[_relatedNewsButton setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-28)];
	_macroFormHeaderView.frame = [self macroFormHeaderViewFrame:UIInterfaceOrientationPortrait];
	_macroTableView.frame = [self macroFormViewFrame:UIInterfaceOrientationPortrait];
	[_macroChartView resize:[self macroChartViewFrame:UIInterfaceOrientationPortrait]];
	currentInterfaceOrientation = UIInterfaceOrientationPortrait;
}

- (void)navigatorDetailController:(CVNavigatorDetailController*)ndc 
		   willShowViewController:(UIViewController *)aViewController 
			 forPopoverController:(UIPopoverController*)pc {
	self.portalInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;
	_addButton.hidden = YES;
	_titleLabel.frame = CGRectMake(CVMACRO_DETAIL_LABEL_LANDSCAPE_X, 0, CVMACRO_DETAIL_LABEL_WIDTH, CVPORTLET_BAR_HEIGHT);
	_backgroundImageView.frame = [self backgroundImageViewFrame:UIInterfaceOrientationLandscapeLeft];
	[self dismissRotationView];
	[_relatedNewsButton setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-28)];
	_macroFormHeaderView.frame = [self macroFormHeaderViewFrame:UIInterfaceOrientationLandscapeLeft];
	_macroTableView.frame = [self macroFormViewFrame:UIInterfaceOrientationLandscapeLeft];
	[_macroChartView resize:[self macroChartViewFrame:UIInterfaceOrientationLandscapeLeft]];
	currentInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;

}

#pragma mark -
#pragma mark CVMacroNavigatorViewControllerDelegate
/*
 * It tells the delegate that the item of a group is selected. An item represents an index of macro
 * If you want to do anything connecting to the item, you have to implement this method.
 *
 * @param:	group - the name of group
 *			item - a 3-key dictionary. "title", the name of the macro index; "leftAxis" and "rightAxis,
 *                 first parameter and second parameter for loading the macro data.
 * @return: none
 */
- (void)didReceiveNavigatorRequest:(NSString *)group forItem:(NSDictionary *)item indexPath:(NSIndexPath *)indexPath{
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	cvChart *chart = [_macroChartView.charts objectAtIndex:0];
	
	if ((section==1 && (row==1 || row==2)) || (section==2 && row==1))
		chart.isPercent = NO;
	else
		chart.isPercent = YES;
	
	_titleLabel.text = [item objectForKey:@"title"];
	
	_activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 10, self.view.frame.size.height / 2 - 10, 
										  _activityIndicator.frame.size.width,
										  _activityIndicator.frame.size.height);
	
	[self.view bringSubviewToFront:_activityIndicator];
	[_activityIndicator startAnimating];
	_activityIndicator.hidden = NO;
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	_macroTableView.hidden = YES;
	_macroChartView.hidden = YES;
	_macroFormHeaderView.hidden = YES;
	[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:item];
}


#pragma mark -
#pragma mark StockChartDataSourceDelegate
- (NSArray *)ChartGetRecordsByName:(NSString *)name Period:(StockDataTimeFrame_e)timeFrame {
	NSMutableArray *destArray;
	NSMutableDictionary *originDict, *destDict;
	
	destArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
	
	NSInteger i, size;

	size = [_dataArray count];
	i = size - 1; 
	for (i = size - 1; i >= 0; i--) {
		originDict = [_dataArray objectAtIndex:i];
		NSDate *currDate;
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM"];
		currDate = [dateFormatter dateFromString:[originDict objectForKey:@"DATE"]];
		NSObject *growth = [originDict objectForKey:@"ZBZ_2"];
		NSObject *value = [originDict objectForKey:@"ZBZ"];
		
		destDict = [[NSMutableDictionary alloc] init];
		if (currDate) {
			[destDict setObject:currDate forKey:@"date"];
		}
		if (growth) {
			[destDict setObject:growth forKey:@"growth"];
		}
		if (value) {
			[destDict setObject:value forKey:@"value"];
		}
		[destArray addObject:destDict];
		[destDict release];
		[dateFormatter release];
	}
	return [self invertOrderArray:destArray];
}

-(NSMutableArray *)invertOrderArray:(NSMutableArray *)originalArray{
	NSMutableArray *newArray = [[[NSMutableArray alloc] init] autorelease];
	int count = [originalArray count];
	for (int i = count-1 ; i >= 0 ; i--) {
		NSObject *obj = [originalArray objectAtIndex:i];
		[newArray addObject:obj];
	}
	return newArray;
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MacroRowCell";
    
    CVMacroFormRowView *cell = (CVMacroFormRowView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CVMacroFormRowView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSDictionary *item = [_dataArray objectAtIndex:indexPath.row];
	cell.dateLabel.textAlignment = UITextAlignmentCenter;
	cell.dateLabel.text = [item objectForKey:@"DATE"];
	NSString *zbz = [item objectForKey:@"ZBZ"];
	NSString *zbz2 = [item objectForKey:@"ZBZ_2"];
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	if ([[local localizedString:@"LangCode"] isEqualToString:@"en"]) {
		zbz = [zbz formatToEnNumber];
		zbz2 = [zbz2 formatToEnNumber];
	}
	cell.valueLabel.text = zbz;
	cell.growthLabel.text = zbz2;
	if ([item objectForKey:@"ZBZ_2"] != nil) {
		cell.columnNumber = 3;
	} else {
		cell.columnNumber = 2;
	}

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 27;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self dismissRotationView];
	
}


#pragma mark -
#pragma mark Dream's table scroll modify
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	float cellHeight = 27.0;
	CGPoint offset = scrollView.contentOffset;
	int n =(int) (offset.y/cellHeight);
	if (offset.y-n*cellHeight>=0.5)
		n++;
	offset.y = n*cellHeight;
	[scrollView setContentOffset:offset animated:YES];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	float cellHeight = 27.0;
	CGPoint offset = scrollView.contentOffset;
	int n =(int) (offset.y/cellHeight);
	if (offset.y-n*cellHeight>=0.5)
		n++;
	offset.y = n*cellHeight;
	[scrollView setContentOffset:offset animated:YES];
}


- (void) setButtonImage
{
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
	[_relatedNewsButton setBackgroundImage:imgx forState:UIControlStateNormal];
	[imgx release];
}
@end
