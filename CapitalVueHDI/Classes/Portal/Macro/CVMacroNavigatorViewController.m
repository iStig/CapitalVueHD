//
//  CVMacroNavigatorViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/25/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMacroNavigatorViewController.h"

@interface CVMacroNavigatorViewController()


@property (nonatomic, retain) NSArray *_navigatorGroups;
@property (nonatomic, retain) UITableView *_tableView;
/*
 * it reads structured items from plist
 *
 * @param:	none
 * @return:	none
 */
- (void)loadNavigatorItems;

@end

@implementation CVMacroNavigatorViewController

@synthesize delegate;

@synthesize _tableView;
@synthesize _navigatorGroups;
@synthesize parent;
@synthesize currentGroupDict;
@synthesize currentItem;
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
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self.style = CVPortletViewStyleBarVisible;
    [super viewDidLoad];
	self.portletTitle = [langSetting localizedString:@"Macro"];
	[self.view bringSubviewToFront:self._tableView];
	
	[self loadNavigatorItems];
	flagArray = [[NSMutableArray alloc] init];
	for (int i=0;i<[_navigatorGroups count];i++)
	{
		[flagArray addObject:[NSNumber numberWithBool:YES]];
	}
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_navigatorGroups count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	NSDictionary *groupDict;
//	groupDict = [_navigatorGroups objectAtIndex:section];
//	
//	return [groupDict objectForKey:@"group"];
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	//NSArray *items;
//	NSDictionary *groupDict;
//	groupDict = [_navigatorGroups objectAtIndex:section];
//	items = [groupDict objectForKey:@"items"];
//    return [items count];
	return [self numberOfRowsInSection:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSArray *items;
	NSDictionary *groupDict, *itemDict;
	groupDict = [_navigatorGroups objectAtIndex:indexPath.section];
	items = [groupDict objectForKey:@"items"];
	itemDict = [items objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.textLabel.text = [itemDict objectForKey:@"title"];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
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
	NSArray *items;
	NSDictionary *groupDict, *itemDict;
	groupDict = [_navigatorGroups objectAtIndex:indexPath.section];
	items = [groupDict objectForKey:@"items"];
	itemDict = [items objectAtIndex:indexPath.row];
	self.currentItem = itemDict;
	self.currentGroupDict = groupDict;
	[delegate didReceiveNavigatorRequest:[groupDict objectForKey:@"group"] forItem:itemDict indexPath:indexPath];
	[parent dismissPopoverAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString *resStr;
	if ([[flagArray objectAtIndex:section] boolValue])
		resStr = @"Macro_minus.png";
	else
		resStr = @"Macro_plus.png";
	NSString *path = [[NSBundle mainBundle] pathForResource:resStr ofType:nil];
	NSDictionary *groupDict;

	groupDict = [_navigatorGroups objectAtIndex:section];
	UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
	NSString *pathx = [[NSBundle mainBundle] pathForResource:@"Macro_button.png" ofType:nil];
	UIImage *imgx = [[UIImage alloc] initWithContentsOfFile:pathx];
	[abtn setBackgroundImage:imgx forState:UIControlStateNormal];
	[imgx release];
	[abtn sizeToFit];
	
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 230, 39)];
	lbl.text = [groupDict objectForKey:@"group"];
	lbl.backgroundColor = [UIColor clearColor];
	[abtn addSubview:lbl];
	[lbl release];
	
    abtn.tag = section;
	abtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [abtn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
	imgv.center = CGPointMake(18, 19.5);
	imgv.opaque = NO;
	[abtn addSubview:imgv];
	[img release];
	[imgv release];

    return abtn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 39;
}
- (void)headerClicked:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	int sectionIndex = btn.tag;
	BOOL flag = ![[flagArray objectAtIndex:sectionIndex] boolValue];
	
    [flagArray replaceObjectAtIndex:sectionIndex withObject:[NSNumber numberWithBool:flag]];
    [_tableView reloadData];

}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
	BOOL flag = [[flagArray objectAtIndex:section] boolValue];
	if (flag)
	{
		NSArray *items;
		NSDictionary *groupDict;
		groupDict = [_navigatorGroups objectAtIndex:section];
		items = [groupDict objectForKey:@"items"];
		return [items count];
	}
	else
		return 0;
		
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
	[_tableView release];
	[_navigatorGroups release];
	[flagArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark private method
/*
 * it reads structured items from plist
 *
 * @param:	none
 * @return:	none
 */
- (void)loadNavigatorItems {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	self._navigatorGroups = [langSetting getMacroNaviItems];
	
	[_tableView reloadData];
}

- (void) reloadCurrentItem{
	if (currentGroupDict==nil || currentItem==nil) {
		NSArray *items;
		NSDictionary *groupDict, *itemDict;
		groupDict = [_navigatorGroups objectAtIndex:0];
		items = [groupDict objectForKey:@"items"];
		itemDict = [items objectAtIndex:0];
		self.currentItem = itemDict;
		self.currentGroupDict = groupDict;
	}
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	if (currentGroupDict && currentItem) {
		[delegate didReceiveNavigatorRequest:[currentGroupDict objectForKey:@"group"] forItem:currentItem indexPath:indexPath];
		[parent dismissPopoverAnimated:YES];
	}
}

@end

