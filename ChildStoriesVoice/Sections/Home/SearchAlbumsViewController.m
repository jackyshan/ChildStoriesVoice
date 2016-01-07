//
//  SearchAlbumsViewController.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/7/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "SearchAlbumsViewController.h"
#import "SearchModel.h"
#import "NWHomeAlbums.h"

@interface SearchAlbumsViewController () {
    SearchModel *_model;
}

@end

@implementation SearchAlbumsViewController

- (instancetype)initWithModel:(SearchModel *)model {
    if (self = [super init]) {
        _model = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"搜索%@", _model.title];
}

- (void)addSubviews {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.hub];
}

- (void)leftBarbuttonClick:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadingData {
    
    [self.hub show:YES];
    NWHomeAlbums *homeAlbums = [[NWHomeAlbums alloc] init];
    [homeAlbums setCompletion:^(NSArray *arr, BOOL succ) {
        
        [self.hub hide:YES];
        
        if (succ) {
            if (arr.count == 0) {
                [CommonHelper showMessage:@"没有更多了"];return;
            }
            
            [self.mArr addObjectsFromArray:arr];
            [self.collectionView reloadData];
            [self.collectionView endFooterNoMore:20 arr:arr];
        }
    }];
    
    homeAlbums.path = [NSString stringWithFormat:@"948/common_tag/6/%@", _model.title];
    [homeAlbums startRequestWithParams:@{@"page_id":@(_pageId)}];
}


@end
