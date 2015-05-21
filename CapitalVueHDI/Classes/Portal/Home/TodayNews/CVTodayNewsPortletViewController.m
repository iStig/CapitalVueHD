//
//  CVTodayNewsPortletViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/5/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVTodayNewsPortletViewController.h"

#import "CVDataProvider.h"

#import "CVTodayNewsSnapshotView.h"
#import "CVTodayNewsTitleLinkView.h"

#import "CVPortal.h"
#import "CVSetting.h"
#import "CVMenuItem.h"

@interface CVTodayNewsPortletViewController()

@property (nonatomic, retain) CVScrollPageViewController *pageViewController;
@property (nonatomic, retain) NSMutableArray *arrayTodayNews;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSString *lastToken;

/*
 * it loads the data of today's news
 * @param: none
 * @return: none
 */
- (void)loadData:(NSNumber *)nForceRefresh;

/*
 * It returns the frame size of scroll page in accordance with the device orientation
 *
 * @param:	device orientation
 * @return:	rectangle size
 */
- (CGRect)scrollPageFrame:(UIInterfaceOrientation)orientation;

/*
 * It returns the frame size of scroll page indicator in accordance with the device orientation.
 * Its coordinates relatively to scroll page view
 *
 * @param:	device orientation
 * @return:	rectangle size
 */
- (CGRect)scrollPageIndicatorFrame:(UIInterfaceOrientation)orientation;

/*
 *	beforeload data for UI things
 *
 */
-(void)beforeLoadData:(BOOL)needRefresh;

/*
 *	after load data for UI things
 *
 */
-(void)afterLoadData;

@end

@implementation CVTodayNewsPortletViewController

@synthesize pageViewController;
@synthesize arrayTodayNews;

@synthesize activityIndicator;
@synthesize lastToken = _lastToken;

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

#define CVPORTLET_TODAYS_NEWS_PORTRAIT_ELEMENT 3
#define CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT 4

#define SCROLL_PAGE_PORTRAIT_X      CVPORTLET_TODAYS_NEWS_SNAP_BORDER
#define SCROLL_PAGE_PORTRAIT_Y      (CVPORTLET_BAR_HEIGHT + CVPORTLET_TODAYS_NEWS_SNAP_BORDER + 5)
#define SCROLL_PAGE_PORTRAIT_WIDTH  (CVPORTLET_TODAYS_NEWS_SNAP_WIDTH + CVPORTLET_TODAYS_NEWS_SNAP_BORDER * 2) * CVPORTLET_TODAYS_NEWS_PORTRAIT_ELEMENT
#define SCROLL_PAGE_PORTRAIT_HEIGHT CVPORTLET_TODAYS_NEWS_SNAP_HEIGHT

#define SCROLL_PAGE_LANDSCAPE_X      CVPORTLET_TODAYS_NEWS_TITLE_LINK_BORDER
#define SCROLL_PAGE_LANDSCAPE_Y      (CVPORTLET_BAR_HEIGHT + CVPORTLET_TODAYS_NEWS_TITLE_LINK_BORDER + 5)
#define SCROLL_PAGE_LANDSCAPE_WIDTH  CVPORTLET_TODAYS_NEWS_TITLE_LINK_WIDTH
#define SCROLL_PAGE_LANDSCAPE_HEIGHT (CVPORTLET_TODAYS_NEWS_SNAP_HEIGHT + CVPORTLET_TODAYS_NEWS_TITLE_LINK_HEIGHT + 30)

#define CVNEWS_PAGENUMBER    8
#define CVNEWS_MAX_PAGE      10
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_ifLoaded = YES;
	//hide setting icon
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self.style = CVPortletViewStyleRefresh| CVPortletViewStyleFullscreen| CVPortletViewStyleBarVisible;	//CVPortletViewStyleSetting| 
	
	_lastToken = @"0";
	
	// fill the menu of setting
	CVSetting *setting;
	NSArray *settingArray;
	NSMutableArray *array;
	NSDictionary *element;
	CVMenuItem *item;
	setting = [CVSetting sharedInstance];
	settingArray = [setting settingTodayNewsCategory];
	array = [[NSMutableArray alloc] initWithCapacity:1];
	for (element in settingArray) {
		NSNumber *number;
		item = [[CVMenuItem alloc] init];
		item.title = [element objectForKey:@"title"];
		item.name = [element objectForKey:@"categoryname"];
		number = [element valueForKey:@"select"];
		item.select = [number boolValue];
		[array addObject:item];
		[item release];
	}
	self.menuItems = array;
	[array release];
	
	[super viewDidLoad];
	
	self.portletTitle = [langSetting localizedString:@"Headline News"];
	
	CVScrollPageViewController *controller;
    
	controller = [[CVScrollPageViewController alloc] init];
	controller.indicatorStyle = CVScrollPageIndicatorStyleHigh;
	controller.frame = [self scrollPageFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	controller.pageControlFrame = [self scrollPageIndicatorFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	[controller setDelegate:self];
	self.pageViewController = controller;
	[controller release];
	
	[self.view addSubview:pageViewController.view];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 5,
										 self.view.frame.size.height / 2 - 5,
										 activityIndicator.frame.size.width,
										 activityIndicator.frame.size.height);
	[self.view addSubview:activityIndicator];
	activityIndicator.hidden = YES;
	
	lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
	lbl.numberOfLines = 2;
	lbl.font = [UIFont systemFontOfSize:13];
	lbl.center = activityIndicator.center;
	lbl.textColor = [UIColor darkGrayColor];
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textAlignment = UITextAlignmentCenter;
	lbl.text = [langSetting localizedString:@"NetworkFailedMessage"];
	[self.view addSubview:lbl];
	lbl.hidden = YES;
    
    CVSetting *s;
	s = [CVSetting sharedInstance];
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	[dp setDataIdentifier:@"TodayNewsRefreshTime" lifecycle:[s cvCachedDataLifecycle:CVSettingHomeStockInTheNews]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
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
	[_lastToken release];
	[pageViewController release];
	[arrayTodayNews release];
	[lbl release];
	[activityIndicator release];
    [super dealloc];
}

#pragma mark -
#pragma mark private methods

- (NSString *)convertString:(NSString *)string {
	NSMutableString *c;
	NSString *temp;
	NSRange range;
	
	c = [[NSMutableString alloc] init];
	range = [string rangeOfString:@" "];
	if (range.location != NSNotFound) {
		[c appendFormat:@"%@", [string substringToIndex:range.location]];
		[c appendString:@"%20"];
		[c appendFormat:@"%@", [string substringFromIndex:(range.location + 1)]];
		temp = [c autorelease];
	} else {
		temp = string;
		[c release];
	}
	
	return temp;
}

/*
 * it loads the data of today's news
 * @param: none
 * @return: none
 */
- (void)loadData:(NSNumber *)nForceRefresh {
	BOOL forceRefresh = [nForceRefresh boolValue];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CVDataProvider *dp;
	NSDictionary *dict;
	
	dp = [CVDataProvider sharedInstance];
	
	
	NSMutableArray *newsListArray, *tempArray;
	newsListArray = [[NSMutableArray alloc] initWithCapacity:1];
	
	// load today's news
	NSString *strPageNumber = [NSString stringWithFormat:@"%d",CVNEWS_PAGENUMBER];
	NSArray *array = [[[NSArray alloc] initWithObjects:@"0",strPageNumber,nil] autorelease];
	
	NSString *oldToken = [[[dp GetNewsToken:CVDataProviderNewsListTypeHeadlineNews withParams:array] copy] autorelease];
	
	dict = [dp GetNewsList:CVDataProviderNewsListTypeHeadlineNews withParams:array forceRefresh:forceRefresh];
	
	tempArray = [dict objectForKey:@"data"];
	if (nil != tempArray) {
		[newsListArray addObjectsFromArray:tempArray];
	}
	
	// load today's news of major industry that are selected
	CVMenuItem *item;
	NSMutableString *strParam;
	strParam = [[NSMutableString alloc] initWithString:@"\""];
	// to get the news list for multiple categories, the dataprovider
	// requires the parameter having the format like below
	// ("Consumer Discretionary,Financial,Health Care")
	for (item in self.menuItems) {
		// check every item , if its select is YES, load its news list
		if (YES == item.select) {
			NSString *categoryName;
            
			//categoryName = [self convertString:item.title];
			categoryName = item.title;
			[strParam appendFormat:@"%@,", categoryName];
		}
	}
	if (NO == [strParam isEqualToString:@"\""]) {
		// some sectors are selected
		NSRange range;
		NSArray *parameters;
		
		// delete the last character ','
		range.location = [strParam length] - 1;
		range.length = 1;
		[strParam deleteCharactersInRange:range];
		// append a character '"' so that it follows the format "***"
		[strParam appendString:@"\""];
		parameters = [[NSArray alloc] initWithObjects:strParam, nil];
		dict = [dp GetNewsList:CVDataProviderNewsListTypeHeadlineNews withParams:parameters forceRefresh:forceRefresh];
		[parameters release];
		tempArray = [dict objectForKey:@"data"];
		if (nil != tempArray) {
			[newsListArray addObjectsFromArray:tempArray];
		}
	}
	
	NSString *newToken = [[[dp GetNewsToken:CVDataProviderNewsListTypeHeadlineNews withParams:array] copy] autorelease];
	
	if ([newToken isEqualToString:oldToken] && forceRefresh == NO && arrayTodayNews) {
		_isNewToken = NO;
	} else {
		_isNewToken = YES;
	}
	
	self.arrayTodayNews = newsListArray;
	
	[strParam release];
	[newsListArray release];
	
	// scroll page holds different number of pages in accordance with the orientation
	// of device. In portrait mode, a page has three elements of news, and in landscape mode,
	// a page has four elements of news.
	if (UIInterfaceOrientationPortrait == self.portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == self.portalInterfaceOrientation) {
		pageViewController.pageCount = [arrayTodayNews count] / CVPORTLET_TODAYS_NEWS_PORTRAIT_ELEMENT;
		pageViewController.pageCount += ([arrayTodayNews count] % CVPORTLET_TODAYS_NEWS_PORTRAIT_ELEMENT == 0)?0:1;
	} else {
		pageViewController.pageCount = [arrayTodayNews count] / CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT;
		pageViewController.pageCount += ([arrayTodayNews count] % CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT == 0)?0:1;
	}
	
	[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];
	
	[pool release];
}

/*
 * It returns the frame size of scroll page in accordance with the device orientation
 *
 * @param:	device orientation
 * @return:	rectangle size
 */
- (CGRect)scrollPageFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(SCROLL_PAGE_PORTRAIT_X,
						  SCROLL_PAGE_PORTRAIT_Y,
						  SCROLL_PAGE_PORTRAIT_WIDTH,
						  SCROLL_PAGE_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(SCROLL_PAGE_LANDSCAPE_X, 
						  SCROLL_PAGE_LANDSCAPE_Y, 
						  SCROLL_PAGE_LANDSCAPE_WIDTH, 
						  SCROLL_PAGE_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

/*
 * It returns the frame size of scroll page indicator in accordance with the device orientation.
 * Its coordinates relatively to scroll page view
 *
 * @param:	device orientation
 * @return:	rectangle size
 */
- (CGRect)scrollPageIndicatorFrame:(UIInterfaceOrientation)orientation {
	CGRect scrollRect, rect;
	scrollRect = [self scrollPageFrame:orientation];
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake((scrollRect.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2, 
                          scrollRect.size.height, 
                          CVSCROLLPAGE_INDICTOR_WIDTH,
                          CVSCROLLPAGE_INDICTOR_HEIGHT);
	} else {
		rect = CGRectMake((scrollRect.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2, 
                          CVPORTLET_TODAYS_NEWS_SNAP_HEIGHT, 
                          CVSCROLLPAGE_INDICTOR_WIDTH,
                          CVSCROLLPAGE_INDICTOR_HEIGHT);
	}
    
	return rect;
}

#pragma mark -
#pragma mark CVScrollPageViewDeleage
- (NSUInteger)numberOfPagesInScrollPageView {
	NSUInteger count;
	if (UIInterfaceOrientationPortrait == portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == portalInterfaceOrientation) {
		count = [arrayTodayNews count] / 3 + 1;
	} else {
		count = [arrayTodayNews count] / 4 + 1;
	}
	return count;
}

- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index {
	
	UIView *pageView;
	CVTodayNewsSnapshotView *snapView;
	
	pageView = [scrollPageView dequeueReusablePage:index];
	if (self.portalInterfaceOrientation == UIInterfaceOrientationPortrait ||
		self.portalInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {		
		
		if (nil == pageView) {
			pageView = [[[UIView alloc] initWithFrame:
						 CGRectMake(0, 0, SCROLL_PAGE_PORTRAIT_WIDTH, SCROLL_PAGE_PORTRAIT_HEIGHT)]
						autorelease];
			pageView.autoresizesSubviews = NO;
			pageView.autoresizingMask = UIViewAutoresizingNone;
			[pageView setBackgroundColor:[UIColor clearColor]];
		}
        
		NSUInteger newsCount = [self.arrayTodayNews count];
		for (NSUInteger i = index * CVPORTLET_TODAYS_NEWS_PORTRAIT_ELEMENT; (i < (index + 1) * CVPORTLET_TODAYS_NEWS_PORTRAIT_ELEMENT) && i < newsCount; i++) {
			NSDictionary *dict;
            
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
			snapView = [[CVTodayNewsSnapshotView alloc] initWithFrame:CGRectMake(0, 0, 230, 206)];
			// construct snap shot of news
			dict = [arrayTodayNews objectAtIndex:i];
			snapView.newsTitleLabel.text = [dict objectForKey:@"title"];
			[snapView adjustTitleLabel];
			snapView.newsTitleLabel.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
			NSString *fullImagePath = [dict objectForKey:@"thumbUrl"];
			NSArray *ary = [fullImagePath componentsSeparatedByString:@"&"];
			NSString *teststr = [NSString stringWithFormat:@"%@&size=456",[ary objectAtIndex:0]];
			snapView.imageUrl = teststr;//[NSString stringWithFormat:@"%@&size=456",[ary objectAtIndex:0]];
			snapView.dictNews = dict;    //add by leon
			
			snapView.frame = CGRectMake(CVPORTLET_TODAYS_NEWS_SNAP_BORDER + (i - index * CVPORTLET_TODAYS_NEWS_PORTRAIT_ELEMENT) * (snapView.frame.size.width + CVPORTLET_TODAYS_NEWS_SNAP_BORDER * 2),
										0,
										snapView.frame.size.width,
										snapView.frame.size.height);
			snapView.postId = [dict objectForKey:@"post_id"];    //add by leon
			[NSThread detachNewThreadSelector:@selector(loadImage) toTarget:snapView withObject:nil];
			[pageView addSubview:snapView];
			[snapView release];
            
			[pool release];
		}
	} 
	else {		
		if (nil == pageView) {
			pageView = [[[UIView alloc] initWithFrame:
                         CGRectMake(0, 0, SCROLL_PAGE_LANDSCAPE_WIDTH, SCROLL_PAGE_LANDSCAPE_HEIGHT)] autorelease];
			pageView.autoresizesSubviews = NO;
			pageView.autoresizingMask = UIViewAutoresizingNone;
			pageView.backgroundColor = [UIColor clearColor];
		}
		
		NSUInteger newsCount = [self.arrayTodayNews count];
		for (NSUInteger i = index * CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT; (i < (index * CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT + CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT)) && i < newsCount; i++) {
			NSDictionary *dict;
			CVTodayNewsTitleLinkView *titleLinkView;
			
			dict = [arrayTodayNews objectAtIndex:i];
			
			if ((i - index * CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT) < 2) {
				// the news is displayed on the upside as a snape
				// allocate a snap view of news
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				snapView = [[CVTodayNewsSnapshotView alloc] initWithFrame:CGRectMake(0, 0, 230, 206)];
				
				// construct snap shot of news
				dict = [arrayTodayNews objectAtIndex:i];
				snapView.newsTitleLabel.text = [dict objectForKey:@"title"];
				[snapView adjustTitleLabel];
				snapView.newsTitleLabel.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				NSString *fullImagePath = [dict objectForKey:@"thumbUrl"];
				NSArray *ary = [fullImagePath componentsSeparatedByString:@"&"];
				NSString *teststr = [NSString stringWithFormat:@"%@&size=456",[ary objectAtIndex:0]];
				snapView.imageUrl = teststr;
				snapView.dictNews = dict;
				snapView.postId = [dict objectForKey:@"post_id"];
				snapView.frame = CGRectMake(CVPORTLET_TODAYS_NEWS_SNAP_BORDER + (i - index * CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT) * (snapView.frame.size.width + CVPORTLET_TODAYS_NEWS_SNAP_BORDER),
											0,
											snapView.frame.size.width,
											snapView.frame.size.height);
				[NSThread detachNewThreadSelector:@selector(loadImage) toTarget:snapView withObject:nil];
				[pageView addSubview:snapView];
				[snapView release];
				[pool release];
			} else {
				// the news is displayed on the downside as a title
				// allocate a view of titles
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CVTodayNewsTitleLinkView" owner:self options:nil];
				
				for (id currentObject in topLevelObjects){
					if ([currentObject isKindOfClass:[CVTodayNewsTitleLinkView class]]) {
						titleLinkView =  (CVTodayNewsTitleLinkView *) currentObject;
						titleLinkView.autoresizesSubviews = NO;
						titleLinkView.autoresizingMask = UIViewAutoresizingNone;
						titleLinkView.backgroundColor = [UIColor clearColor];
						break;
					}
				}
				// construct title view
				dict = [arrayTodayNews objectAtIndex:i];
				titleLinkView.newsTitle1 = [dict objectForKey:@"title"];
				titleLinkView.labelTitle1.text = [dict objectForKey:@"title"];
				titleLinkView.labelTitle1.font = [UIFont systemFontOfSize:14];
				titleLinkView.labelTitle1.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				titleLinkView.postId1 = [dict objectForKey:@"post_id"];
				titleLinkView.dictNews1 = dict;
                
				titleLinkView.frame = CGRectMake(CVPORTLET_TODAYS_NEWS_SNAP_BORDER,
                                                 226,
                                                 CVPORTLET_TODAYS_NEWS_TITLE_LINK_WIDTH,
                                                 CVPORTLET_TODAYS_NEWS_TITLE_LINK_HEIGHT);
				
				i = i + 1;
				if (i < newsCount) {
					dict = [arrayTodayNews objectAtIndex:i];
					titleLinkView.newsTitle2 = [dict objectForKey:@"title"];
					titleLinkView.labelTitle2.text = [dict objectForKey:@"title"];
					titleLinkView.labelTitle2.font = [UIFont systemFontOfSize:14];
					titleLinkView.labelTitle2.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
					titleLinkView.postId2 = [dict objectForKey:@"post_id"];
					titleLinkView.dictNews2 = dict;
				}
				
				[pageView addSubview:titleLinkView];
				[pool release];
			}
		}
	}
    
	return pageView;
}

- (void)didScrollToPageAtIndex:(NSUInteger)index {
}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	//[self._popoverControl dismissPopoverAnimated:YES];
	// adjust the size of scroll page view
	pageViewController.frame = [self scrollPageFrame:orientation];
	pageViewController.pageControlFrame = [self scrollPageIndicatorFrame:orientation];
	
	// scroll page holds different number of pages in accordance with the orientation
	// of device. In portrait mode, a page has three elements of news, and in landscape mode,
	// a page has four elements of news.
	if (UIInterfaceOrientationPortrait == self.portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == self.portalInterfaceOrientation) {
		pageViewController.pageCount = [arrayTodayNews count] / CVPORTLET_TODAYS_NEWS_PORTRAIT_ELEMENT;
		pageViewController.pageCount += ([arrayTodayNews count] % CVPORTLET_TODAYS_NEWS_PORTRAIT_ELEMENT == 0)?0:1;
	} else {
		pageViewController.pageCount = [arrayTodayNews count] / CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT;
		pageViewController.pageCount += ([arrayTodayNews count] % CVPORTLET_TODAYS_NEWS_LANDSCAPE_ELEMENT == 0)?0:1;
	}
	// re-organized the subviews of pages
	
	[pageViewController reloadData];
	
	activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 5,
										 self.view.frame.size.height / 2 - 5,
										 activityIndicator.frame.size.width,
										 activityIndicator.frame.size.height);
	lbl.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height / 2);
	[self.view bringSubviewToFront:activityIndicator];
	
}

#pragma mark -
#pragma mark overidden
- (void)actionMenuDidDismiss {
	// refresh the data
	[self beforeLoadData:YES];
}

- (IBAction)clickFresh:(id)sender {
	// refresh the data
	if (!_ifLoaded) {
		return;
	}
    
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		if ([self.arrayTodayNews count] > 0) {
			lbl.hidden = YES;
		}else {
			lbl.hidden = NO;
		}
		return;
	}
	[self beforeLoadData:YES];
}

-(void)beforeLoadData:(BOOL)needRefresh{
	// refresh the data
	_ifLoaded = NO;
	lbl.hidden = YES;
	[activityIndicator startAnimating];
	activityIndicator.hidden = NO;
	pageViewController.view.hidden = YES;
	[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:[NSNumber numberWithBool:needRefresh]];
}

-(void)afterLoadData{
	if (_isNewToken) {
		[pageViewController reloadData];
	}
	
	[activityIndicator stopAnimating];
	activityIndicator.hidden = YES;
	_ifLoaded = YES;
	if ([self.arrayTodayNews count] > 0) {
		lbl.hidden = YES;
		pageViewController.view.hidden = NO;
	}else {
		lbl.hidden = NO;
	}
    
}

-(void)reloadData{
	if (!_ifLoaded) {
		return;
	}
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		if ([self.arrayTodayNews count] > 0) {
			lbl.hidden = YES;
		}else {
			lbl.hidden = NO;
		}
		return;
	} else {
        if ([self.arrayTodayNews count] > 0 && ![dp isDataExpired:@"TodayNewsRefreshTime"]) {
			//do not need refresh
            return;
		}
    }
	[self beforeLoadData:NO];
}

- (IBAction)clickFullscreen:(id)sender {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[NSNumber numberWithInt:4] forKey:@"Number"];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
	[dict release];
}

#pragma mark -
#pragma mark CVMenuControllerDelegate
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	CVSetting *setting;
	
	setting = [CVSetting sharedInstance];
	[setting settingTodayNewsSelect:indexPath.row];
}

@end
