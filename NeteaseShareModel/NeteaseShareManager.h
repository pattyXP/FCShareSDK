//
//  NeteaseShareManager.h
//  NeteaseShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NeteaseShareData.h"


typedef enum SocialSNSType {
    kSocialSNSTypeNone              = -1,
    kSocialSNSTypeOption            = 0, //自定义操作
    kSocialSNSTypeYixinSession      = 1, //易信好友
    kSocialSNSTypeYixinTimeLine     = 2, //易信朋友圈
    kSocialSNSTypeWeChatSession     = 3, //微信好友
    kSocialSNSTypeWeChatTimeLine    = 4, //微信朋友圈
    kSocialSNSTypeSinaWeibo         = 5, //新浪微博
    kSocialSNSTypeQQ                = 6, //QQ好友
    kSocialSNSTypeQZone             = 7, //QQ空间
    kSocialSNSTypeMeiPai            = 8, //美拍
} SocialSNSType;

typedef enum NeteaseResponseState {
    NeteaseResponseStateBegan = 0, /**< 开始 */
    NeteaseResponseStateSuccess = 1, /**< 成功 */
    NeteaseResponseStateFail = 2, /**< 失败 */
    NeteaseResponseStateCancel = 3, /**< 取消 */
    NeteaseResponseStateNotInstalled = 4 /**< 应用没安装*/
} NeteaseResponseState;

/**
 *  @brief  完成回调
 *
 *  @param socialType
 *  @param responseState
 *  @param sourceShareData
 *  @param error
 *
 */
typedef  void(^SharedCompletionHandler)(SocialSNSType socialType, NeteaseResponseState responseState, NeteaseShareData *sourceShareData, NSError *error);

@class NeteaseShareView;

@interface NeteaseShareManager : NSObject

@property (nonatomic, strong) NeteaseShareView *shareView;
@property (nonatomic, copy) SharedCompletionHandler completionHandler;

#pragma mark - class method

/**
 *  @brief  单列对象
 *
 *  @return 返回一个单列对象
 */
+ (NeteaseShareManager *)sharedManager;

/**
 *  注册易信 appid 信息
 *
 *  @param appKey 易信申请的appid
 */
+ (void)setYiXinAPPKey:(NSString *)appKey;

/**
 *  注册微信appid信息
 *
 *  @param appKey 微信申请的appid
 */
+ (void)setWeChatAPPKey:(NSString *)appKey withDescription:(NSString *)desc;

/**
 *  注册新浪微博
 *
 *  @param appKey 微博申请的appid
 */
+ (void)setSinaWeiboAPPKey:(NSString *)appKey;

/**
 *  注册QQ
 *
 *  @param appId QQ申请的appid
 */
+ (void)setQQAPPId:(NSString *)appId;

/**
 *  注册美拍
 *
 *  @param appId 美拍申请的appid
 */
+ (void)setMeiPaiAPPKey:(NSString *)appKey;

/**
 *  判断易信是否安装
 */
+ (BOOL)isYiXinAppInstalled;

/**
 *  判断微信是否安装
 */
+ (BOOL)isWeChatAppInstalled;

/**
 *  判断新浪微博是否安装
 */
+ (BOOL)isSinaWeiboAppInstalled;

/**
 *  判断QQ是否安装
 */
+ (BOOL)isQQAppInstalled;

/**
 *  判断美拍是否安装
 */
+ (BOOL)isMeiPaiInstalled;

/**
 *  打开url处理
 *
 *  @param url
 *
 *  @return return value description
 */
+(BOOL)handleOpenURL:(NSURL *)url;

/**
 *  @brief  可以不用显示分享界面，直接分享数据内容，如想自定义分享界面时就可以调用此接口
 *
 *  @param shareData         分享的数据内容
 *  @param socialType        分享到的社交类型
 *  @param completionHandler 完成回调处理
 */
+ (void)shareContent:(NeteaseShareData *)shareData
        toSocialType:(SocialSNSType)socialType
   completionHandler:(SharedCompletionHandler)completionHandler;



/**
 *  @brief 全屏显示 显示分享视图，完成后回调block
 *
 *  @param fromViewController
 *  @param shareData             shareData description
 *  @param completionHandler     completionHandler description
 */
+ (void)showShareViewFrom:(UIViewController *)fromViewController
             shareContent:(NeteaseShareData *)shareData
        completionHandler:(SharedCompletionHandler)completionHandler;


/**
 *  @brief 显示在containerView 内
 *
 *  @param fromViewController
 *  @param containerView         显示容器
 *  @param shareData             分享的数据内容
 *  @param completionHandler     完成后的回调
 */
+ (void)showShareViewFrom:(UIViewController *)fromViewController
            containerView:(UIView *)containerView
             shareContent:(NeteaseShareData *)shareData
        completionHandler:(SharedCompletionHandler)completionHandler;


/**
 *  @brief  初始化社交类型
 *
 *  @param socialTypes 社交类型
 *  @param itemTitles  社交标题
 *  @param iconImages  社交图标
 *
 *  @return 初始化成功
 */
+ (BOOL)initSocialTypes:(NSArray *)socialTypes
             itemTitles:(NSArray *)itemTitles
             iconImages:(NSArray *)iconImages;

/**
 *  @brief 一次添加多个分享列表
 *
 *  @param socialTypes 社交类型数组，把枚举转化为NSNumber对象保存
 *  @param itemTitles  社交标题说明
 *  @param iconImages  社交图标
 *
 *  @return 是否添加成功
 */
+ (BOOL)addSocialTypes:(NSArray *)socialTypes
            itemTitles:(NSArray *)itemTitles
            iconImages:(NSArray *)iconImages;


/**
 *  @brief 添加一个社交类型
 *
 *  @param socialType 社交类型
 *  @param title      标题
 *  @param iconImage  图标
 *  @param highlightIconImage 点按图标，可以为空
 *
 *  @return 返回是否添加成功
 */
+ (BOOL)addSocialType:(SocialSNSType)socialType
                title:(NSString *)title
            iconImage:(UIImage *)iconImage
   highlightIconImage:(UIImage *)highlightIconImage;



#pragma mark - instance method

/**
 *  分享视图标题文本
 *
 *  @param title
 */
- (void)setShareTitle:(NSString *)title;

/**
 *  配置分享视图每一项大小, 显示之前应先配置，以便布局
 *  每一项的大小（包含图标和标题） iconHeight = itemSize.Height - titleHeight
 *  default is (80, 80), default titleLabel height is 20px, so iconSize is (60, 60)
 *  You should supply UIImage size is （60，60），if retina screen (120，120）
 *
 *  @param itemSize    项目大小
 *  @param titleHeight 标题高度
 *  @param column      显示列
 */

- (void)setShareItemSize:(CGSize)itemSize titleHeight:(CGFloat)titleHeight itemColumn:(NSUInteger)column;

/**
 *  直接分享数据，不用显示分享界面
 *
 *  @param shareData  分享数据
 *  @param socialType 社交类型
 */
- (void)shareContent:(NeteaseShareData *)shareData toSocialType:(SocialSNSType)socialType;

@end
