//
//  CVStockTopMarketCapital.h
//  CapitalVueHD
//
//  Created by Dream on 10-11-11.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVPortal.h"

#define kDistance 15.0f

@interface CVStockTopMarketCapital : UIView {
	UILabel *m_title;
	UILabel *m_value;
	UITextView *m_description;
	UIImageView *m_imgvLogo;
	
	UILabel *m_company;
	UILabel *m_code;
	UILabel *m_close;
	UILabel *m_chg;
	UILabel *m_chgP;
	UIImageView *m_imgvBar;
	
	UIButton *_btnBack;
	
	UILabel *_close;
	UILabel *_chg;
	UILabel *_chgP;
}

@property (nonatomic, retain) UILabel *m_title;
@property (nonatomic, retain) UILabel *m_value;
@property (nonatomic, retain) UITextView *m_description;
@property (nonatomic, retain) UIImageView *m_imgvLogo;
@property (nonatomic, retain) NSString *m_strImage;
@property (nonatomic, retain) UILabel *m_company;
@property (nonatomic, retain) UILabel *m_code;
@property (nonatomic, retain) UILabel *m_close;
@property (nonatomic, retain) UILabel *m_chg;
@property (nonatomic, retain) UILabel *m_chgP;
@property (nonatomic, retain) UIImageView *m_imgvBar;

-(void)updateOrientation:(UIInterfaceOrientation)orientation;
- (void) btnTapToMySecurity:(id)sender;

@end
