#
#  Be sure to run `pod spec lint MyPodDemo.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "LLLaunchAd"
  s.version      = "1.0.0"
  s.summary      = "A iOS LaunchAd show of MyPodDemo."
  s.homepage     = "https://github.com/LeeFengHY/MyPodDemo"
  s.license      = "MIT"
  s.author             = { "LeeFengHY" => "578545715@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/LeeFengHY/MyPodDemo.git", :tag => "1.0.0" }
  s.source_files  = "LLLaunchAd/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
