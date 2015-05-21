    //
//  CVScrollPageViewController.m
//  CapitalVueHD
//
//  Created by jishen on 9/4/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVScrollPageViewController.h"

@interface CVScrollPageViewController()

//@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSMutableArray *arrayViewCache;
@property (nonatomic) NSUInteger cacheIndex;
@property (nonatomic) NSUInteger cacheSize;


- (void)loadScrollViewWithPage:(NSUInteger)index;
- (IBAction)changePage:(id)sender;

@end

@implementation CVScrollPageViewController

@synthesize frame = _frame;
@synthesize pageControlFrame = _pageControlFrame;
@synthesize pageCount;
@synthesize indicatorStyle;

@synthesize scrollView;
@synthesize pageControl;
@synthesize viewControllers;
@synthesize arrayViewCache;

@synthesize cacheIndex;
@synthesize cacheSize;

- (id)init {
	if ((self = [super init])) {
		UIScrollView *sv = [[UIScrollView alloc] init];
		
		sv.autoresizingMask = UIViewAutoresizingNone;
		sv.autoresizesSubviews = NO;
		self.scrollView = sv;
		[sv release];
		
		NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:1];
		self.arrayViewCache = views;
		[views release];
	}
	
	return self;
}

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
	self.view.autoresizesSubviews = NO;
	self.view.autoresizingMask = UIViewAutoresizingNone;
	self.view.frame = _frame;
	[super viewDidLoad];

	[self.view addSubview:scrollView];
	
	self.cacheIndex = 0;
	self.cacheSize = 0;
	
	// added page controll
	CVPageControlView *pgcv = [[CVPageControlView alloc] init];
	self.pageControl = pgcv;
	[pgcv release];
	pageControl.pageControlStyle = indicatorStyle;
	[pageControl setFrame:_pageControlFrame];
	pageControl.backgroundColor = [UIColor clearColor];
	[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:pageControl];
	
	[self reloadData];
}

- (void)setFrame:(CGRect)frame {
	_frame = frame;
	self.view.frame = frame;
	scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
	_pageControlFrame = pageControlFrame;
	[pageControl setFrame:_pageControlFrame];
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
	[scrollView release];
	[pageControl release];
	[viewControllers release];
	[arrayViewCache release];
    [super dealloc];
}

#pragma mark private method
- (void)loadScrollViewWithPage:(NSUInteger)index {
    if (index < 0) return;
    if (index >= pageCount) return;
	
	UIView *pageView;
	CGRect pageFrame = self.view.frame;
	pageFrame.origin.x = pageFrame.size.width * index;
	pageFrame.origin.y = 0;
	
	pageView = [self dequeueReusablePage:index];
	if (nil == pageView) {
		pageView = [pageViewDelegate scrollPageView:self viewForPageAtIndex:index];
		[self enqueueReusablePage:pageView atIndex:index];
	}
	
	if (nil == pageView.superview) {
		pageView.frame = pageFrame;
		[self.scrollView addSubview:pageView];
	}
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	// customized behavior by caller
	[pageViewDelegate didScrollToPageAtIndex:page];
    self.pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

#pragma mark public method
- (void)enqueueReusablePage:(UIView *)pageView atIndex:(NSUInteger)index {
	NSUInteger cacheCount;
	
	cacheCount = [arrayViewCache count];
	if (index < cacheCount) {
		[arrayViewCache replaceObjectAtIndex:index withObject:pageView];
	} else {
		for (unsigned i = cacheCount; i < index; i++) {
			[arrayViewCache addObject:[NSNull null]];
		}
		[arrayViewCache addObject:pageView];
	}

}

/*
 * For performance reasons, a scrollPageView should generally reuse page objects.
 * It returns a reusable page object.
 *
 * @return: A page object or nil if no such object exists in the reusable-cell queue.
 */
- (UIView *)dequeueReusablePage:(NSUInteger)index {
    UIView *pageView;
	
	pageView = nil;
	
	if (index < [arrayViewCache count]) {
		pageView = [arrayViewCache objectAtIndex:index];
		if ([NSNull null] == (NSNull *)pageView) {
			pageView = nil;
		}
	}
	
	return pageView;
}

- (void)clearReusablePage {
	NSUInteger i, arrayCount;
	UIView *v;
	
	arrayCount = [arrayViewCache count];
	for (i = 0; i < arrayCount; i++) {
		v = [arrayViewCache objectAtIndex:i];
		// clear subviews form the view
		if ([NSNull null] != (NSNull *)v) {
			[v removeFromSuperview];
		}
		[arrayViewCache replaceObjectAtIndex:i withObject:[NSNull null]];
	}
}

- (void)reloadData {
	//pageCount = [pageViewDelegate numberOfPagesInScrollPageView];
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * pageCount, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
	if (pageCount > 0) {
		[self clearReusablePage];
		/*
		arrayViewCache = nil;
		NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:1];
		self.arrayViewCache = views;
		[views release];
		 */
	}
	
	pageControl.numberOfPages = pageCount;
    pageControl.currentPage = 0;
	
	// Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	/*
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
	 */
	[pageControl updateCurrentPageDisplay];
}

- (void)setDelegate:(id)delegate {
	pageViewDelegate = delegate;
}

@end
