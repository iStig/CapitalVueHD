//
//  CVBlanceSheetViewController.h
//  CapitalVueHD
//
//  Created by jishen on 10/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVDataProvider.h"

@interface CVBlanceSheetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	UILabel *titleLabel;
	UILabel *dateLabel;
	UIButton *leftButton;
	UIButton *rightButton;
	UIImageView *imageBackground;
	UIImageView *imageYellowBar;
	UIImageView *imageDelimiter;
	UITableView *sheetTableView;
	
	UIInterfaceOrientation rotationInterfaceOrientation;
	UIActivityIndicatorView *_indicator;
@private
	UINavigationController *_navigationControl;
	NSString *_code;
	NSDictionary *_sheetTitleRef;
	NSArray *_sheetDataList;
	NSMutableArray *_tableList;
}

@property (nonatomic, assign) UIInterfaceOrientation rotationInterfaceOrientation;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UIButton *leftButton;
@property (nonatomic, retain) IBOutlet UIButton *rightButton;
@property (nonatomic, retain) IBOutlet UIImageView *imageBackground;
@property (nonatomic, retain) IBOutlet UIImageView *imageYellowBar;
@property (nonatomic, retain) IBOutlet UIImageView *imageDelimiter;

@property (nonatomic, retain) IBOutlet UITableView *sheetTableView;

@property (nonatomic, retain) NSString *code;

- (NSDictionary *)loadEquitySheetData:(NSString *)equityCode;
- (NSString *)sheetConfigFile:(id)obj;

- (IBAction)actionRightButton:(id)sender;
- (IBAction)actionLeftButton:(id)sender;
- (void)startRotationView;

@end
