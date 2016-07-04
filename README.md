# FCShareSDK
分享视图
此仓库，基于项目分享功能，使用的时候需要初始化，而且与FZThirdPartyLoginAndShareSDK 搭配使用


AppDelegate启动程序的时候，需要初始化该视图：

1.- (void)initShareView
{

    //初始化工作---------------------begin--------------------
    
    //step 1 注册应用appID
    
    [[NeteaseShare sharedInstance] setAppkey:kWeChatAppId type:NeteaseShareWeChat];
    
    [[NeteaseShare sharedInstance] setAppkey:kWeiboAppKey type:NeteaseShareWeibo];
    
    [[NeteaseShare sharedInstance] setAppkey:kTencentAppId type:NeteaseShareQQ];
    
    //step 2 初始化UI接口
    
    [[NeteaseShare sharedInstance] initShareView];
    
}


2.以及在下面方法添加这句话
- (BOOL)handlerOpenURL:(NSURL *)url {
    
    [NeteaseShare handleOpenURL:url];
}

3.使用方法
  NeteaseShareContent *shareContent = [[NeteaseShareContent alloc] init];
    shareContent.dataType = NeteaseShareContentTypeWebpage;
    shareContent.title = self.callshareModel.share_title;
    shareContent.desc = self.callshareModel.share_content;
    shareContent.thumbnailData = UIImagePNGRepresentation(kShareImage);
    shareContent.webpageUrl = self.callshareModel.share_url;
    
    [[NeteaseShare sharedInstance] shareFromViewController:self content:shareContent fullCompletion:^(NeteaseShareSocialSNSType socialType, NeteaseShareResponseState responseState, NSString *errorMessage) {
        if (responseState == NeteaseShareResponseStateSuccess) {
            [weakSelf showHintWithText:@"分享成功"];
        } else if (responseState == NeteaseShareResponseStateNotInstalled) {
            [weakSelf showHintWithText:[NSString stringWithFormat:@"您的手机不支持分享到该APP"]];
        }
    }];
    
