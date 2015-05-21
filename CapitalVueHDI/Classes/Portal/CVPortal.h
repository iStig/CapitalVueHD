/*
 *  CVPortal.h
 *  CapitalVueHD
 *
 *  Created by jishen on 8/29/10.
 *  Copyright 2010 SmilingMobile. All rights reserved.
 *
 */

typedef enum {
	CVPortalSetTypeHome,
	CVPortalSetTypeMarket,
	CVPortalSetTypeIndustrial,
	CVPortalSetTypeMacro,
	CVPortalSetTypeNews,
	CVPortalSetTypeMyStock,
	CVPortalSetTypeMax
} CVPortalSetType;

#define CVPORTAL_PANEL_BAR 43

#define CVPortalSwitchPortalSetNotification @"CVPortalSwitchPortalSetNotification"
#define CVPortalDismissRotationViewNotification @"CVPortalDismissRotationViewNotification"
