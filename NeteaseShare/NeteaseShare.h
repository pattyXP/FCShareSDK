//
//  NeteaseShare.h
//  NeteaseShare
//
//  Created by gzxuzhanpeng on 11/21/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    NeteaseShareYiXin = 0,          //开启易信分享
    NeteaseShareWeChat = 1,         //开启微信分享
    NeteaseShareWeibo = 2,          //开启微博分享
    NeteaseShareQQ = 3,             //开启QQ分享
    NeteaseShareMeiPai = 4,         //开启美拍分享
} NeteaseShareType;

typedef enum NeteaseShareSocialSNSType {
    NeteaseShareSocialSNSTypeNone              = -1,
    NeteaseShareSocialSNSTypeOption            = 0, //自定义操作
    NeteaseShareSocialSNSTypeYixinSession      = 1, //易信好友
    NeteaseShareSocialSNSTypeYixinTimeLine     = 2, //易信朋友圈
    NeteaseShareSocialSNSTypeWeChatSession     = 3, //微信好友
    NeteaseShareSocialSNSTypeWeChatTimeLine    = 4, //微信朋友圈
    NeteaseShareSocialSNSTypeSinaWeibo         = 5, //新浪微博
    NeteaseShareSocialSNSTypeQQ                = 6, //QQ好友
    NeteaseShareSocialSNSTypeQZone             = 7, //QQ空间
    NeteaseShareSocialSNSTypeMeiPai            = 8, //美拍
} NeteaseShareSocialSNSType;


typedef enum NeteaseShareResponseState {
    NeteaseShareResponseStateBegin = 0,       // 开始
    NeteaseShareResponseStateSuccess = 1,     // 成功
    NeteaseShareResponseStateFail = 2,        // 失败
    NeteaseShareResponseStateCancel = 3,      // 取消
    NeteaseShareResponseStateNotInstalled = 4 // 应用没安装
} NeteaseShareResponseState;


/**
 分享内容结构体
 */
@interface NeteaseShareContent : NSObject

typedef enum NeteaseShareContentType {
    NeteaseShareContentTypeText = 0,
    NeteaseShareContentTypeImage = 1,
    NeteaseShareContentTypeWebpage = 2,
    NeteaseShareContentTypeVideo = 3,
} NeteaseShareContentType;

@property (nonatomic) NeteaseShareContentType dataType;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSData *thumbnailData;
@property (nonatomic, retain) NSString *webpageUrl;
@property (nonatomic, retain) NSString *commentStr;
@property (nonatomic, retain) NSString *mediaUrl;

@end


@interface NeteaseShare : NSObject

+ (NeteaseShare *)sharedInstance;

/**
 *  init share view before share with UI
 */
- (void)initShareView;

/**
 *  hanle open url
 *
 *  @param url
 *
 *  @return return value description
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  set share platform appkey
 *
 *  @param appkey platform appkey
 *  @param type   platform type
 */
- (void)setAppkey:(NSString *)appkey
             type:(NeteaseShareType)type;

typedef void(^NeteaseShareCompletionHandler)(NeteaseShareResponseState responseState, NSString *errorMessage);

/**
 *  share without UI
 *
 *  @param data content data for sharing
 *  @param type share SNS type
 */
- (void)shareContent:(NeteaseShareContent *)content
                type:(NeteaseShareSocialSNSType)type
       completion:(NeteaseShareCompletionHandler)completion;

/**
 *  share with default UI
 *
 *  @param data content data for sharing
 *  @param type share SNS type
 */
- (void)shareFromViewController:(UIViewController *)vc
                        content:(NeteaseShareContent *)content
                     completion:(NeteaseShareCompletionHandler)completion;


typedef void(^NeteaseShareFullCompletionHandler)(NeteaseShareSocialSNSType socialType, NeteaseShareResponseState responseState, NSString *errorMessage);

- (void)shareFromViewController:(UIViewController *)vc
                        content:(NeteaseShareContent *)content
                 fullCompletion:(NeteaseShareFullCompletionHandler)completion;

/**
 *  check if any share channels exist
 *
 *  @return YES if any share channels exist, otherwise NO
 */
- (BOOL)shareChannelExist;

/**
 *  @author Victor Ji, 15-08-19 09:08:07
 *
 *  通过分享类型来获得应用名称
 *
 *  @param type 分享类型
 *
 *  @return 应用名称
 */
- (NSString *)getSNSNameWithType:(NeteaseShareSocialSNSType)type;

@end
