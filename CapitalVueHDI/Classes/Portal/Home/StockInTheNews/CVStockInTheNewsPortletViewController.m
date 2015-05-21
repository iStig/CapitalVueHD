//
//  CVStockInTheNewsPortletViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/6/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVStockInTheNewsPortletViewController.h"

#import "CVDataProvider.h"

#import "CVStockSnapShotViewController.h"
#import "CVSetting.h"
#import "CVMenuItem.h"

@interface CVStockInTheNewsPortletViewController ()

@property (nonatomic, retain) NSArray *stockList;
@property (nonatomic, retain) NSMutableArray *controllersCache;
@property (nonatomic, retain) CVScrollPageViewController *scrollPageViewController;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (void)loadData:(NSNumber *)numNeedRefresh;
- (CGRect)viewRectOfOrientation:(UIInterfaceOrientation)orientation;
- (CGRect)pageIndicatorFrame:(UIInterfaceOrientation)orientation;

- (void)createCache:(NSUInteger)size;
- (void)cacheInsertController:(CVStockSnapShotViewController *)controller atIndex:(NSUInteger)index;
- (CVStockSnapShotViewController *)cacheControllerAtIndex:(NSUInteger)index;
- (void)destroyCache;

@end


@implementation CVStockInTheNewsPortletViewController

@synthesize stockList;
@synthesize controllersCache;
@synthesize scrollPageViewController;
@synthesize activityIndicator;
@synthesize isNeedRefresh;

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

#define CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT 3
#define CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT 2

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_ifLoaded = YES;
	self.style = CVPortletViewStyleRefresh | CVPortletViewStyleBarVisible;
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	//self.style = CVPortletViewStyleRefresh | CVPortletViewStyleSetting| CVPortletViewStyleBarVisible;
	
	// fill the menu of setting
	CVSetting *setting;
	NSArray *settingArray;
	NSMutableArray *array;
	NSDictionary *element;
	CVMenuItem *item;
	setting = [CVSetting sharedInstance];
	settingArray = [setting settingStockInTheNewsCategory];
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
	
	self.portletTitle =  [langSetting localizedString:@"StockIntheNews"];
    
	// protrait page
	CVScrollPageViewController *controller;
	controller = [[CVScrollPageViewController alloc] init];
	controller.indicatorStyle = CVScrollPageIndicatorStyleHigh;
	controller.frame = [self viewRectOfOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
	controller.pageControlFrame = [self pageIndicatorFrame:[[UIApplication sharedApplication] statusBarOrientation]];
	[controller setDelegate:self];
	controller.view.backgroundColor = [UIColor clearColor];
	self.scrollPageViewController = controller;
	[controller release];
	
	[self.view addSubview:scrollPageViewController.view];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 15,
										 self.view.frame.size.height / 2 - 5,
										 activityIndicator.frame.size.width,
										 activityIndicator.frame.size.height);
	
	[self.view addSubview:activityIndicator];
	
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
	[dp setDataIdentifier:@"StockInNewsRefreshTime" lifecycle:[s cvCachedDataLifecycle:CVSettingHomeStockInTheNews]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
	[stockList release];
	[controllersCache release];
	[scrollPageViewController release];
	[activityIndicator release];
	[lbl release];
    [super dealloc];
}

#pragma mark private methods
- (void)loadData:(NSNumber *)numNeedRefresh {
	_ifLoaded = NO;
	self.isNeedRefresh = [numNeedRefresh boolValue];
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	NSMutableArray *stockListArray, *tempArray;
	
	stockListArray = [[NSMutableArray alloc] initWithCapacity:1];
	
	dp = [CVDataProvider sharedInstance];
	
	// load today's news of major industry that are selected
	CVMenuItem *item;
	NSArray *arrayParam = nil;
	
	// to get the stock list for a special categories, the dataprovider
	// requires the parameter having the format like below
	// ($industry='5',$token='')
	// FIXME, it is better to mamage the id of sectors in the config file,
	// and token for the purpose of update function shall be implemented
	for (item in self.menuItems) {
		// check every item , if its select is YES, load its stock list
		if (YES == item.select) {
			NSUInteger sectorNumber;
			if ([item.title isEqualToString:@"Heath Care"]) {
				sectorNumber = 35;
			} else if ([item.title isEqualToString:@"Consumer Staples"]) {
				sectorNumber = 30;
			} else if ([item.title isEqualToString:@"Consumer Discretionary"]) {
				sectorNumber = 25;
			} else if ([item.title isEqualToString:@"Industrials"]) {
				sectorNumber = 20;
			} else if ([item.title isEqualToString:@"Telecommunication Services"]) {
				sectorNumber = 50;
			} else if ([item.title isEqualToString:@"Utilities"]) {
				sectorNumber = 55;
			} else if ([item.title isEqualToString:@"Information Technology"]) {
				sectorNumber = 45;
			} else if ([item.title isEqualToString:@"Energy"]) {
				sectorNumber = 10;
			} else if ([item.title isEqualToString:@"Financials"]) {
				sectorNumber = 40;
			} else if ([item.title isEqualToString:@"Materials"]) {
				sectorNumber = 15;
			} else {
				sectorNumber = 0;
			}
			
			if (0 != sectorNumber) {
				arrayParam = [[[NSArray alloc] initWithObjects:
                               [NSString stringWithFormat:@"$industry='%d'", sectorNumber],
                               nil] autorelease];
			}
            
			break;
		}
	}
	paramInfo = [[[CVParamInfo alloc] init] autorelease];
	paramInfo.minutes = 15;
	NSString *oldToken;
	if (nil != arrayParam) {
		// a sector is selected
		paramInfo.parameters = arrayParam;
		
		oldToken = [[[dp getStockInNewsToken:CVDataProviderStockListTypeNewsRelated withParams:paramInfo] copy] autorelease];
		
		if (self.isNeedRefresh) {
			dict = [dp ReGetStockList:CVDataProviderStockListTypeNewsRelated withParams:paramInfo];
		}else {
			dict = [dp GetStockList:CVDataProviderStockListTypeNewsRelated withParams:paramInfo];
		}
		
		tempArray = [dict objectForKey:@"data"];
		if (nil != tempArray) {
			[stockListArray addObjectsFromArray:tempArray];
		}
	} else {
		// no sector is selected, merely load today's news
		
		oldToken = [[[dp getStockInNewsToken:CVDataProviderStockListTypeNewsRelated withParams:paramInfo] copy] autorelease];
		
		if (self.isNeedRefresh) {
			dict = [dp ReGetStockList:CVDataProviderStockListTypeNewsRelated withParams:paramInfo];
		} else {
			dict = [dp GetStockList:CVDataProviderStockListTypeNewsRelated withParams:paramInfo];
		}
		
		tempArray = [dict objectForKey:@"data"];
		[stockListArray addObjectsFromArray:tempArray];
	}
	if (nil != stockListArray && [stockListArray count] > 0) {
		NSDictionary *dict;
		NSString *date;
		NSString *t;
		
		dict = [stockListArray objectAtIndex:0];
		date = [dict objectForKey:@"t_stamp"];
		
		t = [[NSMutableString alloc] initWithFormat:@"%@ %@", [langSetting localizedString:@"StockIntheNews"],date];
		self.portletTitle = t;
		[t release];
	}
	
	NSString *newToken = [[[dp getStockInNewsToken:CVDataProviderStockListTypeNewsRelated withParams:paramInfo] copy] autorelease];
	if ([newToken isEqualToString:oldToken] && self.isNeedRefresh == NO && stockList) {
		_isNewToken = NO;
	} else {
		_isNewToken = YES;
	}
    
	
	self.stockList = stockListArray;
	[stockListArray release];
	
	// TIP: the usage of temporary orientationLog
	// as the current 3.2 iOS doesn't provide correct orientation of device at the very first time,
	// e.g. between the lauching period of application and subsequent 5-seconds period. Consequently, 
	// the construction of landscape view always reads the wrong orientation and does the wrong job.
	// The temporary variant guarantee the righteous construction of landscape view and revert after
	// completion.
	
	if (UIInterfaceOrientationPortrait == portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == portalInterfaceOrientation) {
		scrollPageViewController.pageCount = [stockList count] / CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT;
		scrollPageViewController.pageCount += ([stockList count] % CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT == 0)?0:1;
	} else {
		scrollPageViewController.pageCount = [stockList count] / CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT;
		scrollPageViewController.pageCount += ([stockList count] % CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT == 0)?0:1;
	}
	
	[self performSelectorOnMainThread:@selector(afterLoadData) withObject:nil waitUntilDone:NO];
	
	[pool release];
}

-(void)afterLoadData{
	if (_isNewToken) {
		[self createCache:[stockList count]];
		[scrollPageViewController reloadData];
	}
	
	[activityIndicator stopAnimating];
	activityIndicator.hidden = YES;
	_ifLoaded = YES;
	self.isNeedRefresh = NO;
	
	if ([self.stockList count] > 0) {
		lbl.hidden = YES;
		scrollPageViewController.view.hidden = NO;
	}else {
		lbl.hidden = NO;
	}
    
}

- (CGRect)viewRectOfOrientation:(UIInterfaceOrientation)orientation {
	CGRect rect;
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(7, 
						  CVPORTLET_BAR_HEIGHT + 10, 
						  CVPORTLET_STOCK_IN_THE_NEW_WIDTH * CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT, 
						  211);
	} else {
		rect = CGRectMake(7, 
						  CVPORTLET_BAR_HEIGHT + 10, 
						  CVPORTLET_STOCK_IN_THE_NEW_WIDTH * CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT,
						  211);
	}
    
	return rect;
}

- (CGRect)pageIndicatorFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	rect = CGRectMake((scrollPageViewController.frame.size.width - CVSCROLLPAGE_INDICTOR_WIDTH) / 2,
                      scrollPageViewController.frame.size.height - 10, 
                      CVSCROLLPAGE_INDICTOR_WIDTH,
                      CVSCROLLPAGE_INDICTOR_HEIGHT);
    
	return rect;
}

- (void)createCache:(NSUInteger)size {
	NSMutableArray *array;
	NSUInteger i;
	
	array = [[NSMutableArray alloc] init];
	for (i = 0; i < size; i++) {
		[array addObject:[NSNull null]];
	}
	self.controllersCache = array;
	[array release];
}

- (void)cacheInsertController:(CVStockSnapShotViewController *)controller atIndex:(NSUInteger)index {
	if (nil != controller && index < [controllersCache count]) {
		[controllersCache replaceObjectAtIndex:index withObject:controller];
	}
}

- (CVStockSnapShotViewController *)cacheControllerAtIndex:(NSUInteger)index {
	CVStockSnapShotViewController *controller;
	
	controller = nil;
	if (index < [controllersCache count]) {
		controller = [controllersCache objectAtIndex:index];
		if ([NSNull null] == (NSNull *)controller)
			controller = nil;
	}
	
	return controller;
}

- (void)destroyCache {
	[controllersCache release];
	controllersCache = nil;
}

#pragma mark CVScrollPageViewDeleage
- (NSUInteger)numberOfPagesInScrollPageView {
	NSUInteger count;
	if (UIInterfaceOrientationPortrait == portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == portalInterfaceOrientation) {
		count = [stockList count] / 3 + 1;
	} else {
		count = [stockList count] / 2 + 1;
	}
	return count;
}

- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	UIView *pageView;
	
	if (UIInterfaceOrientationPortrait == self.portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == self.portalInterfaceOrientation) {
		pageView = [scrollPageView dequeueReusablePage:index];
		if (nil == pageView) {
			pageView = [[[UIView alloc] initWithFrame:CGRectMake(0, 5, CVPORTLET_STOCK_IN_THE_NEW_WIDTH * 3, CVPORTLET_STOCK_IN_THE_NEW_HEIGHT)] autorelease];
			pageView.backgroundColor = [UIColor clearColor];
		}
		
		NSUInteger newsCount = [self.stockList count];
		for (NSUInteger i = index * CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT; (i < (index * CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT + CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT)) && i < newsCount; i++) {
			CVStockSnapShotViewController *snapViewController;
			NSDictionary *dict;
			// temperarily used for log strings
			NSString *tempString;
			
			snapViewController = [self cacheControllerAtIndex:i];
			if (nil == snapViewController) {
				dict = [stockList objectAtIndex:i];
				snapViewController = [[CVStockSnapShotViewController alloc] init];
				snapViewController.isNeedRefresh = self.isNeedRefresh;
				snapViewController.stockCode = [dict objectForKey:@"GPDM"];
				
				snapViewController.view.backgroundColor = [UIColor clearColor];
                
				
				snapViewController.view.frame = CGRectMake((i - index * CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT)*CVPORTLET_STOCK_IN_THE_NEW_WIDTH,
                                                           0, 
                                                           snapViewController.view.frame.size.width, 
                                                           snapViewController.view.frame.size.height);
				snapViewController.code.text = [dict objectForKey:@"GPDM"];
				snapViewController.code.font = [UIFont boldSystemFontOfSize:13];
				snapViewController.code.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				dict = [stockList objectAtIndex:i];
				snapViewController.symbol.text = [dict objectForKey:@"GPJC"];
				snapViewController.symbol.font = [UIFont boldSystemFontOfSize:16];
				snapViewController.symbol.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				
				snapViewController.desc.font = [UIFont systemFontOfSize:12];
				snapViewController.desc.text = [dict objectForKey:@"title"];
				[snapViewController adjustDescLabel];
				snapViewController.desc.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				snapViewController.strPostID = [dict objectForKey:@"post_id"];
				tempString = [dict objectForKey:@"KPJ"];
				snapViewController.previousPrice = [tempString floatValue];
				tempString = [dict objectForKey:@"SPJ"];
				snapViewController.currentPrice = [tempString floatValue];
				
				snapViewController.price.text = [NSString stringWithFormat:@"%.2f", [tempString floatValue] / 1000];
				
				UIColor *posColor = [langSetting getColor:@"GainersRate"];
				UIColor *negColor = [langSetting getColor:@"LosersRate"]; 
				
				if (snapViewController.previousPrice < snapViewController.currentPrice) {
					snapViewController.price.textColor = posColor;
					NSString *pathx = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"portlet_stock_arrow_pos_%@.png",[langSetting localizedString:@"LangCode"]] ofType:nil];
					UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
					snapViewController.priceIndicator.image = imgx;
					[imgx release];
				}
				else if (snapViewController.previousPrice > snapViewController.currentPrice){
					snapViewController.price.textColor = negColor;
					NSString *pathx = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"portlet_stock_arrow_neg_%@.png",[langSetting localizedString:@"LangCode"]] ofType:nil];
					UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
					snapViewController.priceIndicator.image = imgx;
					[imgx release];
				}
				else {
					snapViewController.price.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				}
				
				[self cacheInsertController:snapViewController atIndex:i];
				[snapViewController release];
			} else {
				snapViewController.view.frame = CGRectMake((i - index * CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT)*CVPORTLET_STOCK_IN_THE_NEW_WIDTH,
														   0, 
														   snapViewController.view.frame.size.width, 
														   snapViewController.view.frame.size.height);
			}
            
			
			[pageView addSubview:snapViewController.view];
		}
	} else {
		pageView = [scrollPageView dequeueReusablePage:index];
		
		if (nil == pageView) {
			pageView = [[[UIView alloc] initWithFrame:CGRectMake(0, 10, CVPORTLET_STOCK_IN_THE_NEW_WIDTH * CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT, 211)] autorelease];
			[pageView setBackgroundColor:[UIColor clearColor]];
		}
		
		NSUInteger newsCount = [self.stockList count];
		for (NSUInteger i = index * CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT; (i < (index * CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT + CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT)) && i < newsCount; i++) {
			CVStockSnapShotViewController *snapViewController;
			NSDictionary *dict;
			// temperarily used for log strings
			NSString *tempString;
			
			snapViewController = [self cacheControllerAtIndex:i];
			if (nil == snapViewController) {
				dict = [stockList objectAtIndex:i];
				snapViewController = [[CVStockSnapShotViewController alloc] init];
				snapViewController.isNeedRefresh = self.isNeedRefresh;
				snapViewController.stockCode = [dict objectForKey:@"GPDM"];
				
				snapViewController.view.backgroundColor = [UIColor clearColor];
				
				
				
				
				snapViewController.view.frame = CGRectMake((i - index * CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT)*CVPORTLET_STOCK_IN_THE_NEW_WIDTH, 
                                                           0, 
                                                           snapViewController.view.frame.size.width,
                                                           snapViewController.view.frame.size.height);
				snapViewController.code.text = [dict objectForKey:@"GPDM"];
				snapViewController.code.font = [UIFont boldSystemFontOfSize:13];
				snapViewController.code.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				dict = [stockList objectAtIndex:i];
				snapViewController.symbol.text = [dict objectForKey:@"GPJC"];
				snapViewController.symbol.font = [UIFont boldSystemFontOfSize:16];
				snapViewController.symbol.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				snapViewController.desc.font = [UIFont systemFontOfSize:12];
				snapViewController.desc.text = [dict objectForKey:@"title"];
				[snapViewController adjustDescLabel];
				snapViewController.desc.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				snapViewController.strPostID = [dict objectForKey:@"post_id"];
				tempString = [dict objectForKey:@"ZSP"];
				snapViewController.previousPrice = [tempString floatValue];
                
				tempString = [dict objectForKey:@"SPJ"];
				snapViewController.currentPrice = [tempString floatValue];
				tempString = [NSString stringWithFormat:@"%0.2f", [tempString floatValue] / 1000];
				snapViewController.price.text  = tempString;
				
				UIColor *posColor = [langSetting getColor:@"GainersRate"];
				UIColor *negColor = [langSetting getColor:@"LosersRate"]; 
				
				if (snapViewController.previousPrice < snapViewController.currentPrice) {
					snapViewController.price.textColor = posColor;
					NSString *pathx = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"portlet_stock_arrow_pos_%@.png",[langSetting localizedString:@"LangCode"]] ofType:nil];
					UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
					snapViewController.priceIndicator.image = imgx;
					[imgx release];
				}
				else if (snapViewController.previousPrice > snapViewController.currentPrice){
					snapViewController.price.textColor = negColor;
					NSString *pathx = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"portlet_stock_arrow_neg_%@.png",[langSetting localizedString:@"LangCode"]] ofType:nil];
					UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
					snapViewController.priceIndicator.image = imgx;
					[imgx release];
				}
				else {
					snapViewController.price.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
				}
                
				[self cacheInsertController:snapViewController atIndex:i];
				[snapViewController release];
			} else {
				snapViewController.view.frame = CGRectMake((i - index * CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT)*CVPORTLET_STOCK_IN_THE_NEW_WIDTH, 
														   0, 
														   snapViewController.view.frame.size.width,
														   snapViewController.view.frame.size.height);
			}
			
			
			[pageView addSubview:snapViewController.view];
		}
	}
	
	return pageView;
}

- (void)didScrollToPageAtIndex:(NSUInteger)index {
}

#pragma mark public methods

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	
	scrollPageViewController.frame = [self viewRectOfOrientation:orientation];
	scrollPageViewController.pageControlFrame = [self pageIndicatorFrame:orientation];
	if (UIInterfaceOrientationPortrait == portalInterfaceOrientation ||
		UIInterfaceOrientationPortraitUpsideDown == portalInterfaceOrientation) {
		scrollPageViewController.pageCount = [stockList count] / CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT;
		scrollPageViewController.pageCount += ([stockList count] % CVPORTLET_STOCK_IN_THE_NEW_PORTRAIT_ELEMENT == 0)?0:1;
	} else {
		scrollPageViewController.pageCount = [stockList count] / CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT;
		scrollPageViewController.pageCount += ([stockList count] % CVPORTLET_STOCK_IN_THE_NEW_LANDSCAPE_ELEMENT == 0)?0:1;
	}
	[scrollPageViewController reloadData];
	
	activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 15,
										 self.view.frame.size.height / 2 - 5,
										 activityIndicator.frame.size.width,
										 activityIndicator.frame.size.height);
	lbl.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height / 2);
	
	[self.view bringSubviewToFront:activityIndicator];
}

#pragma mark -
#pragma mark Override
- (void)actionMenuDidDismiss {
	[self reloadData];
}

- (void)clickFresh:(id)sender {
	if (!_ifLoaded) {
		return;
	}
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		if ([self.stockList count] > 0) {
			lbl.hidden = YES;
		}else {
			lbl.hidden = NO;
		}
		return;
	}
	[activityIndicator startAnimating];
	activityIndicator.hidden = NO;
	
	scrollPageViewController.view.hidden = YES;
	
	[self destroyCache];
	self.isNeedRefresh = YES;
	[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:[NSNumber numberWithBool:YES]];
}

-(void)reloadData{
	if (!_ifLoaded) {
		return;
	}
    CVDataProvider *dp = [CVDataProvider sharedInstance];
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]) {
		if ([self.stockList count] > 0) {
			lbl.hidden = YES;
		}else {
			lbl.hidden = NO;
		}
		return;
	} else {
        if ([self.stockList count] > 0 && ![dp isDataExpired:@"StockInNewsRefreshTime"]) {
			//do not need refresh
            return;
		}
    }
	lbl.hidden = YES;
	[activityIndicator startAnimating];
	activityIndicator.hidden = NO;
	
	scrollPageViewController.view.hidden = YES;
	
	[NSThread detachNewThreadSelector:@selector(loadData:) toTarget:self withObject:[NSNumber numberWithBool:NO]];
}

@end
