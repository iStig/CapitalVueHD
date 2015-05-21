    //
//  CVAboutBulletinController.m
//  CapitalVueHD
//
//  Created by jishen on 12/8/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVAboutBulletinController.h"
#import "CVAboutLegalViewController.h"
#import "CVAboutBulletin.h"
#import "CVDatacache.h"
#import "CVLocalizationSetting.h"

enum CVAboutItem {
	CVAboutItemPreface,
	CVAboutItemPortletIntro,
	CVAboutItemAbout,
	CVAboutItemContact,
	CVAboutItemButton,
	CVAboutItemInvalid
};

@interface CVAboutBulletinController()

@property (nonatomic, retain) NSArray *_aboutArray;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)goLegalInformation:(id)sender;
- (IBAction)clearCachedData:(id)sender;
- (IBAction)feedbackButtonPressed:(id)sender;
- (void)displayFeedbackComposerSheet;
@end

@implementation CVAboutBulletinController

@synthesize delegate;
@synthesize orientation;
@synthesize scrollView;

@synthesize _aboutArray;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)setOrientation:(UIInterfaceOrientation)o {
	if (UIInterfaceOrientationPortrait == o ||
		UIInterfaceOrientationPortraitUpsideDown == o) {
		self.view.frame = CGRectMake(0, 0, 768, 1004);
		scrollView.frame = CGRectMake(0, 0, 768, 960);
	} else {
		self.view.frame = CGRectMake(128, 0, 768, 748);
		scrollView.frame = CGRectMake(0, 0, 768, 724);
	}

}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self.view.autoresizesSubviews = NO;
	
	UIBarButtonItem *anItem;
	anItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
	self.navigationItem.rightBarButtonItem = anItem;
	[anItem release];
	
	NSString *cfgFilePath;
	cfgFilePath = [[NSBundle mainBundle] pathForResource:@"CVAboutContent" ofType:@"plist"];
	self._aboutArray = [[NSArray alloc] initWithContentsOfFile:cfgFilePath];
	[_aboutArray release];
	
	CVAboutBulletin *bulletin;
	NSArray *objects;
	objects = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"CVAboutBulletin_%@",[langSetting localizedString:@"LangCode"]] owner:self options:nil];
	for (id currentObject in objects){
		if ([currentObject isKindOfClass:[CVAboutBulletin class]]) {
			bulletin = (CVAboutBulletin *)currentObject;
			[bulletin.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[bulletin.clearCacheButton addTarget:self action:@selector(clearCachedData:) forControlEvents:UIControlEventTouchUpInside];
			[bulletin.legalButton addTarget:self action:@selector(goLegalInformation:) forControlEvents:UIControlEventTouchUpInside];
			[bulletin.feedbackButton addTarget:self action:@selector(feedbackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		}
	}
	[scrollView addSubview:bulletin];
	[scrollView setContentSize:bulletin.frame.size];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[scrollView release];
	
	[_aboutArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark Compose Mail
-(void)displayComposerSheet {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@""];
	NSString *lanCode = [langSetting localizedString:@"LangCode"];
	
	// Attach an image to the email
#if 0
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"cv_about_%@",lanCode] ofType:@"htm"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"text/html" fileName:@"rainy"];
#else
	// set subject
	[picker setSubject:[langSetting localizedString:@"CapitalVue Financial Terminal"]];
	// Fill out the email body text
	NSString *htmFilePath;
	NSString *emailBody;;
	
	htmFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"cv_about_%@",lanCode] ofType:@"htm"];
	emailBody = [[NSString alloc] initWithContentsOfFile:htmFilePath];
	[picker setMessageBody:emailBody isHTML:YES];
	[emailBody release];
#endif
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	// for future use
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround
// Launches the Mail application on the device.
-(void)launchMailAppOnDevice {
	NSString *recipients = @"";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"mailto:%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark -
#pragma mark private method
- (IBAction)doneButtonPressed:(id)sender {
	[delegate didTapDoneButton];
}

- (IBAction)shareButtonPressed:(id)sender {
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil) {
		if ([mailClass canSendMail]) {
			[self displayComposerSheet];
		} else {
			[self launchMailAppOnDevice];
		}
	} else {
		[self launchMailAppOnDevice];
	}
}

- (IBAction)goLegalInformation:(id)sender {
	if (!vcLegal)
		vcLegal = [[CVAboutLegalViewController alloc] init];
	[self.navigationController pushViewController:vcLegal animated:YES];
}

- (IBAction)clearCachedData:(id)sender {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	UIActionSheet *actionSheet;
	
	actionSheet = [[UIActionSheet alloc] initWithTitle:nil
											  delegate:self
									 cancelButtonTitle:nil
								destructiveButtonTitle:[langSetting localizedString:@"Clear Cache"]
									 otherButtonTitles:[langSetting localizedString:@"Cancel"], nil];
	
	[actionSheet showInView:self.view];
	[actionSheet release];
}

-(IBAction)feedbackButtonPressed:(id)sender{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil) {
		if ([mailClass canSendMail]) {
			[self displayFeedbackComposerSheet];
		} else {
			[self launchMailAppOnDevice];
		}
	} else {
		[self launchMailAppOnDevice];
	}
}

-(void)displayFeedbackComposerSheet{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@""];
	[picker setToRecipients:[NSArray arrayWithObject:@"Feedback@CapitalVue.com"]];
	
	NSString *lanCode = [langSetting localizedString:@"LangCode"];
	// Attach an image to the email
#if 0
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"cv_about_%@",lanCode] ofType:@"htm"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"text/html" fileName:@"rainy"];
#else
	// set subject
	[picker setSubject:[langSetting localizedString:@"CapitalVue Mobile Feedback"]];
	// Fill out the email body text
	
	
	
	[picker setMessageBody:[langSetting localizedString:@"Dear CapitalVue Development Team,\n"] isHTML:NO];
	
#endif
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (0 == buttonIndex) {
		CVDatacache *cache;
		cache = [[CVDatacache alloc] init];
		[cache empty];
		[cache release];
	}
}




@end
