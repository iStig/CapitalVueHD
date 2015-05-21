//
//  CVNewsDetailView.m
//  CapitalVueHD
//
//  Created by leon on 10-9-25.
//  Copyright 2010 SmilingMobile. All rights reserved.
//


#import "CVNewsDetailView.h"
#import "CVNewsTableViewCell.h"
#import "CVPortalSetNewsController.h"
#import "CVPortal.h"
#import "CVDataProvider.h"
#import "CVSetting.h"
#import "Reachability.h"
#import "NoConnectionAlert.h"


@implementation CVNewsDetailView
@synthesize detailInterfaceOrientation;
@synthesize isLandscape = _isLandscape;
@synthesize iSelectedColumn = _iSelectedColumn;
@synthesize arrayNews = _arrayNews;
@synthesize portalSetNewsController = _portalSetNewsController;
@synthesize newsNavigatorController = _newsNavigatorController;
@synthesize newsrelatedView  = _newsrelatedView;
@synthesize snapshotView = _snapshotView;
@synthesize dictCurrentNews;
@synthesize strPostID = _strPostID;
@synthesize strSetID = _strSetID;
@synthesize strCode = _strCode;
@synthesize fontsize;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		_isLandscape = NO;
		_iSelectedColumn = 0;
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(setButtonImage)
													 name:@"setButtonImage"
												   object:nil];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *path = [paths objectAtIndex:0];
		NSString *filename = [path stringByAppendingPathComponent:@"newsdetailfont.plist"];
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
		self.fontsize = [dict valueForKey:@"detailfontsize"];
		[dict release];
		if (!fontsize) {
			fontsize = [NSNumber numberWithInteger:4];
		}
    }
    return self;
}


- (void)createContentView{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	_imageTableViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 283, self.frame.size.height-2)];
	_imageTableViewBackground.userInteractionEnabled = YES;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"portal_split_landscape_background.png" ofType:nil];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	_imageTableViewBackground.image = img;
	[self addSubview:_imageTableViewBackground];
	[img release];
	
	_newsNavigatorController = [[CVNewsNavigatorController alloc] init];
	[_imageTableViewBackground addSubview:_newsNavigatorController.view];
	[_newsNavigatorController.view setFrame:CGRectMake(0, 0, 275, self.frame.size.height-20)];
	[_newsNavigatorController setDelegate:self];
	[_newsNavigatorController.tableView setFrame:CGRectMake(0, 0, 275, self.frame.size.height-10)];
	
	_activityTableView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 265, 37, 37)];
	_activityTableView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[_newsNavigatorController.tableView addSubview:_activityTableView];
	
	
	if (_isLandscape == NO) {
		_webView = [[UIWebView alloc] initWithFrame:CGRectMake(30,15,670,self.frame.size.height-35)];
		NSArray *views;
		UIView *view;
		views = _webView.subviews;
		for (view in views) {
			if ([view isKindOfClass:[UIScrollView class]]) {
				UIScrollView *scrollView;
				scrollView = (UIScrollView *)view;
				scrollView.backgroundColor = [UIColor whiteColor];
			}
		}
		[self addSubview:_webView];
		
		[_imageTableViewBackground setHidden:YES];
	} else {
		
		_webView   = [[UIWebView alloc] initWithFrame:CGRectMake(315,15,635,self.frame.size.height-40)];
		NSArray *views;
		UIView *view;
		views = _webView.subviews;
		for (view in views) {
			if ([view isKindOfClass:[UIScrollView class]]) {
				UIScrollView *scrollView;
				scrollView = (UIScrollView *)view;
				scrollView.backgroundColor = [UIColor whiteColor];
			}
		}
		[self addSubview:_webView];
		
		[self startActivityTableView];
	}
	_webView.delegate = self;
	
	_activityWebView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_webView.frame.size.width/2, _webView.frame.size.height/2, 37.0, 37.0)];
	_activityWebView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[_webView addSubview:_activityWebView];
	[self startActivityView];
	
	_imageNewsrelatedBackground = [[UIImageView alloc] initWithFrame:CGRectMake(_webView.frame.origin.x + _webView.frame.size.width/2 - 120,
																				_webView.frame.size.height+30, 243, 57)];

	buttonRelatedNews = [UIButton buttonWithType:UIButtonTypeCustom];
	buttonSnapshot = [UIButton buttonWithType:UIButtonTypeCustom];
	path = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	img = [[UIImage alloc] initWithContentsOfFile:path];
	[buttonRelatedNews setBackgroundImage:img forState:UIControlStateNormal];
	[buttonSnapshot setBackgroundImage:img forState:UIControlStateNormal];
	[img release];
	[buttonRelatedNews sizeToFit];
	[buttonSnapshot sizeToFit];
	[buttonRelatedNews setCenter:CGPointMake(_webView.frame.size.width/2-55-15, _webView.frame.size.height+30)];
	[buttonSnapshot setCenter:CGPointMake(_webView.frame.size.width/2+55-15, _webView.frame.size.height+30)];
	
	
	UILabel *labelRelatedNews = [[UILabel alloc] initWithFrame:CGRectMake(42, 15, 100, 20)];
	labelRelatedNews.backgroundColor = [UIColor clearColor];
	labelRelatedNews.font = [UIFont boldSystemFontOfSize:13];
	labelRelatedNews.textAlignment = UITextAlignmentCenter;
	labelRelatedNews.center = CGPointMake(buttonRelatedNews.bounds.size.width/2.0, buttonRelatedNews.bounds.size.height/2.0+8);
	labelRelatedNews.textColor = [UIColor whiteColor];
	labelRelatedNews.text = [langSetting localizedString:@"Related News"];
	labelRelatedNews.userInteractionEnabled = NO;
	[buttonRelatedNews addSubview:labelRelatedNews];
	[labelRelatedNews release];
	
	UILabel *labelSnapshot = [[UILabel alloc] initWithFrame:CGRectMake(42, 25, 100, 20)];
	labelSnapshot.backgroundColor = [UIColor clearColor];
	labelSnapshot.font = [UIFont boldSystemFontOfSize:13];
	labelSnapshot.textColor = [UIColor whiteColor];
	labelSnapshot.text = [langSetting localizedString:@"Snapshot"];
	labelSnapshot.userInteractionEnabled = NO;
	[buttonSnapshot addSubview:labelSnapshot];
	[labelSnapshot release];

	
	[buttonRelatedNews addTarget:self action:@selector(clickRelatedNewsButton) forControlEvents:UIControlEventTouchUpInside];
	[buttonSnapshot addTarget:self action:@selector(clickSnapshotButton) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:buttonSnapshot];
	[self addSubview:buttonRelatedNews];
	
	
	
	[self addSubview:_imageNewsrelatedBackground];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dismissRotationView)
												 name:CVPortalDismissRotationViewNotification object:nil];
}


- (void)adjustSubviews:(UIInterfaceOrientation)orientation{ 
	[self dismissRotationView];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setButtonImage" object:nil];
	if (orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown) {
		[_imageTableViewBackground setHidden:YES];
		[_webView setFrame:CGRectMake(30,15,670,self.frame.size.height-35)];
		[self loadWebContent:[_arrayNews objectAtIndex:_iSelectedColumn]];
		
		[buttonRelatedNews setCenter:CGPointMake(
									_webView.frame.size.width/2-55+35, 
									_webView.frame.size.height+7)];
		[buttonSnapshot setCenter:CGPointMake(
									_webView.frame.size.width/2+55+35,
									_webView.frame.size.height+7)];
	} else {
		[_imageTableViewBackground setHidden:NO];
		[_imageTableViewBackground setFrame:CGRectMake(0, 0, 283, self.frame.size.height-2)];
		[_newsNavigatorController.view setFrame:CGRectMake(0, 0, 275, _imageTableViewBackground.frame.size.height)];
		[_newsNavigatorController.tableView setFrame:CGRectMake(0, 0, 275, _imageTableViewBackground.frame.size.height-10)];
		
		[_webView setFrame:CGRectMake(315,15,635,self.frame.size.height-40)];
		_newsNavigatorController.arrayNews = _arrayNews;
		[_newsNavigatorController.tableView reloadData];
		[self stopActivityTableView];
		[self loadWebContent:[_arrayNews objectAtIndex:_iSelectedColumn]];
		
		[buttonRelatedNews setCenter:CGPointMake(
									_webView.frame.size.width/2-55+300, 
									_webView.frame.size.height+12)];
		[buttonSnapshot setCenter:CGPointMake(
							_webView.frame.size.width/2+55+300, 
							_webView.frame.size.height+12)];
	}
	_activityWebView.center = CGPointMake(_webView.frame.size.width/2, _webView.frame.size.height/2);
}


#pragma mark -
#pragma mark private method
- (void)printWebPage:(UIWebView *)webView jobName:(NSString *)name atPosition:(UIButton *)button{
	UIPrintInteractionController *controller;
	
	controller = [UIPrintInteractionController sharedPrintController];
	
	if(controller) {
		void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
		^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
			if(!completed && error){
				NSLog(@"FAILED! due to error in domain %@ with error code %u",
					  error.domain, error.code);
			}
		};
	
		UIPrintInfo *printInfo = [UIPrintInfo printInfo];
		printInfo.outputType = UIPrintInfoOutputGeneral;
		printInfo.jobName = name;
		printInfo.duplex = UIPrintInfoDuplexLongEdge;
		controller.printInfo = printInfo;
		controller.showsPageRange = YES;
	
		UIViewPrintFormatter *viewFormatter = [webView viewPrintFormatter];
		viewFormatter.startPage = 0;
		controller.printFormatter = viewFormatter;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			CGRect rect;
			rect = CGRectMake(webView.frame.origin.x, webView.frame.size.height - 30, 30, 30);
			rect = button.frame;
			[controller presentFromRect:rect inView:button.superview animated:YES completionHandler:completionHandler];
		} else {
			[controller presentAnimated:YES completionHandler:completionHandler];
		}
	}
}


- (void)updateContent:(NSMutableArray *)array{
	if ([array count]<=0) {
		[_portalSetNewsController showNetWorkLabel];
		[self stopActivityView];
		return;
	} else {
		[_portalSetNewsController hideNetWorkLabel];
	}

	self.arrayNews = array;
	if (detailInterfaceOrientation == UIInterfaceOrientationPortrait ||
		detailInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		if (_portalSetNewsController.isLoadByHome == YES) {
			_portalSetNewsController.isLoadByHome = NO;
		}
		else {
			if ([_arrayNews count] > 0) {
				[self loadWebContent:[_arrayNews objectAtIndex:0]];
			}
		}
	}
	else {
		_newsNavigatorController.arrayNews = array;
		
		[self stopActivityTableView];
		if (_portalSetNewsController.isLoadByHome == NO) {
			[self loadWebContent:[array objectAtIndex:0]];
		} else {
			_portalSetNewsController.isLoadByHome = NO;
		}
		[_newsNavigatorController.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
	}
}


- (void)updateNewsfromHome:(NSMutableArray *)array index:(NSInteger)index{
	if ([array count]<=0) {
		[_portalSetNewsController showNetWorkLabel];
		[self stopActivityView];
		return;
	} else {
		[_portalSetNewsController hideNetWorkLabel];
	}
	
	if ([_arrayNews count]>0)
		[_arrayNews release];
	self.arrayNews = array;
	if (detailInterfaceOrientation == UIInterfaceOrientationPortrait ||
		detailInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self loadWebContent:[_arrayNews objectAtIndex:index]];
		_iSelectedColumn = index;
	}
	else {
		_newsNavigatorController.arrayNews = _arrayNews;
		[_newsNavigatorController.tableView reloadData];
		[self stopActivityTableView];
		[self loadWebContent:[_arrayNews objectAtIndex:index]];
		_iSelectedColumn = index;
	}
}


- (void)loadWebContent:(NSDictionary *)dict{
	if ([dict count]<=0) {
		[_portalSetNewsController showNetWorkLabel];
		[self stopActivityView];
		return;
	} else {
		[_portalSetNewsController hideNetWorkLabel];
	}


	if (nil == dictCurrentNews || dictCurrentNews != dict) {
		self.dictCurrentNews = dict;
	}
	self.strPostID = [dict valueForKey:@"post_id"];
	self.strSetID = [dict valueForKey:@"poststat_setid"];
	self.strCode = [dict valueForKey:@"tag_list_index_0"];
	NSString *strTitle = [dict valueForKey:@"title"];
	NSString *strTimeStamp  = [dict valueForKey:@"t_stamp"];
	NSString *strBody  = [dict valueForKey:@"body"];
	if (strBody) {
		strBody = [self addImageUrl:strBody];
	}
	
	NSString *strTime = [self stampchangetime:strTimeStamp isDetail:YES];
	
	NSMutableString *strContent = [[NSMutableString alloc] init];
	
	[strContent appendFormat:@"<script language=\"javascript\">document.ontouchstart=function()"];
	[strContent appendFormat:@"{document.location=\"myweb:touch:start\";  }; document.ontouchend=function()"];
	[strContent appendFormat:@"{document.location=\"myweb:touch:end\";  }; document.ontouchmove=function(){"];
	[strContent appendFormat:@"document.location=\"myweb:touch:move\";  }  </script>"];
	
	[strContent appendFormat:@"<div align = \"left\">"];
	[strContent appendFormat:@"<font size = \"5\" style=\"font-weight:bold\" face = \"Arial\">"];
	[strContent appendString:strTitle];
	[strContent appendFormat:@"</font></br></div>"];
	
	NSArray *array = [strTime componentsSeparatedByString:@" "];
	if ([array count]>=3) {
		NSString *week = [array objectAtIndex:0];
		NSString *day  = [array objectAtIndex:1];
		NSString *time = [array objectAtIndex:2];
		
		[strContent appendFormat:@"<div align = \"left\">"];
		[strContent appendFormat:@"<font size = \"2\" face = \"Arial\" style=\"font-weight:bold\" color = \"gray\">"];
		[strContent appendString:week];
		[strContent appendFormat:@"</font>"];
		
		[strContent appendFormat:@"<font size = \"2\" face = \"Arial\" color = \"gray\">"];
		[strContent appendString:@"   "];
		[strContent appendString:day];
		[strContent appendFormat:@"</font>"];
		
		[strContent appendFormat:@"<font size = \"2\" face = \"Arial\" color = \"gray\">"];
		[strContent appendString:@"   "];
		[strContent appendString:time];
		[strContent appendFormat:@"</font>"];
		
		[strContent appendFormat:@"</div>"];
	}
	else {
		[strContent appendFormat:@"<div align = \"left\">"];
		[strContent appendFormat:@"<font size = \"2\" face = \"Arial\" color = \"gray\">"];
		[strContent appendString:strTime];
		[strContent appendFormat:@"</font>"];
		[strContent appendFormat:@"</div>"];
	}
	
	
	if (strBody) {
		[strContent appendString:@"<font size = \""];
		[strContent appendString:[fontsize stringValue]];
		[strContent appendString:@"\" face = \"Arial\" color = \"#4D4D4D\">"];
		[strContent appendString:strBody];
		[strContent appendString:@"</font>"];
	}
	
	NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];//release this in loadHTMLByDict:
	[dicc setObject:strContent forKey:@"strContent"];
	[dicc setObject:[NSURL URLWithString:@"http://data.capitalvue.com"] forKey:@"url"];
	
	[self performSelectorOnMainThread:@selector(loadHTMLByDict:) withObject:dicc waitUntilDone:NO];
	
	[strContent release];
}

-(void)loadHTMLByDict:(NSMutableDictionary *)dicc{
	NSMutableString *strContent = [dicc objectForKey:@"strContent"];
	NSURL *url = [dicc objectForKey:@"url"];
	[_webView loadHTMLString:strContent baseURL:url];
	[dicc release];
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	BOOL shouldStart;
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
	
	shouldStart = YES;
	switch (navigationType) {
		case UIWebViewNavigationTypeLinkClicked:
			NSLog(@"UIWebViewNavigationTypeLinkClicked");
			shouldStart = NO;
			break;
			
		case UIWebViewNavigationTypeFormSubmitted:
			NSLog(@"UIWebViewNavigationTypeFormSubmitted");
			break;
			
		case UIWebViewNavigationTypeBackForward:
			NSLog(@"UIWebViewNavigationTypeBackForward");
			break;
			
		case UIWebViewNavigationTypeReload:
			NSLog(@"UIWebViewNavigationTypeReload");
			break;
			
		case UIWebViewNavigationTypeFormResubmitted:
			NSLog(@"UIWebViewNavigationTypeFormResubmitted");
			break;
			
		case UIWebViewNavigationTypeOther:
			NSLog(@"UIWebViewNavigationTypeOther");
			break;
	}
	
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"]) 
        {
			if([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
			{
				if (_newsrelatedView) 
				{
					[_newsrelatedView removeFromSuperview];
					[_newsrelatedView release];
					_newsrelatedView = nil;
				}
				if (_snapshotView) {
					[_snapshotView removeFromSuperview];
					[_snapshotView release];
					_snapshotView = nil;
				}
			}
        }
		shouldStart = NO;
    }
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setButtonImage" object:nil];
    return shouldStart;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
	//[self startActivityView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[self stopActivityView];
}

- (void)startActivityView{
	[_activityWebView setHidden:NO];
	[_activityWebView startAnimating];
}

- (void)stopActivityView{
	[_activityWebView setHidden:YES];
	[_activityWebView stopAnimating];
}

- (void)startActivityTableView{
	if (_activityTableView) {
		[_activityTableView setHidden:NO];
		[_activityTableView startAnimating];
	}
}

- (void)stopActivityTableView{
	if (_activityTableView) {
		[_activityTableView setHidden:YES];
		[_activityTableView stopAnimating];
	}
}


//因为图片地址为相对地址，所有图片地址加上头http://www.capitalvue.com
- (NSString *)addImageUrl:(NSString *)strContent{
	if (!strContent) {
		return nil;
	}
	NSRange xRange = [strContent rangeOfString:@"<img src=\""];
	NSInteger length = strContent.length;
	if (xRange.location>length || xRange.location<0) {
		return strContent;
	}
	else {
		NSInteger local = xRange.location+xRange.length;
		NSString *strPre = [strContent substringWithRange:NSMakeRange(0,local)];
		NSString *strEnd = [strContent substringWithRange:NSMakeRange(local,length-local)];
		NSMutableString *strResult = [[[NSMutableString alloc] init] autorelease];
		[strResult appendString:strPre];
		[strResult appendFormat:@"http://www.capitalvue.com"];
		[strResult appendString:strEnd];
		return strResult;
	}
}

//unix time stamp conversion to date string
- (NSString *)stampchangetime:(NSString *)timestamp isDetail:(BOOL)isDetail{
	NSTimeInterval seconds = [timestamp intValue];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	NSString *str;
	if (isDetail == YES) {
		CVSetting *setting = [CVSetting sharedInstance];
		NSString *currentLanguage = [setting cvLanguage];
		if ([currentLanguage isEqualToString:@"cn"]) {
			NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
			[formatter setLocale:currentLocale];
			[currentLocale release];
		}else {
			NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
			[formatter setLocale:currentLocale];
			[currentLocale release];
		}
		[formatter setDateFormat:@"EEEE yyyy-MM-dd HH:mm"];
		str = [formatter stringFromDate:date];
	}
	else {
		
		[formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
		str = [formatter stringFromDate:date];
	}
	
	return str;
}


#pragma mark CVNewsNavigatorControllerDelegate
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath item:(NSDictionary *)item {
	[self dismissRotationView];
	_iSelectedColumn = indexPath.row;
	self.dictCurrentNews = item;
	[self loadWebContent:item];
}

- (void)selectedNextPage{
	if (detailInterfaceOrientation == UIInterfaceOrientationPortrait ||
		detailInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		[_portalSetNewsController.buttonPanelPortraitView selectedNextPage];
	}
	else {
		[_portalSetNewsController.buttonPanelLandscapeView selectedNextPage];
	}
}

- (void)dismissRotationView{
	if (_newsrelatedView) 
	{
		[_newsrelatedView removeFromSuperview];
		[_newsrelatedView release];
		_newsrelatedView = nil;
	}
	if (_snapshotView) {
		[_snapshotView removeFromSuperview];
		[_snapshotView release];
		_snapshotView = nil;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setButtonImage" object:nil];
}

- (void)clickRelatedNewsButton{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	if (_snapshotView.superview!=nil) {
		[_snapshotView removeFromSuperview];
		[_snapshotView release];
		_snapshotView = nil;
	}
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]){
		[NoConnectionAlert alert];
		return;
	}
	NSLog(@"clickRelatedNewsButton: start");
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_highlight_button.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonRelatedNews setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonSnapshot setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	if (!_newsrelatedView) {
		_newsrelatedView = [[CVNewsrelatedView alloc] initWithFrame:CGRectMake(
														_webView.frame.origin.x + _webView.frame.size.width/2 - 285,
														_webView.frame.size.height - 461 + 20, 571, 461)];
		[_newsrelatedView setDelegate:self];
		[self addSubview:_newsrelatedView];
	}
	else
	{
		[_newsrelatedView removeFromSuperview];
		[_newsrelatedView release];
		_newsrelatedView = nil;
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[buttonRelatedNews setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
		pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[buttonSnapshot setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
		return;
	}
	_newsrelatedView.rotationInterfaceOrientation = self.detailInterfaceOrientation;
	_newsrelatedView.newsClass = CVClassNews;
	_newsrelatedView.labelTitle.text = [langSetting localizedString:@"Related News"];
	[_newsrelatedView startRotationView];
	[_newsrelatedView setHidden:NO];

}

- (void)clickSnapshotButton{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	if (_newsrelatedView && _newsrelatedView.superview!=nil) 
	{
		[_newsrelatedView removeFromSuperview];
		[_newsrelatedView release];
		_newsrelatedView = nil;
	}
	CVSetting *setting = [CVSetting sharedInstance];
	if (![setting isReachable]){
		[NoConnectionAlert alert];
		return;
	}
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_highlight_button.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonSnapshot setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonRelatedNews setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	if (!_snapshotView) {
		_snapshotView = [[CVSnapshotView alloc] initWithFrame:CGRectMake(
														_webView.frame.origin.x + _webView.frame.size.width/2 - 285,
														_webView.frame.size.height - 461 + 20, 571, 461)];
		_snapshotView.opaque = NO;
		[self addSubview:_snapshotView];
	}
	else
	{
		[_snapshotView removeFromSuperview];
		[_snapshotView release];
		_snapshotView = nil;
		NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[buttonRelatedNews setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
		pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
		image = [[UIImage alloc] initWithContentsOfFile:pathx];
		[buttonSnapshot setBackgroundImage:image forState:UIControlStateNormal];
		[image release];
		return;
	}
	_snapshotView.rotationInterfaceOrientation = self.detailInterfaceOrientation;
	_snapshotView.labelTitle.text = [langSetting localizedString:@"Snapshot"];
	NSLog(@"Dream snapshot:%@",_strCode);
	
	if (0==[_strCode intValue])
		_strCode = nil;
	
	_snapshotView.snapshotContentView.strCode = _strCode;
	[_snapshotView startRotationView];
	[_snapshotView.snapshotContentView setHidden:NO];
	[_snapshotView setHidden:NO];
}

- (void)changeDetailFontToBig{
	NSInteger i = [fontsize integerValue];
	if (i<5) {
		i++;
		fontsize = [NSNumber numberWithInteger:i];
		[self saveDetailFontSize];
	}
}

- (void)changeDetailFontToSmall{
	NSInteger i = [fontsize integerValue];
	if (i>2) {
		i--;
		fontsize = [NSNumber numberWithInteger:i];
		[self saveDetailFontSize];
	}
}

/*save my stock to plist*/
- (void)saveDetailFontSize{
	
	[self loadWebContent:dictCurrentNews];
	NSString *fileName = @"newsdetailfont.plist";
	NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
					  stringByAppendingPathComponent:fileName];
	
	//make dict to save
	NSDictionary *dict = [[NSDictionary alloc]
						  initWithObjectsAndKeys:fontsize,@"detailfontsize",nil];
	
	//save latest data to file
	[dict writeToFile:path atomically:NO];
	[dict release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self dismissRotationView];
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonRelatedNews setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonSnapshot setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
}

#pragma mark RelatedNewsandSnapshot delegate
-(void)goWebDetail:(NSDictionary *)dict{
	if (_newsrelatedView) {
		[_newsrelatedView removeFromSuperview];
		// FIXME here will lead to memory-leaking
		_newsrelatedView = nil;
	}
	[self loadWebContent:dict];
}

#pragma mark CVLoadNewsDelegate method
-(NSMutableArray *)attachNewsAtPage:(NSInteger)pageNumber{
	NSMutableArray *ary = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
	CVDataProvider *dataProvider = [CVDataProvider sharedInstance];
	NSDictionary *dict;
	NSString *pageCurrent = [NSString stringWithFormat:@"%d",pageNumber];
	NSString *pageCapacity = [NSString stringWithFormat:@"%d",CV_NEWS_PAGECAPACITY];
	NSArray *array = [[NSArray alloc] initWithObjects:_strPostID,_strSetID,pageCurrent,pageCapacity,nil];
	dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeRelative withParams:array forceRefresh:NO];
	[array release];
	NSMutableArray *arrayData = [dict valueForKey:@"data"];
	if (arrayData)
		ary = arrayData;

	[_newsrelatedView performSelectorOnMainThread:@selector(changeIndicator:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
	return ary;
}
//1244624267
#pragma mark -

- (void)dealloc {
	[_strPostID release];
	[_strSetID release];
	[_strCode release];
	[_arrayNews release];
	[_activityWebView release];
	if (_activityTableView) {
		[_activityTableView release];
	}
	[dictCurrentNews release];
	[_portalSetNewsController release];
	[_newsNavigatorController release];
	[_newsrelatedView release];
	[fontsize release];
    [super dealloc];
}

- (void) setButtonImage
{
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonRelatedNews setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
	pathx = [[NSBundle mainBundle] pathForResource:@"cv_rotation_normal_button.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:pathx];
	[buttonSnapshot setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
}

- (void)popPrintController:(id)sender {
	UIButton *button;
	button = (UIButton *)sender;
	[self printWebPage:_webView jobName:@"capital vue" atPosition:button];
}

@end
