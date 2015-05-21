    //
//  CVMyStockNavigatorViewController.m
//  CapitalVueHD
//
//  Created by leon on 10-9-28.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVMyStockNavigatorViewController.h"
#import "CVDataProvider.h"
#import "NSString+Number.h"

@interface CVMyStockNavigatorViewController()

@property (nonatomic, retain) NSMutableArray *_arrayEquity;
@property (nonatomic, retain) NSMutableArray *_arrayFund;
@property (nonatomic, retain) NSMutableArray *_arrayBond;

@property (nonatomic,retain) NSMutableArray *_arrayIndexDetail;

@property (nonatomic, retain) NSTimer *_stockListTimer;
@property (nonatomic, retain) NSLock *_dataMutex;

- (void)timerUpdateStockList:(NSTimer *)timer;

- (void)syncIndexIntroDay:(NSNotification *)notification;

- (void)syncStockIntroDay:(NSNotification *)notification;

@end

#define CVMYSTOCK_BUTTON_HEIGHT   20
#define CVMYSTOCK_NAMELABEL_TAG   29
#define CVMYSTOCK_CLOSELABEL_TAG  30
#define CVMYSTOCK_CHGLABEL_TAG    31
#define CVMYSTOCK_CHGPERLABEL_TAG 32


@implementation CVMyStockNavigatorViewController
@synthesize parent;
@synthesize frame;
@synthesize tableView  = _tableView;
@synthesize buttonEdit = _buttonEdit;
@synthesize arrayButton = _arrayButton;
@synthesize arrayDetail = _arrayDetail;
@synthesize activityIndicator = _activityIndicator;

@synthesize _arrayEquity;
@synthesize _arrayFund;
@synthesize _arrayBond;

@synthesize _arrayIndexDetail;

@synthesize _stockListTimer;
@synthesize _dataMutex;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    self.view.frame = frame;
	_imageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 656)];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"portal_mystock_navigator_background.png" ofType:nil];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	_imageBackground.image = img;
	[img release];
	_imageBackground.userInteractionEnabled = YES;
	
	_buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
	[_buttonEdit setFrame:CGRectMake(220, 10, 48, 24)];
	NSString *path1 = [[NSBundle mainBundle] pathForResource:@"mystock_navigator_edit_button.png" ofType:nil];
	UIImage *imgButtonEdit = [[UIImage alloc] initWithContentsOfFile:path1];
	[_buttonEdit setBackgroundImage:imgButtonEdit forState:UIControlStateNormal];
	[_buttonEdit setTitle:[langSetting localizedString:@"Edit"] forState:UIControlStateNormal];
	_buttonEdit.titleLabel.font = [UIFont systemFontOfSize:14];
	[_buttonEdit addTarget:self action:@selector(clickEditButton) forControlEvents:UIControlEventTouchUpInside];
	[_imageBackground addSubview:_buttonEdit];
	[imgButtonEdit release];
	
	UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 100, 20)];
	labelTitle.backgroundColor = [UIColor clearColor];
	labelTitle.textColor = [UIColor whiteColor];
	labelTitle.text = [langSetting localizedString:@"My Stock"];
	labelTitle.font = [UIFont boldSystemFontOfSize:15];
	[_imageBackground addSubview:labelTitle];
	[labelTitle release];
	
	_imageToolbarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 47, 296, 36)];
	NSString *path2 = [[NSBundle mainBundle] pathForResource:@"mystock_navigator_toolbar_background.png" ofType:nil];
	UIImage *img2 = [[UIImage alloc] initWithContentsOfFile:path2];
	_imageToolbarBackground.image = img2;
	[img2 release];
	_imageToolbarBackground.userInteractionEnabled = YES;
	[_imageBackground addSubview:_imageToolbarBackground];
	[self loadToolBarButton];
	
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 83, 296, 550)];
	
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.separatorColor = [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1];
	_tableView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
	[_imageBackground addSubview:_tableView];
	
	[self.view addSubview:_imageBackground];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_activityIndicator.frame = CGRectMake(_imageBackground.frame.size.width / 2 - 5,
										  _imageBackground.frame.size.height / 2 - 35,
										  _activityIndicator.frame.size.width, 
										  _activityIndicator.frame.size.height);
	_activityIndicator.hidesWhenStopped = YES;
	[_activityIndicator stopAnimating];
	[_imageBackground addSubview:_activityIndicator];
	
	self._dataMutex = [[NSLock alloc] init];
	
	_lastSelect = -1;
	
	[NSThread detachNewThreadSelector:@selector(loadStockList) toTarget:self withObject:nil];
	
	self._stockListTimer = [NSTimer scheduledTimerWithTimeInterval:300.0
															target:self selector:@selector(timerUpdateStockList:)
														  userInfo:nil repeats:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncIndexIntroDay:) name:kNotificationUpdateIndex object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncStockIntroDay:) name:kNotificationUpdateStock object:nil];
	
	[super viewDidLoad];
}


/*get my stoct array from plist*/
- (void)getMyStock {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:@"mystock.plist"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:filename]) {
		NSString *fileAtPath;
		NSError *error;
		fileAtPath = [[NSBundle mainBundle] pathForResource:@"mystock" ofType:@"plist"];
		if ([[NSFileManager defaultManager] copyItemAtPath:fileAtPath toPath:filename error:&error] == NO) {
			NSAssert1(0, @"Failed to copy data with error message '%@'.", [error localizedDescription]);
		}
	}
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];

	self._arrayEquity = [dict valueForKey:@"EquityList"];
	if (!_arrayEquity) {
		NSMutableArray *array;
		array = [[NSMutableArray alloc] init];
		self._arrayEquity = array;
		[array release];
	}
	self._arrayFund  = [dict valueForKey:@"FundList"];
	self._arrayBond  = [dict valueForKey:@"BondList"];
	[dict release];
}

- (void)addNewFavoerite:(NSDictionary *)description {
	[_dataMutex lock];
	
	// sort _arrayEquity
	// spilit the array into two arrays: index and equity
	NSDictionary *equityDict;
	NSMutableArray *indexArray, *equityArray;
	BOOL isEquity;
	
	[_arrayEquity addObject:description];
	indexArray = [[NSMutableArray alloc] initWithCapacity:1];
	equityArray = [[NSMutableArray alloc] initWithCapacity:1];
	
	for (equityDict in _arrayEquity) {
		isEquity = [[equityDict objectForKey:@"isEquity"] boolValue];
		if (isEquity) {
			[equityArray addObject:equityDict];
		} else {
			[indexArray addObject:equityDict];
		}
	}
	
	// sort arrays
	NSSortDescriptor *sortDescByCode;
	NSSortDescriptor *sortDescByName;
	
	sortDescByCode = [[NSSortDescriptor alloc] initWithKey:@"code" ascending:YES];
	sortDescByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[indexArray sortUsingDescriptors:[NSMutableArray arrayWithObject:sortDescByName]];
	[equityArray sortUsingDescriptors:[NSMutableArray arrayWithObject:sortDescByCode]];
	[sortDescByCode release];
	[sortDescByName release];
	
	[_arrayEquity removeAllObjects];
	[_arrayEquity addObjectsFromArray:indexArray];
	[_arrayEquity addObjectsFromArray:equityArray];
	[indexArray release];
	[equityArray release];
	
	[self saveMyStock];
	[_tableView reloadData];
	[_dataMutex unlock];
}

/*save my stock to plist*/
- (void)saveMyStock {
	NSString *fileName = @"mystock.plist";
	NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
					  stringByAppendingPathComponent:fileName];
	
	//make dict to save
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						  _arrayEquity, @"EquityList",
						  _arrayFund, @"FundList",
						  _arrayBond, @"BondList",nil];
	
	//save latest data to file
	[dict writeToFile:path atomically:NO];
	[dict release];
}

- (void)timerUpdateStockList:(NSTimer *)timer {
	[NSThread detachNewThreadSelector:@selector(loadStockList) toTarget:self withObject:nil];
}

- (void)loadStockList{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (!_arrayEquity)
		[self getMyStock];
	if ([_arrayEquity count] > 0) {
		NSUInteger count;
		NSDictionary *aDict;
		NSString *code, *name;
		NSNumber *numIsEquity;
		BOOL isEquity;
		count = [_arrayEquity count];
		
		for (int i=0;i<count;i++){
			aDict = [_arrayEquity objectAtIndex:i];
			code = [aDict objectForKey:@"code"];
			name = [aDict objectForKey:@"name"];
			numIsEquity = [aDict objectForKey:@"isEquity"];
			isEquity = [numIsEquity boolValue];
			if (isEquity) {
				[NSThread detachNewThreadSelector:@selector(updateStock:) toTarget:self withObject:code];
			} else {
				[NSThread detachNewThreadSelector:@selector(updateIndex:) toTarget:self withObject:code];
			}
		}
	}
	
	[pool release];
}

- (void)loadToolBarButton{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	UIButton *button;
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:CVMyStockBondButton];
	for (int i = CVMyStockStockButton; i <= CVMyStockBondButton; i++) {
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *strTitle;
		switch (i) {
			case CVMyStockStockButton:
				strTitle = [NSString stringWithString:[langSetting localizedString:@"Stock"]];
				[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				break;
			case CVMyStockFundButton:
				strTitle = [NSString stringWithString:[langSetting localizedString:@"Fund"]];
				[button setTitleColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1] forState:UIControlStateNormal];
				break;
			case CVMyStockBondButton:
				strTitle = [NSString stringWithString:[langSetting localizedString:@"Bond"]];
				[button setTitleColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1] forState:UIControlStateNormal];
				break;
			default:
				break;
		}
		[button setTitle:strTitle forState:UIControlStateNormal];
		[button.titleLabel setFont:[UIFont systemFontOfSize:15]];
		if (i == CVMyStockStockButton) {
			button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
		}
		else {
			//button.enabled = NO;
		}

		button.tag = i;
		[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		button.frame = CGRectMake(i*80 + 45, 10, 50, CVMYSTOCK_BUTTON_HEIGHT);
		//button.portalset = i;
		button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		[_imageToolbarBackground addSubview:button];
		[array addObject:button];
	}
	self.arrayButton = array;
	[array release];
	
	for (int i = CVMyStockStockButton; i < CVMyStockBondButton; i++) {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*80 + 105, 10, 2, CVMYSTOCK_BUTTON_HEIGHT)];
		label.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1];
		label.backgroundColor = [UIColor clearColor];	
		label.font = [UIFont systemFontOfSize:17];
		label.text = @"|";
		[_imageToolbarBackground addSubview:label];
		[label release];
	}
}

- (void)buttonClicked:(id)sender{
	CVLocalizationSetting *local = [CVLocalizationSetting sharedInstance];
	UIButton *button = (UIButton *)sender;
	switch (button.tag) {
		case CVMyStockStockButton:
		{
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
			
			for (UIButton *element in _arrayButton) {
				if (element.tag != button.tag) {
					[element setTitleColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1] forState:UIControlStateNormal];
					element.titleLabel.font = [UIFont systemFontOfSize:15];
				}
			}
			break;	
		}
		case CVMyStockFundButton:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[local localizedString:@"This feature is unavailable with your current version of the application."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			break;
		}
		case CVMyStockBondButton:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[local localizedString:@"This feature is unavailable with your current version of the application."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			break;
		}
		default:
			break;
	}
}

- (void)clickEditButton{
	[_tableView setEditing:!_tableView.editing animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	//[self dismissRotationView];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 296, 30)];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"mystock_navigator_tablehead_background.png" ofType:nil];
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
	view.backgroundColor = [UIColor colorWithPatternImage:img];
	[img release];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 298, 25)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor blackColor];
	label.font = [UIFont boldSystemFontOfSize:12];
	label.text = [langSetting localizedString:@"MyStockNaviCaption"];
	[view addSubview:label];
	[label release];
	return [view autorelease];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_arrayEquity count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyEquityCell";
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *_langCode = [langSetting localizedString:@"LangCode"];
    UILabel *labelName, *labelClose,*labelCHG,*labelCHGPercent;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
		labelName		= [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 70, 30)];
		labelClose      = [[UILabel alloc] initWithFrame:CGRectMake(82, 10, 70, 30)];
		labelCHG        = [[UILabel alloc] initWithFrame:CGRectMake(158, 10, 70, 30)];
		labelCHGPercent = [[UILabel alloc] initWithFrame:CGRectMake(225, 10, 70, 30)];
		
		labelName.tag = CVMYSTOCK_NAMELABEL_TAG;
		labelClose.tag  = CVMYSTOCK_CLOSELABEL_TAG;
		labelCHG.tag    = CVMYSTOCK_CHGLABEL_TAG;
		labelCHGPercent.tag = CVMYSTOCK_CHGPERLABEL_TAG;
		
		labelName.font = [UIFont boldSystemFontOfSize:14];
		labelClose.font = [UIFont systemFontOfSize:14];
		labelCHG.font = [UIFont systemFontOfSize:14];
		labelCHGPercent.font = [UIFont systemFontOfSize:14];
		
		labelName.backgroundColor = [UIColor clearColor];
		labelClose.backgroundColor = [UIColor clearColor];
		labelCHG.backgroundColor = [UIColor clearColor];
		labelCHGPercent.backgroundColor = [UIColor clearColor];
		
		
		[cell.contentView addSubview:labelName];
		[cell.contentView addSubview:labelClose];
		[cell.contentView addSubview:labelCHG];
		[cell.contentView addSubview:labelCHGPercent];
		
		[labelName release];
		[labelClose release];
		[labelCHG release];
		[labelCHGPercent release];
    } else {
		labelName = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_NAMELABEL_TAG];
		labelClose = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_CLOSELABEL_TAG];
		labelCHG = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_CHGLABEL_TAG];
		labelCHGPercent = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_CHGPERLABEL_TAG];
	}
	
	NSDictionary *dict;
	
	NSString *code;
	NSString *close;
	NSString *change;
	NSString *changeRatio;
	NSNumber *numIsEquity;
	BOOL isEquity;
	
	dict = [[_arrayEquity objectAtIndex:indexPath.row] copy];
	numIsEquity = [dict objectForKey:@"isEquity"];
	isEquity = [numIsEquity boolValue];
	if (isEquity) {	
		code = [dict objectForKey:@"code"];
	} else {
		code = [dict objectForKey:@"name"];
	}
	close = [dict objectForKey:@"close"];
	change = [dict objectForKey:@"change"];
	changeRatio = [dict objectForKey:@"change%"];
	
	labelName.text = code;
	
	if ([_langCode isEqualToString:@"en"]) {
		close = [close formatToEnNumber];
	}
	labelClose.text = (close == nil) ? @"-" : close;
	labelCHG.text = (change == nil) ? @"-" : change;
	labelCHGPercent.text = [NSString stringWithFormat:@"%@%%",(changeRatio == nil) ? @"-" : changeRatio];
	

	

	
	UIColor *posColor = [langSetting getColor:@"GainersRate"];
	UIColor *negColor = [langSetting getColor:@"LosersRate"];	
	
	CGFloat fChange = 0.0;
	if (change) {
		fChange = [change floatValue];
	}
	if (fChange > 0) {
		labelClose.textColor = posColor;
		labelCHG.textColor = posColor;
		labelCHGPercent.textColor = posColor;
	} else if (fChange < 0) {
		labelClose.textColor = negColor;
		labelCHG.textColor = negColor;
		labelCHGPercent.textColor = negColor;
	} else {
		labelClose.textColor = [UIColor grayColor];
		labelCHG.textColor = [UIColor grayColor];
		labelCHGPercent.textColor = [UIColor grayColor];
	}
	
	[dict release];

    return cell;
}

#pragma mark set delegate
- (void)setDelegate:(id)delegate{
	navigatorDelegate = delegate;
}

#pragma mark -
#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger equityCount;
	equityCount = [_arrayEquity count];
	
	if (equityCount > indexPath.row) {
		NSDictionary *equtiyDict;
		
		equtiyDict = [_arrayEquity objectAtIndex:indexPath.row];
		[navigatorDelegate didSelectItemAtIndexPath:equtiyDict];
		[parent dismissPopoverAnimated:YES];
	}
	
	if (_lastSelect != -1 && equityCount > _lastSelect) {
		NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_lastSelect inSection:0];
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:lastIndexPath];
		
		UILabel *labelClose = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_CLOSELABEL_TAG];
		UILabel *labelCHG = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_CHGLABEL_TAG];
		UILabel *labelCHGPercent = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_CHGPERLABEL_TAG];
		
		NSDictionary *dict;
		
		NSString *close;
		NSString *change;
		NSString *changeRatio;
		NSNumber *numIsEquity;
		BOOL isEquity;
		
		CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
		NSString *_langCode = [langSetting localizedString:@"LangCode"];
		
		dict = [[_arrayEquity objectAtIndex:_lastSelect] copy];
		numIsEquity = [dict objectForKey:@"isEquity"];
		isEquity = [numIsEquity boolValue];
		close = [dict objectForKey:@"close"];
		change = [dict objectForKey:@"change"];
		changeRatio = [dict objectForKey:@"change%"];
		
		
		if ([_langCode isEqualToString:@"en"]) {
			close = [close formatToEnNumber];
		}
		labelClose.text = (close == nil) ? @"-" : close;
		labelCHG.text = (change == nil) ? @"-" : change;
		labelCHGPercent.text = [NSString stringWithFormat:@"%@%%",(changeRatio == nil) ? @"-" : changeRatio];
		
		
		UIColor *posColor = [langSetting getColor:@"GainersRate"];
		UIColor *negColor = [langSetting getColor:@"LosersRate"];	
		
		CGFloat fChange = 0.0;
		if (change) {
			fChange = [change floatValue];
		}
		if (fChange > 0) {
			labelClose.textColor = posColor;
			labelCHG.textColor = posColor;
			labelCHGPercent.textColor = posColor;
		} else if (fChange < 0) {
			labelClose.textColor = negColor;
			labelCHG.textColor = negColor;
			labelCHGPercent.textColor = negColor;
		} else {
			labelClose.textColor = [UIColor grayColor];
			labelCHG.textColor = [UIColor grayColor];
			labelCHGPercent.textColor = [UIColor grayColor];
		}
		
		[dict release];
	}
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	UILabel *labelClose = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_CLOSELABEL_TAG];
	UILabel *labelCHG = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_CHGLABEL_TAG];
	UILabel *labelCHGPercent = (UILabel *)[cell.contentView viewWithTag:CVMYSTOCK_CHGPERLABEL_TAG];

	
	labelClose.text = @"--";
	labelCHG.text = @"--";
	labelCHGPercent.text = @"--";
	
	_lastSelect = indexPath.row;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger equityCount;
	
	equityCount = [_arrayEquity count];
	if (equityCount > indexPath.row) {
		[_arrayEquity removeObjectAtIndex:indexPath.row];
		[self saveMyStock];
	}
	[_tableView reloadData];
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
	[_imageToolbarBackground release];
	[_imageBackground release];
	[_tableView release];
	[_arrayButton release];
	
	[_arrayEquity release];
	[_arrayFund release];
	[_arrayBond release];
	
	[_arrayDetail release];
	[_activityIndicator release];
	
	[_arrayIndexDetail release];
	[_stockListTimer release];
	[_dataMutex release];
		
    [super dealloc];
}


-(void)updateStock:(NSString *)code{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"Equity Count in Stock:%d",[_arrayEquity count]);
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	CVParamInfo *paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = 15;
	paramInfo.parameters = code;
	NSDictionary *dataDict = [dp GetMyStockDetail:CVDataProviderMyStockDetailTypeMinuteStock withParams:paramInfo];
	NSDictionary *equity = [[dataDict objectForKey:@"data"] objectAtIndex:0];
	if (!equity){
		[paramInfo release];
		[pool release];
		return;
	}
		
//	NSLog(@"Loaded Equity:%@",equity);
	NSString *strCode = [equity objectForKey:@"GPDM"];
	NSString *strName = [equity objectForKey:@"GPJC"];
	NSString *strClose = [equity objectForKey:@"SP"];
	NSString *strCHG = [equity objectForKey:@"ZF"];
	NSString *strCHG_PERCENT = [equity objectForKey:@"ZDF"];
	NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
	
	assert(strCode!=nil);//,@"strCode nil");
	assert(strName!=nil);//,@"strName nil");
	assert(strClose!=nil);//,@"strClose nil");
	assert(strCHG!=nil);//,@"strCHG nil");
	assert(strCHG_PERCENT!=nil);//,@"strCHG_PERCENT nil");
	
	[newDict setObject:[NSNumber numberWithBool:YES] forKey:@"isEquity"];
	[newDict setObject:strCode forKey:@"code"];
	[newDict setObject:strName forKey:@"name"];
	if ([strClose floatValue]) {
		[newDict setObject:[NSString stringWithFormat:@"%.2lf", [strClose floatValue]] forKey:@"close"];
	}
	if ([strCHG floatValue]) {
		[newDict setObject:[NSString stringWithFormat:@"%.2lf", [strCHG floatValue]] forKey:@"change"];
	}
	if ([strCHG_PERCENT floatValue]) {
		[newDict setObject:[NSString stringWithFormat:@"%.2lf", [strCHG_PERCENT floatValue]] forKey:@"change%"];
	}
	
	for(int i=0;i<[_arrayEquity count];i++){
		NSDictionary *dict = [_arrayEquity objectAtIndex:i];
		if ([[dict objectForKey:@"code"] isEqualToString:code] && [[dict objectForKey:@"isEquity"] boolValue] == YES){
			[_dataMutex lock];
			[_arrayEquity replaceObjectAtIndex:[_arrayEquity indexOfObject:dict] withObject:newDict];
			[_dataMutex unlock];
			break;
		}
		
	}
	[newDict release];
	[paramInfo release];
	[pool release];
	
	[_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void)updateIndex:(NSString *)code{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"Equity Count in Index:%d",[_arrayEquity count]);
	CVDataProvider *dp = [CVDataProvider sharedInstance];
	CVParamInfo *paramInfo = [[CVParamInfo alloc] init];
	paramInfo.minutes = 15;
	paramInfo.parameters = code;
	NSDictionary *dataDict = [dp GetMyStockDetail:CVDataProviderMyStockDetailTypeMinuteComposite withParams:paramInfo];
	NSDictionary *equity = [[dataDict objectForKey:@"data"] objectAtIndex:0];
	if (!equity){
		[paramInfo release];
		return;
	}
	for(int i=0;i<[_arrayEquity count];i++){
		NSDictionary *dict = [_arrayEquity objectAtIndex:i];
		if ([[dict objectForKey:@"code"] isEqualToString:code] && [[dict objectForKey:@"isEquity"] boolValue] == NO){
			NSString *value;
			NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
			[newDict setObject:[NSNumber numberWithBool:NO] forKey:@"isEquity"];
			value = [equity objectForKey:@"GPDM"];
			// the index code has the foramt, e.g. "000001.ZS"
			value = [value stringByReplacingOccurrencesOfString:@".ZS" withString:@""];
			if (value){
				[newDict setObject:value forKey:@"code"];
			}
			value = [equity objectForKey:@"GPJC"];
			if (value){
				[newDict setObject:value forKey:@"name"];
			}
			value = [equity valueForKey:@"SPJ"];
			if (value){
				float fValue = [value floatValue];
				value  = [NSString stringWithFormat:@"%.2f",fValue];
				[newDict setObject:value forKey:@"close"];
			}
			value = [equity valueForKey:@"CHANGE"];
			if (value){
				float fValue = [value floatValue];
				value  = [NSString stringWithFormat:@"%.2f",fValue];
				[newDict setObject:value forKey:@"change"];
			}
			value = [equity valueForKey:@"CHANGE_PERCENT"];
			if (value){
				float fValue = [value floatValue];
				value  = [NSString stringWithFormat:@"%.2f",fValue];
				[newDict setObject:value forKey:@"change%"];
			}
			
			[_arrayEquity replaceObjectAtIndex:[_arrayEquity indexOfObject:dict] withObject:newDict];
			[newDict release];
			break;
		}
		
	}
	[paramInfo release];
	
	[pool release];
	[_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark sync introday data
- (void)syncIndexIntroDay:(NSNotification *)notification{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dict = [notification object];
	for(int i=0;i<[_arrayEquity count];i++){
		NSDictionary *dictTemp = [_arrayEquity objectAtIndex:i];
		if (![[dictTemp objectForKey:@"isEquity"] boolValue] && [[dictTemp objectForKey:@"code"] isEqual:[dict objectForKey:@"code"]]) {
			NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithDictionary:dictTemp];
			[newDict setObject:[dict objectForKey:@"close"] forKey:@"close"];
			[newDict setObject:[dict objectForKey:@"change"] forKey:@"change"];
			[newDict setObject:[dict objectForKey:@"change%"] forKey:@"change%"];
			[_dataMutex lock];
			[_arrayEquity replaceObjectAtIndex:i withObject:newDict];
			[_dataMutex unlock];
			[newDict release];
			break;
		}
	}
	[_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
	[pool release];
}

- (void)syncStockIntroDay:(NSNotification *)notification{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dict = [notification object];
	for(int i=0;i<[_arrayEquity count];i++){
		NSDictionary *dictTemp = [_arrayEquity objectAtIndex:i];
		if ([[dictTemp objectForKey:@"isEquity"] boolValue] && [[dictTemp objectForKey:@"code"] isEqual:[dict objectForKey:@"code"]]) {
			NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithDictionary:dictTemp];
			[newDict setObject:[dict objectForKey:@"close"] forKey:@"close"];
			[newDict setObject:[dict objectForKey:@"change"] forKey:@"change"];
			[newDict setObject:[dict objectForKey:@"change%"] forKey:@"change%"];
			[_dataMutex lock];
			[_arrayEquity replaceObjectAtIndex:i withObject:newDict];
			[_dataMutex unlock];
			[newDict release];
			break;
		}
	}
	[_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
	[pool release];
}

@end
