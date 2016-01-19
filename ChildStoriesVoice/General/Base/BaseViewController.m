//
//  BaseViewController.m
//  DBMeiziFuli
//
//  Created by jackyshan on 9/14/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController()<UIGestureRecognizerDelegate> {
    UIView *_failView;
    UIView *_emptyView;
}

@end

@implementation BaseViewController

- (AppDelegate *)delegate {
    if (!_delegate) {
        _delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return _delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_WHITE;
    
    [self createLeftButtonWithTitle:nil withLeftImage:[UIImage imageNamed:@"ArrowLeft"]];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self addSubviews];
    [self defineLayout];
}

- (void)addSubviews {
	NSAssert(NO, @"Must override");
}

- (void)updateViewConstraints {
    [self defineLayout];
    [super updateViewConstraints];
}

- (void)defineLayout {
	NSAssert(NO, @"Must override");
}

- (void)loadingData {
    [_failView removeFromSuperview];
    [_emptyView removeFromSuperview];
    _failView = nil;
    _emptyView = nil;
}

- (void)loadingFial {
    _failView = nil;
    
    //init
    _failView = [[UIView alloc] init];
    _failView.backgroundColor =  COLOR_FAIL;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadingData)];
    [_failView addGestureRecognizer:tap];
    [self.view addSubview:_failView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_fail"]];
    [_failView addSubview:imageView];
    
    UILabel *failLabel = [[UILabel alloc] init];
    failLabel.font = [UIFont boldSystemFontOfSize:16.f];
    failLabel.textColor = COLOR_WHITE;
    failLabel.text = @"网络加载失败，点击重试";
    failLabel.textAlignment = NSTextAlignmentCenter;
    [_failView addSubview:failLabel];
    
    //frame
    [_failView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-60);
    }];
    
    [failLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 60));
        make.top.mas_equalTo(imageView.mas_bottom).offset(20);
        make.left.equalTo(self.view);
    }];
}

- (void)loadingDataEmpty {
    _emptyView = nil;
    
    //init
    UIView *emptyView = [[UIView alloc] init];
    _emptyView = emptyView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadingData)];
    [emptyView addGestureRecognizer:tap];
    emptyView.backgroundColor =  COLOR_FAIL;
    [self.view addSubview:emptyView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_empty"]];
    [emptyView addSubview:imageView];
    
    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.font = [UIFont boldSystemFontOfSize:16.f];
    emptyLabel.textColor = COLOR_WHITE;
    emptyLabel.text = @"没有数据";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    [emptyView addSubview:emptyLabel];
    
    //frame
    [emptyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-60);
    }];
    
    [emptyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 60));
        make.top.mas_equalTo(imageView.mas_bottom).offset(20);
        make.left.equalTo(self.view);
    }];
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"进入页面%@", [self class]);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"离开页面%@", [self class]);
}

- (void)dealloc {
    NSLog(@"页面销毁%@", [self class]);
}

#pragma mark - navigationBar
- (void)createLeftButtonWithTitle:(NSString *)title withLeftImage:(UIImage *)leftImage
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0f, 40.0f, 44.0)];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    
    if (title && [title length] > 0) {
        leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton setTitle:title forState:UIControlStateNormal];
    }
    
    if (leftImage) {
        [leftButton setImage:leftImage forState:UIControlStateNormal];
    }
    
    [leftButton addTarget:self action:@selector(leftBarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)createRightButtonWithTitle:(NSString *)title withRightImage:(UIImage *)rightImage
{
    UIButton *rightButton =[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0f, 60.0f, 44.0)];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    if (title && [title length] > 0) {
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [rightButton setTitle:title forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (rightImage) {
        [rightButton setImage:rightImage forState:UIControlStateNormal];
    }
    
    [rightButton addTarget:self action:@selector(rightBarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spacer.width = -6.0f; // for example shift right bar button to the right
    
//    self.navigationItem.rightBarButtonItems = @[spacer, barItem];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)leftBarbuttonClick:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarbuttonClick:(UIBarButtonItem *)item
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
