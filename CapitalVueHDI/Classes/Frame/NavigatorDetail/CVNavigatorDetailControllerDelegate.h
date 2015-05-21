//
//  CVNavigatorDetailControllerDelegate.h
//  CapitalVueHD
//
//  Created by jishen on 9/24/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CVNavigatorDetailControllerDelegate

/*
 * Tells the delegate the button / the item whoes event is received. When the user taps the button 
 * which don't need to show the pop over, you can use this method to return NO to avoid pop over.
 *
 * @param	button - UIButton or UIBarButtonItem recieves the touch-up-inside event
 * @return	NO if pop-over is not allowed.
 */
- (BOOL)navigatorDetailController:(CVNavigatorDetailController*)ndc allowPopOverByButton:(id)button;

/*
 * Tells the delegate that the hidden view controller is about to be displayed in a popover.
 * The toolbar button you add to your user interface facilitates the display of the hidden view controller 
 * in response to user taps. When the user taps that button, the split view controller calls this method. 
 * You can use this method to perform any additional steps prior to displaying the currently hidden view 
 * controller.
 *
 * @param:	ndc - The split view controller that owns the hidden view controller.
 *			pc - The popover controller that is about to display the view controller.
 *			aViewController - The view controller to be displayed in the popover.
 * @return	none
 */
- (void)navigatorDetailController:(CVNavigatorDetailController*)ndc 
				popoverController:(UIPopoverController*)pc 
		willPresentViewController:(UIViewController *)aViewController;

/*
 * Tells the delegate that the specified view controller is about to be hidden.
 * When the split view controller rotates from a landscape to portrait orientation, it normally hides 
 * one of its view controllers. When that happens, it calls this method to coordinate the addition of 
 * a button to the toolbar (or navigation bar) of the remaining custom view controller. If you want 
 * the soon-to-be hidden view controller to be displayed in a popover, you must implement this method
 * and use it to add the specified button to your interface.
 *
 * @param:	ndc - The split view controller that owns the specified view controller.
 *			aViewController - The view controller being hidden.
 *			pc - The popover controller that uses taps in barButtonItem to display the specified view controller.
 * @return:	none
 */
- (void)navigatorDetailController:(CVNavigatorDetailController*)ndc 
		   willHideViewController:(UIViewController *)aViewController
			 forPopoverController:(UIPopoverController*)pc;

/*
 * Tells the delegate that the specified view controller is about to be shown again. When the view controller
 * rotates from a portrait to landscape orientation, it shows its hidden view controller once more. If you 
 * added the specified button to your toolbar to facilitate the display of the hidden view controller in 
 * a popover, you must implement this method and use it to remove that button.
 *
 * @param:	ndc - The split view controller that owns the specified view controller.
 *			aViewController - The view controller being hidden.
 *			pc - The popover controller that uses taps in barButtonItem to display the specified view controller.
 * @return:	none
 */
- (void)navigatorDetailController:(CVNavigatorDetailController*)ndc 
		   willShowViewController:(UIViewController *)aViewController 
			 forPopoverController:(UIPopoverController*)pc;

@end
