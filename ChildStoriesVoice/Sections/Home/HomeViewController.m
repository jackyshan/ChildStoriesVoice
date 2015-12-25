//
//  HomeViewController.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/17/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionCell.h"
#import "NWHomeAlbums.h"
#import "AlbumVoiceModel.h"
#import "AlbumDetailListVC.h"
#import "SettingsViewController.h"

#define HOME_COLLECTION_CELL @"homeCollectionCell"

#define ITEM_WIDTH 127
#define ITEM_HEIGH 180
#define kHeaderHeight 20

@interface HomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *mArr;

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"儿童故事音汇";
    
    self.mArr = [NSMutableArray array];
    [self loadingData];
}

- (void)addSubviews {
    [self.view addSubview:self.collectionView];
    
    [self createLeftButtonWithTitle:nil withLeftImage:[UIImage imageNamed:@"search"]];
    [self createRightButtonWithTitle:nil withRightImage:[UIImage imageNamed:@"settings"]];
}


- (void)leftBarbuttonClick:(UIBarButtonItem *)item {}

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
        _collectionView.backgroundColor = COLOR_FFFFFF;
        
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
    [super loadingData];
    
    NWHomeAlbums *homeAlbums = [[NWHomeAlbums alloc] init];
    [homeAlbums setCompletion:^(NSArray *arr, BOOL succ) {
        if (succ) {
            if (arr.count == 0) {
                [CommonHelper showMessage:@"没有更多了"];return;
            }
            
            [self.mArr addObjectsFromArray:arr];
            [_collectionView reloadData];
        }
        else {
            [self loadingFial];
        }
    }];
    
    homeAlbums.path = @"948/common_tag/6/童话故事";
    [homeAlbums startRequestWithParams:@{@"page_id":@(1)}];
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
