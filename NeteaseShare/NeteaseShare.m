//
//  NeteaseShare.m
//  NeteaseShare
//
//  Created by gzxuzhanpeng on 12/16/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import "NeteaseShare.h"
#import "NeteaseShareManager.h"


@implementation NeteaseShareContent

@end


@interface NeteaseShare()
@property BOOL initFlagYiXin;
@property BOOL initFlagWeChat;
@property BOOL initFlagWeibo;
@property BOOL initFlagQQ;
@property BOOL initFlagMeiPai;
@property BOOL isChannelInit;
@end


@implementation NeteaseShare

+ (NeteaseShare *)sharedInstance
{
    static NeteaseShare *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[NeteaseShare alloc] init];
        [_share setup];
    });
    return _share;
}



- (void)setup
{
    self.initFlagYiXin = NO;
    self.initFlagWeChat = NO;
    self.initFlagWeibo = NO;
    self.initFlagQQ = NO;
    self.initFlagMeiPai = NO;
    self.isChannelInit = NO;
}


- (void)initShareView
{
    [[NeteaseShareManager sharedManager] setShareTitle:@"分享到"];
    [[NeteaseShareManager sharedManager] setShareItemSize:CGSizeMake(70, 70) titleHeight:12 itemColumn:4];
    [NeteaseShareManager initSocialTypes:@[] itemTitles:@[] iconImages:@[]];
    
    if (self.initFlagYiXin) {
        self.isChannelInit = YES;
//        if ([NeteaseShareManager isYiXinAppInstalled]) {
            [NeteaseShareManager addSocialType:kSocialSNSTypeYixinSession title:@"易信好友" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_yixin_normal.png"] highlightIconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_yixin_pressed.png"]];
            [NeteaseShareManager addSocialType:kSocialSNSTypeYixinTimeLine title:@"易信朋友圈" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_yixincircle_normal.png"] highlightIconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_yixincircle_pressed.png"]];
//        } else {
//            [NeteaseShareManager addSocialType:kSocialSNSTypeYixinSession title:@"易信好友" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_yixin_disabled.png"] highlightIconImage:nil];
//            [NeteaseShareManager addSocialType:kSocialSNSTypeYixinTimeLine title:@"易信朋友圈" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_yixincircle_disabled.png"] highlightIconImage:nil];
//        }
    }
    
    if (self.initFlagWeChat) {
        self.isChannelInit = YES;
//        if ([NeteaseShareManager isWeChatAppInstalled]) {
            [NeteaseShareManager addSocialType:kSocialSNSTypeWeChatSession title:@"微信好友" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_wechat_normal.png"] highlightIconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_wechat_pressed.png"]];
            [NeteaseShareManager addSocialType:kSocialSNSTypeWeChatTimeLine title:@"微信朋友圈" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_circle_normal.png"] highlightIconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_circle_pressed.png"]];
//        } else {
//            [NeteaseShareManager addSocialType:kSocialSNSTypeWeChatSession title:@"微信好友" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_wechat_disabled.png"] highlightIconImage:nil];
//            [NeteaseShareManager addSocialType:kSocialSNSTypeWeChatTimeLine title:@"微信朋友圈" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/fab_share_circle_disabled.png"] highlightIconImage:nil];
//        }
    }
    
    if (self.initFlagWeibo) {
        self.isChannelInit = YES;
//        if ([NeteaseShareManager isSinaWeiboAppInstalled]) {
            [NeteaseShareManager addSocialType:kSocialSNSTypeSinaWeibo title:@"新浪微博" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-SinaWeibo.png"] highlightIconImage:nil];
//        } else {
//            [NeteaseShareManager addSocialType:kSocialSNSTypeSinaWeibo title:@"新浪微博" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-SinaWeibo-bw.png"] highlightIconImage:nil];
//        }
    }
    
    if (self.initFlagQQ) {
        self.isChannelInit = YES;
//        if ([NeteaseShareManager isQQAppInstalled]) {
            [NeteaseShareManager addSocialType:kSocialSNSTypeQQ title:@"QQ好友" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-QQ.png"] highlightIconImage:nil];
            [NeteaseShareManager addSocialType:kSocialSNSTypeQZone title:@"QQ空间" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-QZone.png"] highlightIconImage:nil];
//        } else {
//            [NeteaseShareManager addSocialType:kSocialSNSTypeQQ title:@"QQ好友" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-QQ-bw.png"] highlightIconImage:nil];
//            [NeteaseShareManager addSocialType:kSocialSNSTypeQZone title:@"QQ空间" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-QZone-bw.png"] highlightIconImage:nil];
//        }
    }
    
//    if (self.initFlagMeiPai) {
//        self.isChannelInit = YES;
//        [NeteaseShareManager addSocialType:kSocialSNSTypeMeiPai title:@"美拍" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-QZone.png"] highlightIconImage:nil];
//    }
    
//    if ([NeteaseShareManager isYiXinAppInstalled] && self.initFlagYiXin) {
//        self.isChannelInit = YES;
//        [NeteaseShareManager addSocialType:kSocialSNSTypeYixinSession title:@"易信好友" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-YiXinSession.png"]];
//        [NeteaseShareManager addSocialType:kSocialSNSTypeYixinTimeLine title:@"易信朋友圈" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-YiXinTimeLine.png"]];
//    }
//    if ([NeteaseShareManager isWeChatAppInstalled] && self.initFlagWeChat) {
//        self.isChannelInit = YES;
//        [NeteaseShareManager addSocialType:kSocialSNSTypeWeChatSession title:@"微信好友" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-WeChatSession.png"]];
//        [NeteaseShareManager addSocialType:kSocialSNSTypeWeChatTimeLine title:@"微信朋友圈" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-WeChatTimeLine.png"]];
//    }
//    if ([NeteaseShareManager isSinaWeiboAppInstalled] && self.initFlagWeibo) {
//        self.isChannelInit = YES;
//        [NeteaseShareManager addSocialType:kSocialSNSTypeSinaWeibo title:@"新浪微博" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-SinaWeibo.png"]];
//    }
//    if ([NeteaseShareManager isQQAppInstalled] && self.initFlagQQ) {
//        self.isChannelInit = YES;
//        [NeteaseShareManager addSocialType:kSocialSNSTypeQQ title:@"QQ好友" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-QQ.png"]];
//        [NeteaseShareManager addSocialType:kSocialSNSTypeQZone title:@"QQ空间" iconImage:[UIImage imageNamed:@"NeteaseShare.bundle/share-QZone.png"]];
//    }
}


/**
 *  hanle open url
 *
 *  @param url
 *
 *  @return return value description
 */
+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [NeteaseShareManager handleOpenURL:url];
}

/**
 *  set share platform appkey
 *
 *  @param appkey platform appkey
 *  @param type   platform type
 */
- (void)setAppkey:(NSString *)appkey
             type:(NeteaseShareType)type
{
    switch (type) {
        case NeteaseShareYiXin: {
            [NeteaseShareManager setYiXinAPPKey:appkey];
            self.initFlagYiXin = YES;
            break;
        }
        case NeteaseShareWeChat: {
            [NeteaseShareManager setWeChatAPPKey:appkey withDescription:nil];
            self.initFlagWeChat = YES;
            break;
        }
        case NeteaseShareWeibo: {
            [NeteaseShareManager setSinaWeiboAPPKey:appkey];
            self.initFlagWeibo = YES;
            break;
        }
        case NeteaseShareQQ: {
            [NeteaseShareManager setQQAPPId:appkey];
            self.initFlagQQ = YES;
            break;
        }
        case NeteaseShareMeiPai: {
            [NeteaseShareManager setMeiPaiAPPKey:appkey];
            self.initFlagMeiPai = YES;
            break;
        }
        default:
            break;
    }
}

/**
 *  check if any share channels exist
 *
 *  @return YES if any share channels exist, otherwise NO
 */
- (BOOL)shareChannelExist
{
    return self.isChannelInit;
}

/**
 *  share withou UI
 *
 *  @param data data for sharing
 *  @param type share SNS type
 */
- (void)shareContent:(NeteaseShareContent *)content
             type:(NeteaseShareSocialSNSType)type
       completion:(NeteaseShareCompletionHandler)completion
{
    NeteaseShareData *shareData = [NeteaseShareData message];
    switch (content.dataType) {
        case NeteaseShareContentTypeText: {
            if (!content.text) {
                completion(NeteaseShareResponseStateFail, @"分享文本数据格式错误 必需字段: text");
                return;
            }
            shareData.dataType = kShareDataTypeText;
            shareData.text = content.text;
            shareData.bText = YES;
            break;
        }
        case NeteaseShareContentTypeImage: {
            if (!content.text || !content.imageData) {
                completion(NeteaseShareResponseStateFail, @"分享图片数据格式错误 必需字段: text, imageData");
                return;
            }
            shareData.dataType = kShareDataTypeImage;
            shareData.text = content.text;
            shareData.bText = NO;
            NeteaseImageObject *imageObject = [NeteaseImageObject object];
            imageObject.imageData = content.imageData;
            imageObject.thumbnailData = content.thumbnailData;
            shareData.mediaObject = imageObject;
            break;
        }
        case NeteaseShareContentTypeWebpage: {
            if (!content.title || !content.desc || !content.thumbnailData || !content.webpageUrl) {
                completion(NeteaseShareResponseStateFail, @"分享网页数据格式错误 必需字段: title, desc, thumbnailData, webpageUrl");
                return;
            }
            shareData.bText = NO;
            shareData.dataType = kShareDataTypeWebPage;
            NeteaseWebpageObject *mediaObject = [NeteaseWebpageObject object];
            mediaObject.title = content.title;
            mediaObject.desc = content.desc;
            mediaObject.thumbnailData = content.thumbnailData;
            mediaObject.webpageUrl = content.webpageUrl;
            shareData.mediaObject = mediaObject;
            break;
        }
        case NeteaseShareContentTypeVideo: {
            if (!content.mediaUrl) {
                completion(NeteaseShareResponseStateFail, @"分享视频数据格式错误 必需字段: mediaUrl");
                return;
            }
            shareData.bText = NO;
            shareData.dataType = kShareDataTypeVideo;
            NeteaseBaseMediaObject *mediaObject = [NeteaseBaseMediaObject object];
            mediaObject.mediaURL = [NSURL URLWithString:content.mediaUrl];
            shareData.mediaObject = mediaObject;
            break;
        }
        default: {
            completion(NeteaseShareResponseStateFail, @"分享类型错误");
            return;
            break;
        }
    }
    [NeteaseShareManager shareContent:shareData
                         toSocialType:(SocialSNSType)type
                    completionHandler:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                        completion((NeteaseShareResponseState)responseState, @"分享结果");
                    }];
}


/**
 *  share with UI
 *
 *  @param data data for sharing
 *  @param type share SNS type
 */
- (void)shareFromViewController:(UIViewController *)vc
                           content:(NeteaseShareContent *)content
                     completion:(NeteaseShareCompletionHandler)completion
{
    // 没有任何分享渠道
    if (!self.isChannelInit) {
//        completion(NeteaseShareResponseStateFail, @"未初始化或分享渠道不存在");
//        return;
    }
    
    switch (content.dataType) {
        case NeteaseShareContentTypeText: {
            [self shareTextFrom:vc text:content.text completion:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                completion((NeteaseShareResponseState)responseState, @"分享文本");
            }];
            break;
        }
        case NeteaseShareContentTypeImage: {
            [self shareImageFrom:vc text:content.text image:content.imageData thumbnail:content.thumbnailData completion:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                completion((NeteaseShareResponseState)responseState, @"分享图片");
            }];
            break;
        }
        case NeteaseShareContentTypeWebpage: {
            [self shareWebpageFrom:vc title:content.title desc:content.desc thumbnail:content.thumbnailData url:content.webpageUrl completion:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                completion((NeteaseShareResponseState)responseState, @"分享网页");
            }];
            break;
        }
        case NeteaseShareContentTypeVideo: {
            [self shareVideoFrom:vc url:content.mediaUrl completion:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                completion((NeteaseShareResponseState)responseState, @"分享视频");
            }];
            break;
        }
        default:
            break;
    }
}

- (void)shareFromViewController:(UIViewController *)vc content:(NeteaseShareContent *)content fullCompletion:(NeteaseShareFullCompletionHandler)completion {
    switch (content.dataType) {
        case NeteaseShareContentTypeText: {
            [self shareTextFrom:vc text:content.text completion:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                completion((NeteaseShareSocialSNSType)socialType, (NeteaseShareResponseState)responseState, @"分享文本");
            }];
            break;
        }
        case NeteaseShareContentTypeImage: {
            [self shareImageFrom:vc text:content.text image:content.imageData thumbnail:content.thumbnailData completion:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                completion((NeteaseShareSocialSNSType)socialType, (NeteaseShareResponseState)responseState, @"分享图片");
            }];
            break;
        }
        case NeteaseShareContentTypeWebpage: {
            [self shareWebpageFrom:vc title:content.title desc:content.desc thumbnail:content.thumbnailData url:content.webpageUrl completion:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                completion((NeteaseShareSocialSNSType)socialType, (NeteaseShareResponseState)responseState, @"分享网页");
            }];
            break;
        }
        case NeteaseShareContentTypeVideo: {
            [self shareVideoFrom:vc url:content.mediaUrl completion:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                completion((NeteaseShareSocialSNSType)socialType, (NeteaseShareResponseState)responseState, @"分享视频");
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - private methods


- (void)shareTextFrom:(UIViewController *)vc
                 text:(NSString *)text
           completion:(SharedCompletionHandler)completion
{
    NeteaseShareData *shareData = [NeteaseShareData message];
    shareData.dataType = kShareDataTypeText;
    shareData.text = text;
    shareData.bText = YES;
    [NeteaseShareManager showShareViewFrom:vc
                             containerView:vc.view
                              shareContent:shareData
                         completionHandler:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                             completion(socialType, responseState, sourceShareData, error);
                         }];
}

- (void)shareImageFrom:(UIViewController *)vc
                  text:(NSString *)text
                 image:(NSData *)image
             thumbnail:(NSData *)thumbnail
            completion:(SharedCompletionHandler)completion
{
    NeteaseShareData *shareData = [NeteaseShareData message];
    shareData.dataType = kShareDataTypeImage;
    shareData.text = text;
    shareData.bText = NO;
    
    NeteaseImageObject *imageObject = [NeteaseImageObject object];
    imageObject.imageData = image;
    imageObject.thumbnailData = thumbnail;
    shareData.mediaObject = imageObject;
    
    [NeteaseShareManager showShareViewFrom:vc
                             containerView:vc.view
                              shareContent:shareData
                         completionHandler:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                             completion(socialType, responseState, sourceShareData, error);
                         }];
}

- (void)shareWebpageFrom:(UIViewController *)vc
                   title:(NSString *)title
                    desc:(NSString *)desc
               thumbnail:(NSData *)thumbnail
                     url:(NSString *)url
              completion:(SharedCompletionHandler)completion
{
    NeteaseShareData *shareData = [NeteaseShareData message];
    shareData.dataType = kShareDataTypeWebPage;
    shareData.bText = NO;
    
    NeteaseWebpageObject *mediaObject = [NeteaseWebpageObject object];
    mediaObject.title = title;
    mediaObject.desc = desc;
    mediaObject.thumbnailData = thumbnail;
    mediaObject.webpageUrl = url;
    
    shareData.mediaObject = mediaObject;
    
    [NeteaseShareManager showShareViewFrom:vc
                             containerView:vc.view
                              shareContent:shareData
                         completionHandler:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
                             completion(socialType, responseState, sourceShareData, error);
                         }];
}

- (void)shareVideoFrom:(UIViewController *)vc
                   url:(NSString *)url
            completion:(SharedCompletionHandler)completion
{
    NeteaseShareData *shareData = [NeteaseShareData message];
    shareData.dataType = kShareDataTypeVideo;
    shareData.bText = NO;
    
    NeteaseBaseMediaObject *mediaObject = [NeteaseBaseMediaObject object];
    mediaObject.mediaURL = [NSURL URLWithString:url];
    
    shareData.mediaObject = mediaObject;
    
    [NeteaseShareManager showShareViewFrom:vc
                             containerView:vc.view
                              shareContent:shareData
                         completionHandler:^(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error) {
        completion(socialType, responseState, sourceShareData, error);
    }];
}

/**
 *  @author Victor Ji, 15-08-19 09:08:38
 *
 *  通过分享类型返回应用名称
 */

- (NSString *)getSNSNameWithType:(NeteaseShareSocialSNSType)type {
    switch (type) {
        case 1:
        case 2:
            return @"易信";
            break;
            
        case 3:
        case 4:
            return @"微信";
            break;
            
        case 5:
            return @"新浪微博";
            break;
            
        case 6:
        case 7:
            return @"QQ";
            break;
        case 8:
            return @"美拍";
            break;
        default:
            return @"应用";
            break;
    }
}

@end

