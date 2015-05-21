//
//  RectImage.h
//  CapitalVueHD
//
//  Created by Dream on 10-9-25.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RectImage : UIImageView {
	UILabel *lblLeft;
	UILabel *lblCenter;
	UILabel *lblRight;
	
	UIButton *btnAction;
	
	NSString *code;
}

@property (nonatomic,retain) UILabel *lblLeft;
@property (nonatomic,retain) UILabel *lblCenter;
@property (nonatomic,retain) UILabel *lblRight;
@property (nonatomic, retain) UIButton *btnAction;

@property (nonatomic, retain) NSString *code;

- (IBAction)actionRespondTapping:(id)sender;

@end
