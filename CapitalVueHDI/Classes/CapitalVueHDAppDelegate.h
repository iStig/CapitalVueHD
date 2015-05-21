//
//  CapitalVueHDAppDelegate.h
//  CapitalVueHD
//
//  Created by jishen on 8/12/10.
//  Copyright SmilingMobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVOutManager.h"



@class CVPortalViewController;
@class SplashViewController;

@interface CapitalVueHDAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CVPortalViewController *viewController;
	SplashViewController *splashController;
	UIImageView *splashView;
	UIView *modalView;
	NSString *strLanguage;
	NSTimer *check;
	
	//model defined
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CVPortalViewController *viewController;

@property (nonatomic,retain,readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,retain,readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(NSString *)applicationDocumentsDirectory;

- (void) loadMainView;

-(void)setDefaultTimeZone;
@end

