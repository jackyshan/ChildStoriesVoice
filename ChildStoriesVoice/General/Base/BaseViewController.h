//
//  BaseViewController.h
//  DBMeiziFuli
//
//  Created by jackyshan on 9/14/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JackyBusiness.pch"
#import "Project.pch"

@interface BaseViewController : UIViewController

- (void)addSubviews;
- (void)defineLayout;
- (void)loadingData;
- (void)loadingFial;
- (void)loadingDataEmpty;

@end
