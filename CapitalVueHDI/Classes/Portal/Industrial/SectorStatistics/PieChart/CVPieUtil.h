//
//  CVPieUtil.h
//  PieChart
//
//  Created by ANNA on 10-8-13.
//  Copyright 2010 Smiling Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef _CVPIEUTIL
#define _CVPIEUTIL
#define kMinDis		0.001

static CGPoint getPos(float radius, float angle)
{
	float posx = radius + radius * cos(angle);
	float posy = radius + radius * sin(angle);
	return CGPointMake(posx, posy);
}

static CGPoint getInnerPos(float outerRadius, float innerRadius, float angle)
{
	float posx = outerRadius + innerRadius * cos(angle);
	float posy = outerRadius + innerRadius * sin(angle);
	return CGPointMake(posx, posy);
}

static CGFloat getAngle( CGPoint target, CGPoint origin)
{
	float delta_x = target.x - origin.x;
	float delta_y = target.y - origin.y;
	double cosValue;
	if ( ABS(delta_x) < kMinDis && ABS(delta_y) < kMinDis)
	{
		cosValue = 0.0;
	}
	else 
	{
		cosValue= delta_x/sqrt(delta_x*delta_x + delta_y*delta_y);
	}
	
	if (delta_y < 0 )
	{
		cosValue = -cosValue;
	}
	
	if ( delta_y >= 0 )
	{
		return acos(cosValue);
	}
	else 
	{
		return M_PI + acos(cosValue);
	}

}

#endif
