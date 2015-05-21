    //
//  CVTodaysNewsView.m
//  CapitalValDemo
//
//  Created by leon on 10-8-12.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
/*
 Today's News小窗口模块，包括横竖屏，由8个页面组成
 横屏显示2条新闻thumbs和2条文字标题
 竖屏显示3条新闻thumbs
 继承于CVPortletController,上面放置ScrollView和PageContol
 */

#import "CVTodaysNewsView.h"
#import "CVTodaysNewsData.h"
#import "CVTodaysNewsContentView.h"
#import "CVTodaysNewsTableViewCell.h"


static NSUInteger kNumberOfPages = 8;

@implementation CVTodaysNewsView

@synthesize contentScrollPageView = _contentScrollPageView;
@synthesize arrayTodaysNews = _arrayTodaysNews;

@synthesize arrayHeadlineNews = _arrayHeadlineNews;
@synthesize arrayLatestNews = _arrayLatestNews;
@synthesize arrayMacro = _arrayMacro;
@synthesize arrayDiscretionary = _arrayDiscretionary;
@synthesize arrayStaples = _arrayStaples;
@synthesize arrayFinancials = _arrayFinancials;
@synthesize arrayHealthCare = _arrayHealthCare;
@synthesize arrayIndustrials = _arrayIndustrials;
@synthesize arrayMaterials = _arrayMaterials;
@synthesize arrayEnergy = _arrayEnergy;
@synthesize arrayTelecom = _arrayTelecom;
@synthesize arrayUtilities = _arrayUtilities;
@synthesize arrayIT = _arrayIT;
@synthesize arrayTable = _arrayTable;

@synthesize pageNews = _pageNews;
@synthesize arrayPortraitTodaysNews = _arrayPortraitTodaysNews; 
@synthesize arrayLandscapeTodaysNews = _arrayLandscapeTodaysNews;
@synthesize pageLandscape = _pageLandscape;
@synthesize pagePortrait = _pagePortrait;
@synthesize iChecked = _iChecked;
@synthesize arrayButtonTitle = _arrayButtonTitle;
@synthesize arrayButtons = _arrayButtons;
@synthesize arrayButtonsLandscape = _arrayButtonsLandscape;
@synthesize arrayButtonsPortrait = _arrayButtonsPortrait;
@synthesize webView = _webView;
@synthesize dictCurrentNews = _dictCurrentNews;
@synthesize imageButtonBackground = _imageButtonBackground;
@synthesize imageButtonSecondBackground = _imageButtonSecondBackground;
@synthesize imageButtonLandscapeBackground = _imageButtonLandscapeBackground;
@synthesize imageTableBackground = _imageTableBackground;
@synthesize tableView = _tableView;

@synthesize response	  = _response;
@synthesize todaysnewsPopoverView = _todaysnewsPopoverView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//初始化竖屏资源
//初始化横竖屏View数组
//通过CVTodaysNewsData获取数据，并加载第一、二张页面

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) 
	{
		_boolFullScreen = NO;
		_imageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 742.0f, 294.0f)];
		_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(19.0f, 11.0f, 200.0f, 30.0f)];
		UIImage *image = [UIImage imageNamed:@"todaysnews_portrait_background.png"];
		_imageBackground.image = image;
		
		_labelTitle.backgroundColor = [UIColor clearColor];
		_labelTitle.textColor = [UIColor whiteColor];
		_labelTitle.font = [UIFont systemFontOfSize:19.0];
		_labelTitle.text = @"Today's News";
		
		_buttonRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
		[_buttonRefresh setFrame:CGRectMake(631.0, 13.0, 25.0, 25.0)];
		UIImage *imgRefresh = [UIImage imageNamed:@"refresh_button.png"];
		[_buttonRefresh setImage:imgRefresh forState:UIControlStateNormal];
		
		_buttonFullscreen = [UIButton buttonWithType:UIButtonTypeCustom];
		[_buttonFullscreen setFrame:CGRectMake(661.0, 13.0, 25.0, 25.0)];
		UIImage *imgFullscreen = [UIImage imageNamed:@"expand_button.png"];
		[_buttonFullscreen setImage:imgFullscreen forState:UIControlStateNormal];
		
		_buttonSetting = [UIButton buttonWithType:UIButtonTypeCustom];
		[_buttonSetting setFrame:CGRectMake(701.0, 13.0, 30.0, 25.0)];
		UIImage *imgSetting = [UIImage imageNamed:@"setting_button.png"];
		[_buttonSetting setImage:imgSetting forState:UIControlStateNormal];
		
		_buttonRestore = [UIButton buttonWithType:UIButtonTypeCustom];
		[_buttonRestore setFrame:CGRectMake(651.0, 85.0, 25.0, 25.0)];
		UIImage *imgRestorescreen = [UIImage imageNamed:@"restore_button.png"];
		[_buttonRestore setImage:imgRestorescreen forState:UIControlStateNormal];
		
		
		[_buttonRefresh addTarget:self action:@selector(clickRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonFullscreen addTarget:self action:@selector(clickFullscreenButton:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonSetting addTarget:self action:@selector(clickSettingButton:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonRestore addTarget:self action:@selector(clickRestoreButton:) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:_imageBackground];
		[self addSubview:_labelTitle];
		[self addSubview:_buttonRefresh];
		[self addSubview:_buttonFullscreen];
		[self addSubview:_buttonSetting];
		[self addSubview:_buttonRestore];
		[_buttonRestore setHidden:YES];
		
		_contentScrollPageView = [[CVContentScrollPageView alloc] initWithFrame:CGRectMake(4.0f, 50.0f, 735.0f, 260.0f)];
		_contentScrollPageView.delegate = self;
		[self addSubview:_contentScrollPageView];
		
		NSMutableArray *portraitcontrollers = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < kNumberOfPages; i++) {
			[portraitcontrollers addObject:[NSNull null]];
		}
		
		
		self.arrayPortraitTodaysNews = portraitcontrollers;
		[portraitcontrollers release];
		
		NSMutableArray *landscapecontrollers = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < kNumberOfPages; i++) {
			[landscapecontrollers addObject:[NSNull null]];
		}
		self.arrayLandscapeTodaysNews = landscapecontrollers;
		[landscapecontrollers release];
		
		
		CVTodaysNewsData *todaysnewsdata = [CVTodaysNewsData sharedSettingData];
		[todaysnewsdata setDelegate:self];
		
		_arrayTodaysNews = [todaysnewsdata getArrayData];
		if ([_arrayTodaysNews count] > 0) {
			UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
			if (orientation == UIInterfaceOrientationPortrait
				|| orientation == UIInterfaceOrientationPortraitUpsideDown) {
				[self loadScrollViewWithPage:0 isLandscape:NO];
				[self loadScrollViewWithPage:1 isLandscape:NO];
			}
			else {
				[self loadScrollViewWithPage:0 isLandscape:YES];
				[self loadScrollViewWithPage:1 isLandscape:YES];
			}
			
		}
		_pageLandscape = 0;
		_pagePortrait = 0;
		_iChecked = 0;
		
		_pageNews = [[CVPageControlView alloc] init];
		_arrayButtonsLandscape = [[NSMutableArray alloc] init];
		_arrayButtonsPortrait = [[NSMutableArray alloc] init];
		_arrayButtons = [[NSMutableArray alloc] init];  //初始化buttons数组
		
		
		[_pageNews setFrame:CGRectMake(280.0f, 260.0f, 150.0f, 30.0f)];
		
		
		_pageNews.currentPage = 0;
		_pageNews.numberOfPages = 8;
		_pageNews.backgroundColor = [UIColor clearColor];
		[_pageNews addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_pageNews];
		
	}
	return self;
}


//当屏幕转动时，判断为横屏还是竖屏，从而移动控件，以适应横/竖屏窗口
- (void) updateOrientation{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
	if (_boolFullScreen == YES) {
		[self loadFullStatus:orientation];
	}
	else
	{
		[self loadRestoreStatus:orientation];
	}
}

- (void)loadFullStatus:(UIInterfaceOrientation)orientation{
	if (orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self loadProtriatFullView];
	}
	else {
		[self loadLandscapeFullView];
	}

}

- (void)loadRestoreStatus:(UIInterfaceOrientation)orientation{
	if (orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self loadProtriatRestoreView];
	}
	else {
		[self loadLandscapeRestoreView];
	}
}

//加载Todays News小窗口横向模式
- (void)loadLandscapeRestoreView{
	[self setFrame:CGRectMake(16.0f, 72.0f, 501.0f, 362.0f)];
	[_imageBackground setFrame:CGRectMake(0.0f, 0.0f, 501.0f, 362.0f)];
	[_labelTitle setFrame:CGRectMake(19.0f, 11.0f, 200.0f, 30.0f)];
	UIImage *image = [UIImage imageNamed:@"todaysnews_landscape_background.png"];
	_imageBackground.image = image;
	_imageBackground.userInteractionEnabled = YES;
	
	
	[_buttonRefresh setFrame:CGRectMake(380.0, 13.0, 25.0, 25.0)];
	[_buttonFullscreen setFrame:CGRectMake(420.0, 13.0, 25.0, 25.0)];
	[_buttonSetting setFrame:CGRectMake(460.0, 13.0, 30.0, 25.0)];
	
	[_contentScrollPageView setFrame:CGRectMake(2.0f, 50.0f, 495.0f, 330.0f)];
	_contentScrollPageView.contentSize = CGSizeMake(495.0 * 8, 330.0);
	
	[_pageNews setFrame:CGRectMake(150.0f, 260.0f, 150.0f, 30.0f)];
	_pageNews.currentPage = _pageLandscape;
	[_contentScrollPageView setContentOffset:CGPointMake(_contentScrollPageView.frame.size.width*_pageLandscape, 0) animated:NO];
	[self loadScrollViewWithPage:_pageLandscape isLandscape:YES];
}

//加载Todays News小窗口竖向模式
- (void)loadProtriatRestoreView{
	[self setFrame:CGRectMake(16.0f, 72.0f, 742.0f, 294.0f)];
	[_imageBackground setFrame:CGRectMake(0.0f, 0.0f, 742.0f, 294.0f)];
	[_labelTitle setFrame:CGRectMake(19.0f, 11.0f, 200.0f, 30.0f)];
	UIImage *image = [UIImage imageNamed:@"todaysnews_portrait_background.png"];
	_imageBackground.image = image;
	_imageBackground.userInteractionEnabled = YES;
	
	
	[_buttonRefresh setFrame:CGRectMake(631.0, 13.0, 25.0, 25.0)];
	[_buttonFullscreen setFrame:CGRectMake(661.0, 13.0, 25.0, 25.0)];
	[_buttonSetting setFrame:CGRectMake(701.0, 13.0, 30.0, 25.0)];
	
	[_contentScrollPageView setFrame:CGRectMake(4.0f, 50.0f, 735.0f, 260.0f)];
	_contentScrollPageView.contentSize = CGSizeMake(735.0 * 8, 260.0);
	
	[_pageNews setFrame:CGRectMake(280.0f, 260.0f, 150.0f, 30.0f)];
	_pageNews.currentPage = _pagePortrait;
	[_contentScrollPageView setContentOffset:CGPointMake(_contentScrollPageView.frame.size.width*_pagePortrait, 0) animated:NO];
	[self loadScrollViewWithPage:_pagePortrait isLandscape:NO];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

//CVTodaysNewsData调用Webservice获取数据后，通过delegate返回数据结果
//然后判断横竖屏，加载横竖屏第一、二页页面，并显示
#pragma mark -
#pragma mark CVTodaysNewsData delegate
- (void)getDataFinished:(NSMutableArray *)array{
	_arrayTodaysNews = array;
	if ([_arrayTodaysNews count] > 0) {
		UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
		if (orientation == UIInterfaceOrientationPortrait ||
			orientation == UIInterfaceOrientationPortraitUpsideDown) {
				[self loadScrollViewWithPage:0 isLandscape:NO];
				[self loadScrollViewWithPage:1 isLandscape:NO];
		}
		else {
			[self loadScrollViewWithPage:0 isLandscape:YES];
			[self loadScrollViewWithPage:1 isLandscape:YES];
		}

		[_contentScrollPageView reloadInputViews];
	}
}

- (IBAction)changePage:(id)sender{
	int page = _pageNews.currentPage;
	[_pageNews changeIcoImage];
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
	CGRect frame = _contentScrollPageView.frame;
	
	if (orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self loadScrollViewWithPage:page - 1 isLandscape:NO];
		[self loadScrollViewWithPage:page isLandscape:NO];
		[self loadScrollViewWithPage:page + 1 isLandscape:NO];
		
		frame.origin.x = 735 * page;
	}
	else {
		[self loadScrollViewWithPage:page - 1 isLandscape:YES];
		[self loadScrollViewWithPage:page isLandscape:YES];
		[self loadScrollViewWithPage:page + 1 isLandscape:YES];
		
		frame.origin.x = 495 * page;
	}

    
    
	// update the scroll view to the appropriate page
    
    //frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_contentScrollPageView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _boolUsed = YES;
}

//拖动scrollView,滑动到前一页或后一页
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (_boolUsed) {
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _contentScrollPageView.frame.size.width;
	int page = floor((_contentScrollPageView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageNews.currentPage = page;
	[_pageNews changeIcoImage];
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
	UIDevice *device = [UIDevice currentDevice];
	UIDeviceOrientation orientation = [device orientation];
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		_pagePortrait = page;
		[self loadScrollViewWithPage:(page - 1) isLandscape:NO];
		[self loadScrollViewWithPage:page isLandscape:NO];
		[self loadScrollViewWithPage:(page + 1) isLandscape:NO];
	}
	else {
		_pageLandscape = page;
		[self loadScrollViewWithPage:(page - 1) isLandscape:YES];
		[self loadScrollViewWithPage:page isLandscape:YES];
		[self loadScrollViewWithPage:(page + 1) isLandscape:YES];
	}
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _boolUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _boolUsed = NO;
}


//加载ScrollView页面上的内容。从m_arrayLandscapeTodaysNews数组里面取出横屏页面
//从m_arrayPortraitTodaysNews数组里面取出竖屏页面
//如果页面不存在，或者取出的页面为空，则创建新的页面添加到相应数组里面.
//
- (void) loadScrollViewWithPage:(int)page isLandscape:(BOOL)isLandscape{
	if (page < 0) return;
    if (page >= kNumberOfPages) return;
	if ([_arrayTodaysNews count] <= 0) return;
	
	CVTodaysNewsContentView *contentView;
	if (isLandscape == YES) {
		contentView = [_arrayLandscapeTodaysNews objectAtIndex:page];
		
		//如果contentView为空，则创建新的contentView进行替换
		if ((NSNull *)contentView == [NSNull null]) { 
			contentView = [[CVTodaysNewsContentView alloc] init];
			[_arrayLandscapeTodaysNews replaceObjectAtIndex:page withObject:contentView];
			[contentView release];
		}
		
		if (nil == contentView.superview) {
			CGRect frame = _contentScrollPageView.frame;
			frame.origin.x = frame.size.width * page;
			frame.origin.y = 0;
			contentView.frame = frame;
			
			for (NSInteger i = 0; i < 4; i++) {
				NSDictionary *dict = [_arrayTodaysNews objectAtIndex:page*4+i];
				NSString *strthumb = [dict valueForKey:@"smallUrl"];
				NSMutableDictionary *dictionary;
				switch (i) {
					case 0:
						dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
															strthumb,@"picurl",
															contentView,@"contentView",
															@"first",@"imageID",nil];
						[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:dictionary];
						contentView.labelFirTitle.text = [dict valueForKey:@"title"];
						break;
					case 1:
						dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
															strthumb,@"picurl",
															contentView,@"contentView",
															@"second",@"imageID",nil];
						[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:dictionary];
						contentView.labelSecTitle.text = [dict valueForKey:@"title"];
						break;
					case 2:
						contentView.labelThiTitle.text = [dict valueForKey:@"title"];
						break;
					case 3:
						contentView.labelFouTitle.text = [dict valueForKey:@"title"];
						break;

					default:
						break;
				}
			}
			
			//[contentView.buttonThird  setFrame:CGRectMake(30.0, 250.0, 400.0, 20.0)];
			[contentView.buttonFirst addTarget:self action:@selector(clickFirstTodaysNews:) forControlEvents:UIControlEventTouchUpInside];
			[contentView.buttonSecond addTarget:self action:@selector(clickSecondTodaysNews:) forControlEvents:UIControlEventTouchUpInside];
			[contentView.buttonThird addTarget:self action:@selector(clickThirdTodaysNews:) forControlEvents:UIControlEventTouchUpInside];
			[contentView.buttonForth addTarget:self action:@selector(clickForthTodaysNews:) forControlEvents:UIControlEventTouchUpInside];
			
			
			[_contentScrollPageView addSubview:contentView];
		}
		
		
		
		for (CVTodaysNewsContentView *contentPortraitView in _arrayPortraitTodaysNews) {
			if ((NSNull *)contentPortraitView != [NSNull null])
				[contentPortraitView setHidden:YES];
		}
		[contentView setHidden:NO];
		
	}
	else{
		contentView = [self.arrayPortraitTodaysNews objectAtIndex:page];
		if ((NSNull *)contentView == [NSNull null]) { 
			contentView = [[CVTodaysNewsContentView alloc] init];
			[_arrayPortraitTodaysNews replaceObjectAtIndex:page withObject:contentView];
			[contentView release];
		}
		
		if (nil == contentView.superview) {
			CGRect frame = _contentScrollPageView.frame;
			frame.origin.x = frame.size.width * page;
			frame.origin.y = 0;
			contentView.frame = frame;
			
			for (NSInteger i = 0; i < 3; i++) {
				NSDictionary *dict = [_arrayTodaysNews objectAtIndex:page*3+i];
				NSString *strthumb = [dict valueForKey:@"smallUrl"];
				NSMutableDictionary *dictionary;
				switch (i) {
					case 0:
						dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									  strthumb,@"picurl",
									  contentView,@"contentView",
									  @"first",@"imageID",nil];
						[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:dictionary];
						contentView.labelFirTitle.text = [dict valueForKey:@"title"];
						break;
					case 1:
						dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									  strthumb,@"picurl",
									  contentView,@"contentView",
									  @"second",@"imageID",nil];
						[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:dictionary];
						contentView.labelSecTitle.text = [dict valueForKey:@"title"];
						break;
					case 2:
						dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									  strthumb,@"picurl",
									  contentView,@"contentView",
									  @"third",@"imageID",nil];
						[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:dictionary];
						contentView.labelThiTitle.text = [dict valueForKey:@"title"];
						break;
						
					default:
						break;
				}
			}
			
			[contentView.imageFirThumb setFrame:CGRectMake(12.0, 5.0, 230.0, 160.0)];
			[contentView.imageSecThumb setFrame:CGRectMake(257.0, 5.0, 230.0, 160.0)];
			[contentView.imageThiThumb setFrame:CGRectMake(502.0, 5.0, 230.0, 160.0)];
			
			[contentView.labelFirTitle setFrame:CGRectMake(12.0, 170.0, 230.0, 40.0)];
			[contentView.labelSecTitle setFrame:CGRectMake(257.0, 170.0, 230.0, 40.0)];
			[contentView.labelThiTitle setFrame:CGRectMake(502.0, 170.0, 230.0, 40.0)];
			
			
			[contentView.buttonFirst setFrame:CGRectMake(12.0, 5.0, 230.0, 210.0)];
			[contentView.buttonFirst addTarget:self action:@selector(clickFirstTodaysNews:) forControlEvents:UIControlEventTouchUpInside];
			
			[contentView.buttonSecond setFrame:CGRectMake(257.0, 5.0, 230.0, 210.0)];
			[contentView.buttonSecond addTarget:self action:@selector(clickSecondTodaysNews:) forControlEvents:UIControlEventTouchUpInside];
			
			[contentView.buttonThird setFrame:CGRectMake(502.0, 5.0, 230.0, 210.0)];
			[contentView.buttonThird addTarget:self action:@selector(clickThirdTodaysNews:) forControlEvents:UIControlEventTouchUpInside];
			
			
			[_contentScrollPageView addSubview:contentView];
		}
		
		

		for (CVTodaysNewsContentView *contentLandscapeView in _arrayLandscapeTodaysNews) {
			if ((NSNull *)contentLandscapeView != [NSNull null])
				[contentLandscapeView setHidden:YES];
		}
		[contentView setHidden:NO];
	}
	[_contentScrollPageView reloadInputViews];
}

//加载图片线程
- (void) loadImage:(id)imageInfo{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableDictionary *dict = imageInfo;
	NSString *str = [dict valueForKey:@"picurl"];
	CVTodaysNewsContentView *contentView = [dict valueForKey:@"contentView"];
	NSString *strID = [dict valueForKey:@"imageID"];
	NSURL *url = [NSURL URLWithString:str];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *img = [[UIImage alloc] initWithData:imageData];
	if ([strID isEqualToString:@"first"]) {
		contentView.imageFirThumb.image = img;
	}
	else if([strID isEqualToString:@"second"]){
		contentView.imageSecThumb.image = img;
	}
	else {
		contentView.imageThiThumb.image = img;
	}
	[dict release];
	[pool release];
}

- (void)didRecievedImage:(UIImage *)image forUrl:(NSString *)url{
	//NSString *imgurl = url;
	//UIImage *img = image;
}

- (void)didRunIntoError:(NSError *)error forUrl:(NSString *)url{
}


//图片的url地址转换成image
- (UIImage *)stringToImage:(NSString *)str{
	NSURL *url = [NSURL URLWithString:str];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *img = [[UIImage alloc] initWithData:imageData];
	return img;
}
#pragma mark -
#pragma mark Click Today's News content

- (void)clickFirstTodaysNews:(id)sender{
	[self didSpreadToFullScreen];
	//NSDictionary *dict;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:_pagePortrait*3];
	}
	else{
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:_pageLandscape*4];
	}
	[self loadWebContent:_dictCurrentNews];
}

- (void) clickSecondTodaysNews:(id)sender{
	[self didSpreadToFullScreen];
	//NSDictionary *dict;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:_pagePortrait*3+1];
	}
	else{
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:_pageLandscape*4+1];
	}
	[self loadWebContent:_dictCurrentNews];
}

- (void) clickThirdTodaysNews:(id)sender{
	[self didSpreadToFullScreen];
	//NSDictionary *dict;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:_pagePortrait*3+2];
	}
	else{
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:_pageLandscape*4+2];
	}
	[self loadWebContent:_dictCurrentNews];
}

- (void) clickForthTodaysNews:(id)sender{
	[self didSpreadToFullScreen];
	//NSDictionary *dict;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:_pagePortrait*3+3];
	}
	else{
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:_pageLandscape*4+3];
	}
	[self loadWebContent:_dictCurrentNews];
}

#pragma mark -
#pragma mark FullScreen

- (void)didSpreadToFullScreen{
	_boolFullScreen = YES;
	[_buttonFullscreen setHidden:YES];
	[_contentScrollPageView setHidden:YES];
	[_pageNews setHidden:YES];
	
	[_buttonRestore setHidden:NO];
	if (_webView) {
		[_webView setHidden:NO];
	}
	
	if ([_arrayButtonTitle count]<=0) {
		_arrayButtonTitle = [[NSArray alloc] initWithObjects:@"Headline News",@"Latest News",@"Macro",@"Discretianary",@"Staples",@"Financials",
						 @"Health Care",@"Industrials",@"Materials",@"Energy",@"Telecom",@"Utilities",@"IT",nil];
	}
	if (!_webView) {
		_webView = [[UIWebView alloc] init];
		[self addSubview:_webView];
		//[self insertSubview:_webView atIndex:0];
	}
	
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self loadProtriatFullView];
	}
	else {
		[self loadLandscapeFullView];
	}

}

- (void)loadLandscapeFullView{
	if (_imageButtonBackground) {
		[_imageButtonBackground setHidden:YES];
	}
	if (_imageButtonSecondBackground) {
		[_imageButtonSecondBackground setHidden:YES];
	}
	if (_imageButtonLandscapeBackground) {
		[_imageButtonLandscapeBackground setHidden:NO];
	}
	if (_imageTableBackground) {
		[_imageTableBackground setHidden:NO];
	}
	CGRect rc = [[UIScreen mainScreen] applicationFrame];
	[self setFrame:CGRectMake(0.0, 0.0, rc.size.height, rc.size.width)];
	[_imageBackground setFrame:CGRectMake(16.0f, 72.0f, 981.0f, 653.0f)];
	[_labelTitle setFrame:CGRectMake(35.0f, 83.0f, 200.0f, 30.0f)];
	UIImage *image = [UIImage imageNamed:@"todaysnews_full_landscape.png"];
	_imageBackground.image = image;
	_imageBackground.userInteractionEnabled = YES;
	
	[_buttonRefresh setFrame:CGRectMake(870.0, 85.0, 25.0, 25.0)];
	[_buttonRestore setFrame:CGRectMake(900.0, 85.0, 25.0, 25.0)];
	[_buttonSetting setFrame:CGRectMake(930.0, 85.0, 30.0, 25.0)];
	
	UIImage *imgsilver = [UIImage imageNamed:@"silver_landscape_bar.png"];
	if (!_imageButtonLandscapeBackground) {
		_imageButtonLandscapeBackground = [[UIImageView alloc] init];
		[self addSubview:_imageButtonLandscapeBackground];
	}
	[_imageButtonLandscapeBackground setFrame:CGRectMake(16.0, 117.0, 981.0, 38.0)];
	_imageButtonLandscapeBackground.image = imgsilver;
	_imageButtonLandscapeBackground.userInteractionEnabled = YES;
	
	BOOL isAddButtonArray = NO;
	if ([_arrayButtonsLandscape count]<=0) {
		isAddButtonArray = YES;
	}
	else {
		_arrayButtons = _arrayButtonsLandscape;
	}
	if ([_arrayButtonTitle count]>0 && [[_imageButtonLandscapeBackground subviews] count]<=0) {
		CGFloat X = 15;
		for (NSInteger i = 0; i<[_arrayButtonTitle count]; i++) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.tag = i;
			
			NSString *strTitle = [_arrayButtonTitle objectAtIndex:i];
			UIFont *font = [UIFont systemFontOfSize:14.0];
			CGSize stringSize = [strTitle sizeWithFont:font]; //规定字符字体获取字符串Size，再获取其宽度。
			CGFloat width = stringSize.width + 5;
			
			[button setFrame:CGRectMake(X, 5.0, width, 30.0)];
			
			if (i < [_arrayButtonTitle count]-1) {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X+width+5, 5.0, 3.0, 30.0)];
				label.text = @"|";
				label.backgroundColor = [UIColor clearColor];
				label.textColor = [UIColor blackColor];
				[_imageButtonLandscapeBackground addSubview:label];
			}
			
			X = X + width + 10;
			//[button setFrame:CGRectMake(10.0+i*120, 5.0, 100.0, 30.0)];
			[button setTitle:strTitle forState:UIControlStateNormal];
			[button setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont systemFontOfSize:14.0];
			[button addTarget:self action:@selector(clickNewsButton:) forControlEvents:UIControlEventTouchUpInside];
			[_imageButtonLandscapeBackground addSubview:button];
			
			if (isAddButtonArray == YES) {
				//_arrayButtons = [[NSMutableArray alloc] init];
				//[_arrayButtons addObject:button];
				[_arrayButtonsLandscape addObject:button];
				_arrayButtons = _arrayButtonsLandscape;
			}
		}
	}
	
	if (!_imageTableBackground) {
		_imageTableBackground = [[UIImageView alloc] init];
		[self addSubview:_imageTableBackground];
	}
	[_imageTableBackground setFrame:CGRectMake(16.0, 155.0, 283.0, 570.0)];
	UIImage *imgTable = [UIImage imageNamed:@"todaysnews_table_background.png"];
	_imageTableBackground.image = imgTable;
	_imageTableBackground.userInteractionEnabled = YES;
	
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		[_imageTableBackground addSubview:_tableView];
		//[_imageTableBackground insertSubview:_tableView atIndex:0];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	[_tableView setFrame:CGRectMake(0.0, 0.0, 275.0, 565.0)];
	_arrayTable = _arrayTodaysNews;
	
	
	[_webView setFrame:CGRectMake(300.0, 155.0, 697.0, 570.0)];
	if ([_dictCurrentNews count]<=0) {
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:0];
	}
	[self loadWebContent:_dictCurrentNews];
	[self reloadTableViewAndWebView:YES];
}

- (void)loadProtriatFullView{
	if (_imageButtonBackground) {
		[_imageButtonBackground setHidden:NO];
	}
	if (_imageButtonSecondBackground) {
		[_imageButtonSecondBackground setHidden:NO];
	}
	if (_imageButtonLandscapeBackground) {
		[_imageButtonLandscapeBackground setHidden:YES];
	}
	if (_imageTableBackground) {
		[_imageTableBackground setHidden:YES];
	}

	CGRect frame = [[UIScreen mainScreen] applicationFrame];	
	[self setFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
	[_imageBackground setFrame:CGRectMake(16.0f, 72.0f, 732.0f, 914.0f)];
	[_labelTitle setFrame:CGRectMake(35.0f, 83.0f, 200.0f, 30.0f)];
	UIImage *image = [UIImage imageNamed:@"todaysnews_full_portrait.png"];
	_imageBackground.image = image;
	
	[_buttonRefresh setFrame:CGRectMake(621.0, 85.0, 25.0, 25.0)];
	[_buttonRestore setFrame:CGRectMake(651.0, 85.0, 25.0, 25.0)];
	[_buttonSetting setFrame:CGRectMake(691.0, 85.0, 30.0, 25.0)];
	
	UIImage *imgsilver = [UIImage imageNamed:@"silver_bar.png"];
	if (!_imageButtonBackground) {
		_imageButtonBackground = [[UIImageView alloc] init];
		[self addSubview:_imageButtonBackground];
	}
	if (!_imageButtonSecondBackground) {
		_imageButtonSecondBackground = [[UIImageView alloc] init];
		[self addSubview:_imageButtonSecondBackground];
	}
	[_imageButtonBackground setFrame:CGRectMake(16.0, 117.0, 732.0, 37.0)];
	[_imageButtonSecondBackground setFrame:CGRectMake(16.0, 153.0, 732.0, 37.0)];

	_imageButtonBackground.image = imgsilver;
	_imageButtonSecondBackground.image = imgsilver;
	
	_imageButtonBackground.userInteractionEnabled = YES;  //设置为yes,否则按钮点击事件不触发
	_imageButtonSecondBackground.userInteractionEnabled = YES;
	
	BOOL isAddButtonArray = NO;
	if ([_arrayButtonsPortrait count]<=0) {
		isAddButtonArray = YES;
	}
	else {
		_arrayButtons = _arrayButtonsPortrait;
	}

	
	if ([_arrayButtonTitle count]>0 && [[_imageButtonBackground subviews] count]<=0) {
		CGFloat X = 30;
		for (NSInteger i = 0; i<[_arrayButtonTitle count]/2; i++) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; 
			button.tag = i;
			
			NSString *strTitle = [_arrayButtonTitle objectAtIndex:i];
			UIFont *font =  [UIFont systemFontOfSize:15.0];
			CGSize stringSize = [strTitle sizeWithFont:font]; //规定字符字体获取字符串Size，再获取其宽度。
			CGFloat width = stringSize.width + 15;
			
			[button setFrame:CGRectMake(X, 5.0, width, 30.0)];
			
			if (i < [_arrayButtonTitle count]/2-1) {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X+width+15, 5.0, 3.0, 30.0)];
				label.text = @"|";
				label.backgroundColor = [UIColor clearColor];
				label.textColor = [UIColor blackColor];
				[_imageButtonBackground addSubview:label];
			}
			
			
			X = X + width + 30;
			//[button setFrame:CGRectMake(10.0+i*120, 5.0, 100.0, 30.0)];
			[button setTitle:strTitle forState:UIControlStateNormal];
			[button setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont systemFontOfSize:15.0];
			[button addTarget:self action:@selector(clickNewsButton:) forControlEvents:UIControlEventTouchUpInside];
			[_imageButtonBackground addSubview:button];
			
			if (isAddButtonArray == YES) {
				//_arrayButtons = [[NSMutableArray alloc] init];
				[_arrayButtonsPortrait addObject:button];
				_arrayButtons = _arrayButtonsPortrait;
			}
		}
		X = 30;
		for (NSInteger i = [_arrayButtonTitle count]/2; i < [_arrayButtonTitle count]; i++) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; 
			button.tag = i;
			
			
			NSString *strTitle = [_arrayButtonTitle objectAtIndex:i];
			UIFont *font =  [UIFont systemFontOfSize:15.0];
			CGSize stringSize = [strTitle sizeWithFont:font]; //规定字符字体获取字符串Size，再获取其宽度。
			CGFloat width = stringSize.width + 15;
			
			[button setFrame:CGRectMake(X, 5.0, width, 30.0)];
			
			if (i < [_arrayButtonTitle count]-1) {    //为button添加分隔符
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X+width+15, 5.0, 3.0, 30.0)];
				label.text = @"|";
				label.backgroundColor = [UIColor clearColor];
				label.textColor = [UIColor blackColor];
				[_imageButtonSecondBackground addSubview:label];
			}
			
			X = X + width + 30;
			
			//[button setFrame:CGRectMake(10.0+(i-[_arrayButtons count]/2)*100, 5.0, 90.0, 30.0)];
			[button setTitle:strTitle forState:UIControlStateNormal];
			[button setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont systemFontOfSize:15.0];
			[button addTarget:self action:@selector(clickNewsButton:) forControlEvents:UIControlEventTouchUpInside];
			[_imageButtonSecondBackground addSubview:button];
			
			if (isAddButtonArray == YES) {
				//_arrayButtons = [[NSMutableArray alloc] init];
				[_arrayButtonsPortrait addObject:button];
				_arrayButtons = _arrayButtonsPortrait;
			}
		}
	}
	if (!_tableView) {
		_tableView = [[UITableView alloc] init];
		[_imageTableBackground addSubview:_tableView];
		//[_imageTableBackground insertSubview:_tableView atIndex:0];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	//[self reloadTableViewAndWebView];
	[_webView setFrame:CGRectMake(17.0, 200.0, 730.0, 784.0)];	
	if ([_dictCurrentNews count]<=0) {
		_dictCurrentNews = [_arrayTodaysNews objectAtIndex:0];
	}
	[self loadWebContent:_dictCurrentNews];
}

#pragma mark -
#pragma mark RestoreScreen

- (void)didSpreadToRestoreScreen{
	_boolFullScreen = NO;
	[_buttonFullscreen setHidden:NO];
	[_contentScrollPageView setHidden:NO];
	[_pageNews setHidden:NO];
	
	[_buttonRestore setHidden:YES];
	if (_imageButtonBackground) {
		[_imageButtonBackground setHidden:YES];
	}
	if (_imageButtonSecondBackground) {
		[_imageButtonSecondBackground setHidden:YES];
	}
	if (_imageButtonLandscapeBackground) {
		[_imageButtonLandscapeBackground setHidden:YES];
	}
	if (_imageTableBackground) {
		[_imageTableBackground setHidden:YES];
	}
	if (_webView) {
		[_webView setHidden:YES];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self loadProtriatRestoreView];
	}
	else {
		[self loadLandscapeRestoreView];
	}
	
}

//全屏模式时，点击按钮触发的事件
#pragma mark -
#pragma mark FullScreen Action
- (void)clickNewsButton:(id)sender{
	UIButton *button = sender;
	NSInteger i = button.tag;
	if (i != _iChecked) {
		for (id btn in _arrayButtons) {
			UIButton *selButton = btn;
			if (selButton.tag == _iChecked) {
				[btn setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
				break;
			}
		}
		_iChecked = i;
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	[self loadNewsClassList:i];
}

- (void)loadNewsClassList:(NSInteger)number{
	BOOL isQuery = NO;       //如果返回为YES,则需要通过Webservice查询，返回填充array
	NSString *strNewsURL;
	switch (number) {
		case 0:
			if ([_arrayHeadlineNews count]<=0) {
				isQuery = YES; 
				strNewsURL = @"GetHeadlineNews%28%29";
			}
			else {
				_arrayTable = _arrayHeadlineNews;
				[self reloadTableViewAndWebView];
			}
			break;
		case 1:
			if ([_arrayLatestNews count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetLatestNews%28%29";
			}
			else {
				_arrayTable = _arrayLatestNews;
				[self reloadTableViewAndWebView];
			}
			break;
		case 2:
			if ([_arrayMacro count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetMacroNews%28%29";
			}
			else {
				_arrayTable = _arrayMacro;
				[self reloadTableViewAndWebView];
			}
			break;
		case 3:
			if ([_arrayDiscretionary count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28%22consumer+discretionary%22%29";
			}
			else {
				_arrayTable = _arrayDiscretionary;
				[self reloadTableViewAndWebView];
			}
			break;
		case 4:
			if ([_arrayStaples count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28%22consumer+staples%22%29";
			}
			else {
				_arrayTable = _arrayStaples;
				[self reloadTableViewAndWebView];
			}
			break;
		case 5:
			if ([_arrayFinancials count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28%22financial%22%29";
			}
			else {
				_arrayTable = _arrayFinancials;
				[self reloadTableViewAndWebView];
			}
			break;
		case 6:
			if ([_arrayHealthCare count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28%22health+care%22%29";
			}
			else {
				_arrayTable = _arrayHealthCare;
				[self reloadTableViewAndWebView];
			}
			break;
		case 7:
			if ([_arrayIndustrials count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28Industrials%29";
			}
			else {
				_arrayTable = _arrayIndustrials;
				[self reloadTableViewAndWebView];
			}
			break;
		case 8:
			if ([_arrayMaterials count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28Materials%29";
			}
			else {
				_arrayTable = _arrayMaterials;
				[self reloadTableViewAndWebView];
			}
			break;
		case 9:
			if ([_arrayEnergy count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28Energy%29";
			}
			else {
				_arrayTable = _arrayEnergy;
				[self reloadTableViewAndWebView];
			}
			break;
		case 10:
			if ([_arrayTelecom count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28Telecom%29";
			}
			else {
				_arrayTable = _arrayTelecom;
				[self reloadTableViewAndWebView];
			}
			break;
		case 11:
			if ([_arrayUtilities count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28Utilities%29";
			}
			else {
				_arrayTable = _arrayUtilities;
				[self reloadTableViewAndWebView];
			}
			break;
		case 12:
			if ([_arrayIT count]<=0) {
				isQuery = YES;
				strNewsURL = @"GetIndustryNews%28IT%29";
			}
			else {
				_arrayTable = _arrayIT;
				[self reloadTableViewAndWebView];
			}
			break;
		default:
			break;
	}
	if (isQuery == YES) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		ServiceRequest *request;
		
		request = [[ServiceRequest alloc] init];
		request.url = strNewsURL;
		_response  = [[CVTodaysNewsServiceResponse alloc] init];
		
		[_response setDelegate:self];
		[_response startQueryAndParse:request];
		
		
		[pool release];
	}
}

//通过xml解析后，返回结果
- (void)queryFinished:(NSDictionary *)data {
	NSString *strNewsStyle = [data valueForKey:@"NewsStyle"];
	if ([strNewsStyle isEqualToString:@"GetHeadlineNews%28%29"]) {
		_arrayHeadlineNews = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayHeadlineNews;
	}
	else if([strNewsStyle isEqualToString:@"GetLatestNews%28%29"]) {
		_arrayLatestNews = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayLatestNews;
	}
	else if([strNewsStyle isEqualToString:@"GetMacroNews%28%29"]) {
		_arrayMacro = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayMacro;
	}
	else if([strNewsStyle isEqualToString:@"GetIndustryNews%28%22consumer+discretionary%22%29"]) {
		_arrayDiscretionary = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayDiscretionary;
	}
	else if([strNewsStyle isEqualToString:@"GetIndustryNews%28%22consumer+staples%22%29"]) {
		_arrayStaples = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayStaples;
	}
	else if([strNewsStyle isEqualToString:@"GetIndustryNews%28%22Financials%22%29"]) {
		_arrayFinancials = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayFinancials;
	}
	else if([strNewsStyle isEqualToString:@"GetIndustryNews%28%22health+care%22%29"]) {
		_arrayHealthCare = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayHealthCare;
	}
	else if([strNewsStyle isEqualToString:@"GetIndustryNews%28Industrials%29"]) {
		_arrayIndustrials = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayIndustrials;
	}
	else if([strNewsStyle isEqualToString:@"GetIndustryNews%28Materials%29"]) {
		_arrayIndustrials = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayIndustrials;
	}
	else if([strNewsStyle isEqualToString:@"GetIndustryNews%28Energy%29"]) {
		_arrayMaterials = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayMaterials;
	}
	else if([strNewsStyle isEqualToString:@"GetIndustryNews%28Telecom%29"]) {
		_arrayEnergy = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayEnergy;
	}
	else if([strNewsStyle isEqualToString:@"GetIndustryNews%28Utilities%29"]) {
		_arrayUtilities = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayUtilities;
	}
	else{
		_arrayIT = [data valueForKey:@"TodaysNewsDataSet"];
		_arrayTable = _arrayIT;
	}
	[self reloadTableViewAndWebView];
}

- (void)reloadTableViewAndWebView:(BOOL)isChangeOriention{
	if (_todaysnewsPopoverView) {
		[_todaysnewsPopoverView removeFromSuperview];
		_todaysnewsPopoverView = nil;
	}
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
	}
	else {
		[_tableView setFrame:CGRectMake(0.0, 0.0, 275.0, 565.0)];
		[_imageTableBackground addSubview:_tableView];
	}
	[_tableView reloadData];
	[self loadWebContent:_dictCurrentNews];
}

- (void)reloadTableViewAndWebView{
	if (_todaysnewsPopoverView) {
		[_todaysnewsPopoverView removeFromSuperview];
		_todaysnewsPopoverView = nil;
	}
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		CGRect frame;
		UIButton *selButton;
		NSUInteger i;
		for(id button in _arrayButtons){
			selButton = button;
			if (selButton.tag == _iChecked) {
				frame = selButton.frame;
				i = selButton.tag;
				break;
			}
		}
		UIImage *img;
		switch (i) {
			case 0:
			case 1:
			case 2:
			case 3:
				_todaysnewsPopoverView = [[CVTodaysNewsPopoverView alloc] initWithFrame:CGRectMake(frame.origin.x+frame.size.width/2-40, frame.origin.y+140, 302.0, 681.0)];
				img = [UIImage imageNamed:@"todaysnews_list_background.png"];
				break;
			case 4:
			case 5:
				_todaysnewsPopoverView = [[CVTodaysNewsPopoverView alloc] initWithFrame:CGRectMake(frame.origin.x-205, frame.origin.y+140, 302.0, 681.0)];
				img = [UIImage imageNamed:@"todaysnews_list_background_right.png"];
				break;
			case 6:
			case 7:
			case 8:
			case 9:
				_todaysnewsPopoverView = [[CVTodaysNewsPopoverView alloc] initWithFrame:CGRectMake(frame.origin.x+frame.size.width/2-40, frame.origin.y+140+36, 302.0, 681.0)];
				img = [UIImage imageNamed:@"todaysnews_list_background.png"];
				break;
			case 10:
			case 11:
				_todaysnewsPopoverView = [[CVTodaysNewsPopoverView alloc] initWithFrame:CGRectMake(frame.origin.x-205, frame.origin.y+140+36, 302.0, 681.0)];
				img = [UIImage imageNamed:@"todaysnews_list_background_right.png"];
				break;
			case 12:
				_todaysnewsPopoverView = [[CVTodaysNewsPopoverView alloc] initWithFrame:CGRectMake(frame.origin.x-220, frame.origin.y+140+36, 302.0, 681.0)];
				img = [UIImage imageNamed:@"todaysnews_list_background_right.png"];
				break;
				
			default:
				break;
		}

		_todaysnewsPopoverView.labelTitle.text = selButton.currentTitle;
		_todaysnewsPopoverView.imgbackground.image = img;
		[self addSubview:_todaysnewsPopoverView];
		[_tableView setFrame:CGRectMake(5.0, 68.0, 292.0, 608.0)];
		[_todaysnewsPopoverView insertSubview:_tableView atIndex:0];
	}
	else {
		[_tableView setFrame:CGRectMake(0.0, 0.0, 275.0, 565.0)];
		[_imageTableBackground addSubview:_tableView];
	}

	[_tableView reloadData];
	//NSMutableDictionary *dict = [_arrayTable objectAtIndex:0];
	//[self loadWebContent:dict];
	_dictCurrentNews = [_arrayTable objectAtIndex:0];
	[self loadWebContent:_dictCurrentNews];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (_todaysnewsPopoverView) {
		[_todaysnewsPopoverView removeFromSuperview];
		[_todaysnewsPopoverView release];
		_todaysnewsPopoverView = nil;
	}
}

- (void)loadWebContent:(NSDictionary *)dict{
	if ([dict count]<=0) {
		return;
	}
	NSString *strTitle = [dict valueForKey:@"title"];
	NSString *strTimeStamp  = [dict valueForKey:@"t_stamp"];
	NSString *strBody  = [dict valueForKey:@"body"];
	strBody = [self addImageUrl:strBody];
	NSString *strTime = [self stampchangetime:strTimeStamp isDetail:YES];
	
	NSMutableString *strContent = [[NSMutableString alloc] init];
	[strContent appendFormat:@"<div align = \"left\">"];
	[strContent appendFormat:@"<font size = \"5\" style=\"font-weight:bold\">"];
	[strContent appendString:strTitle];
	[strContent appendFormat:@"</br>"];
	[strContent appendFormat:@"</font></br></div>"];
	
	[strContent appendFormat:@"<div align = \"left\">"];
	[strContent appendString:strTime];
	[strContent appendFormat:@"</div>"];
	
	[strContent appendString:strBody];
	[_webView loadHTMLString:strContent baseURL:[NSURL URLWithString:@"http://data.capitalvue.com"]];
	[strContent release];
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
		[formatter setDateFormat:@"EEEE yyyy-MM-dd HH:mm"];
		str = [formatter stringFromDate:date];
	}
	else {

		[formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
		str = [formatter stringFromDate:date];
	}
	
	return str;
}

#pragma mark -
#pragma mark TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [_arrayTable count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	CVTodaysNewsTableViewCell *cell = (CVTodaysNewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CVTodaysNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	NSMutableDictionary *dict = [_arrayTable objectAtIndex:indexPath.row];
	NSString *strTitle = [dict valueForKey:@"title"];
	NSString *strStamp = [dict valueForKey:@"t_stamp"];
	cell.strTitle = strTitle;
	cell.strTime  = [self stampchangetime:strStamp isDetail:NO];
	if (indexPath.row<=1) {
		NSString *strThumb = [dict valueForKey:@"thumbUrl"];
		if ([strThumb isEqualToString:@"http://www.capitalvue.com/avatardownload.php?ck=f814a7dca13dbbe901e07ecea204426910rz&size=160&mode=canvas"]) {
			cell.strThumbnail = nil;
		}
		else {
			cell.strThumbnail = strThumb;
		}
	}
	else {
		cell.strThumbnail = nil;
	}

	[cell removeElement];
	[cell addElement];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//return 80;
	if (indexPath.row < 2) {
		NSMutableDictionary *dict = [_arrayTable objectAtIndex:indexPath.row];
		NSString *strThumb = [dict valueForKey:@"thumbUrl"];
		if ([strThumb isEqualToString:@"http://www.capitalvue.com/avatardownload.php?ck=f814a7dca13dbbe901e07ecea204426910rz&size=160&mode=canvas"]) {
			return 80;
		}
		else {
			return 220;
		}
	}
	else {
		return 80;
	}

}

#pragma mark -
#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//如果是竖屏，出现popover窗口，点击后就消失
	if (_todaysnewsPopoverView) {
		[_todaysnewsPopoverView removeFromSuperview];
		_todaysnewsPopoverView = nil;
	}
	_dictCurrentNews = [_arrayTable objectAtIndex:indexPath.row];
	[self loadWebContent:_dictCurrentNews];
}

- (void)dealloc {
	[_contentScrollPageView release];
	
	[_arrayTodaysNews release];
	[_arrayHeadlineNews release];
	[_arrayLatestNews release];
	[_arrayMacro release];
	[_arrayDiscretionary release];
	[_arrayStaples release];
	[_arrayFinancials release];
	[_arrayHealthCare release];
	[_arrayIndustrials release];
	[_arrayMaterials release];
	[_arrayEnergy release];
	[_arrayTelecom release];
	[_arrayUtilities release];
	[_arrayIT release];
	[_arrayTable release];
	
	[_pageNews release];
	[_arrayPortraitTodaysNews release]; 
	[_arrayLandscapeTodaysNews release];
	[_arrayButtonTitle release];
	[_webView release];
	[_dictCurrentNews release];
	[_imageButtonBackground release];
	[_imageButtonSecondBackground release];
	[_imageButtonLandscapeBackground release];
	[_imageTableBackground release];
	[_tableView release];
	
	[_arrayButtons release];
	[_arrayButtonsPortrait release];
	[_arrayButtonsLandscape release];
	
	[_response release];
	if (_todaysnewsPopoverView) {
		[_todaysnewsPopoverView release];
	}
    [super dealloc];
}


@end
