//
//  NeteaseShareManager.m
//  NeteaseShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import "NeteaseShareManager.h"
#import "NeteaseShareView.h"
#import "NeteaseShareConfig.h"

//#import "YXApi.h"
#import "WXApi.h"
#import "WeiboSDK.h"
//#import "YXApiObject.h"
#import "WXApiObject.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <MPShareSDK/MPShareSDK.h>

@interface NeteaseShareManager () <
#ifdef NETEASE_SHARE_YIXIN
//YXApiDelegate,
#endif
#ifdef NETEASE_SHARE_WECHAT
WXApiDelegate,
#endif
#ifdef NETEASE_SHARE_WEIBO
WeiboSDKDelegate,
#endif
#ifdef NETEASE_SHARE_QQ
QQApiInterfaceDelegate,
TencentSessionDelegate,
#endif
#ifdef NETEASE_SHARE_MEIPAI
MPSDKProtocol,
#endif
UIAlertViewDelegate>

@property (nonatomic, weak)   UIViewController *fromViewController;
@property (nonatomic, strong) UIViewController *containerViewController;
@property (nonatomic, strong) NSMutableArray *socialTypes;
@property (nonatomic, assign) SocialSNSType selectedSocialType;
@property (nonatomic, strong) NeteaseShareData *shareData;

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation NeteaseShareManager

#pragma mark - Class method

const NSUInteger cMaxThumbnailSize = 32 * 1024;
NSString * const NeteaseShareErrorDomain = @"com.netease.nie";
NSString * const kShowMessageThumbnailLarge = @"缩略图大于32k";


+ (NeteaseShareManager *)sharedManager
{
    static NeteaseShareManager *sharedManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManagerInstance = [[NeteaseShareManager alloc] init];
    });
    
    return sharedManagerInstance;
}


+ (void)setYiXinAPPKey:(NSString *)appKey
{
    #ifdef NETEASE_SHARE_YIXIN
//    [YXApi registerApp:appKey];
    #endif
}


+ (void)setWeChatAPPKey:(NSString *)appKey withDescription:(NSString *)desc
{
    #ifdef NETEASE_SHARE_WECHAT
    [WXApi registerApp:appKey withDescription:desc];
    #endif
}


+ (void)setSinaWeiboAPPKey:(NSString *)appKey
{
    #ifdef NETEASE_SHARE_WEIBO
    [WeiboSDK registerApp:appKey];
    #endif
}


+ (void)setQQAPPId:(NSString *)appId
{
    #ifdef NETEASE_SHARE_QQ
    TencentOAuth *tencent = [[TencentOAuth alloc] initWithAppId:appId andDelegate:[NeteaseShareManager sharedManager]];
    [NeteaseShareManager sharedManager].tencentOAuth = tencent;  // must keep
    #endif
}

+ (void)setMeiPaiAPPKey:(NSString *)appKey {
    #ifdef NETEASE_SHARE_MEIPAI
    [MPShareSDK registerApp:appKey];
    #endif
}

+ (BOOL)isYiXinAppInstalled
{
    BOOL installed = NO;
    #ifdef NETEASE_SHARE_YIXIN
//    installed = [YXApi isYXAppInstalled];
    #endif
    return installed;
}

+ (BOOL)isWeChatAppInstalled
{
    BOOL installed = NO;
    #ifdef NETEASE_SHARE_WECHAT
    installed = [WXApi isWXAppInstalled];
    #endif
    return installed;
}

+ (BOOL)isSinaWeiboAppInstalled
{
    BOOL installed = NO;
    #ifdef NETEASE_SHARE_WEIBO
    installed = [WeiboSDK isWeiboAppInstalled];
    #endif
    return installed;
}

+ (BOOL)isQQAppInstalled
{
    BOOL installed = NO;
    #ifdef NETEASE_SHARE_QQ

    //installed = [QQApi isQQInstalled];

    installed = [QQApiInterface isQQInstalled];

    #endif
    return installed;
}

+ (BOOL)isMeiPaiInstalled {
    BOOL installed = NO;
    #ifdef NETEASE_SHARE_MEIPAI
    installed = [MPShareSDK isMeipaiInstalled];
    #endif
    return installed;
}

+ (void)showShareViewFrom:(UIViewController *)fromViewController
             shareContent:(NeteaseShareData *)shareData
        completionHandler:(SharedCompletionHandler)completionHandler
{
    [NeteaseShareManager showShareViewFrom:fromViewController
                        containerView:nil
                         shareContent:shareData
                    completionHandler:completionHandler];
    
}

+ (void)showShareViewFrom:(UIViewController *)fromViewController
            containerView:(UIView *)containerView
             shareContent:(NeteaseShareData *)shareData
        completionHandler:(SharedCompletionHandler)completionHandler
{
    NeteaseShareManager *sharedManager = [NeteaseShareManager sharedManager];
    sharedManager.fromViewController = fromViewController;
    sharedManager.shareData = shareData;
    sharedManager.completionHandler = completionHandler;
    [sharedManager.shareView showInview:containerView];
}

+ (BOOL)initSocialTypes:(NSArray *)socialTypes
             itemTitles:(NSArray *)itemTitles
             iconImages:(NSArray *)iconImages
{
    if (!socialTypes || !itemTitles || !iconImages) {
        return NO;
    }
    
    NeteaseShareManager *sharedManager = [NeteaseShareManager sharedManager];
    [sharedManager.shareView setupItemTitles:itemTitles images:iconImages];
    [sharedManager.socialTypes addObjectsFromArray:socialTypes];
    return YES;
}

+ (BOOL)addSocialTypes:(NSArray *)socialTypes
            itemTitles:(NSArray *)itemTitles
            iconImages:(NSArray *)iconImages
{
    if (!socialTypes || !itemTitles || !iconImages) {
        return NO;
    }
    
    NeteaseShareManager *sharedManager = [NeteaseShareManager sharedManager];
    BOOL isAddSuccess = [sharedManager.shareView addItemTitles:itemTitles images:iconImages];
    if (isAddSuccess) {
       [sharedManager.socialTypes addObjectsFromArray:socialTypes];
    }
    return isAddSuccess;
}

+ (BOOL)addSocialType:(SocialSNSType)socialType
                title:(NSString *)title
            iconImage:(UIImage *)iconImage
   highlightIconImage:(UIImage *)highlightIconImage
{
    if (!title || !iconImage) {
        return NO;
    }
    
    NeteaseShareManager *sharedManager = [NeteaseShareManager sharedManager];
    BOOL isAddSuccess = NO;
    if (highlightIconImage) {
        isAddSuccess = [sharedManager.shareView addItemTitle:title image:iconImage highlightImage:highlightIconImage];
    } else {
        isAddSuccess = [sharedManager.shareView addItemTitle:title image:iconImage highlightImage:iconImage];
    }
    
    if (isAddSuccess) {
        [sharedManager.socialTypes addObject:[NSNumber numberWithInt:socialType]];
    }
    return isAddSuccess;
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    NeteaseShareManager *sharedManager = [NeteaseShareManager sharedManager];
 
    return
    #ifdef NETEASE_SHARE_YIXIN
//    [YXApi handleOpenURL:url delegate:sharedManager] ||
    #endif
    #ifdef NETEASE_SHARE_WECHAT
    [WXApi handleOpenURL:url delegate:sharedManager] ||
    #endif
    #ifdef NETEASE_SHARE_WEIBO
    [WeiboSDK handleOpenURL:url delegate:sharedManager] ||
    #endif
    #ifdef NETEASE_SHARE_QQ
    [QQApiInterface handleOpenURL:url delegate:sharedManager] ||
    #endif
    #ifdef NETEASE_SHARE_MEIPAI
    [MPShareSDK handleOpenURL:url delegate:sharedManager] ||
    #endif
    NO;
}

+ (void)shareContent:(NeteaseShareData *)shareData
        toSocialType:(SocialSNSType)socialType
   completionHandler:(SharedCompletionHandler)completionHandler
{
    NeteaseShareManager *sharedManager = [NeteaseShareManager sharedManager];
    sharedManager.completionHandler = completionHandler;
    [sharedManager shareContent:shareData toSocialType:socialType];
}

#pragma  mark - Instance method

- (UIViewController *)containerViewController
{
    if (!_containerViewController) {
        _containerViewController = [[UIViewController alloc] init];
        _containerViewController.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    }
    
    return _containerViewController;
}


- (NeteaseShareView *)shareView
{
    if (!_shareView) {
        _shareView = [[NeteaseShareView alloc] initWithTitle:@"分享至" itemTitles:@[] images:@[] selectedHandler:^(NSInteger index){
            //视图消失
            
            if (index >= 0 && index < self.socialTypes.count) {
                SocialSNSType socialType = (SocialSNSType)[self.socialTypes[index] intValue];
                [self shareContent:self.shareData toSocialType:socialType];
            }
            else {
                [self shareContent:self.shareData toSocialType:kSocialSNSTypeNone];
            }
        }];
    }
    
    return _shareView;
}

- (NSMutableArray *)socialTypes
{
    if (!_socialTypes) {
        _socialTypes = [NSMutableArray array];
    }
    
    return _socialTypes;
}

- (void)setShareTitle:(NSString *)title
{
    self.shareView.title = title;
}

- (void)setShareItemSize:(CGSize)itemSize titleHeight:(CGFloat)titleHeight itemColumn:(NSUInteger)column
{
    self.shareView.itemSize = itemSize;
    self.shareView.titleHeight = titleHeight;
    self.shareView.numOfColumns = column;
}

- (void)shareContent:(NeteaseShareData *)shareData toSocialType:(SocialSNSType)socialType
{
    if (self.shareData != shareData) {
        self.shareData = shareData;
    }
    self.selectedSocialType = socialType;
    
    //先判断是否安装客户端，若未安装，则提示未安装客户端信息，不发送分享信息
    switch (socialType) {
        
        // 自定义操作则返回
        case kSocialSNSTypeOption: {
            self.completionHandler(kSocialSNSTypeOption, NeteaseResponseStateSuccess, shareData, nil);
            return;
        }
            
        #ifdef NETEASE_SHARE_YIXIN
//        case kSocialSNSTypeYixinSession: {
//            if (![YXApi isYXAppInstalled]) {
//                self.completionHandler(kSocialSNSTypeYixinSession, NeteaseResponseStateNotInstalled, shareData, nil);
//                return;
//            }
//            break;
//        }
//        case kSocialSNSTypeYixinTimeLine: {
//            if (![YXApi isYXAppInstalled]) {
//                self.completionHandler(kSocialSNSTypeYixinTimeLine, NeteaseResponseStateNotInstalled, shareData, nil);
//                return;
//            }
//            break;
//        }
        #endif
            
        #ifdef NETEASE_SHARE_WECHAT
        case kSocialSNSTypeWeChatSession: {
            if (![WXApi isWXAppInstalled]) {
                self.completionHandler(kSocialSNSTypeWeChatSession, NeteaseResponseStateNotInstalled, shareData, nil);
                return;
            }
            break;
        }
        case kSocialSNSTypeWeChatTimeLine: {
            if (![WXApi isWXAppInstalled]) {
                self.completionHandler(kSocialSNSTypeWeChatTimeLine, NeteaseResponseStateNotInstalled, shareData, nil);
                return;
            }
            break;
        }
        #endif
            
        #ifdef NETEASE_SHARE_WEIBO
        case kSocialSNSTypeSinaWeibo: {
            if (![WeiboSDK isWeiboAppInstalled]) {
                self.completionHandler(kSocialSNSTypeSinaWeibo, NeteaseResponseStateNotInstalled, shareData, nil);
                return;
            }
            break;
        }
        #endif
        
        #ifdef NETEASE_SHARE_QQ
        case kSocialSNSTypeQQ:
        case kSocialSNSTypeQZone:{
            if (![QQApiInterface isQQInstalled]) {
                self.completionHandler(kSocialSNSTypeQQ, NeteaseResponseStateNotInstalled, shareData, nil);
                return;
            }
            break;
        }
        #endif
            
        #ifdef NETEASE_SHARE_MEIPAI
        case kSocialSNSTypeMeiPai: {
            if (![MPShareSDK isMeipaiInstalled]) {
                self.completionHandler(kSocialSNSTypeMeiPai, NeteaseResponseStateNotInstalled, shareData, nil);
                return;
            }
            break;
        }
        #endif
            
        default:
            break;
    }
    
    if (self.completionHandler) {
        self.completionHandler(socialType, NeteaseResponseStateBegan, shareData, nil);
    }
    
    if (shareData.dataType == kShareDataTypeImage) {
        NeteaseImageObject *sourceMediaObject = (NeteaseImageObject *)shareData.mediaObject;
        // 如果分享缩略图不存在，则压缩图片成缩略图
        if (!sourceMediaObject.thumbnailData) {
            NSData *thumbnailData = sourceMediaObject.imageData;
            if (thumbnailData.length > cMaxThumbnailSize) {
                // 缩略图大于32k,压缩到100*100
                UIImage *imageData = [self thumbnailWithImage:[UIImage imageWithData:thumbnailData] size:CGSizeMake(100, 100)];
                thumbnailData = UIImageJPEGRepresentation(imageData,1.0);
            }
            sourceMediaObject.thumbnailData = thumbnailData;
        }
    }
    
    if (shareData.dataType == kShareDataTypeWebPage) {
        NeteaseWebpageObject *sourceMediaObject = (NeteaseWebpageObject *)shareData.mediaObject;
        NSData *thumbnailData = sourceMediaObject.thumbnailData;
        if (thumbnailData.length > cMaxThumbnailSize) {
            // 缩略图大于32k,压缩到100*100
            UIImage *imageData = [self thumbnailWithImage:[UIImage imageWithData:thumbnailData] size:CGSizeMake(100, 100)];
            thumbnailData = UIImageJPEGRepresentation(imageData,1.0);
        }
        if (socialType == kSocialSNSTypeWeChatTimeLine) {
            sourceMediaObject.title = sourceMediaObject.desc;
        }
        
        sourceMediaObject.thumbnailData = thumbnailData;
    }
    
    
    switch (socialType) {
        
        // 自定义操作则返回
        case kSocialSNSTypeOption: {
            self.completionHandler(kSocialSNSTypeOption, NeteaseResponseStateSuccess, shareData, nil);
            return;
        }
            
        #ifdef NETEASE_SHARE_YIXIN
//        case kSocialSNSTypeYixinSession: {
//            [self shareContent:shareData toYiXin:kYXSceneSession];
//        }
//            break;
//        case kSocialSNSTypeYixinTimeLine: {
//            [self shareContent:shareData toYiXin:kYXSceneTimeline];
//        }
//            break;
        #endif
            
        #ifdef NETEASE_SHARE_WECHAT
        case kSocialSNSTypeWeChatSession: {
            [self shareContent:shareData toWeChat:WXSceneSession];
        }
            break;
        case kSocialSNSTypeWeChatTimeLine: {
            [self shareContent:shareData toWeChat:WXSceneTimeline];
        }
            break;
        #endif
        
        #ifdef NETEASE_SHARE_WEIBO
        case kSocialSNSTypeSinaWeibo: {
            [self shareContentToSinaWeibo:shareData];
        }
            break;
        #endif
        
        #ifdef NETEASE_SHARE_QQ
        case kSocialSNSTypeQQ: {
            [self shareContentToQQ:shareData];
        }
            break;
        case kSocialSNSTypeQZone: {
            [self shareContentToQZone:shareData];
        }
            break;
        #endif
            
        #ifdef NETEASE_SHARE_MEIPAI
        case kSocialSNSTypeMeiPai: {
            [self shareContentToMeiPai:shareData];
        }
            break;
        #endif
            
        default:    //kSocialSNSTypeNone do nothing
            if (self.completionHandler) {
                self.completionHandler(kSocialSNSTypeNone, NeteaseResponseStateCancel, shareData, nil);
            }
            break;
    }
}



- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


#pragma mark - private method share content


#ifdef NETEASE_SHARE_YIXIN
//- (void)shareContent:(NeteaseShareData *)shareData toYiXin:(enum YXScene)yxScene
//{
//    SendMessageToYXReq *req = [[SendMessageToYXReq alloc] init];
//    req.scene = yxScene;
// 
//    if (shareData.dataType == kShareDataTypeImage) {
//        req.bText = NO;
//        req.text = shareData.text;
//        
//        NeteaseImageObject *sourceMediaObject = (NeteaseImageObject *)shareData.mediaObject;
//        
//        YXImageObject *imageObject = [YXImageObject object];
//        imageObject.imageData = sourceMediaObject.imageData;
//        
//        YXMediaMessage *message = [YXMediaMessage message];
//        message.thumbData = sourceMediaObject.thumbnailData;
//        message.mediaObject = imageObject;
//        
//        req.message = message;
//    } else if (shareData.dataType == kShareDataTypeWebPage) {
//        
//        NeteaseWebpageObject *sourceMediaObject = (NeteaseWebpageObject *)shareData.mediaObject;
//        
//        YXWebpageObject *pageObject = [YXWebpageObject object];
//        pageObject.webpageUrl = sourceMediaObject.webpageUrl;
//        
//        YXMediaMessage *message = [YXMediaMessage message];
//        message.title = sourceMediaObject.title;
//        message.description = sourceMediaObject.desc;
//        [message setThumbData:sourceMediaObject.thumbnailData];
//        message.mediaObject = pageObject;
//        
//        req.message = message;
//    } else {
//        //默认以文本信息发送
//        req.bText = YES;
//        req.text = shareData.text;
//    }
//
//    [YXApi sendReq:req];
//}
#endif

#ifdef NETEASE_SHARE_WECHAT
- (void)shareContent:(NeteaseShareData *)shareData toWeChat:(enum WXScene)wxScene
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.scene = wxScene;
    
    if (shareData.dataType == kShareDataTypeImage) {
        req.bText = NO;
        
        NeteaseImageObject *sourceMediaObject = (NeteaseImageObject *)shareData.mediaObject;

        WXMediaMessage *message = [WXMediaMessage message];
        req.text = shareData.text;
        message.title = shareData.text;
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = sourceMediaObject.imageData;
        message.mediaObject = imageObject;
        message.thumbData = sourceMediaObject.thumbnailData;
        
        req.message = message;
    } else if (shareData.dataType == kShareDataTypeWebPage) {
        req.bText = NO;
        NeteaseWebpageObject *sourceMediaObject = (NeteaseWebpageObject *)shareData.mediaObject;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = sourceMediaObject.title;
        message.description = sourceMediaObject.desc;
        message.thumbData = sourceMediaObject.thumbnailData;
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = sourceMediaObject.webpageUrl;
        message.mediaObject = ext;
        
        req.message = message;
    } else {
        req.bText = YES;
        req.text = shareData.text;
    }
    
    [WXApi sendReq:req];
}
#endif


#ifdef NETEASE_SHARE_WEIBO
- (void)shareContentToSinaWeibo:(NeteaseShareData *)shareData
{
    WBMessageObject *message = [WBMessageObject message];
    
    if (shareData.dataType == kShareDataTypeText) {
        message.text = shareData.text;
    }
    else if (shareData.dataType == kShareDataTypeImage) {
        NeteaseImageObject *sourceMediaObject = (NeteaseImageObject *)shareData.mediaObject;
        message.text = shareData.text;
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = sourceMediaObject.imageData;
        message.imageObject = imageObject;
    }
    else if (shareData.dataType == kShareDataTypeWebPage) {
        
        NeteaseWebpageObject *sourceMediaObject = (NeteaseWebpageObject *)shareData.mediaObject;
        message.text = [NSString stringWithFormat:@"%@ %@", sourceMediaObject.title, sourceMediaObject.desc];
        WBWebpageObject *webpage = [WBWebpageObject object];
        if (!webpage.objectID) {
            webpage.objectID = @"weiboDataId";
        } else {
            webpage.objectID = sourceMediaObject.objectID;
        }
        webpage.title = sourceMediaObject.title;
        webpage.description = sourceMediaObject.desc;
        webpage.thumbnailData = sourceMediaObject.thumbnailData;
        webpage.webpageUrl = sourceMediaObject.webpageUrl;
        message.mediaObject = webpage;
    }
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": @"NeteaseShareManager"
                         };
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
}
#endif


#ifdef NETEASE_SHARE_QQ
- (SendMessageToQQReq *)qqMessageForData:(NeteaseShareData *)shareData {

    SendMessageToQQReq *message;
    
    if (shareData.dataType == kShareDataTypeText) {
        QQApiTextObject *text = [QQApiTextObject objectWithText:shareData.text];
        message = [SendMessageToQQReq reqWithContent:text];
    }
    else if (shareData.dataType == kShareDataTypeImage) {
        NeteaseImageObject *sourceMediaObject = (NeteaseImageObject *)shareData.mediaObject;
        QQApiImageObject* img = [QQApiImageObject objectWithData:sourceMediaObject.imageData
                                                previewImageData:UIImageJPEGRepresentation([UIImage imageWithData:sourceMediaObject.imageData],0.3)
                                                           title:sourceMediaObject.title
                                                     description:shareData.text];
        message = [SendMessageToQQReq reqWithContent:img];
    }
    else if (shareData.dataType == kShareDataTypeWebPage) {
        
        NeteaseWebpageObject *sourceMediaObject = (NeteaseWebpageObject *)shareData.mediaObject;
        QQApiNewsObject *object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:sourceMediaObject.webpageUrl]
                                                         title:sourceMediaObject.title
                                                   description:sourceMediaObject.desc
                                              previewImageData:sourceMediaObject.thumbnailData
                                             targetContentType:QQApiURLTargetTypeNews];
        message = [SendMessageToQQReq reqWithContent:object];
    }
    return message;
}

- (void)shareContentToQQ:(NeteaseShareData *)shareData{

    SendMessageToQQReq *message = [self qqMessageForData:shareData];
    QQApiSendResultCode sendResult = [QQApiInterface sendReq:message];
    [self handleQQSendResult:sendResult];
}


- (void)shareContentToQZone:(NeteaseShareData *)shareData{
    
//    分享到QQ空间支持发送：
//    - 带有URL的消息
//    - 新闻类消息(QQApiNewsObject)
//    - 音频类消息(QQApiImageObject)
//    - 视频类消息(QQApiVideoObject)
    if (shareData.dataType != kShareDataTypeWebPage) {
        return;
    }
    
    SendMessageToQQReq *message = [self qqMessageForData:shareData];
    QQApiSendResultCode sendResult = [QQApiInterface SendReqToQZone:message];
    [self handleQQSendResult:sendResult];
}

- (void)handleQQSendResult:(QQApiSendResultCode)sendResult
{
    NeteaseResponseState responseState = NeteaseResponseStateFail;
    switch (sendResult)
    {
        case EQQAPISENDSUCESS: {
            responseState = NeteaseResponseStateSuccess;
            break;
        }
        case EQQAPIQQNOTINSTALLED: {
            break;
        }
        case EQQAPIAPPNOTREGISTED:
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        case EQQAPIQQNOTSUPPORTAPI:
        case EQQAPISENDFAILD: {
            break;
        }
        default: {
            break;
        }
    }
}

+ (BOOL)isSuccessResultFromQQOpenURL:(NSURL *)url
{
    NSLog(@"%@", url);
    NSString *urlParameter = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *components = [urlParameter componentsSeparatedByString:@"&"];
    [components enumerateObjectsUsingBlock:^(NSString *c, NSUInteger idx, BOOL *stop) {
        NSLog(@"obj:  %@", c);
    }];
    return YES;
}
#endif

#ifdef NETEASE_SHARE_MEIPAI
- (void)shareContentToMeiPai:(NeteaseShareData *)shareData {
    NeteaseBaseMediaObject *mediaObj = shareData.mediaObject;
    NSURL *mediaURL = mediaObj.mediaURL;
    [MPShareSDK shareVideoAtPathToMeiPai:mediaURL];
}
#endif


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{


}


#pragma mark - YXApiDelegate

/*! @brief 易信SDK Delegate
 *
 * 接收来至易信客户端的事件消息，接收后唤起第三方App来处理。
 * 易信SDK会在handleOpenURL中根据消息回调YXApiDelegate的方法。
 */

#ifdef NETEASE_SHARE_YIXIN
//- (void)onReceiveRequest: (YXBaseReq *)req
//{
//    
//}
//- (void)onReceiveResponse: (YXBaseResp *)resp
//{
//    if([resp isKindOfClass:[SendMessageToYXResp class]])
//    {
//        NeteaseResponseState responseState;
//        if (resp.code == kYXRespSuccess) {
//            responseState = NeteaseResponseStateSuccess;
//        }
//        else if (resp.code == kYXRespErrUserCancel) {
//            responseState = NeteaseResponseStateCancel;
//        }
//        else if (resp.code == kYXRespErrSentFail) {
//            responseState = NeteaseResponseStateFail;
//        }
//        else {
//            responseState = NeteaseResponseStateFail;
//        }
//        
//        if (self.completionHandler) {
//            self.completionHandler(self.selectedSocialType, responseState, self.shareData, nil);
//        }
//    }
//}
#endif

#pragma mark - WX & QQ ApiDelegate

-(void) onReq:(BaseReq*)req
{
    
    NSLog(@"--onReq ");
    NSLog(@"%@", req);
}

// QQ & WX's delegate has the same method name.
-(void) onResp:(id)responseObject
{
    NeteaseResponseState responseState;
    
    #ifdef NETEASE_SHARE_WECHAT
    if ([responseObject isKindOfClass:[SendMessageToWXResp class]]) {
        BaseResp* resp = (BaseResp *)responseObject;
        if (resp.errCode == WXSuccess) {
            responseState = NeteaseResponseStateSuccess;
        }
        else if (resp.errCode == WXErrCodeUserCancel) {
            responseState = NeteaseResponseStateCancel;
        }
        else if (resp.errCode == WXErrCodeSentFail) {
            responseState = NeteaseResponseStateFail;
        }
        else {
            responseState = NeteaseResponseStateFail;
        }
        
        if (self.completionHandler) {
            self.completionHandler(self.selectedSocialType, responseState, self.shareData, nil);
        }
        
        return;

    }
    #endif
    
    #ifdef NETEASE_SHARE_QQ
    if ([responseObject isKindOfClass:[QQBaseResp class]]) {
        QQBaseResp* resp = (QQBaseResp *)responseObject;
        if (resp.result.intValue == 0) {
            responseState = NeteaseResponseStateSuccess;
        } else if (resp.result.intValue == -4) {
            responseState = NeteaseResponseStateCancel;
        } else {
            responseState = NeteaseResponseStateFail;
        }
        if (self.completionHandler) {
            self.completionHandler(self.selectedSocialType, responseState, self.shareData, nil);
        }
        return;
    }
    #endif
}

#pragma mark - WeiboSDKDelegate


#ifdef NETEASE_SHARE_WEIBO
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)resp
{
    if ([resp isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NeteaseResponseState responseState;
        if (resp.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            responseState = NeteaseResponseStateSuccess;
        } else if (resp.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
            responseState = NeteaseResponseStateCancel;
        } else if (resp.statusCode == WeiboSDKResponseStatusCodeSentFail) {
            responseState = NeteaseResponseStateFail;
        } else {
            responseState = NeteaseResponseStateFail;
        }
        if (self.completionHandler) {
            self.completionHandler(self.selectedSocialType, responseState, self.shareData, nil);
        }
    } else if ([resp isKindOfClass:WBAuthorizeResponse.class]) {
        
    }
}
#endif

#pragma mark - QQApiInterfaceDelegate

#ifdef NETEASE_SHARE_QQ
- (void)isOnlineResponse:(NSDictionary *)response{

}
#endif

#pragma mark Tencent Session Delegate

#ifdef NETEASE_SHARE_QQ
- (void)tencentDidLogin{

}

- (void)tencentDidNotLogin:(BOOL)cancelled{

}

- (void)tencentDidNotNetWork{

    
}
#endif

#pragma mark - MeiPai Share delegate
#ifdef NETEASE_SHARE_MEIPAI
- (void)shareToMeipaiDidSuccess:(BOOL)success {
    if (self.completionHandler) {
        if (success) {
            NSLog(@"share to meipai success");
            self.completionHandler(self.selectedSocialType, NeteaseResponseStateSuccess, self.shareData, nil);
        } else {
            NSLog(@"share to meipai fail");
            self.completionHandler(self.selectedSocialType, NeteaseResponseStateFail, self.shareData, nil);
        }
    }
}
#endif
@end
