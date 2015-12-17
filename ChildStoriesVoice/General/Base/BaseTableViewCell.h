//
//  BaseTableViewCell.h
//  PregnantMotherAte
//
//  Created by apple on 9/13/15.
//  Copyright (c) 2015 jackyshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JackyBusiness.pch"
#import "ProjectMacro.h"

@interface BaseTableViewCell : UITableViewCell

// You must override these methods in subclasses

// Override this method and add all subviews to the contentView in it
- (void)addSubviews;

// Override this method and use the mas_updateConstraints... methods to add constraints
// It's important to use the 'update' methods as this may be called multiple times.
- (void)defineLayout;

- (void)updateWithModel:(id)model;

@end
