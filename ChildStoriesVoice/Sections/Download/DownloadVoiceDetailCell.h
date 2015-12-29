//
//  DownloadVoiceDetailCell.h
//  ChildStoriesVoice
//
//  Created by apple on 12/28/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import "VoiceDetailCell.h"
#import "NWDownLoad.h"

@class DownloadVoiceListVC;
@interface DownloadVoiceDetailCell : VoiceDetailCell

@property (nonatomic, strong) NWDownLoad *nwDownload;
@property (nonatomic, weak)  DownloadVoiceListVC *pViewController;

@end
