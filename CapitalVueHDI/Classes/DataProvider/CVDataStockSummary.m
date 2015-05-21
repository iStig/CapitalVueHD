//
//  CVDataStockSummary.m
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVDataStockSummary.h"


@implementation CVDataStockSummary

@synthesize code;
@synthesize companyPinyinName;
@synthesize dateEstablished;
@synthesize telephone;
@synthesize mainBusiness;
@synthesize legalRepresentative;
@synthesize officeAddress;
@synthesize countryAndRegion;
@synthesize companyReferredToAs;
@synthesize website;
@synthesize companyDescription;
@synthesize latestMark;
@synthesize companyType1;
@synthesize companyType2;
@synthesize businessScope;
@synthesize csrcIndustryClassification;
@synthesize companyChineseName;
@synthesize listedCompanyOrNot;
@synthesize previousCompanyName;
@synthesize address;
@synthesize industry1Code;
@synthesize postcode;
@synthesize companyEnglishName;
@synthesize fax;
@synthesize businessRegistrationNumber;
@synthesize currencyCode;
@synthesize city;
@synthesize companyName;
@synthesize email;
@synthesize listingDate;
@synthesize industry;
@synthesize subIndustry;
@synthesize shortName;
@synthesize registeredCapital;
@synthesize sector;
@synthesize province;

-(void)dealloc {
	[code release];
	[companyPinyinName release];
	[dateEstablished release];
	[telephone release];
	[mainBusiness release];
	[legalRepresentative release];
	[officeAddress release];
	[countryAndRegion release];
	[companyReferredToAs release];
	[website release];
	[companyDescription release];
	[latestMark release];
	[companyType1 release];
	[companyType2 release];
	[businessScope release];
	[csrcIndustryClassification release];
	[companyChineseName release];
	[listedCompanyOrNot release];
	[previousCompanyName release];
	[address release];
	[industry1Code release];
	[postcode release];
	[companyEnglishName release];
	[fax release];
	[businessRegistrationNumber release];
	[currencyCode release];
	[city release];
	[companyName release];
	[email release];
	[listingDate release];
	[industry release];
	[subIndustry release];
	[shortName release];
	[registeredCapital release];
	[sector release];
	[province release];
	[super dealloc];
}

@end
