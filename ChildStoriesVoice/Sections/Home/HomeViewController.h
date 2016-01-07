//
//  HomeViewController.h
//  ChildStoriesVoice
//
//  Created by jackyshan on 12/17/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController {
    NSUInteger _pageId;
}

@property (nonatomic, readonly) UICollectionView *collectionView;

@property (nonatomic, readonly) NSMutableArray *mArr;

@property (nonatomic, readonly) MBProgressHUD *hub;

@end
