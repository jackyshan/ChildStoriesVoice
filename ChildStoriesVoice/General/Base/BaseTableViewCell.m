//
//  BaseTableViewCell.m
//  PregnantMotherAte
//
//  Created by apple on 9/13/15.
//  Copyright (c) 2015 jackyshan. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        [self defineLayout];
    }
    return self;
}

- (void)updateConstraints {
    [self defineLayout];
    [super updateConstraints];
}

- (void)addSubviews {
    NSAssert(NO, @"Must override");
}

- (void)defineLayout {
    NSAssert(NO, @"Must override");
}

- (void)updateWithModel:(id)model {}

@end
