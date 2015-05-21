//
//  CVPortalSetNews.m
//  CapitalVueHD
//
//  Created by jishen on 8/31/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPortalSetNewsController.h"
#import "CVButtonPanelView.h"
#import "CVLocalizationSetting.h"
#import "CVSetting.h"
#import "CVDataProvider.h"
@interface CVPortalSetNewsController()

@property (nonatomic, retain) UIButton *_printButton;

- (IBAction)printButtonTapped:(id)sender;
- (CGPoint)centerNetworkLabel:(UIInterfaceOrientation)orientation;

@end

@implementation CVPortalSetNewsController

@synthesize buttonPanelPortraitView;
@synthesize buttonPanelLandscapeView;
@synthesize portletViewController;
@synthesize newsDetailView;
@synthesize isLoadByHome;
@synthesize arrayNewsChooseStatus = _arrayNewsChooseStatus;

@synthesize _printButton;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	CVPortletViewController *vcPortlet = [[CVPortletViewController alloc] init];
	[vcPortlet setDelegate:self];
	vcPortlet.portalInterfaceOrientation = self.portalInterfaceOrientation;
	vcPortlet.frame = [self portletFrame:self.portalInterfaceOrientation];
	vcPortlet.style = CVPortletViewStyleRefresh| CVPortletViewStyleRestore | CVPortletViewStyleBarVisible;// | CVPortletViewStyleContentTransparent;
	vcPortlet.portletTitle = [langSetting localizedString:@"Today's News"];
	self.portletViewController = vcPortlet;
	[vcPortlet release];
	
	CVButtonPanelView *panelPortraitView = [[CVButtonPanelView alloc] initWithFrame:self.view.frame];
	CVButtonPanelView *panelLandscapeView = [[CVButtonPanelView alloc] initWithFrame:self.view.frame];
    
	
	buttonPanelPortraitView = panelPortraitView;
	buttonPanelLandscapeView = panelLandscapeView;
    
	
	[self loadButtonPanel];
	[self loadDetailContent];
	
	_arrayNewsChooseStatus = [[NSMutableArray alloc] init];
	for (int i = 0; i< 13; i++) {
		[_arrayNewsChooseStatus addObject:[NSNumber numberWithInteger:0]];
	}
    
	[portletViewController.view addSubview:buttonPanelPortraitView];
	[portletViewController.view addSubview:buttonPanelLandscapeView];
    
	
	[self.view addSubview:portletViewController.view];
	
	[self adjustSubviews:self.portalInterfaceOrientation];
	
	buttonFontBig = [UIButton buttonWithType:UIButtonTypeCustom];
	buttonFontSmall = [UIButton buttonWithType:UIButtonTypeCustom];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"cv_news_detailfont_big_button.png" ofType:nil];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	[buttonFontBig setBackgroundImage:img forState:UIControlStateNormal];
	[img release];
	NSString *path2 = [[NSBundle mainBundle] pathForResource:@"cv_news_detailfont_small_button.png" ofType:nil];
	UIImage *img2 = [[UIImage alloc] initWithContentsOfFile:path2];
	[buttonFontSmall setBackgroundImage:img2 forState:UIControlStateNormal];
	[img2 release];
	[buttonFontBig sizeToFit];
	[buttonFontSmall sizeToFit];
	CGFloat X = portletViewController.view.frame.size.width;
	[buttonFontSmall setCenter:CGPointMake(X-150, 22)];
	[buttonFontBig setCenter:CGPointMake(X-105, 20)];
	
	[portletViewController.view addSubview:buttonFontSmall];
	[portletViewController.view addSubview:buttonFontBig];
	
	self._printButton = [UIButton buttonWithType:UIButtonTypeCustom];
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_airprint_button.png" ofType:nil];
	UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
	[_printButton setBackgroundImage:imgx forState:UIControlStateNormal];
	[imgx release];
	[_printButton sizeToFit];
	[_printButton setCenter:CGPointMake(X-195, 22)];
	[_printButton addTarget:self action:@selector(printButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[portletViewController.view addSubview:_printButton];
    
	[buttonFontBig addTarget:self action:@selector(clickBigFontButton) forControlEvents:UIControlEventTouchUpInside];
	[buttonFontSmall addTarget:self action:@selector(clickSmallFontButton) forControlEvents:UIControlEventTouchUpInside];
	
	lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
	lbl.numberOfLines = 2;
	lbl.font = [UIFont systemFontOfSize:13];
	lbl.center = [self centerNetworkLabel:[[UIApplication sharedApplication] statusBarOrientation]];
	lbl.textColor = [UIColor darkGrayColor];
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textAlignment = UITextAlignmentCenter;
	lbl.text = [langSetting localizedString:@"NetworkFailedMessage"];
	[self.view addSubview:lbl];
	lbl.hidden = YES;
    
    CVSetting *s;
	s = [CVSetting sharedInstance];
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	[dp setDataIdentifier:@"NewsRefreshTime" lifecycle:[s cvCachedDataLifecycle:CVSettingHomeStockInTheNews]];
}

- (void)reloadTableData{
	[buttonPanelPortraitView.newsNavigatorController.tableView reloadData];
	[buttonPanelLandscapeView.newsNavigatorController.tableView reloadData];
}

#pragma mark private methods
- (IBAction)printButtonTapped:(id)sender {
	[newsDetailView popPrintController:sender];
}

/*
 * It returns the frame of portlet in accrodance with
 * the device orientation.
 *
 * @param: orientation - the orientation of device
 * @return: coordinates and size of portlet
 */
- (CGRect)portletFrame:(UIInterfaceOrientation)orientation {
	CGRect rect;
	
	if (UIInterfaceOrientationPortrait == orientation ||
		UIInterfaceOrientationPortraitUpsideDown == orientation) {
		rect = CGRectMake(15, 20, CVPORTLET_PORTRAIT_WIDTH, CVPORTLET_PORTRAIT_HEIGHT);
	} else {
		rect = CGRectMake(15, 20, CVPORTLET_LANDSCAPE_WIDTH, CVPORTLET_LANDSCAPE_HEIGHT);
	}
	
	return rect;
}

- (void)loadButtonPanel{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSArray *arrayButtonTitle = [[NSArray alloc] initWithObjects:
								 [langSetting localizedString:@"Headline News"],
								 [langSetting localizedString:@"Latest News"],
								 [langSetting localizedString:@"Macro"],
								 [langSetting localizedString:@"Discretionary"],
								 [langSetting localizedString:@"Staples"],
								 [langSetting localizedString:@"Financials"],
								 [langSetting localizedString:@"Health Care"],
								 [langSetting localizedString:@"Industrials"],
								 [langSetting localizedString:@"Materials"],
								 [langSetting localizedString:@"Energy"],
								 [langSetting localizedString:@"Telecom"],
								 [langSetting localizedString:@"Utilities"],
								 [langSetting localizedString:@"IT"]
								 ,nil];
    
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portal_button_bar.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	buttonPanelPortraitView.img = image;
	[image release];
	buttonPanelPortraitView.frame = CGRectMake(0.0, CVBUTTON_PANEL_Y, CVBUTTON_PANEL_PORTRAIT_WIDTH, CVBUTTON_PANEL_PORTRAIT_HEIGHT);//(16, 72, 732, 38);
	buttonPanelPortraitView.portalSetNewsController = self;
	buttonPanelPortraitView.isLandscape = NO;
	buttonPanelPortraitView.arrayButtonTitle = arrayButtonTitle;
	[buttonPanelPortraitView createButtonPanel];
    
	
	pathx = [[NSBundle mainBundle] pathForResource:@"portal_button_bar.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	buttonPanelLandscapeView.img = image;
	[image release];
	buttonPanelLandscapeView.frame = CGRectMake(0.0, CVBUTTON_PANEL_Y, CVBUTTON_PANEL_LANDSCAPE_WIDTH, CVBUTTON_PANEL_LANDSCAPE_HEIGHT);
	buttonPanelLandscapeView.portalSetNewsController = self;
	buttonPanelLandscapeView.isLandscape = YES;
	buttonPanelLandscapeView.arrayButtonTitle = arrayButtonTitle;
	[buttonPanelLandscapeView createButtonPanel];
    
	
	
	[arrayButtonTitle release];
}

- (void)loadDetailContent{   //newsdetailview
	if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait ||
		[[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		newsDetailView = [[CVNewsDetailView alloc] initWithFrame:CGRectMake(0.0, CVBUTTON_PANEL_Y + CVBUTTON_PANEL_PORTRAIT_HEIGHT,
                                                                            CVBUTTON_PANEL_PORTRAIT_WIDTH, 
                                                                            CVPORTLET_PORTRAIT_HEIGHT - CVBUTTON_PANEL_Y - CVBUTTON_PANEL_PORTRAIT_HEIGHT)];
		newsDetailView.isLandscape = NO;
	}
	else {
		newsDetailView = [[CVNewsDetailView alloc] initWithFrame:CGRectMake(0.0, CVBUTTON_PANEL_Y + CVBUTTON_PANEL_LANDSCAPE_HEIGHT,
                                                                            CVBUTTON_PANEL_LANDSCAPE_WIDTH,
                                                                            CVPORTLET_LANDSCAPE_HEIGHT - CVBUTTON_PANEL_Y - CVBUTTON_PANEL_LANDSCAPE_HEIGHT)];
		newsDetailView.isLandscape = YES;
	}
    //	newsDetailView.layer.cornerRadius = 8;
    //	newsDetailView.layer.masksToBounds = YES;
	newsDetailView.detailInterfaceOrientation = self.portalInterfaceOrientation;
	newsDetailView.portalSetNewsController = self;
	//newsDetailView.isLandscape = YES;
	[newsDetailView createContentView];
	[portletViewController.view addSubview:newsDetailView];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


/*
 * It adjust the views postion in accordance to the device orientation.
 *
 * @param: orientation - The orientation of the application’s user interface
 * @return: none
 */
- (void)adjustSubviews:(UIInterfaceOrientation)orientation {
	[super adjustSubviews:orientation];
	portletViewController.view.frame = [self portletFrame:orientation];
	portletViewController.portalInterfaceOrientation = orientation;
	[portletViewController adjustSubviews:orientation];
	if (orientation==UIInterfaceOrientationPortrait
		|| orientation==UIInterfaceOrientationPortraitUpsideDown)
	{
		buttonPanelPortraitView.hidden = NO;
		buttonPanelLandscapeView.hidden = YES;
		[buttonPanelPortraitView adjustSubviews:orientation];  //update button panel selected status
		
		[newsDetailView setFrame:CGRectMake(0.0, CVBUTTON_PANEL_Y + CVBUTTON_PANEL_PORTRAIT_HEIGHT,
                                            CVBUTTON_PANEL_PORTRAIT_WIDTH, 
											CVPORTLET_PORTRAIT_HEIGHT - CVBUTTON_PANEL_Y - CVBUTTON_PANEL_PORTRAIT_HEIGHT)];
		
	}
	else
	{
		buttonPanelPortraitView.hidden = YES;
		buttonPanelLandscapeView.hidden = NO;
		[buttonPanelLandscapeView adjustSubviews:orientation];  //update button panel selected status
		
		[newsDetailView setFrame:CGRectMake(0.0, CVBUTTON_PANEL_Y + CVBUTTON_PANEL_LANDSCAPE_HEIGHT,
                                            CVBUTTON_PANEL_LANDSCAPE_WIDTH,
											CVPORTLET_LANDSCAPE_HEIGHT - CVBUTTON_PANEL_Y - CVBUTTON_PANEL_LANDSCAPE_HEIGHT)];
		
	}
	newsDetailView.detailInterfaceOrientation = orientation;
	CGFloat X = portletViewController.view.frame.size.width;
	[buttonFontSmall setCenter:CGPointMake(X-150, 22)];
	[buttonFontBig setCenter:CGPointMake(X-105, 20)];
	[_printButton setCenter:CGPointMake(X-195, 22)];
	[newsDetailView adjustSubviews:orientation];
	[portletViewController adjustSubviews:orientation];
	lbl.center = [self centerNetworkLabel:orientation];
}

-(void)clickRefreshButton{
	newsDetailView.hidden = YES;
	if (UIInterfaceOrientationIsPortrait(newsDetailView.detailInterfaceOrientation)) {
		[buttonPanelPortraitView performSelector:@selector(refreshList) withObject:nil afterDelay:0.2];
	}else {
		[buttonPanelLandscapeView performSelector:@selector(refreshList) withObject:nil afterDelay:0.2];
	}
}

- (NSNumber *)getDetailFontSize{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:@"newsdetailfont.plist"];
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filename] autorelease];
	NSNumber *fontsize = [dict valueForKey:@"detailfontsize"];
	return fontsize;
}

- (void)clickBigFontButton{
	[newsDetailView changeDetailFontToBig];
}

- (void)clickSmallFontButton{
	[newsDetailView changeDetailFontToSmall];
}

//click a home's todays news,then jump to news portal,and show detail news
- (void)updateNewsfromHome:(NSDictionary *)dict{
	if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait ||
		[[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		[buttonPanelPortraitView updateNewsfromHome:dict];
	}
	else {
		[buttonPanelLandscapeView updateNewsfromHome:dict];
	}
    
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
	[_printButton release];
	[newsDetailView release];
	[_arrayNewsChooseStatus release];
	[buttonPanelPortraitView release];
	[buttonPanelLandscapeView release];
    [super dealloc];
}

- (void)reloadData{
    CVDataProvider *dp = [CVDataProvider sharedInstance];
	CVSetting *setting = [CVSetting sharedInstance];
	if ([setting isReachable]) {
        if ([newsDetailView.newsNavigatorController.arrayNews count] > 0 && ![dp isDataExpired:@"NewsRefreshTime"]) {
			//do not need refresh
            return;
		}
    }
	if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait ||
		[[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		[buttonPanelPortraitView reloadList];
	}
	else {
		[buttonPanelLandscapeView reloadList];
	}
}

-(void)showNetWorkLabel{
	lbl.hidden = NO;
}

-(void)hideNetWorkLabel{
	lbl.hidden = YES;
}

- (CGPoint)centerNetworkLabel:(UIInterfaceOrientation)orientation{
	CGPoint point;
	if (orientation==UIInterfaceOrientationPortrait
		|| orientation==UIInterfaceOrientationPortraitUpsideDown)
	{
		point = CGPointMake(380, 425);
	}
	else
	{
		point = CGPointMake(620, 326);
	}
    
	return point;
}

@end
