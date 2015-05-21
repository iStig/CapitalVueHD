//
//  CVSearchDisplayController.m
//  CapitalVueHD
//
//  Created by jishen on 10/28/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVSearchDisplayController.h"

#import "CVDataProvider.h"
#define CV_LABEL_CODE_TAG 3001
#define CV_LABEL_COMPANY_TAG 3002

@interface CVSearchDisplayController()

@property (nonatomic, retain) UITableView *_tableView;
@property (nonatomic, retain) NSArray *_stockList;
//@property (nonatomic, retain) NSMutableArray *displayList;

- (void)loadData;

@end


@implementation CVSearchDisplayController

@synthesize code = _code;

@synthesize _stockList;
@synthesize displayList = _displayList;
@synthesize _tableView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
//	[self loadData];
	[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
	_displayList = [[NSMutableArray alloc] initWithCapacity:20];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_code release];
	
	[_stockList release];
	[_displayList release];
	[_tableView release];
    [super dealloc];
}

- (void)setStockList:(NSArray *)stockList {
	[_stockList release];
	_stockList = [stockList retain];
	[_tableView reloadData];
}

- (void)setCode:(NSString *)code {	
	[_displayList removeAllObjects];
	NSUInteger codeLength = [code length];
	unichar firstChar = [code characterAtIndex:0];
	
	if ('0'<=firstChar && '9'>=firstChar){
		for (NSUInteger i = 0; i < [_stockList count]; i++) {
			NSDictionary *dict = [_stockList objectAtIndex:i];
			NSString *currentCode = [dict valueForKey:@"GPDM"];
			if (codeLength <= [currentCode length]) {
				NSString *currentSubCode = [currentCode substringWithRange:NSMakeRange(0, codeLength)];
				if ([code isEqualToString:currentSubCode]) {
					[_displayList addObject:dict];
				}
			}
		}
	}
	else{
		if (('A'<=firstChar && 'Z'>=firstChar) || ('a'<=firstChar && 'z'>=firstChar)){
			for (NSUInteger i=0;i<[_stockList count];i++){
				NSDictionary *dict = [_stockList objectAtIndex:i];
				NSString *name = [dict valueForKey:@"GPJC"];
				NSString *pyjc = [dict valueForKey:@"GPJCPY"];
				NSString *subCode = nil;
				if (codeLength<=[name length]){
					subCode = [name substringWithRange:NSMakeRange(0, codeLength)];
					if ([[code lowercaseString] isEqualToString:[subCode lowercaseString]])
						[_displayList addObject:dict];
				}
				if (codeLength<=[pyjc length]){
					subCode = [pyjc substringWithRange:NSMakeRange(0, codeLength)];
					if ([[code lowercaseString] isEqualToString:[subCode lowercaseString]])
						[_displayList addObject:dict];
				}
			}
		}else {
			for (NSUInteger i = 0; i < [_stockList count]; i++) {
				NSDictionary *dict = [_stockList objectAtIndex:i];
				NSString *currentCode = [dict valueForKey:@"GPJC"];
				if (codeLength <= [currentCode length]) {
					NSString *currentSubCode = [currentCode substringWithRange:NSMakeRange(0, codeLength)];
					if ([code isEqualToString:currentSubCode]) {
						[_displayList addObject:dict];
					}
				}
			}
		}
		
		
	}
	
	NSSortDescriptor *sortDescByCode;
//	NSSortDescriptor *sortDescByName;
	
	sortDescByCode = [[NSSortDescriptor alloc] initWithKey:@"GPDM" ascending:YES];
//	sortDescByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[_displayList sortUsingDescriptors:[NSMutableArray arrayWithObject:sortDescByCode]];
//	[equityArray sortUsingDescriptors:[NSMutableArray arrayWithObject:sortDescByCode]];
	[sortDescByCode release];
//	[sortDescByName release];
	
	[_tableView reloadData];
}

#pragma mark -
#pragma mark private method
- (void)loadData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = 15;
	dict = [dp GetStockList:CVDataProviderStockListTypeAll withParams:paramInfo];
	[paramInfo release];
	
	self._stockList = [dict objectForKey:@"data"];
	
	[pool release];
}

- (void)setDelegate:(id)delegate{
	searchDelegate = delegate;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[searchDelegate selectedSearchItem:[[_displayList objectAtIndex:indexPath.row] valueForKey:@"GPDM"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40.0;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"SearchBarDisplay";
    UILabel *labelCode, *labelCompany;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	else {
		labelCode = (UILabel *)[cell viewWithTag:CV_LABEL_CODE_TAG];
		labelCompany = (UILabel *)[cell viewWithTag:CV_LABEL_COMPANY_TAG];
		[labelCode removeFromSuperview];
		[labelCompany removeFromSuperview];
	}

	
	NSDictionary *dict = [_displayList objectAtIndex:indexPath.row];
	labelCode = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 30)];
	labelCompany = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 250, 30)];
	labelCode.tag = CV_LABEL_CODE_TAG;
	labelCompany.tag = CV_LABEL_COMPANY_TAG;
	labelCode.backgroundColor = [UIColor clearColor];
	labelCompany.backgroundColor = [UIColor clearColor];
	labelCode.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
	labelCode.font = [UIFont boldSystemFontOfSize:15];
	labelCompany.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
	labelCompany.font = [UIFont systemFontOfSize:15];
	
	labelCode.text = [dict valueForKey:@"GPDM"];
	labelCompany.text = [dict valueForKey:@"GPJC"];
	
	[cell.contentView addSubview:labelCode];
	[cell.contentView addSubview:labelCompany];
	[labelCode release];
	[labelCompany release];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return [_stockList count];
	return [_displayList count];
}

@end
