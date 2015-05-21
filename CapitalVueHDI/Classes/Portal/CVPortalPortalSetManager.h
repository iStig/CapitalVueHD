//
//  CVPortalPortalSetManager.h
//  CapitalVueHD
//
//  Created by jishen on 8/30/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CVPortal.h"


@interface CVPortalPortalSetManager : NSObject {
@private
	NSMutableArray *arrayPortalSet;
}

/*
 * It stores the PortalSet.
 *
 * @param: controller - a controller of PortalSet
 *         type - the PortalSet type
 * @return: YES if it is stored, else NO
 */
- (BOOL)setPortalSet:(id)controller type:(CVPortalSetType)type;

/*
 * It returns the specified controller of PortalSet
 *
 * @param: type - the specified PortalSet
 * @return: controller of PortalSet
 */
- (id)getPortalSet:(CVPortalSetType)type;

/*
 * It checks whether the specified PortalSet has already
 * created and cached.
 *
 * @param: type - the specified PortalSet
 * @return: YES if existed, else NO.
 */
- (BOOL)isPortalSetExisted:(CVPortalSetType)type;

@end
