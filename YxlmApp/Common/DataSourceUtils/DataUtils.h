//
//  DataUtils.h
//  YxlmApp
//
//  Created by yanhuanpei on 2018/11/14.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroModel.h"

#define DATA_UTIL [DataUtils sharedInstance]

@interface DataUtils : NSObject

+ (instancetype)sharedInstance;

-(void)getHeroAllData:(void(^)(NSMutableArray<HeroModel *> *heroArr))response;

@end

