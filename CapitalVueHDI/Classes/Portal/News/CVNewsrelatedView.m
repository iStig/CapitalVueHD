//
//  CVNewsrelatedView.m
//  CapitalVueHD
//
//  Created by leon on 10-9-26.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVNewsrelatedView.h"
#import "CVNewsDetailView.h"
#import "CVPortal.h"
#import "CVMyStockDetailViewController.h"
#define CVNEWS_RELATE_TITLELABEL_TAG 33;
#define CVNEWS_RELATE_DATELABEL_TAG 34;

@interface CVNewsrelatedView()

@property (nonatomic, retain) NSMutableArray *tempArray;
@property (nonatomic, retain) UILabel *_noEntryLabel;

@end


@implementation CVNewsrelatedView
//@synthesize labelTitle = _labelTitle;
@synthesize tableView  = _tableView;
@synthesize tempArray = _tempArray;
@synthesize newsClass;

@synthesize _noEntryLabel;

- (id)initWithFrame:(CGRect)frame {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.autoresizesSubviews = NO;
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(20.0, 50.0, 440, 275) style:UITableViewStylePlain];
		_tableView.separatorColor = [UIColor clearColor];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.backgroundColor = [UIColor clearColor];
		[_imageBackground addSubview:_tableView];
		_imageBackground.userInteractionEnabled = YES;
		
		UILabel *label;
		label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 440, 272)];
		label.autoresizingMask = UIViewAutoresizingNone;
		label.autoresizesSubviews = NO;
		label.font = [UIFont boldSystemFontOfSize:18.0];
		label.textColor = [UIColor darkGrayColor];
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		label.text = [langSetting localizedString:@"Sorry! No Entry Available"];
		label.hidden = YES;
		self._noEntryLabel = label;
		[label release];
		[_imageBackground addSubview:_noEntryLabel];
		
		self.tempArray = [[NSMutableArray alloc] initWithObjects:nil];
		[_tempArray release];
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setHidesWhenStopped:YES];
        CGRect activityFrame = CGRectMake(_imageBackground.frame.size.width/2-20, 
										  _imageBackground.frame.size.height/2- 20, 
										  40, 40);
        activityIndicator.frame = activityFrame;
        [_imageBackground addSubview:activityIndicator];
		[activityIndicator startAnimating];
		_isLoading = NO;
    }
    return self;
}

#pragma mark -
#pragma mark TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [self.tempArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	if ([[self.tempArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
		static NSString *CellIdentifier = @"Cell";
		UILabel *titleLabel, *dateLabel;
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		else {
			titleLabel = (UILabel *)[cell.contentView viewWithTag:1];//CVNEWS_RELATE_TITLELABEL_TAG];
			dateLabel = (UILabel *)[cell.contentView viewWithTag:2];//CVNEWS_RELATE_DATELABEL_TAG];
			if (titleLabel) {
				[titleLabel removeFromSuperview];
			}
			if (dateLabel) {
				[dateLabel removeFromSuperview];
			}
		}
		
		UIImageView *imageDottedline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54, 435, 1)];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"dotted_line.png" ofType:nil];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
		imageDottedline.image = img;
		[img release];
		[cell.contentView addSubview:imageDottedline];
		[imageDottedline release];
		
		
		NSDictionary *dict = [self.tempArray objectAtIndex:indexPath.row];
		if (dict && [dict isKindOfClass:[NSDictionary class]]) {
			titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 400, 25)];
			titleLabel.tag = 1;
			
			titleLabel.text = [dict valueForKey:@"title"];
			titleLabel.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
			titleLabel.backgroundColor = [UIColor clearColor];
			titleLabel.font = [UIFont boldSystemFontOfSize:15];
			[cell.contentView addSubview:titleLabel];
			[titleLabel release];
			
			dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 400, 20)];
			dateLabel.tag = 2;
			dateLabel.text = [self stampchangetime:[dict valueForKey:@"t_stamp"]];
			dateLabel.textColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
			dateLabel.backgroundColor = [UIColor clearColor];
			dateLabel.font = [UIFont systemFontOfSize:14];
			[cell.contentView addSubview:dateLabel];
			[dateLabel release];
		}
		//}
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		return cell;
	}else {
		static NSString *MoreIdentifier = @"MoreIdentifier";
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MoreIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreIdentifier] autorelease];
		}else {
			UIView *titleLabel = [cell viewWithTag:1024];
			if (titleLabel) {
				[titleLabel removeFromSuperview];
			}
		}

		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 400, 45)];
		
		titleLabel.tag = 1024;
		
		titleLabel.text = [langSetting localizedString:@"more..."];
		titleLabel.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont systemFontOfSize:14];
		[cell.contentView addSubview:titleLabel];
		[titleLabel release];
		//}
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		return cell;
	}
}

//unix time stamp conversion to date string
- (NSString *)stampchangetime:(NSString *)timestamp{
	NSTimeInterval seconds = [timestamp intValue];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	NSString *str;
		
	[formatter setDateFormat:@"MM/dd/yyyy    HH:mm"];
	str = [formatter stringFromDate:date];
	
	return str;
}

-(void)appendNewsForCurrentPage{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	_isLoading = YES;
	_currentPage ++;
	NSMutableArray *array = [relatedDelegate attachNewsAtPage:_currentPage];
	
	if ([self.tempArray count]> 0 && [[self.tempArray lastObject] isKindOfClass:[NSString class]]) {
		[self.tempArray removeLastObject];
	}
	if ([array count] > 0) {
		[self.tempArray addObjectsFromArray:array];
		if ([array count] == CV_NEWS_PAGECAPACITY) {
			[self.tempArray addObject:[langSetting localizedString:@"more..."]];
		}
	}else {
		_currentPage--;
	}
	if (0 == [self.tempArray count]) {
		_noEntryLabel.hidden = NO;
	}
	[_tableView reloadData];
	_isLoading = NO;
	[pool release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}

#pragma mark -
#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (_isLoading && indexPath.row == (_currentPage)*CV_NEWS_PAGECAPACITY) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}
	if (indexPath.row == (_currentPage+1)*CV_NEWS_PAGECAPACITY) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		_isLoading = YES;
		[NSThread detachNewThreadSelector:@selector(appendNewsForCurrentPage) toTarget:self withObject:nil];
		return;
	}
	NSDictionary *dict = [self.tempArray objectAtIndex:indexPath.row];
	if (newsClass == CVClassNews) {
		if (dict && [dict isKindOfClass:[NSDictionary class]]) {
			[relatedDelegate goWebDetail:dict];
		}
	}
	else if (newsClass == CVClassMystock) {
		NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
		[dictTemp setObject:[NSNumber numberWithInt:4] forKey:@"Number"];
		[dictTemp setObject:dict forKey:@"dictContent"];
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:CVPortalSwitchPortalSetNotification object:dictTemp];
		[dictTemp release];
	}
	else if (newsClass == CVClassMacro){
		NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
		[dictTemp setObject:[NSNumber numberWithInt:4] forKey:@"Number"];
		[dictTemp setObject:dict forKey:@"dictContent"];
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:CVPortalSwitchPortalSetNotification object:dictTemp];
		[dictTemp release];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"setButtonImage" object:nil];
	
	//[self setHidden:YES];
}

- (void)setDelegate:(id)delegate{
	if (relatedDelegate!=delegate){
		[relatedDelegate release];
		relatedDelegate = [delegate retain];
	}
}

- (void)dealloc {
	[relatedDelegate release];
	
	[_tableView  release];
	[_tempArray release];
	[activityIndicator release];
	[_noEntryLabel release];
    [super dealloc];
}

- (void)startRotationView
{
	[super startRotationView];
	_currentPage = -1;
	[NSThread detachNewThreadSelector:@selector(appendNewsForCurrentPage) toTarget:self withObject:nil];
}

- (void)changeIndicator:(NSNumber *)action
{
	BOOL bAnimate = [action boolValue];
	if(bAnimate)
	{
		[activityIndicator startAnimating];
		activityIndicator.hidden = NO;
	}
	else
	{
		[activityIndicator stopAnimating];
		activityIndicator.hidden = YES;
	}
}
@end
