//
//  CVSnapshotView.h
//  CapitalVueHD
//
//  Created by leon on 10-10-19.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVRotationView.h"
#import "CVSnapshotContentView.h"

@interface CVSnapshotView : CVRotationView {
	CVSnapshotContentView *_snapshotContentView;
}
@property (nonatomic, retain)CVSnapshotContentView *snapshotContentView;
@end
