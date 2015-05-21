//
//  NoConnectionAlert.m
//  CapitalVueHD
//
//  Created by Carl on 12/27/10.
//  Copyright 2010 CapitalVue. All rights reserved.
//

#import "NoConnectionAlert.h"
#import "CVLocalizationSetting.h"

@implementation NoConnectionAlert

+(void)alert{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *strTitle = [langSetting localizedString:@"NetworkFailedTitle"];
	NSString *strMessage = [langSetting localizedString:@"NetworkFailedMessage"];
	NSString *strOK = [langSetting localizedString:@"NetworkFailedOK"];
	UIAlertView *retAlert = [[UIAlertView alloc] initWithTitle:strTitle
													   message:strMessage
													  delegate:nil
											 cancelButtonTitle:strOK
											 otherButtonTitles:nil];
	[retAlert show];
	[retAlert release];
}

@end
