//
//  CVTodaysNewsView.h
//  CapitalValDemo
//
//  Created by leon on 10-8-12.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPortletView.h"
#import "CVContentScrollPageView.h"
#import "CVImageCache.h"
#import "CVTodaysNewsServiceResponse.h"
#import "CVTodaysNewsPopoverView.h"
#import "CVPageControlView.h"

@interface CVTodaysNewsView : CVPortletView <UIScrollViewDelegate,CVImageCacheDelegate,UITableViewDelegate,UITableViewDataSource>
{
	CVContentScrollPageView *_contentScrollPageView;
	//CVTodaysNewsFullController *_cvFullController;

	NSArray *_arrayTodaysNews;     //小窗口时，Today's News数据
	NSArray *_arrayHeadlineNews;
	NSArray *_arrayLatestNews;
	NSArray *_arrayMacro;
	NSArray *_arrayDiscretionary;
	NSArray *_arrayStaples;
	NSArray *_arrayFinancials;
	NSArray *_arrayHealthCare;
	NSArray *_arrayIndustrials;
	NSArray *_arrayMaterials;
	NSArray *_arrayEnergy;
	NSArray *_arrayTelecom;
	NSArray *_arrayUtilities;
	NSArray *_arrayIT;
	
	NSArray *_arrayTable;
	
	//UIPageControl *_pageNews;
	CVPageControlView *_pageNews;
	
	NSMutableArray *_arrayPortraitTodaysNews;     //存储竖屏TodaysNewsContentView对象
	NSMutableArray *_arrayLandscapeTodaysNews;    //存储横屏TodaysNewsContentView对象

	BOOL _boolUsed;
	BOOL _boolFullScreen;
	
	NSUInteger _pageLandscape;
	NSUInteger _pagePortrait;
	
	NSArray		   *_arrayButtonTitle;                  //全屏模式时，栏目按钮标题数组
	NSMutableArray *_arrayButtons;
	NSMutableArray *_arrayButtonsLandscape;
	NSMutableArray *_arrayButtonsPortrait;
	UIWebView      *_webView;
	NSDictionary   *_dictCurrentNews;            //当前选择的一条新闻
	
	UIImageView *_imageButtonBackground;         //竖屏Buttons第一栏背景
	UIImageView *_imageButtonSecondBackground;   //竖屏Buttons第二栏背景
	UIImageView *_imageButtonLandscapeBackground;//横屏Buttons栏背景
	UIImageView *_imageTableBackground;          //tableview背景
	NSUInteger _iChecked;                        //保存当前选择的按钮Tag
	
	UITableView *_tableView;
	
	CVTodaysNewsServiceResponse *_response;
	CVTodaysNewsPopoverView *_todaysnewsPopoverView;
}

@property (nonatomic, retain) CVPageControlView *pageNews;
@property (nonatomic, retain) CVContentScrollPageView *contentScrollPageView;
@property (nonatomic, retain) NSArray *arrayTodaysNews;
@property (nonatomic, retain) NSArray *arrayHeadlineNews;
@property (nonatomic, retain) NSArray *arrayLatestNews;
@property (nonatomic, retain) NSArray *arrayMacro;
@property (nonatomic, retain) NSArray *arrayDiscretionary;
@property (nonatomic, retain) NSArray *arrayStaples;
@property (nonatomic, retain) NSArray *arrayFinancials;
@property (nonatomic, retain) NSArray *arrayHealthCare;
@property (nonatomic, retain) NSArray *arrayIndustrials;
@property (nonatomic, retain) NSArray *arrayMaterials;
@property (nonatomic, retain) NSArray *arrayEnergy;
@property (nonatomic, retain) NSArray *arrayTelecom;
@property (nonatomic, retain) NSArray *arrayUtilities;
@property (nonatomic, retain) NSArray *arrayIT;
@property (nonatomic, retain) NSArray *arrayTable;

@property (nonatomic, retain) NSMutableArray *arrayPortraitTodaysNews;
@property (nonatomic, retain) NSMutableArray *arrayLandscapeTodaysNews;
@property (nonatomic, retain) NSArray *arrayButtonTitle;
@property (nonatomic, retain) NSMutableArray *arrayButtons;
@property (nonatomic, retain) NSMutableArray *arrayButtonsLandscape;
@property (nonatomic, retain) NSMutableArray *arrayButtonsPortrait;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSDictionary *dictCurrentNews;
@property (nonatomic, retain) UIImageView *imageButtonBackground;
@property (nonatomic, retain) UIImageView *imageButtonSecondBackground;
@property (nonatomic, retain) UIImageView *imageButtonLandscapeBackground;
@property (nonatomic, retain) UIImageView *imageTableBackground;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) CVTodaysNewsServiceResponse *response;
@property (nonatomic, retain) CVTodaysNewsPopoverView *todaysnewsPopoverView;

@property NSUInteger pageLandscape;
@property NSUInteger pagePortrait;
@property NSUInteger iChecked;

- (void) clickFirstTodaysNews:(id)sender;
- (void) clickSecondTodaysNews:(id)sender;
- (void) clickThirdTodaysNews:(id)sender;
- (void) clickForthTodaysNews:(id)sender;

- (void) loadImage:(id)imageInfo;
- (IBAction)changePage:(id)sender;
- (UIImage *)stringToImage:(NSString *)str;
- (void) updateOrientation;
- (void) loadScrollViewWithPage:(int)page isLandscape:(BOOL)isLandscape;

- (void)clickNewsButton:(id)sender;
- (void)loadNewsClassList:(NSInteger)number;    //加载各类栏目的Array
- (void)loadWebContent:(NSDictionary *)dict;

- (void)reloadTableViewAndWebView;
- (void)reloadTableViewAndWebView:(BOOL)isChangeOriention;

- (NSString *)stampchangetime:(NSString *)timestamp isDetail:(BOOL)isDetail;
- (NSString *)addImageUrl:(NSString *)strContent;

- (void)loadFullStatus:(UIInterfaceOrientation)orientation;     //加载Todays News全屏模式
- (void)loadRestoreStatus:(UIInterfaceOrientation)orientation;  //加载Todays News小窗口模式

- (void)loadLandscapeRestoreView;      //加载Todays News小窗口横向模式
- (void)loadProtriatRestoreView;       //加载Todays News小窗口竖向模式

- (void)loadLandscapeFullView;         //加载Todays News全屏横向模式
- (void)loadProtriatFullView;          //加载Todays News全屏竖向模式

@end
