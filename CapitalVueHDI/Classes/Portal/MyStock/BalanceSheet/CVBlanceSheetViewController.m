    //
//  CVBlanceSheetViewController.m
//  CapitalVueHD
//
//  Created by jishen on 10/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVBlanceSheetViewController.h"

#import "CVBlanceSheetFormViewController.h"

#import "CVLocalizationSetting.h"

#import "SheetCell.h"
#import "NormalCell.h"

@interface CVBlanceSheetViewController()

@property (nonatomic, retain) UINavigationController *_navigationControl;
@property (nonatomic, retain) NSDictionary *_sheetTitleRef;
@property (nonatomic, retain) NSArray *_sheetDataList;
@property (nonatomic, retain) NSArray *_tableList;

- (void)setPageData:(id)pageData;
- (void)loadSheetData;

@end


static int kCountOfPages = 12;
int _currentPageNumber;
BOOL isType2BackgroundWhite;

@implementation CVBlanceSheetViewController

@synthesize code = _code;

@synthesize rotationInterfaceOrientation;

@synthesize titleLabel;
@synthesize dateLabel;
@synthesize leftButton;
@synthesize rightButton;
@synthesize imageBackground;
@synthesize imageDelimiter;
@synthesize imageYellowBar;

@synthesize sheetTableView;

@synthesize _navigationControl;
@synthesize _sheetTitleRef;
@synthesize _sheetDataList;
@synthesize _tableList;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	
	self.titleLabel.text = [local localizedString:@"Balance Sheet"];
	
	_currentPageNumber = 0;
	self.view.userInteractionEnabled = YES;
	self.view.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height - 30);
	self.rotationInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
	self.view.alpha = 0.5;
	self.view.backgroundColor = [UIColor clearColor];
	self.view.autoresizesSubviews = NO;
	isType2BackgroundWhite = YES;
	
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_indicator.hidesWhenStopped = YES;
	_indicator.center = CGPointMake(self.view.frame.size.width/2.0f,self.view.frame.size.height/2.0f);
	[_indicator startAnimating];
	[self.view addSubview:_indicator];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


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
	[dateLabel release];
	[leftButton release];
	[rightButton release];
	[imageBackground release];
	[imageDelimiter release];
	[imageYellowBar release];
	
	[sheetTableView release];
	
	[_sheetTitleRef release];
	[_sheetDataList release];
	[_code release];
	
    [super dealloc];
}

- (void)setCode:(NSString *)code {
	if (nil != code) {
		[_code release];
		_code = [code retain];
		[self performSelector:@selector(loadSheetData) withObject:nil afterDelay:0.4];
	}
}

- (void)loadSheetData {
	NSDictionary *dict;
	NSArray *array;
	
	dict = [self loadEquitySheetData:_code];
	array = [dict objectForKey:@"data"];
	
	if (nil != array) {
		dateLabel.hidden = NO;
		leftButton.hidden = NO;
		rightButton.hidden = NO;
		imageYellowBar.hidden = NO;
		imageDelimiter.hidden = NO;
		sheetTableView.hidden = NO;
		
		[_sheetTitleRef release];
		[_sheetDataList release];
		
		NSDictionary *headArray;
		NSDictionary *elementDic;
		NSMutableDictionary *headDict;
		headArray = [dict objectForKey:@"head"];
		headDict = [[NSMutableDictionary alloc] init];
		for (elementDic in headArray) {
			[headDict setObject:[elementDic objectForKey:@"value"] forKey:[elementDic objectForKey:@"name"]];
		}
		self._sheetTitleRef = headDict;
		[headDict release];
		
		self._sheetDataList = array;
		
		//
		NSDictionary *paramDict;
		NSDictionary *aSheetData;
		aSheetData = [_sheetDataList objectAtIndex:_currentPageNumber];
		paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:aSheetData, @"values", _sheetTitleRef, @"titles", nil];
		[self setPageData:paramDict];
		[paramDict release];
		
		NSString *dateString = [aSheetData objectForKey:@"JZRQ"];
		NSRange range;
		
		range = [dateString rangeOfString:@" "];
		if (NSNotFound != range.location) {
			dateLabel.text = [dateString substringToIndex:range.location];
		}
	}else {
		dateLabel.hidden = YES;
		leftButton.hidden = YES;
		rightButton.hidden = YES;
		imageYellowBar.hidden = YES;
		imageDelimiter.hidden = YES;
		sheetTableView.hidden = YES;
	}

	[NSThread detachNewThreadSelector:@selector(changeIndicator:) toTarget:self withObject:[NSNumber numberWithBool:NO]];
}

- (void)setPageData:(id)pageData {
	NSDictionary *titles, *values;
	
	if (nil != pageData) {
		titles = [pageData objectForKey:@"titles"];
		values = [pageData objectForKey:@"values"];
		
		NSDictionary *dict, *aCellFormat;
		NSArray *format;
		NSString *cfgFilePath;
		NSMutableArray *tableData = nil;
		
		dict = (NSDictionary *)values;		
		cfgFilePath = [self sheetConfigFile: dict];
		
		format = [[NSArray alloc] initWithContentsOfFile:cfgFilePath];
		
		if (format != nil) {
			tableData = [[NSMutableArray alloc] init];
			SheetCell *cellData;
			NSNumber *number;
			NSString *keyValue;
			for (aCellFormat in format) {
				cellData = [[SheetCell alloc] init];
				
				number = [aCellFormat objectForKey:@"type"];
				cellData.type = [number integerValue];
				
				number = [aCellFormat objectForKey:@"isHeader"];
				cellData.isHeader = [number boolValue];
				
				if ((0 == cellData.type || 1 == cellData.type) && YES == cellData.isHeader) {
					keyValue = [aCellFormat objectForKey:@"title"];
					cellData.title = keyValue;
				} else if (2 == cellData.type) {
					NSString *keyTitle;
					NSMutableString *t;
					
					t = [[NSMutableString alloc] init];
					keyTitle = [aCellFormat objectForKey:@"title"];
					if (nil != keyTitle && [keyTitle length] > 0) {
						[t appendString:keyTitle];
					}
					keyValue = [aCellFormat objectForKey:@"key"];
					keyTitle = [titles objectForKey:keyValue];
					if (nil != keyTitle && [keyTitle length] > 0) {
						[t appendString:keyTitle];
					}
					
					cellData.title = t;
					[t release];
				} else {
					keyValue = [aCellFormat objectForKey:@"key"];
					cellData.title = [titles objectForKey:keyValue];
				}
				// value
				
				NSString *value;
				long long currency;
				value = [values objectForKey:keyValue];
				currency = [value longLongValue];
				
				// As longLongValue does not round the value up, e.g. 1.8 is 1,
				// the decimal of the value has to be parsed.
				NSArray *components;
				components = [value componentsSeparatedByString:@"."];
				if ([components count] > 1) {
					NSString *strDecimal;
					strDecimal = [components objectAtIndex:1];
					unichar firstDecimal;
					firstDecimal = [strDecimal characterAtIndex:0];
					if (firstDecimal >= '5' && firstDecimal <= '9') {
						currency += 1;
					}
				}
				
				// convert the value to the style of the grouping separator 
				// used in the United States - the comma (“10,000”)
				NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
				NSNumber *number = [[NSNumber alloc] initWithLongLong:currency];
				
				[numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
				[numberFormatter setGroupingSeparator:@","];
				value = [numberFormatter stringForObjectValue:number];
				[number release];
				[numberFormatter release];
				
				if (NO == [value isEqualToString:@"0"]) {
					cellData.value = value;
				} else {
					cellData.value = nil;
				}				
				[tableData addObject:cellData];
				[cellData release];
			}
			
			self._tableList = tableData;
			[format release];
			[tableData release];
		}
	}
	[sheetTableView reloadData];
}


#pragma mark -
#pragma mark public method

- (NSDictionary *)loadEquitySheetData:(NSString *)equityCode {
	[NSThread detachNewThreadSelector:@selector(changeIndicator:) toTarget:self withObject:[NSNumber numberWithBool:YES]];
	CVDataProvider *dp;
	CVParamInfo *paramInfo;
	NSDictionary *dict;
	dp = [CVDataProvider sharedInstance];
	paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = 15;
	paramInfo.parameters = equityCode;
	dict = [dp GetStockBlance:paramInfo];
	[paramInfo release];
	
	return dict;
}

- (NSString *)sheetConfigFile:(id)obj {
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [local localizedString:@"LangCode"];
	
	NSString *hydm;
	NSString *cfgFilePath;
	NSDictionary *dict;
	
	dict = (NSDictionary *)obj;
	
	hydm = [dict objectForKey:@"HYDM"];
	hydm = [hydm lowercaseString];
	if ([hydm isEqualToString:@"i31"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetTrust_%@",_langCode] ofType:@"plist"];
	} else if ([hydm isEqualToString:@"i11"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetInsurance_%@",_langCode] ofType:@"plist"];
	} else if ([hydm isEqualToString:@"i01"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetBank_%@",_langCode] ofType:@"plist"];
	} else if ([hydm isEqualToString:@"i21"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetSecurities_%@",_langCode] ofType:@"plist"];
	} else if ([hydm hasPrefix:@"i00"]) {
		cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetOther_%@",_langCode] ofType:@"plist"];
	} else {
		cfgFilePath = nil;
	}
	
	if (cfgFilePath) {
		cfgFilePath = [[[NSString alloc] initWithString:cfgFilePath] autorelease];
	}
	
	
	return cfgFilePath;
}

- (IBAction)actionRightButton:(id)sender {	
	if (_currentPageNumber < kCountOfPages) {
		NSDictionary *paramDict;
		NSDictionary *aSheetData;
		
		_currentPageNumber++;
		if (_currentPageNumber>[_sheetDataList count]-1)
			_currentPageNumber = [_sheetDataList count]-1;
		aSheetData = [_sheetDataList objectAtIndex:_currentPageNumber];
		paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:aSheetData, @"values", _sheetTitleRef, @"titles", nil];
		[self setPageData:paramDict];
		[paramDict release];
		
		NSString *dateString = [aSheetData objectForKey:@"JZRQ"];
		NSRange range;
		
		range = [dateString rangeOfString:@" "];
		if (NSNotFound != range.location) {
			dateLabel.text = [dateString substringToIndex:range.location];
		}
	}
}

- (IBAction)actionLeftButton:(id)sender {
	if (_currentPageNumber > 0) {
		NSDictionary *paramDict;
		NSDictionary *aSheetData;
		
		_currentPageNumber--;
		aSheetData = [_sheetDataList objectAtIndex:_currentPageNumber];
		paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:aSheetData, @"values", _sheetTitleRef, @"titles", nil];
		[self setPageData:paramDict];
		[paramDict release];
		
		NSString *dateString = [aSheetData objectForKey:@"JZRQ"];
		NSRange range;
		
		range = [dateString rangeOfString:@" "];
		if (NSNotFound != range.location) {
			dateLabel.text = [dateString substringToIndex:range.location];
		}
	}
}

- (void)startRotationView {
	[self.view setHidden:NO];
	CGPoint start;
	start = CGPointMake(self.view.frame.origin.x + 40 + self.view.frame.size.width / 2, 
						self.view.frame.origin.y + self.view.frame.size.height + 20);
	
	self.view.center = start;
	//scale rotate and then concat,also with the alpha
	CGAffineTransform scale = CGAffineTransformMakeScale(0.1,0.1);
	CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI/3);
	self.view.transform = CGAffineTransformConcat(scale, rotate);
	self.view.alpha = 0.5;
	
	[UIView beginAnimations:@"circle" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	float ptX = self.view.center.x;
	float ptY = self.view.center.y;
	if (self.rotationInterfaceOrientation == UIInterfaceOrientationPortrait ||
		self.rotationInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.view.center = CGPointMake(ptX+200, ptY-220);
	}
	else {
		self.view.center = CGPointMake(ptX+200, ptY-175);
	}
	
	scale = CGAffineTransformMakeScale(0.5, 0.5);
	rotate = CGAffineTransformMakeRotation(M_PI/6);
	self.view.transform = CGAffineTransformConcat(scale, rotate);
	self.view.alpha = 0.75;
	[UIView commitAnimations];
	[self performSelector:@selector(anotherAnimation) withObject:nil afterDelay:0.2];
}

- (void)anotherAnimation{
	float ptX = self.view.center.x;
	float ptY = self.view.center.y;
	[UIView beginAnimations:@"2circle" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	self.view.transform = CGAffineTransformIdentity;
	if (self.rotationInterfaceOrientation == UIInterfaceOrientationPortrait ||
		self.rotationInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.view.center = CGPointMake(ptX-200, ptY-220);
	}
	else {
		self.view.center = CGPointMake(ptX-200, ptY-120);
	}
	self.view.alpha = 1.0;
	[UIView commitAnimations];
}


#define CVSHEET_TYPE0_HEADER_CELL_HEIGHT 28
#define CVSHEET_OTHER_CELL_HEIGHT        21
#define CVSHEET_TYPE0_FOOTER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE1_HEADER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE1_FOOTER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE2_CELL_HEIGHT        CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE3_HEADER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE3_FOOTER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_tableList count];
}

#pragma mark - 
#pragma mark Tabel View delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	SheetCell *cellData;
	CGFloat height;
	
	cellData = [_tableList objectAtIndex:indexPath.row];
	
	if (0 == cellData.type && YES == cellData.isHeader) {
		height = CVSHEET_TYPE0_HEADER_CELL_HEIGHT;
	} else {
		height = CVSHEET_OTHER_CELL_HEIGHT;
	}
	
	return height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SheetCell";
	NormalCell *cell;
	SheetCell *cellData;
	
	cellData = [_tableList objectAtIndex:indexPath.row];
	
	cell = (NormalCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NormalCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (NormalCell *) currentObject;
				break;
			}
		}
	}
    
    // Configure the cell...
	if (0 == cellData.type && YES == cellData.isHeader) {
		cell.titleLabel.textColor = [UIColor orangeColor];
		cell.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
		cell.cellHeight = CVSHEET_TYPE0_HEADER_CELL_HEIGHT;
		isType2BackgroundWhite = YES;
	} else if (1 == cellData.type && YES == cellData.isHeader) {
		cell.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
		cell.titleLabel.textColor = [UIColor whiteColor];
		cell.contentView.backgroundColor = [UIColor lightGrayColor];
		cell.cellHeight = CVSHEET_OTHER_CELL_HEIGHT;
		isType2BackgroundWhite = YES;
	} else if (2 == cellData.type) {
		cell.titleLabel.font = [UIFont systemFontOfSize:12.0];
		cell.cellHeight = CVSHEET_OTHER_CELL_HEIGHT;
		cell.titleIndent = 20.0;
		if (YES == isType2BackgroundWhite) {
			cell.contentView.backgroundColor = [UIColor whiteColor];
		} else {
			cell.contentView.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:216.0/255.0 blue:222.0/255.0 alpha:1.0];
		}
		isType2BackgroundWhite = !isType2BackgroundWhite;
	} else if (3 == cellData.type) {
		isType2BackgroundWhite = !isType2BackgroundWhite;
	} else if (1 == cellData.type && NO == cellData.isHeader) {
		cell.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
		cell.valueLabel.font = [UIFont boldSystemFontOfSize:12.0];
		if (YES == isType2BackgroundWhite) {
			cell.contentView.backgroundColor = [UIColor whiteColor];
		} else {
			cell.contentView.backgroundColor = [UIColor colorWithRed:214.0/255.0 green:216.0/255.0 blue:222.0/255.0 alpha:1.0];
		}
		isType2BackgroundWhite = !isType2BackgroundWhite;
	} else if (0 == cellData.type && NO == cellData.isHeader) {
		cell.contentView.backgroundColor = [UIColor orangeColor];
		isType2BackgroundWhite = YES;
	}
	
	cell.titleLabel.text = cellData.title;
	cell.valueLabel.text = cellData.value;
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

- (void)changeIndicator:(NSNumber *)action
{
	BOOL bAnimate = [action boolValue];
	if(bAnimate)
	{
		[_indicator startAnimating];
		_indicator.hidden = NO;
	}
	else
	{
		[_indicator stopAnimating];
		_indicator.hidden = YES;
	}
}

@end
