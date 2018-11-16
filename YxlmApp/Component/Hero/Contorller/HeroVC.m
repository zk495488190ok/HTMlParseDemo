//
//  HeroVC.m
//  YxlmApp
//
//  Created by yanhuanpei on 2018/11/14.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "HeroVC.h"
#import "DataUtils.h"
#import "JGProgressHUD.h"
#import "HeroCollectionVC.h"

@interface HeroVC ()<WMPageControllerDelegate>

@property (nonatomic, strong) NSMutableArray<HeroModel *> *heroArr;
@property (nonatomic, strong) NSArray *roleKeys;
@end

@implementation HeroVC

- (instancetype)init
{
    self.roleKeys = @[@"TOP",@"JUNGLE",@"MID",@"ADC",@"SUPPORT"];
    self = [super initWithViewControllerClasses:@[[HeroCollectionVC class],
                                                  [HeroCollectionVC class],
                                                  [HeroCollectionVC class],
                                                  [HeroCollectionVC class],
                                                  [HeroCollectionVC class]]
                                 andTheirTitles:@[@"上单",@"打野",@"中单",@"ADC",@"辅助"]];
    self.menuViewStyle = WMMenuViewStyleLine;
    [self.menuView setTintColor:[UIColor whiteColor]];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Private

- (NSArray *)filterDataWithRoleKey:(NSString *)key {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"role == %@",key];
    return [self.heroArr filteredArrayUsingPredicate:pred];
}

#pragma mark - WMPageControllerDelegate

- (void)pageController:(WMPageController *)pageController lazyLoadViewController:(__kindof HeroCollectionVC *)viewController withInfo:(NSDictionary *)info{
    NSString *key = [self.roleKeys objectAtIndex:[info[@"index"] integerValue]];
    if (self.heroArr.count == 0) {
        JGProgressHUD *hud = [[JGProgressHUD alloc] initWithStyle:(JGProgressHUDStyleDark)];
        [hud showInView:self.view];
        [DATA_UTIL getHeroAllData:^(NSMutableArray<HeroModel *> *heroArr) {
            [hud dismissAnimated:YES];
            self.heroArr = heroArr;
            [viewController loadData:[self filterDataWithRoleKey:key]];
        }];
    }else{
        [viewController loadData:[self filterDataWithRoleKey:key]];
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

-(CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(0, originY, kScreenWidth, 44);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.showOnNavigationBar = YES;
}

- (NSMutableArray<HeroModel *> *)heroArr{
    if (!_heroArr) {
        _heroArr = [[NSMutableArray<HeroModel *> alloc] init];
    }
    return _heroArr;
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
