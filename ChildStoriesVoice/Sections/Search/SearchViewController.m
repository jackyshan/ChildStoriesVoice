//
//  SearchViewController.m
//  ChildStoriesVoice
//
//  Created by jackyshan on 1/4/16.
//  Copyright © 2016 jackyshan. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultCell.h"
#import "SearchHeaderView.h"
#import "SearchHistoryCell.h"
#import "SearchTextField.h"
#import "NWSuggestSearch.h"
#import "SearchModel.h"
#import "AlbumDetailListVC.h"
#import "DataBaseServer.h"
#import "ClearHistoryCell.h"
#import "SearchAlbumsViewController.h"

NSString * const kSearchHistoryCell = @"searchHistoryCell";
NSString * const kSearchResultCell = @"searchResultCell";
NSString * const kClearHistoryCell = @"clearHistoryCell";

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SearchHeaderViewDelegate> {
    UITextField *_searchField;
    NSString *_searchStr;
    NSMutableArray *_dataSearchArr;
    NSMutableArray *_dataHistoryArr;
    SearchHeaderView *_headView;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataHistoryArr = [NSMutableArray array];
    _dataSearchArr = [NSMutableArray array];
    [self loadingData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

- (void)addSubviews {
    UITextField *searchField = [[SearchTextField alloc] initWithFrame:CGRectMake(0, 0, 260, 34)];
    searchField.clipsToBounds = YES;
    searchField.layer.cornerRadius = 3.f;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.layer.borderWidth = 1.f;
    searchField.layer.borderColor = [ColorHelper colorWithHexString:@"#e0e0e0"].CGColor;
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 34)];
    [searchBtn setImage:[UIImage imageNamed:@"icon_search_glass"]];
    searchField.leftView = searchBtn;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.placeholder = @"请输入搜索内容...";
    searchField.textAlignment = NSTextAlignmentLeft;
    searchField.font = [UIFont systemFontOfSize:12.f];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.tintColor = [ColorHelper colorWithHexString:@"#e0e0e0"];
    searchField.delegate = self;
    self.navigationItem.titleView = searchField;
    [searchField becomeFirstResponder];
    _searchField = searchField;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingData) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [ColorHelper colorWithHexString:@"#ecebe8"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        SearchHeaderView *headView = [[SearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
        headView.delegate = self;
        _headView = headView;
        
        [_tableView registerClass:[SearchHistoryCell class] forCellReuseIdentifier:kSearchHistoryCell];
        [_tableView registerClass:[SearchResultCell class] forCellReuseIdentifier:kSearchResultCell];
        [_tableView registerClass:[ClearHistoryCell class] forCellReuseIdentifier:kClearHistoryCell];
    }
    
    return _tableView;
}

- (void)defineLayout {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.mas_equalTo(-kPlayBottomBarHeight);
    }];
}

- (void)loadingData {
    if ([_searchStr isEqualToString:_searchField.text]) {
        return;
    }
    
    [_dataSearchArr removeAllObjects];
    _tableView.tableHeaderView = _headView;
    _searchStr = _searchField.text;
    if (!_searchStr || [_searchStr isEqualToString:@""]) {
        [_tableView reloadData];
        return;
    }
    
    NWSuggestSearch *suggestSearch = [[NWSuggestSearch alloc] init];
    [suggestSearch setCompletion:^(NSArray *arr, BOOL succ) {
        if (succ) {
            [_dataSearchArr addObjectsFromArray:arr];
            
            if (arr.count > 0) {
                _tableView.tableHeaderView = nil;
            }
            
            [_tableView reloadData];
        }
    }];
    [suggestSearch startRequestWithParams:@{@"condition":_searchStr}];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataSearchArr.count > 0) {
        return _dataSearchArr.count;
    }
    else {
        [_dataHistoryArr removeAllObjects];
        [_dataHistoryArr addObjectsFromArray:[DataBaseServer selectSearchHistoryList]];
        
        return _dataHistoryArr.count > 0 ? _dataHistoryArr.count + 1 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSearchArr.count > 0) {
        SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell updateWithModel:_dataSearchArr[indexPath.row]];
        return cell;
    }
    else {
        if (indexPath.row == _dataHistoryArr.count) {
            ClearHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kClearHistoryCell];
            
            [cell setClearTap:^{
                [DataBaseServer deleteSearchHistoryList];
                [self.tableView reloadData];
            }];
            
            return cell;
        }
        
        SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchHistoryCell];
        [cell updateWithModel:_dataHistoryArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataSearchArr.count > 0) {
        SearchModel *model = _dataSearchArr[indexPath.row];
        [self goToDetailVc:model];
    }
    else {
        if (_dataHistoryArr.count <= 0) {
            return;
        }
        
        SearchModel *model = _dataHistoryArr[indexPath.row];
        
        if (model.albumId && ![model.albumId isEqualToString:@""]) {
            [self goToDetailVc:model];
        }
        else {
            [self goToAlbums:model];
        }
        
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchField endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    SearchModel *model = [[SearchModel alloc] init];
    model.title = textField.text;
    [self goToAlbums:model];
    
    return YES;
}

#pragma mark - SearchHeaderViewDelegate
- (void)goToSearchVC:(SearchModel *)model {
    [self goToAlbums:model];
}

- (void)goToDetailVc:(SearchModel *)model {
    AlbumVoiceModel *albumModel = [[AlbumVoiceModel alloc] initWithDictionary:[model toDictionary] error:nil];
    AlbumDetailListVC *vc = [[AlbumDetailListVC alloc] initWithModel:albumModel];
    [self.navigationController pushViewController:vc animated:YES];
    [DataBaseServer insertSearchHistory:model];
    
    [_searchField endEditing:YES];
}

- (void)goToAlbums:(SearchModel *)model {
    SearchAlbumsViewController *vc = [[SearchAlbumsViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:vc animated:YES];
    [DataBaseServer insertSearchHistory:model];
    
    [_searchField endEditing:YES];
}

@end
