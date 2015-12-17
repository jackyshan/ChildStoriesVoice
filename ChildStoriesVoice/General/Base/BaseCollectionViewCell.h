//
//  BaseCollectionViewCell.h
//  DBMeiziFuli
//
//  Created by jackyshan on 9/14/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JackyBusiness.pch"
#import "ProjectMacro.h"

@interface BaseCollectionViewCell : UICollectionViewCell

- (void)addSubviews;
- (void)defineLayout;

- (void)updateWithModel:(id)model;

@end
