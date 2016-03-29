Pod::Spec.new do |s|

  s.name         = "FCShareSDK"
  s.version      = "0.1"
  s.summary      = "FCShareSDK"

  s.description  = <<-DESC
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "git@114.215.169.104:/alidata/gitwork/FCShareSDK.git"
  
  s.license          = 'MIT'              #开源协议
  s.source           = { :git => "git@114.215.169.104:/alidata/gitwork/FCShareSDK.git",:branch => "master"}      #项目地址，这里不支持ssh的地址，验证不通过，只支持HTTP和HTTPS，最好使用HTTPS


  s.author             = { "Patty" => "yu916700yupp@163.com" }

  s.platform     = :ios, "6.0"
  s.dependency 'FZThirdPartyLoginAndShareSDK'

  s.source_files  = "**/*.{h,m}"
  s.resources = ["**/*.{jpg,json,plist,cer,xib}","NeteaseShare.bundle"]

  s.requires_arc = true

#   s.prefix_header_contents = '#import "test.h"'
#   s.xcconfig     = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/UserTrack" "$(PODS_ROOT)/SecurityGuardSDK" "$(PODS_ROOT)/TBHotpatchSDK"' }
end
