//
//  MainTabbarVC.m
//  YxlmApp
//
//  Created by yanhuanpei on 2018/11/14.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "MainTabbarVC.h"
#import "HeroVC.h"
#import "RankingListVC.h"

@interface MainTabbarVC ()

@property (nonatomic, strong) HeroVC *heroVC;
@property (nonatomic, strong) RankingListVC *rankingListVC;
@end

@implementation MainTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    
    CGFloat buttonCenterY = -(kTabHeight / 2) + 10;
    
    //英雄
    self.heroVC = [[HeroVC alloc] init];
    self.heroVC.view.backgroundColor = [UIColor grayColor];
    UINavigationController *heroNav = [[UINavigationController alloc] initWithRootViewController:self.heroVC];
    UITabBarItem *heroTabItem = [[UITabBarItem alloc] initWithTitle:@"英雄" image:nil tag:1000];
    heroTabItem.titlePositionAdjustment = UIOffsetMake(0, buttonCenterY);
    [heroNav setTabBarItem:heroTabItem];
    
    //排行榜
    self.rankingListVC = [[RankingListVC alloc] init];
    self.rankingListVC.view.backgroundColor = [UIColor lightGrayColor];
    UINavigationController *rankingListNav = [[UINavigationController alloc] initWithRootViewController:self.rankingListVC];
    UITabBarItem *rankingListTabItem = [[UITabBarItem alloc] initWithTitle:@"排行" image:nil tag:1001];
    rankingListTabItem.titlePositionAdjustment = UIOffsetMake(0, buttonCenterY);
    [rankingListNav setTabBarItem:rankingListTabItem];
    
    [self setViewControllers:@[heroNav,rankingListNav]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
