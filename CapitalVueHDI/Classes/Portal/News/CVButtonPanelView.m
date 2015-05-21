//
//  CVButtonPanelView.m
//  CapitalVueHD
//
//  Created by leon on 10-9-25.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVButtonPanelView.h"
#import "CVPortalSetNewsController.h"
#import "CVDataProvider.h"

@interface CVButtonPanelView()

@property (nonatomic, retain) NSMutableArray *_columnsContentArray;
@property (nonatomic, retain) NSMutableArray *arrayNews;

@end

@implementation CVButtonPanelView

@synthesize _columnsContentArray;
@synthesize arrayNews = _arrayNews;

@synthesize imageBackground = _imageBackground;
@synthesize arrayButtonTitle = _arrayButtonTitle;
@synthesize img = _img;
@synthesize isLandscape = _isLandscape;
@synthesize iChecked = _iChecked;
@synthesize portalSetNewsController = _portalSetNewsController;
@synthesize newsNavigatorController = _newsNavigatorController;
@synthesize popoverController = _popoverController;
#define CV_NEWS_MAX_PAGE 10
#define CV_NEWS_PAGECAPACITY 10

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		_iChecked = 0;
		_isLandscape = NO;
		_isClickButton = NO;
		_ifLoaded = YES;
		_arrayPortraitButtons = [[NSMutableArray alloc] init];
		_arrayLandscapeButtons = [[NSMutableArray alloc] init];
		
		_newsNavigatorController = [[CVNewsNavigatorController alloc] init];
		[_newsNavigatorController setDelegate:self];
		[_newsNavigatorController.tableView setFrame:CGRectMake(0, 0, 275, 600)];
		
		_popoverController = [[UIPopoverController alloc] initWithContentViewController:_newsNavigatorController];
		_popoverController.popoverContentSize = CGSizeMake(275, 600);
		
		NSMutableArray *aArray;
		NSUInteger i;
		aArray = [[NSMutableArray alloc] init];
		for (i = 0; i < 13; i++) {
			[aArray addObject:[NSNull null]];
		}
		self._columnsContentArray = aArray;
		[aArray release];
		
		_newsLock = [[NSLock alloc] init];
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.



- (void)createButtonPanel{
	if (_isLandscape == YES) {
		_imageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 
																		 self.frame.size.height)];
	}
	else {
		_imageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 
																		 self.frame.size.height/2)];//CGRectMake(0.0, 0.0, 732.0, 38.0)];
	}
	if (_img) {
		_imageBackground.image = _img;
	}
	
	_imageBackground.userInteractionEnabled = YES;
	[self addSubview:_imageBackground];
	
	if (_isLandscape == NO) {
		_imageSecondBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height/2, 
																			   self.frame.size.width, 
																			   self.frame.size.height/2)];
		if (_img) {
			_imageSecondBackground.image = _img;
		}
		
		_imageSecondBackground.userInteractionEnabled = YES;
		[self addSubview:_imageSecondBackground];
		
	}
	[self loadButtons];
}

- (void)loadButtons {
	if ([_arrayButtonTitle count]>0 && _isLandscape == YES) {
		CGFloat X = 15.0;
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
				[_imageBackground addSubview:label];
				[label release];
			}
			
			X = X + width + 10;
			[button setTitle:strTitle forState:UIControlStateNormal];
			[button setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont boldSystemFontOfSize:13.5];
			[button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
			[_imageBackground addSubview:button];
			
			[_arrayLandscapeButtons addObject:button];
		}
	}
	
	if ([_arrayButtonTitle count]>0 && _isLandscape == NO) {
		CGFloat X = 15;
		for (NSInteger i = 0; i<[_arrayButtonTitle count]/2; i++) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; 
			button.tag = i;
			
			NSString *strTitle = [_arrayButtonTitle objectAtIndex:i];
			UIFont *font =  [UIFont boldSystemFontOfSize:15.0];
			CGSize stringSize = [strTitle sizeWithFont:font]; //规定字符字体获取字符串Size，再获取其宽度。
			CGFloat width = stringSize.width + 15;
			
			[button setFrame:CGRectMake(X, 5.0, width, 30.0)];
			
			if (i < [_arrayButtonTitle count]/2-1) {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X+width+15, 5.0, 3.0, 30.0)];
				label.text = @"|";
				label.backgroundColor = [UIColor clearColor];
				label.textColor = [UIColor blackColor];
				[_imageBackground addSubview:label];
				[label release];
			}
			
			
			X = X + width + 30;
			[button setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
			[button setTitle:strTitle forState:UIControlStateNormal];
			[button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
			[_imageBackground addSubview:button];
			
			[_arrayPortraitButtons addObject:button];
		}
		X = 15;
		for (NSInteger i = [_arrayButtonTitle count]/2; i < [_arrayButtonTitle count]; i++) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; 
			button.tag = i;
			
			
			NSString *strTitle = [_arrayButtonTitle objectAtIndex:i];
			UIFont *font =  [UIFont boldSystemFontOfSize:15.0];
			CGSize stringSize = [strTitle sizeWithFont:font]; //规定字符字体获取字符串Size，再获取其宽度。
			CGFloat width = stringSize.width + 15;
			
			[button setFrame:CGRectMake(X, 5.0, width, 30.0)];
			
			if (i < [_arrayButtonTitle count]-1) {    //为button添加分隔符
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X+width+15, 5.0, 3.0, 30.0)];
				label.text = @"|";
				label.backgroundColor = [UIColor clearColor];
				label.textColor = [UIColor blackColor];
				[_imageSecondBackground addSubview:label];
				[label release];
			}
			
			X = X + width + 30;
			
			[button setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
			[button setTitle:strTitle forState:UIControlStateNormal];
			[button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
			[_imageSecondBackground addSubview:button];
			
			[_arrayPortraitButtons addObject:button];
		}
		
	}
}


#pragma mark -
#pragma mark clickButton Action
- (void)clickButton:(id)sender{
	UIButton *button = sender;
	NSInteger i = button.tag;
	NSLog(@"click the %d button",i);
	BOOL _isSameButton = YES;
	if (i != _iChecked) {
		_isSameButton = NO;
		for (id btn in _arrayPortraitButtons) {
			UIButton *selButton = btn;
			if (selButton.tag == _iChecked) {
				[btn setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
				break;
			}
		}
		for (id btn in _arrayLandscapeButtons) {
			UIButton *selButton = btn;
			if (selButton.tag == _iChecked) {
				[btn setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
				break;
			}
		}
		_iChecked = i;
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	[_portalSetNewsController.newsDetailView dismissRotationView];

	_isClickButton = YES;
	NSNumber *number = [NSNumber numberWithInteger:i];
	if (_buttonPanelInterfaceOrientation == UIInterfaceOrientationPortrait ||
		_buttonPanelInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self updatePopoverPosition];
	}
	
	if (!_isSameButton) {
		NSMutableArray *newsOfColumn = [_columnsContentArray objectAtIndex:i];
		if ([NSNull null] != (NSNull *)newsOfColumn) {	
			[newsOfColumn removeAllObjects];
		}
		[_portalSetNewsController.newsDetailView startActivityView];
		[_portalSetNewsController.newsDetailView startActivityTableView];
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[self performSelector:@selector(getList:) withObject:number afterDelay:0.2];
	}

}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation {   //update button panel selected status
	_buttonPanelInterfaceOrientation = orientation;
	if (orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown) {
		_iChecked = _portalSetNewsController.buttonPanelLandscapeView.iChecked;
		for (id btn in _arrayPortraitButtons) {
			UIButton *selButton = btn;
			if (selButton.tag == _iChecked) {
				[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			} else {
				[btn setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
			}
		}
	} else {
		_iChecked = _portalSetNewsController.buttonPanelPortraitView.iChecked;
		[_portalSetNewsController.buttonPanelPortraitView.popoverController dismissPopoverAnimated:NO];
		for (id btn in _arrayLandscapeButtons) {
			UIButton *selButton = btn;
			if (selButton.tag == _iChecked) {
				[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			} else {
				[btn setTitleColor:[UIColor colorWithRed:(96.0/255) green:(96.0/255) blue:(96.0/255) alpha:1] forState:UIControlStateNormal];
			}
		}
	}
}

- (void)updateNewsfromHome:(NSDictionary *)dict{
	[_portalSetNewsController.newsDetailView loadWebContent:dict];
}

- (void)reloadList{
	if (!_ifLoaded) {
		return;
	}
	_ifLoaded = NO;
	[_portalSetNewsController.newsDetailView startActivityView];
	[_portalSetNewsController.newsDetailView startActivityTableView];
	
	NSMutableArray *icheckArray = [_columnsContentArray objectAtIndex:_iChecked];
	if ([NSNull null] != (NSNull *)icheckArray) {
		[icheckArray removeAllObjects];
	}
	[_portalSetNewsController.arrayNewsChooseStatus replaceObjectAtIndex:_iChecked withObject:[NSNumber numberWithInt:0]];
//	[self getNewsClassList:_iChecked andForceRefresh:NO];
	[NSThread detachNewThreadSelector:@selector(getnewsThread:) 
							 toTarget:self 
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_iChecked],@"number",[NSNumber numberWithBool:NO],@"forceRefresh",nil]];
}

- (void)refreshList{
	[_portalSetNewsController.newsDetailView startActivityView];
	[_portalSetNewsController.newsDetailView startActivityTableView];
	
	NSMutableArray *icheckArray = [_columnsContentArray objectAtIndex:_iChecked];
	if ([NSNull null] != (NSNull *)icheckArray) {
		[icheckArray removeAllObjects];
	}
	[_portalSetNewsController.arrayNewsChooseStatus replaceObjectAtIndex:_iChecked withObject:[NSNumber numberWithInt:0]];
//	[self getNewsClassList:_iChecked andForceRefresh:YES];
	[NSThread detachNewThreadSelector:@selector(getnewsThread:) 
							 toTarget:self 
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_iChecked],@"number",[NSNumber numberWithBool:YES],@"forceRefresh",nil]];
}

- (void)getList:(id)sender{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSNumber *i = sender;
	NSInteger number = [i integerValue];
//	[self getNewsClassList:number andForceRefresh:NO];
	[NSThread detachNewThreadSelector:@selector(getnewsThread:) 
							 toTarget:self 
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:number],@"number",[NSNumber numberWithBool:NO],@"forceRefresh",nil]];
	[pool release];
}

- (void)getnewsThread:(NSDictionary *)param{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[_newsLock lock];
	
	NSInteger number = [[param objectForKey:@"number"] intValue];
	BOOL forceRefresh = [[param objectForKey:@"forceRefresh"] boolValue];
	
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSUInteger page = [[_portalSetNewsController.arrayNewsChooseStatus objectAtIndex:_iChecked] integerValue];
	NSString *strPageNumber = [NSString stringWithFormat:@"%d",CV_NEWS_PAGECAPACITY];
	NSString *strPage = [NSString stringWithFormat:@"%d",page];
	NSMutableArray *newsOfColumn = [_columnsContentArray objectAtIndex:_iChecked];
	
	NSArray *array = [[NSArray alloc] initWithObjects:strPage,strPageNumber,nil];
	CVDataProvider *dataProvider = [CVDataProvider sharedInstance];
	NSDictionary *dict;
	switch (number) {
		case 0:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeHeadlineNews withParams:array forceRefresh:forceRefresh];
			break;
		case 1:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeLatestNews withParams:array forceRefresh:forceRefresh];
			break;
		case 2:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeMacroNews withParams:array forceRefresh:forceRefresh];
			break;
		case 3:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeDiscretionaryNews withParams:array forceRefresh:forceRefresh];
			break;
		case 4:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeStaplesNews withParams:array forceRefresh:forceRefresh];
			break;
		case 5:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeFinancialsNews withParams:array forceRefresh:forceRefresh];
			break;
		case 6:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeHealthCareNews withParams:array forceRefresh:forceRefresh];
			break;
		case 7:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeIndustrialsNews withParams:array forceRefresh:forceRefresh];
			break;
		case 8:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeMaterialsNews withParams:array forceRefresh:forceRefresh];
			break;
		case 9:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeEnergyNews withParams:array forceRefresh:forceRefresh];
			break;
		case 10:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeTelecomNews withParams:array forceRefresh:forceRefresh];
			break;
		case 11:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeUtilitiesNews withParams:array forceRefresh:forceRefresh];
			break;
		case 12:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeITNews withParams:array forceRefresh:forceRefresh];
			break;
		default:
			break;
	}
	[array release];
	
	if (!dict){
		if ([self.arrayNews count] <= 0) {
			[_portalSetNewsController showNetWorkLabel];
		}
	} else {
		[_portalSetNewsController hideNetWorkLabel];
        
        self.arrayNews = [dict valueForKey:@"data"];
        
        if ([NSNull null] != (NSNull *)newsOfColumn && [newsOfColumn count] > 0) {
            id obj = [newsOfColumn lastObject];
            if ([obj isKindOfClass:[NSString class]]) {
                [newsOfColumn removeLastObject];
            }
            if (self.arrayNews) {
                [newsOfColumn addObjectsFromArray:self.arrayNews];
            }
            self.arrayNews = newsOfColumn;
        }
        
        if (self.arrayNews) {
            [_columnsContentArray replaceObjectAtIndex:_iChecked withObject:self.arrayNews];
        }
        
        
        NSMutableArray *arrayNewsChooseStatus = _portalSetNewsController.arrayNewsChooseStatus;
        _currentPage = [[arrayNewsChooseStatus objectAtIndex:number] integerValue];
        
        if (_currentPage < CV_NEWS_MAX_PAGE && [self.arrayNews count] >= CV_NEWS_PAGECAPACITY) {
            NSString *strMore = [langSetting localizedString:@"more..."];
            [self.arrayNews addObject:strMore];
        }
        
        if (_buttonPanelInterfaceOrientation == UIInterfaceOrientationPortrait ||
            _buttonPanelInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            if (_isClickButton == YES) {
                [self updatePopoverContent:self.arrayNews];
                _isClickButton = NO;
            } else {
                [_portalSetNewsController.newsDetailView updateContent:self.arrayNews];
            }
        } else {
            //[_portalSetNewsController.newsDetailView performSelectorOnMainThread:@selector(updateContent:) withObject:self.arrayNews waitUntilDone:NO];
            [_portalSetNewsController.newsDetailView updateContent:self.arrayNews];
        }
	}
	[_portalSetNewsController.newsDetailView stopActivityView];
    [_portalSetNewsController.newsDetailView stopActivityTableView];
	_portalSetNewsController.newsDetailView.hidden = NO;
	_ifLoaded = YES;
	
	[_newsLock unlock];
	[pool release];
}


- (void)getNewsClassList:(NSInteger)number andForceRefresh:(BOOL)forceRefresh{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSUInteger page = [[_portalSetNewsController.arrayNewsChooseStatus objectAtIndex:_iChecked] integerValue];
	NSString *strPageNumber = [NSString stringWithFormat:@"%d",CV_NEWS_PAGECAPACITY];
	NSString *strPage = [NSString stringWithFormat:@"%d",page];
	NSMutableArray *newsOfColumn = [_columnsContentArray objectAtIndex:_iChecked];
	
	NSArray *array = [[NSArray alloc] initWithObjects:strPage,strPageNumber,nil];
	CVDataProvider *dataProvider = [CVDataProvider sharedInstance];
	NSDictionary *dict;
	switch (number) {
		case 0:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeHeadlineNews withParams:array forceRefresh:forceRefresh];
			break;
		case 1:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeLatestNews withParams:array forceRefresh:forceRefresh];
			break;
		case 2:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeMacroNews withParams:array forceRefresh:forceRefresh];
			break;
		case 3:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeDiscretionaryNews withParams:array forceRefresh:forceRefresh];
			break;
		case 4:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeStaplesNews withParams:array forceRefresh:forceRefresh];
			break;
		case 5:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeFinancialsNews withParams:array forceRefresh:forceRefresh];
			break;
		case 6:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeHealthCareNews withParams:array forceRefresh:forceRefresh];
			break;
		case 7:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeIndustrialsNews withParams:array forceRefresh:forceRefresh];
			break;
		case 8:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeMaterialsNews withParams:array forceRefresh:forceRefresh];
			break;
		case 9:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeEnergyNews withParams:array forceRefresh:forceRefresh];
			break;
		case 10:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeTelecomNews withParams:array forceRefresh:forceRefresh];
			break;
		case 11:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeUtilitiesNews withParams:array forceRefresh:forceRefresh];
			break;
		case 12:
			dict = [dataProvider GetNewsList:CVDataProviderNewsListTypeITNews withParams:array forceRefresh:forceRefresh];
			break;
		default:
			break;
	}
	[array release];
	
	if (!dict){
		[_portalSetNewsController.newsDetailView stopActivityView];
		[_portalSetNewsController.newsDetailView stopActivityTableView];
		if ([self.arrayNews count] <= 0) {
			[_portalSetNewsController showNetWorkLabel];
		}
		return;
	} else {
		[_portalSetNewsController hideNetWorkLabel];
	}

	self.arrayNews = [dict valueForKey:@"data"];
	
	if ([NSNull null] != (NSNull *)newsOfColumn && [newsOfColumn count] > 0) {
		id obj = [newsOfColumn lastObject];
		if ([obj isKindOfClass:[NSString class]]) {
			[newsOfColumn removeLastObject];
		}
		if (self.arrayNews) {
			[newsOfColumn addObjectsFromArray:self.arrayNews];
		}
		self.arrayNews = newsOfColumn;
	}
	
	if (self.arrayNews) {
		[_columnsContentArray replaceObjectAtIndex:_iChecked withObject:self.arrayNews];
	}

	
	NSMutableArray *arrayNewsChooseStatus = _portalSetNewsController.arrayNewsChooseStatus;
	_currentPage = [[arrayNewsChooseStatus objectAtIndex:number] integerValue];
	
	if (_currentPage < CV_NEWS_MAX_PAGE && [self.arrayNews count] >= CV_NEWS_PAGECAPACITY) {
		NSString *strMore = [langSetting localizedString:@"more..."];
		[self.arrayNews addObject:strMore];
	}
	
	if (_buttonPanelInterfaceOrientation == UIInterfaceOrientationPortrait ||
		_buttonPanelInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		if (_isClickButton == YES) {
			[self updatePopoverContent:self.arrayNews];
			_isClickButton = NO;
			[_portalSetNewsController.newsDetailView stopActivityView];
		} else {
			[_portalSetNewsController.newsDetailView updateContent:self.arrayNews];
		}
	} else {
		//[_portalSetNewsController.newsDetailView performSelectorOnMainThread:@selector(updateContent:) withObject:self.arrayNews waitUntilDone:NO];
		[_portalSetNewsController.newsDetailView updateContent:self.arrayNews];
	}
	_portalSetNewsController.newsDetailView.hidden = NO;
	_ifLoaded = YES;
}

- (void)updatePopoverPosition{
	for (id btn in _arrayPortraitButtons) {
		UIButton *selButton = btn;
		if (selButton.tag == _iChecked) {
			if (selButton.tag < [_arrayButtonTitle count]/2) {
				[_popoverController presentPopoverFromRect:selButton.frame inView:_imageBackground permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
			}
			else {
				[_popoverController presentPopoverFromRect:selButton.frame inView:_imageSecondBackground permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
			}
		}
	}
}

- (void)updatePopoverContent:(NSMutableArray *)aryNews{
	for (id btn in _arrayPortraitButtons) {
		UIButton *selButton = btn;
		if (selButton.tag == _iChecked) {
			CVNewsNavigatorController *controller = (CVNewsNavigatorController *)_popoverController.contentViewController;
			controller.arrayNews = aryNews;
			[controller.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
		}
	}
	
	for (id btn in _arrayLandscapeButtons) {
		UIButton *selButton = btn;
		if (selButton.tag == _iChecked) {
			[_portalSetNewsController.newsDetailView updateContent:aryNews];
		}
	}
}

#pragma mark CVNewsNavigatorControllerDelegate
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath item:(NSDictionary *)item {
	if (_buttonPanelInterfaceOrientation == UIInterfaceOrientationPortrait ||
		_buttonPanelInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		[_popoverController dismissPopoverAnimated:YES];
	}
	
	_portalSetNewsController.newsDetailView.iSelectedColumn = indexPath.row;
	[_portalSetNewsController.newsDetailView loadWebContent:item];
}

- (void)selectedNextPage{
	_currentPage++;
	[_portalSetNewsController.arrayNewsChooseStatus replaceObjectAtIndex:_iChecked withObject:[NSNumber numberWithInteger:_currentPage]];
	NSNumber *number = [NSNumber numberWithInteger:_iChecked];
	_isClickButton = YES;
	[self getList:number];
}

- (void)dealloc {
	[_portalSetNewsController release];
	[_newsNavigatorController release];
	[_imageBackground release];
	[_arrayPortraitButtons release];
	[_arrayLandscapeButtons release];
	[_arrayButtonTitle release];
	[_arrayNews release];
	[_img release];
    [super dealloc];
}


@end
