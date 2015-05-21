//
//  CVMyStockNavigatorViewController.h
//  CapitalVueHD
//
//  Created by leon on 10-9-28.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#define		kNotificationUpdateIndex		@"kNotificationUpdateIndex"
#define		kNotificationUpdateStock		@"kNotificationUpdateStock"


#import <UIKit/UIKit.h>
@protocol CVMyStockNavigatorControllerDelegate

-(void)didSelectItemAtIndexPath:(NSDictionary *)dict;

@end

typedef enum {
	CVMyStockStockButton,
	CVMyStockFundButton,
	CVMyStockBondButton
} CVMyStockButtonType;

@interface CVMyStockNavigatorViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	id<CVMyStockNavigatorControllerDelegate> navigatorDelegate;
	CGRect frame;
	UIImageView *_imageBackground;
	UIImageView *_imageToolbarBackground;
	UITableView *_tableView;
	UIButton    *_buttonEdit;
	NSMutableArray *_arrayButton;
	NSMutableArray *_arrayDetail;
	
	UIPopoverController *parent;
	UIActivityIndicatorView *_activityIndicator;
@private
	NSMutableArray *_arrayEquity;
	NSMutableArray *_arrayFund;
	NSMutableArray *_arrayBond;
	
	NSMutableArray *_arrayIndexDetail;
	
	NSTimer *_stockListTimer;
	
	NSInteger _lastSelect;
	
	NSLock *_dataMutex;
}

@property (nonatomic) CGRect frame;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *buttonEdit;
@property (nonatomic, retain) NSMutableArray *arrayDetail;
@property (nonatomic, retain) NSMutableArray *arrayButton;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) UIPopoverController *parent;

- (void)setDelegate:(id)delegate;
- (void)loadToolBarButton;
- (void)getMyStock;
- (void)saveMyStock;
- (void)loadStockList;
- (void)addNewFavoerite:(NSDictionary *)description;
@end
