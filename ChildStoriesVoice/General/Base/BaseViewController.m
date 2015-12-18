//
//  BaseViewController.m
//  DBMeiziFuli
//
//  Created by jackyshan on 9/14/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController() {
    UIView *_failView;
    UIView *_emptyView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    failLabel.font = [UIFont systemFontOfSize:16.f];
    failLabel.textColor = COLOR_FFFFFF;
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
    emptyLabel.font = [UIFont systemFontOfSize:16.f];
    emptyLabel.textColor = COLOR_FFFFFF;
    emptyLabel.text = @"没有数据，点击重试";
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

@end
