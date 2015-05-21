    //
//  CVSettingTableController.m
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

#import "CVSettingTableController.h"
#import "CVSettingData.h"
#import <QuartzCore/QuartzCore.h>


@implementation CVSettingTableController
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
//	SettingData *setting = [SettingData sharedSettingData];
//	NSMutableArray *array = [setting getArrayData];
//	if ([array count] <= 0) {
//		NSMutableDictionary *dict = [[NSMutableDictionary alloc] 
//									 initWithObjectsAndKeys:
//									 @"Today's News",@"Style",
//									 @"YES",@"Headline News",
//									 @"YES",@"Latest News",
//									 @"NO",@"Macro",
//									 @"NO",@"Discretion",
//									 @"NO",@"Staples",nil];
//		[array addObject:dict];
//		[setting setArrayData:array];
//		
//		for (NSInteger i = 1; i < [dict count]; i++)
//		{
//			NSString *str = [dict ];
//		}
//	}
//	self.m_arraySetting = array;

	_arraySetting = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",nil];
	self.view.layer.cornerRadius = 8;
	self.view.layer.masksToBounds = YES;
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *tableIdentifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:tableIdentifier] autorelease];
	}
	UIImage *img = [UIImage imageNamed:@"settingtablecell_background.png"];
	UIImageView *imgcellbackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, img.size.width, img.size.height-10)];
	imgcellbackground.image = img;

	[cell setBackgroundView:imgcellbackground];
	UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 15.0, 100.0, 20.0)];
	labelContent.text = [_arraySetting objectAtIndex:indexPath.row];
	labelContent.backgroundColor = [UIColor clearColor];
	[cell.contentView addSubview:labelContent];
	[labelContent release];
	
	UIButton *buttonSeleted = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonSeleted setFrame:CGRectMake(5.0, 15.0, 20.0, 20.0)];
	UIImage *imgSeleted = [UIImage imageNamed:@"uncheck_button.png"];
	[buttonSeleted setImage:imgSeleted forState:UIControlStateNormal];
	[buttonSeleted addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:buttonSeleted];
	//[buttonSeleted release];
	
	UIImage *imglines = [UIImage imageNamed:@"three_lines.png"];
	UIImageView *imgethreelines = [[UIImageView alloc] initWithFrame:CGRectMake(225.0, 15.0, 9.0, 9.0)];
	imgethreelines.image = imglines;
	[cell.contentView addSubview:imgethreelines];
	[imgethreelines release];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [_arraySetting count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

//head of section height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 41;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIImageView *imgView = [[UIImageView alloc] init];
	UIImage *img = [UIImage imageNamed:@"setting_sectionhead_background.png"];
	imgView.image = img;
	
	UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 5.0, 150.0, 30.0)];
	label_title.text = @"Edit Categories";
	label_title.textColor = [UIColor whiteColor];
	label_title.backgroundColor = [UIColor clearColor];
	[imgView addSubview:label_title];
	[label_title release];
	return imgView;
}

-(IBAction) clickSelectedButton:(id)sender{
	UIButton *button = (UIButton *)sender;
	UIImage *img = [UIImage imageNamed:@"check_button.png"];
	[button setImage:img forState:UIControlStateNormal];
	//NSLog(@"b click");
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
	[_arraySetting release];
    [super dealloc];
}


@end
