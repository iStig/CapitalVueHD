//
//  CVCompanyProfileBulletin.h
//  CapitalVueHD
//
//  Created by jishen on 11/2/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CVCompanyProfileBulletin : UIView {
	UILabel *companyNameInEnglish;
	UILabel *companyNameInEnglishValue;
	UILabel *chineseNameOfCompany;
	UILabel *chineseNameOfCompanyValue;
	UILabel *companyDescription;
	UITextView *companyDescriptionValue;
	UILabel *shortName;
	UILabel *shortNameValue;
	UILabel *website;
	UILabel *websiteValue;
	UILabel *listingDate;
	UILabel *listingDateValue;
	UILabel *legalRepresentative;
	UILabel *legalRepresentativeValue;
	UILabel *dateEstablished;
	UILabel *dateEstablishedValue;
	UILabel *registeredCapital;
	UILabel *registeredCapitalValue;
	UILabel *businessRegisteredNumber;
	UILabel *businessRegisteredNumberValue;
	UILabel *address;
	UITextView *addressValue;
	UILabel *postcode;
	UILabel *postcodeValue;
	UILabel *email;
	UILabel *emailValue;
	UILabel *telephone;
	UILabel *telephoneValue;
	UILabel *fax;
	UILabel *faxValue;
	
	UIImageView *imageTopDelimiter;
	UIImageView *imageBottomDelimiter;
}

@property (nonatomic, retain) IBOutlet UILabel *companyNameInEnglish;
@property (nonatomic, retain) IBOutlet UILabel *companyNameInEnglishValue;
@property (nonatomic, retain) IBOutlet UILabel *chineseNameOfCompany;
@property (nonatomic, retain) IBOutlet UILabel *chineseNameOfCompanyValue;
@property (nonatomic, retain) IBOutlet UILabel *companyDescription;
@property (nonatomic, retain) IBOutlet UITextView *companyDescriptionValue;
@property (nonatomic, retain) IBOutlet UILabel *shortName;
@property (nonatomic, retain) IBOutlet UILabel *shortNameValue;
@property (nonatomic, retain) IBOutlet UILabel *website;
@property (nonatomic, retain) IBOutlet UILabel *websiteValue;
@property (nonatomic, retain) IBOutlet UILabel *listingDate;
@property (nonatomic, retain) IBOutlet UILabel *listingDateValue;
@property (nonatomic, retain) IBOutlet UILabel *legalRepresentative;
@property (nonatomic, retain) IBOutlet UILabel *legalRepresentativeValue;
@property (nonatomic, retain) IBOutlet UILabel *dateEstablished;
@property (nonatomic, retain) IBOutlet UILabel *dateEstablishedValue;
@property (nonatomic, retain) IBOutlet UILabel *registeredCapital;
@property (nonatomic, retain) IBOutlet UILabel *registeredCapitalValue;
@property (nonatomic, retain) IBOutlet UILabel *businessRegisteredNumber;
@property (nonatomic, retain) IBOutlet UILabel *businessRegisteredNumberValue;
@property (nonatomic, retain) IBOutlet UILabel *address;
@property (nonatomic, retain) IBOutlet UITextView *addressValue;
@property (nonatomic, retain) IBOutlet UILabel *postcode;
@property (nonatomic, retain) IBOutlet UILabel *postcodeValue;
@property (nonatomic, retain) IBOutlet UILabel *email;
@property (nonatomic, retain) IBOutlet UILabel *emailValue;
@property (nonatomic, retain) IBOutlet UILabel *telephone;
@property (nonatomic, retain) IBOutlet UILabel *telephoneValue;
@property (nonatomic, retain) IBOutlet UILabel *fax;
@property (nonatomic, retain) IBOutlet UILabel *faxValue;

@property (nonatomic, retain) IBOutlet UIImageView *imageTopDelimiter;
@property (nonatomic, retain) IBOutlet UIImageView *imageBottomDelimiter;

@end
