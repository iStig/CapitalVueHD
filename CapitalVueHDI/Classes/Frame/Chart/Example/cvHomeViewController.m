    //
//  cvHomeViewController.m
//  cvChart
//
//  Created by He Jun on 10-8-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cvHomeViewController.h"


@implementation cvHomeViewController

@synthesize simpleChart1, simpleChart2, simpleChart3, indexChart;
@synthesize stockDetailChart, macroDetailChart;
@synthesize finianceData;

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
    // create symbol selector
    NSArray *segmentTextContent = [NSArray arrayWithObjects: @"YHOO", @"AAPL", @"MSFT", @"ERRO", nil];    
    CGRect frame = CGRectMake(21, 0, 320, 28);
    UISegmentedControl *stockControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    stockControl.frame = frame;
    [stockControl addTarget:self action:@selector(stockControlAction:) forControlEvents:UIControlEventValueChanged];
    stockControl.segmentedControlStyle = UISegmentedControlStyleBordered;
    stockControl.selectedSegmentIndex = -1;
    
    [self.view addSubview:stockControl];
    [stockControl release];
    
    // create chart views
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *cfgFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"homeStockChartConfig.plist"]];
    NSString *cfgFilePath = [[NSBundle mainBundle] pathForResource:@"homeStockChartConfig" ofType:@"plist"];
    
    simpleChart1 = [[cvChartView alloc] initWithFrame:CGRectMake(21, 645, 0, 0) FormatFile:cfgFilePath];
    simpleChart1.dataProvider = self;

    simpleChart2 = [[cvChartView alloc] initWithFrame:CGRectMake(270, 645, 0, 0) FormatFile:cfgFilePath];
    simpleChart2.dataProvider = self;    
    
    cfgFilePath = [[NSBundle mainBundle] pathForResource:@"homeIndexChartConfig" ofType:@"plist"];
    indexChart = [[cvChartView alloc] initWithFrame:CGRectMake(21, 770, 0, 0) FormatFile:cfgFilePath];
    indexChart.dataProvider = self;

    // create detail stock chart
    cfgFilePath = [[NSBundle mainBundle] pathForResource:@"stockChartConfig" ofType:@"plist"];
    stockDetailChart = [[cvChartView alloc] initWithFrame:CGRectMake(21,30, 0, 0) FormatFile:cfgFilePath];
    stockDetailChart.dataProvider = self;
     
    // create macro stock chart
    //cfgFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"macroChartConfig.plist"]];
    cfgFilePath = [[NSBundle mainBundle] pathForResource:@"macroChartConfig" ofType:@"plist"];
    macroDetailChart = [[cvChartView alloc] initWithFrame:CGRectMake(21, 365, 0, 0) FormatFile:cfgFilePath];
    macroDetailChart.dataProvider = self;
    
    [self.view addSubview:simpleChart1];
    [self.view addSubview:simpleChart2];
    [self.view addSubview:indexChart];
    [self.view addSubview:stockDetailChart];
    [self.view addSubview:macroDetailChart];
    
    //[simpleChart1 loadWithSymbol:@"AAPL"];
    simpleChart1.symbolName = @"AAPL";
    simpleChart2.symbolName = @"PXLW";
    indexChart.symbolName = @"^DJI";
    stockDetailChart.symbolName = @"GOOG";
    macroDetailChart.symbolName = @"YHOO";
    
    /*
    [simpleChart1 setNeedsDisplay];
    [simpleChart2 setNeedsDisplay];
    [indexChart setNeedsDisplay];
    [stockDetailChart setNeedsDisplay];
    [macroDetailChart setNeedsDisplay];
     */

    [super viewDidLoad];
}


/*
-(void)viewWillAppear:(BOOL)animated{
    
}
 */


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
    self.simpleChart1 = nil;
    self.simpleChart2 = nil;
    self.simpleChart3 = nil;
    self.indexChart = nil;
    self.stockDetailChart = nil;
    self.macroDetailChart = nil;
}


- (void)dealloc {
    [simpleChart1 release];
    [simpleChart2 release];
    [simpleChart3 release];
    [indexChart release];
    
    [stockDetailChart release];
    [macroDetailChart release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark stock Selector event
- (void)stockControlAction:(id)sender
{
//	NSLog(@"stockControlAction: selected segment = %d", [sender selectedSegmentIndex]);
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            stockDetailChart.symbolName = @"YHOO";
            break;
        case 1:
            stockDetailChart.symbolName = @"AAPL";
            break;
        case 2:
            stockDetailChart.symbolName = @"MSFT";
            break;
            
        case 3:
            stockDetailChart.symbolName = @"ERRO";
        default:
            break;
    }
    [stockDetailChart setNeedsDisplay];
}

#pragma mark -
#pragma mark Chart Data provider

- (void) resetData
{
    //[finianceData release];
}
- (NSArray *)ChartGetRecordsByName:(NSString *)name Period:(StockDataTimeFrame_e)timeFrame
{
	NSString *cfgFilePath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];

//    NSLog(@"data file: %@", cfgFilePath);
    
    [self resetData];
    finianceData = [NSDictionary dictionaryWithContentsOfFile:cfgFilePath];
    if (YES == [name isEqualToString:@"MSFT"]) sleep(3);
    if (YES == [name isEqualToString:@"ERRO"]) sleep(2);
    
    return [finianceData objectForKey:@"financalData"];
}


@end
