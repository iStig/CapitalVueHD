//
//  CapitalVueHDAppDelegate.m
//  CapitalVueHD
//
//  Created by jishen on 8/12/10.
//  Copyright SmilingMobile 2010. All rights reserved.
//

#import "CapitalVueHDAppDelegate.h"
#import "CVPortalViewController.h"
#import "SplashViewController.h"
#import "CVSetting.h"
#import "CVDataProvider.h"

@implementation CapitalVueHDAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    NSString *language = [[NSUserDefaults standardUserDefaults] 
					  stringForKey:@"language"];
    if(!language || [[[NSUserDefaults standardUserDefaults] objectForKey:@"cache"] intValue]==0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"refresh"] intValue]==0) {
        [self performSelector:@selector(registerDefaultsFromSettingsBundle)];        
    }
	strLanguage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"language"] copy];

	[self setDefaultTimeZone];
	
    // Override point for customization after app launch.
	window.backgroundColor = [UIColor blackColor];
//	[window addSubview:viewController.view];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(loadMainView)
												 name:@"LoadMainView"
											   object:nil];
	splashController = [[SplashViewController alloc] init];
	[window addSubview:splashController.view];
	[window makeKeyAndVisible];
	
	//[[TVOutManager sharedInstance] startTVOut];
	
	return YES;
}

-(void)setDefaultTimeZone{
	NSTimeZone *zone;
	zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
	[NSTimeZone setDefaultTimeZone:zone];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
//	check = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkLanguage) userInfo:nil repeats:YES];
	
	[self performSelector:@selector(checkLanguage) withObject:nil afterDelay:1.0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
	[strLanguage release];
	
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Splash Screen
- (void) loadMainViewThread
{
	[window insertSubview:viewController.view belowSubview:splashController.view];
	[splashController.view removeFromSuperview];
}

- (void) loadMainView
{
	[splashController presentModalViewController:viewController animated:NO];
//	[window insertSubview:viewController.view belowSubview:splashController.view];
//	[splashController.view removeFromSuperview];
//	[splashController.view removeFromSuperview];
//	[splashController release];
}


- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
			NSLog(@"Default %@ value:%@",key,[prefSpecification objectForKey:@"DefaultValue"]);
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [defaultsToRegister release];
}

-(void)checkLanguage{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
	if (![strLanguage isEqualToString:currentLanguage])
	{
	//	[check invalidate];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"LanguageChangedTitle"] 
														message:[langSetting localizedString:@"LanguageChangedMessage"]
													   delegate:nil
											  cancelButtonTitle:[langSetting localizedString:@"OK"] 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[alert release];
	}
//	else
//		[check invalidate];
}


#pragma mark -
#pragma mark Core Data Model Implementation
-(NSManagedObjectContext *)managedObjectContext{
	if (managedObjectContext!=nil){
		return managedObjectContext;
	}
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator!=nil){
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator:coordinator];
	}
	
	return managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel{
	if (managedObjectModel!=nil){
		return managedObjectModel;
	}
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	
	return managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator{
	if (persistentStoreCoordinator!=nil){
		return persistentStoreCoordinator;
	}
	NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"CapitalVueHD.sqlite"]];
	NSError *error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]){
		/*Error for store creation should be handled in here*/
	}
	
	return persistentStoreCoordinator;
}

-(NSString *)applicationDocumentsDirectory{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
@end
