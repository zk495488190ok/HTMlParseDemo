//
//  DataUtils.m
//  YxlmApp
//
//  Created by yanhuanpei on 2018/11/14.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DataUtils.h"
#import "AFNetworking.h"
#import "ONOXMLDocument.h"

#define ACTION_HERO     @"http://www.op.gg/champion/statistics"

static DataUtils *onceObj;
@implementation DataUtils

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onceObj = [[DataUtils alloc] init];
    });
    return onceObj;
}

-(void)getHeroAllData:(void(^)(NSMutableArray<HeroModel *> *heroArr))response {
    [self reqURL:ACTION_HERO success:^(NSString *text) {
        NSMutableArray<NSDictionary *> *arr = [self regex:@"<div class=\".*Role-(.*?)\" data-champion-name=\"(.*?)\".*\n.*<a href=\"(.*?)\".*\n.*<div class=\"by-champion__item-image __sprite __spc40 __spc40-(.*?)\">" text:text];
        NSMutableArray *responseArr = [NSMutableArray new];
        for (NSDictionary *dic in arr) {
            for (NSString *key in dic.allKeys) {
                NSArray *dicVal = [dic valueForKey:key];
                HeroModel *model = [[HeroModel alloc] init];
                model.role = dicVal[0];
                model.name = dicVal[1];
                model.href = dicVal[2];
                model.pointY = dicVal[3];
                [responseArr addObject:model];
            }
        }
        if (response) {
            response(responseArr);
        }
    } fial:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}


#pragma mark -

- (void)reqURL:(NSString *)url success:(void(^)(NSString *text))success fial:(void(^)(NSError *error))fial {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (success) {
            success(html);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fial) {
            fial(error);
        }
    }];
}


- (NSMutableArray<NSDictionary *> *)regex:(NSString *)regxStr text:(NSString *)text {
    NSError *error = nil;
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:regxStr options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Error:%@",error.localizedDescription);
        return nil;
    }
    NSMutableArray<NSDictionary *> *matchsArr = [[NSMutableArray<NSDictionary *> alloc] init];
    NSArray *res = [regx matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    int j = 0;
    for (NSTextCheckingResult *item in res) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 1; i < item.numberOfRanges; i++) {
            [arr addObject:[text substringWithRange:[item rangeAtIndex:i]]];
        }
        [matchsArr addObject:@{[NSString stringWithFormat:@"%d",j]:arr}];
        j++;
    }
    return matchsArr;
}

@end
