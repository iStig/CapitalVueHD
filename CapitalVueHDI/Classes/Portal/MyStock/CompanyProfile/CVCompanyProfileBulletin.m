//
//  CVCompanyProfileBulletin.m
//  CapitalVueHD
//
//  Created by jishen on 11/2/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVCompanyProfileBulletin.h"


@implementation CVCompanyProfileBulletin

@synthesize companyNameInEnglish;
@synthesize companyNameInEnglishValue;
@synthesize chineseNameOfCompany;
@synthesize chineseNameOfCompanyValue;
@synthesize companyDescription;
@synthesize companyDescriptionValue;
@synthesize shortName;
@synthesize shortNameValue;
@synthesize website;
@synthesize websiteValue;
@synthesize listingDate;
@synthesize listingDateValue;
@synthesize legalRepresentative;
@synthesize legalRepresentativeValue;
@synthesize dateEstablished;
@synthesize dateEstablishedValue;
@synthesize registeredCapital;
@synthesize registeredCapitalValue;
@synthesize businessRegisteredNumber;
@synthesize businessRegisteredNumberValue;
@synthesize address;
@synthesize addressValue;
@synthesize postcode;
@synthesize postcodeValue;
@synthesize email;
@synthesize emailValue;
@synthesize telephone;
@synthesize telephoneValue;
@synthesize fax;
@synthesize faxValue;

@synthesize imageTopDelimiter;
@synthesize imageBottomDelimiter;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[companyNameInEnglish release];
	[companyNameInEnglishValue release];
	[chineseNameOfCompany release];
	[chineseNameOfCompanyValue release];
	[companyDescription release];
	[companyDescriptionValue release];
	[shortName release];
	[shortNameValue release];
	[website release];
	[websiteValue release];
	[listingDate release];
	[listingDateValue release];
	[legalRepresentative release];
	[legalRepresentativeValue release];
	[dateEstablished release];
	[dateEstablishedValue release];
	[registeredCapital release];
	[registeredCapitalValue release];
	[businessRegisteredNumber release];
	[businessRegisteredNumberValue release];
	[address release];
	[addressValue release];
	[postcode release];
	[postcodeValue release];
	[email release];
	[emailValue release];
	[telephone release];
	[telephoneValue release];
	[fax release];
	[faxValue release];
	
	[imageTopDelimiter release];
	[imageBottomDelimiter release];
	
    [super dealloc];
}


@end
