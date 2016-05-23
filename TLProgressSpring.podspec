#
# Be sure to run `pod lib lint TLProgressSpring.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TLProgressSpring"
  s.version          = "1.0.1"
  s.summary          = "一款进度条工具类，可以在导航栏上显示，也可以弹出一个转轮显示，用户随时可交互"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"进度条提示框工具，API简单易用，可以在导航栏上显示，也可以弹出一个转轮来显示，支持点击关闭；支持显示百分比，动画效果简单优雅"
                       DESC

  s.homepage         = "https://github.com/TLOpenSpring/TLProgressSpring"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Andrew" => "anluanlu123@163.com" }
  s.source           = { :git => "https://github.com/TLOpenSpring/TLProgressSpring.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TLProgressSpring/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TLProgressSpring' => ['TLProgressSpring/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
