//
//  cvChartFormatter.m
//  cvChart
//
//  Created by He Jun on 10-8-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cvChartFormatter.h"


#pragma mark -
#pragma mark Chart Formatter
@interface cvChartFormatter ()


@property (nonatomic, retain) NSMutableDictionary *localPlistDict;
@end

@implementation cvChartFormatter

@synthesize General, Header, Legend, PeriodSelector, Charts, localPlistDict;

- (void)initializeCharts:(NSDictionary *)dict Defaults:(cvChartFormatterGeneral *)general
{
    NSMutableArray *rwArray = [[NSMutableArray alloc] init];
    int i = 0;
    cvChartFormatterChart *chart = nil;
    for(i=1; i<=[dict count]; i++){
        NSString *keyName = [NSString stringWithFormat:@"Chart%d",i];
        chart = [[cvChartFormatterChart alloc] initWithDictionary:[dict objectForKey:keyName] Defaults:general];
        if (nil != chart){
            [rwArray addObject:chart];
            [chart release];
        }
    }
    NSArray *tempArray = [[NSArray alloc] initWithArray:rwArray];
	self.Charts = tempArray;
	[tempArray release];
    [rwArray release];
//    NSLog(@"Finished parsing CHarts");
}

- (id)initWithConfigFile:(NSString *)FileName
{
    
    if ((self = [super init])){
 //       NSLog(@"chartConfig File: %@", FileName);
		mutDict = [[NSMutableDictionary alloc] initWithContentsOfFile:FileName];
		
        self.localPlistDict = mutDict;
		[mutDict release];
        if (nil == localPlistDict) 
			NSLog(@"Failed to load cfgs");
        else {
            General = [[cvChartFormatterGeneral alloc] initWithDictionary:[localPlistDict objectForKey:@"General"]];
            
            if (YES == General.HeaderEnable){
                Header = [[cvChartFormatterHeader alloc] initWithDictionary:[localPlistDict objectForKey:@"Header"] Defaults:General];
            }
            if (YES == General.LegendEnable){
                Legend = [[cvChartFormatterLegend alloc] initWithDictionary:[localPlistDict objectForKey:@"Legend"] Defaults:General];
            }
            if (YES == General.PeriodSelectorEnable){
                PeriodSelector = [[cvChartFormatterPeriodSelector alloc] initWithDictionary:[localPlistDict objectForKey:@"PeriodSelector"] Defaults:General];
            }
            //Charts = [[cvChartFormatterChart alloc] initWithDictionary:[localPlistDict objectForKey:@"Chart"] Defaults:General];
            [self initializeCharts:[localPlistDict objectForKey:@"Charts"] Defaults:General];
            
        }
        
    }
    
    return self;
}

-(void)setTitles:(NSArray *)titleArray{
	[Legend setTitles:titleArray];
}

- (void)dealloc
{
    [General release];
    [Header release];
    [Legend release];
    [PeriodSelector release];
    [Charts release];
    [localPlistDict release];
    
    [super dealloc];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//	if ([keyPath isEqualToString:@"localPlistDict"]){
//		NSLog(@"Older:%@",mutDict);
//		NSLog(@"Newer:%@",self.localPlistDict);
//		[self removeObserver:self forKeyPath:keyPath];
//	}
//}

@end