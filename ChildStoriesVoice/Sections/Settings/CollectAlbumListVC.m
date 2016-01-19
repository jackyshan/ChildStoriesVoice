//
//  CollectAlbumListVC.m
//  ChildStoriesVoice
//
//  Created by apple on 12/27/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "CollectAlbumListVC.h"
#import "HomeCollectionCell.h"
#import "NWHomeAlbums.h"
#import "AlbumVoiceModel.h"
#import "AlbumDetailListVC.h"
#import "SettingsViewController.h"
#import "DataBaseServer.h"

#define HOME_COLLECTION_CELL @"homeCollectionCell"

#define ITEM_WIDTH 127
#define ITEM_HEIGH 180
#define kHeaderHeight 20

@interface CollectAlbumListVC ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray *_mArr;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CollectAlbumListVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"专辑";
    
    [self loadingData];
}

- (void)addSubviews {
    [self.view addSubview:self.collectionView];
}

- (void)rightBarbuttonClick:(UIBarButtonItem *)item {
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = COLOR_WHITE;
        
        [_collectionView registerClass:[HomeCollectionCell class] forCellWithReuseIdentifier:HOME_COLLECTION_CELL];
    }
    
    return _collectionView;
}

- (void)defineLayout {
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.mas_equalTo(-kPlayBottomBarHeight);
    }];
}

- (void)loadingData {
    _mArr = [DataBaseServer selectCollectAlbumList];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HOME_COLLECTION_CELL forIndexPath:indexPath];
    
    AlbumVoiceModel *model = _mArr[indexPath.row];
    [cell updateWithModel:model];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    AlbumVoiceModel *model = _mArr[indexPath.row];
    AlbumDetailListVC *vc = [[AlbumDetailListVC alloc] initWithModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 25, 0, 25);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 20.f;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kHeaderHeight);
}

@end
