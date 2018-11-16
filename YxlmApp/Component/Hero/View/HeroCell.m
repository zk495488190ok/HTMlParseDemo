//
//  HeroCell.m
//  YxlmApp
//
//  Created by yanhuanpei on 2018/11/16.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "HeroCell.h"
#import "Masonry.h"

@implementation HeroCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.lbName];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 30, 10));
    }];
    [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor grayColor];
    }
    return _imgView;
}

-(UILabel *)lbName{
    if (!_lbName) {
        _lbName = [[UILabel alloc] init];
        _lbName.font = [UIFont systemFontOfSize:12];
        _lbName.textAlignment = NSTextAlignmentCenter;
    }
    return _lbName;
}

@end
