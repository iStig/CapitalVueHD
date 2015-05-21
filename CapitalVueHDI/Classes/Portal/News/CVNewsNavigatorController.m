//
//  CVNewsNavigatorController.m
//  CapitalVueHD
//
//  Created by leon on 10-9-26.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVNewsNavigatorController.h"
#import "CVNewsTableViewCell.h"

@implementation CVNewsNavigatorController
@synthesize tableView = _tableView;
@synthesize arrayNews = _arrayNews;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 275, 600) style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	_isFinished = YES;
    [super viewDidLoad];
}

#pragma mark -
#pragma mark TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [_arrayNews count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	CVNewsTableViewCell *cell = (CVNewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CVNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	} else {
		[cell removeElement];
	}
    
	if ([_arrayNews count]>indexPath.row){
		NSObject *obj = [_arrayNews objectAtIndex:indexPath.row];
		if ([obj isKindOfClass:[NSString class]]) {
			NSString *more = (NSString *)obj;
			cell.strTitle = more;
			cell.strTime = nil;
			cell.strThumbnail = nil;
		} else {
			NSDictionary *dict = (NSDictionary *)obj;
			NSString *strTitle = [dict valueForKey:@"title"];
			NSString *strStamp = [dict valueForKey:@"t_stamp"];
			cell.strTitle = strTitle;
			cell.strTime  = [self stampchangetime:strStamp isDetail:NO];
			if (indexPath.row<=1) {
				NSString *strThumb = [dict valueForKey:@"thumbUrl"];
				if (!strThumb) {
					cell.strThumbnail = nil;
				}
				else {
					NSArray *ary = [strThumb componentsSeparatedByString:@"&"];
					cell.strThumbnail = [NSString stringWithFormat:@"%@&size=456",[ary objectAtIndex:0]];
				}
			} else {
				cell.strThumbnail = nil;
			}
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		[cell addElement];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height;
	if (indexPath.row < 2) {
		NSMutableDictionary *dict = [_arrayNews objectAtIndex:indexPath.row];
		NSString *strThumb = [dict valueForKey:@"thumbUrl"];
		if (!strThumb) {
			height = 80;
		}
		else {
			height = 230;
		}
	}
	else {
		height = 80;
	}
	
	return height;
}

#pragma mark -
#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject *obj;
	if ([_arrayNews count] == 0) {
		NSLog(@"_arrayNews=nil");
		return;
	}
	
	obj = [_arrayNews objectAtIndex:indexPath.row];
	if ([obj isKindOfClass:[NSString class]]) {
		[navigatorDelegate selectedNextPage];
	} else {
		[navigatorDelegate didSelectItemAtIndexPath:indexPath item:(NSDictionary *)obj];
	}
    
}

#pragma mark -
#pragma mark set delegate
- (void)setDelegate:(id)delegate {
	navigatorDelegate = delegate;
}

//unix time stamp conversion to date string
- (NSString *)stampchangetime:(NSString *)timestamp isDetail:(BOOL)isDetail{
	NSTimeInterval seconds = [timestamp intValue];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	NSString *str;
	if (isDetail == YES) {
		[formatter setDateFormat:@"EEEE yyyy-MM-dd HH:mm"];
		str = [formatter stringFromDate:date];
	}
	else {
		
		[formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
		str = [formatter stringFromDate:date];
	}
	
	return str;
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
	[_tableView release];
	[_arrayNews release];
    [super dealloc];
}


@end
