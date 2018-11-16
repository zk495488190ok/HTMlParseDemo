//
//  Header.h
//  YxlmApp
//
//  Created by yanhuanpei on 2018/11/14.
//  Copyright © 2018 zhuk. All rights reserved.
//

#ifndef Header_h
#define Header_h

// 屏幕宽高
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kScreenNavHeight (self.navigationController.navigationBar.frame.size.height)
#define kScreenBarHeight (self.tabBarController.tabBar.frame.size.height)
#define kIsPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIsIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIsIpad (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define kIsSmallPhone ([[UIScreen mainScreen] bounds].size.width <= 320)
#define kNavHeight (kIsPhoneX ? 88 : 64)
#define kTabHeight (kIsPhoneX ? (49.f+34.f) : 49.f)
#define kTabbarSafeBottomMargin (kIsPhoneX ? 34.f : 0.f)
#define ScalSize ((float)([[UIScreen mainScreen] bounds].size.width / 375.0))
#define ScalSizeH ((float)([[UIScreen mainScreen] bounds].size.height / 667.0))
#define kLandscapeScaleSizeW ((float)([[UIScreen mainScreen] bounds].size.width / 667.0))
#define kLandscapeScaleSizeH ((float)([[UIScreen mainScreen] bounds].size.height / 375.0))
#define iphone5ssw ((float)(kIsSmallPhone ? ScalSize : 1.0))
#define iphone5ssh ((float)(kIsSmallPhone ? ScalSizeH : 1.0))

#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGBVCOLOR(v) RGBCOLOR(((v&0xFF0000)>>16),((v&0xFF00)>>8),(v&0xFF))

#endif /* Header_h */
