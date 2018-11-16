//
//  HeroCollectionVC.h
//  YxlmApp
//
//  Created by yanhuanpei on 2018/11/16.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeroModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeroCollectionVC : UICollectionViewController


-(void)loadData:(NSArray<HeroModel *> *)dataArr;
@end

NS_ASSUME_NONNULL_END
