
//
//  HttpRequest.m
//  SDMarketingManagement
//
//  Created by Longfei on 16/6/20.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import <netinet/in.h>

#define TIME_OUT 8
#define DOMAIN_KEY @"domainCustom"
#define kErrorInfoKey @"localizedDescription"
#define REQ_TYPE_GET @"GET"
#define REQ_TYPE_POST @"POST"

static NSDictionary *responseErrorInfoDic;

@implementation HttpRequest


#pragma mark - Public



/**
 GET
 
 */
+(void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    
    NSString *reqPath = path;
    AFHTTPSessionManager *manager = [self managerWithPath:reqPath requestType:REQ_TYPE_GET];
    
    [manager GET:reqPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // create a new SMXMLDocument with the contents of sample.xml
        NSError *error = nil;
        SMXMLDocument *document = [SMXMLDocument documentWithData:responseObject error:&error];
        if (success) {
            success(document);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self callBackResponseFail:failure success:success error:error];
    }];
    
}


#pragma mark - Private

+(void)callBackResponseFail:(HttpFailureBlock) fail success:(HttpSuccessBlock) success error:(NSError *) error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (fail) {
            fail(error);
        }
    });
}

+(void)callBackResponseSuccess:(HttpSuccessBlock) success fail:(HttpFailureBlock) fail responseObject:(id) responseObject{
    NSLog(@"\n------------------------------------ 当前请求的结果 ------------------------------------\n");
    NSLog(@"%@\n",[responseObject mj_keyValues]);
    NSLog(@"\n--------------------------------------------------------------------------------------\n");
    if(responseObject && [responseObject isKindOfClass:[NSDictionary class]]){
        NSDictionary* resDic = [responseObject mj_keyValues];
        
        //401 身份认证失败
        if ([resDic[@"status"] intValue] == 401) {
            NSError *error = [self createError:NSLocalizedString(@"Information mismatch, please login again", nil) ErrorCode:401];
            [self callBackResponseFail:fail success:success error:error];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *retCode = [resDic valueForKey:@"ReturnCode"];
            if (retCode && [retCode intValue] == 0) {
                if (success) {
                    success(resDic);
                }
            }else{
                NSString *retMsg = [self ErrorDic][retCode];
                NSError *error = [self createError:retMsg ErrorCode:[retCode intValue]];
                [self callBackResponseFail:fail success:success error:error];
            }
        });
    }
}

+(BOOL)isExistenceNetwork{
    struct sockaddr_in zeroAddress;//sockaddr_in是与sockaddr等价的数据结构
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress); //创建测试连接的引用：
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

+(NSError *)createError:(NSString *)msg ErrorCode:(NSInteger)code {
    NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:code userInfo:@{@"NSLocalizedDescription":msg}];
    return error;
}

#pragma mark - 懒加载

+(NSDictionary *)ErrorDic{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //mark - lcoal  (没用上)
        responseErrorInfoDic = @{
                                 @0:@"成功",//成功
                                 @1:NSLocalizedString(@"Loading failed", nil),   //请求失败
                                 @2:NSLocalizedString(@"Email already registered", nil), //@"邮箱已被注册", //"Email already registered"
                                 @3:@"必填信息不完整",
                                 @4:NSLocalizedString(@"Account does not exist", nil), //@"该用户没有注册", //"Account does not exist"
                                 @5:@"用户密码错误", //"Password incorrect"
                                 @6:NSLocalizedString(@"Friend has been applied", nil),//@"好友申请失败,该好友已被申请", //"Friend has been applied"
                                 @7:NSLocalizedString(@"Buddy info update incomplete", nil),//@"获取好友信息失败,无任何好友信息", //"Buddy info update incomplete"
                                 @8:@"获取失败,获取条件不匹配",
                                 @9:@"处理失败,处理条件不匹配",
                                 @10:@"命令查询失败,命令不匹配",
                                 @11:NSLocalizedString(@"Information mismatch, please login again", nil),//@"身份过期,需要重新登录", //"Information mismatch, please login again"
                                 @12:@"获取请求数据为空",
                                 @13:@"请求数据为非法JSON",
                                 @14:@"好友确认失败,该用户已有正式好友",
                                 @15:NSLocalizedString(@"Remove buddy failed", nil),//@"好友删除失败,该用户没有正式好友", //"Remove buddy failed"
                                 @16:@"图库上传失败,已存在该MD5的文件",
                                 @17:@"手机号码格式不正确",
                                 @18:@"手机验证码校验失败",
                                 };
    });
    return responseErrorInfoDic;
}

+(AFHTTPSessionManager *)managerWithPath:(NSString *) path requestType:(NSString *) type{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{
                                     @"User-Agent":@"XXXX/3.5.0 (iPhone; iOS 10.0; Scale/2.00)",
                                     @"Accept-Language":@"zh-Hans-US;q=1, en;q=0.9"
                                     };
    
    if ([type isEqualToString:REQ_TYPE_POST]) {
        [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
            return [parameters mj_JSONString];
        }];
    }
    // 客户端是否信任非法证书
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //支持https（校验证书，不可以抓包）
    /*
     [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
     // 设置证书模式
     NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];
     NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
     // 客户端是否信任非法证书
     manager.securityPolicy.allowInvalidCertificates = YES;
     // 是否在证书域字段中验证域名
     [manager.securityPolicy setValidatesDomainName:NO];
     */
    
    //支持https（不校验证书，可以抓包查看）
    /*
     // 设置非校验证书模式
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.securityPolicy.allowInvalidCertificates = YES;
     [manager.securityPolicy setValidatesDomainName:NO];
     */
    
    //可以识别的内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"plant/html",@"image/jpeg",@"application/octet-stream",nil];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    return manager;
}


@end
