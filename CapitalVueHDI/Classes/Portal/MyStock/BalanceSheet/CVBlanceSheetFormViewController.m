//
//  CVBlanceSheetFormViewController.m
//  CapitalVueHD
//
//  Created by jishen on 10/29/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVBlanceSheetFormViewController.h"
#import "SheetCell.h"
#import "NormalCell.h"
#import "CVLocalizationSetting.h"

@interface CVBlanceSheetFormViewController()

@property (nonatomic, retain) NSArray *_list;

@end

#define CVSHEET_TYPE0_HEADER_CELL_HEIGHT 28
#define CVSHEET_OTHER_CELL_HEIGHT        21
#define CVSHEET_TYPE0_FOOTER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE1_HEADER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE1_FOOTER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE2_CELL_HEIGHT        CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE3_HEADER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT
#define CVSHEET_TYPE3_FOOTER_CELL_HEIGHT CVSHEET_OTHER_CELL_HEIGHT

BOOL isType2BackgroundWhite;

@implementation CVBlanceSheetFormViewController

@synthesize pageData = _pageData;
@synthesize sheetTableView;

@synthesize _list;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	isType2BackgroundWhite = YES;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (NSString *) stringWithB:(NSString *)str
{
	NSUInteger integerValue;
	NSString *retStr;
	
	integerValue = [str integerValue];
	

	return retStr;
}

- (void)setPageData:(id)pageData {
	NSDictionary *titles, *values;
	
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [local localizedString:@"LangCode"];
	
	if (nil != pageData) {
		[_pageData release];
		_pageData = [pageData retain];
		titles = [_pageData objectForKey:@"titles"];
		values = [_pageData objectForKey:@"values"];
		
		NSDictionary *dict, *aCellFormat;
		NSArray *format;
		NSString *hydm;
		NSString *cfgFilePath;
		NSMutableArray *tableData = nil;
		
		dict = (NSDictionary *)values;
		hydm = [dict objectForKey:@"HYDM"];
		hydm = [hydm lowercaseString];
		if ([hydm isEqualToString:@"i0000"]) {
			cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetOther_%@",_langCode] ofType:@"plist"];
		} else if ([hydm isEqualToString:@"i31"]) {
			cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetTrust_%@",_langCode] ofType:@"plist"];
		} else if ([hydm isEqualToString:@"i11"]) {
			cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetInsurance_%@",_langCode] ofType:@"plist"];
		} else if ([hydm isEqualToString:@"i01"]) {
			cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetBank_%@",_langCode] ofType:@"plist"];
		} else if ([hydm isEqualToString:@"i21"]) {
			cfgFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"BalanceSheetSecurities_%@",_langCode] ofType:@"plist"];
		}
		
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
			[format release];
			[_list release];
			self._list = tableData;
			[tableData release];
		}
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_list count];
}

#pragma mark - 
#pragma mark Tabel View delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	SheetCell *cellData;
	CGFloat height;
	
	cellData = [_list objectAtIndex:indexPath.row];
	
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
	
	cellData = [_list objectAtIndex:indexPath.row];
	
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

	if (cellData.value != nil && NO == [cellData.value isKindOfClass:[NSString class]]){
		//NSLog(@"");
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


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[sheetTableView release];
	
	[_list release];
	[_pageData release];
    [super dealloc];
}
											
								


@end

