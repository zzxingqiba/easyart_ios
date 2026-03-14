# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'easyart' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for easyart
  pod 'Moya/RxSwift'
  pod 'MMKV'
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'HDHUD', '3.1.0'
  pod 'ObjectMapper'
  pod 'Kingfisher'
  pod 'DDUtils', '~> 5'
  pod 'DDUtils/idfa'
  pod 'SwiftyJSON'
  pod 'BSText'
  pod 'KakaJSON'
  pod 'MJRefresh'
  pod 'IQKeyboardManagerSwift'
  pod 'DDKitSwift', '4.0.3'
  pod 'DDKitSwift_Netfox', '~> 4'
  pod 'DDKitSwift_FPS', '~> 4'
  pod 'DDKitSwift_Ping', '~> 4'
  pod 'DDKitSwift_FileBrowser', '~> 4'
  pod 'DDKitSwift_UserDefaultManager', '~> 4'
  pod 'GoogleSignIn'
  pod "ESTabBarController-swift"
  pod 'StripePaymentSheet'
  pod 'ZLPhotoBrowser'
  pod 'Lightbox'
  pod 'FSPagerView', :git => 'https://github.com/WenchaoD/FSPagerView.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
    end
  end
end
