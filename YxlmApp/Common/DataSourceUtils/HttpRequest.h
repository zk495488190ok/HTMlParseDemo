//
//  HttpRequest.h
//  SDMarketingManagement
//
//  Created by Longfei on 16/6/20.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//PostUserRegionId

typedef NS_ENUM(NSInteger, HttpNetStatus){
    NetSucceed                      = 0,                         //成功-0
    NetFailure                      = 1,                         //失败(通用)-1
    NetEmailIsReg                   = 2,                         //邮箱已被注册-2
    NetIncompleteInformation        = 3,                         //必填信息不完整-3
    NetUserIsNoReg                  = 4,                         //该用户没有注册-4
    NetUserPassWordError            = 5,                         //用户密码错误-5
    NetFriendHasBeeApply            = 6,                         //好友申请失败,该好友已被申请-6
    NetNoFriendInformation          = 7,                         //获取好友信息失败,无任何好友信息-7
    NetGetReqCondNoMatch            = 8,                         //获取失败,获取条件不匹配-8
    NetOptReqCondNoMatch            = 9,                         //处理失败,处理条件不匹配-9
    NetCommandCondNoMatch           = 10,                        //命令查询失败,命令不匹配-10
    NetTokenNoMatch                 = 11,                        //服务器Token不匹配,需要重新登录-11
    NetDataIsEmpty                  = 12,                        //获取请求数据为空-12
    NetIllegalArgument              = 13,                        //请求数据为非法JSON-13
    NetUserIsHasaFriend             = 14,                        //好友确认失败,该用户已有正式好友-14
    NetUserIsNotaFriend             = 15,                        //好友删除失败,该用户没有正式好友-15
    NetUpdateGalleryError           = 16,                        //图库上传失败,已存在该MD5的文件-16
    NetPhoneNumberError             = 17,                        //手机号码格式不正确-17
    NetPhoneCheckCodeError          = 18,                        //手机验证码校验失败-18
    NetWorkIsShutDown               = NSURLErrorUnknown,         //网络无效
    NetWorkIsTimeOut                = NSURLErrorTimedOut,        //网络超时
};

typedef void (^HttpSuccessBlock)(id document);
typedef void (^HttpFailureBlock)(NSError* _Nonnull error);

@interface HttpRequest : NSObject

+ (void)getWithPath:(NSString*_Nonnull)path params:(NSDictionary*_Nonnull)params success:(HttpSuccessBlock _Nullable )success failure:(HttpFailureBlock _Nullable )failure;
@end
