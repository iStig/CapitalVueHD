//  CVMenuController.m
//  CapitalVueHD
//
//  Renamed by Ji Shen on 10-9-3
//
//  CVMenuController.m
//  CapitalValDemo
//
//  Created by leon on 10-8-7.
//  Copyright 2010 SmilingMobile. All rights reserved.
//
/*
 this class can create a TableViewController,
 when SettingTableView has been created,this controller
 will be added.
 */

#import "CVMenuController.h"
#import <QuartzCore/QuartzCore.h>

#import "CVMenuItem.h"


@implementation CVMenuController

@synthesize tableMenu;
@synthesize arraySetting = _arraySetting;

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

//初始化设置数组内容，从SettingData设置类读取数据
- (void)viewDidLoad {
	self.view.layer.cornerRadius = 8;
	self.view.layer.masksToBounds = YES;
	CGRect rect;
	
	// draw the bar 
	UIImageView *barView;
	UIImage *image;
	
	rect = CGRectMake(0.0, 0.0, 236, 31);
	barView = [[UIImageView alloc] initWithFrame:rect];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"portlet_menu_bar.png" ofType:nil];
	image = [[UIImage alloc] initWithContentsOfFile:path];
	barView.image = image;
	[image release];
	[self.view addSubview:barView];
	[barView release];
	
	UITableView *table;
	rect = CGRectMake(0, 31, 236, 120);
	table = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
	table.delegate  = self;
	table.dataSource = self;
	
	[self.view addSubview:table];
	[table release];//dream's release
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#define CVPORTLET_MENU_CELL_LABEL_TAG 2001
#define CVPORTLET_MENU_CELL_CHECK_TAG 2002

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *tableIdentifier = @"MenuCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:tableIdentifier] autorelease];
		
		// draw background
		NSString *path = [[NSBundle mainBundle] pathForResource:@"portlet_menu_cell_background.png" ofType:nil];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
		UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 236, 31)];
		background.image = img;
		[img release];
		[cell setBackgroundView:background];
		[background release];//dream's release
		// insert label
		UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 5.0, 100.0, 21.0)];
		labelContent.backgroundColor = [UIColor clearColor];
		labelContent.tag = CVPORTLET_MENU_CELL_LABEL_TAG;
		[cell.contentView addSubview:labelContent];
		[labelContent release];
		
		// insert image view for check box
		UIImageView *checkboxView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 21, 21)];
		checkboxView.tag = CVPORTLET_MENU_CELL_CHECK_TAG;
		[cell.contentView addSubview:checkboxView];
		[checkboxView release];
		
		// accessory
		NSString *pathacc = [[NSBundle mainBundle] pathForResource:@"portlet_menu_cell_accessory.png" ofType:nil];
		UIImage *imglines = [[UIImage alloc] initWithContentsOfFile:pathacc];
		UIImageView *imgethreelines = [[UIImageView alloc] initWithFrame:CGRectMake(210.0, 10.0, 9.0, 9.0)];
		imgethreelines.image = imglines;
		[imglines release];
		[cell.contentView addSubview:imgethreelines];
		[imgethreelines release];
	}
	
	CVMenuItem *item = [_arraySetting objectAtIndex:indexPath.row];
	UILabel *label = (UILabel *)[cell.contentView viewWithTag:CVPORTLET_MENU_CELL_LABEL_TAG];
	label.text = item.name;
	label.font = [UIFont boldSystemFontOfSize:13];
	UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:CVPORTLET_MENU_CELL_CHECK_TAG];
	if (YES == item.select) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"portlet_menu_cell_checked.png" ofType:nil];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
		imageView.image = img;
		[img release];
	} else {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"portlet_menu_cell_unchecked.png" ofType:nil];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
		imageView.image = img;
		[img release];
	}

	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [_arraySetting count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 31.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[menuDelegate didSelectItemAtIndexPath:indexPath];
	
	// alter the background of cell at index
	CVMenuItem *item = [_arraySetting objectAtIndex:indexPath.row];
	item.select = !item.select;
	[tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/*
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
*/


- (void)dealloc {
	[_arraySetting release];
    [super dealloc];
}

#pragma mark public methods
- (void)setDelegate:(id)delegate {
	menuDelegate = delegate;
}

@end
