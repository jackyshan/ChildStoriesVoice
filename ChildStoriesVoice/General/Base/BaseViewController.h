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
#import "AppDelegate.h"

@interface BaseViewController : UIViewController

@property (nonatomic, weak) AppDelegate *delegate;

- (void)addSubviews;
- (void)defineLayout;
- (void)loadingData;
- (void)loadingFial;
- (void)loadingDataEmpty;

/**
 *  创建导航栏的左按钮
 *
 *  @param title         标题
 *  @param leftImageName 图片
 */
- (void)createLeftButtonWithTitle:(NSString *)title withLeftImage:(UIImage *)leftImage;
/**
 *  点击导航栏左按钮响应该方法
 *
 *  @param item 按钮
 */
- (void)leftBarbuttonClick:(UIBarButtonItem *)item;
/**
 *  创建导航栏的右按钮
 *
 *  @param title         标题
 *  @param leftImageName 图片
 */
- (void)createRightButtonWithTitle:(NSString *)title withRightImage:(UIImage *)rightImage;
/**
 *  点击导航栏右按钮响应该方法
 *
 *  @param item 按钮
 */
- (void)rightBarbuttonClick:(UIBarButtonItem *)item;

@end
