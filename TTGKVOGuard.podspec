Pod::Spec.new do |s|
s.name             = 'TTGKVOGuard'
s.version          = '0.1.0'
s.summary          = 'Auto remove KVO observer from object after it dealloc.'

s.description      = <<-DESC
Auto remove KVO observer from object after it dealloc, base on TTGDeallocTaskHelper.
DESC

s.homepage         = 'https://github.com/zekunyan/TTGKVOGuard'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'zekunyan' => 'zekunyan@163.com' }
s.source           = { :git => 'https://github.com/zekunyan/TTGKVOGuard.git', :tag => s.version.to_s }
s.social_media_url = 'http://tutuge.me'

s.ios.deployment_target = '6.0'
s.platform = :ios, '6.0'
s.requires_arc = true

s.source_files = 'TTGKVOGuard/Classes/**'
s.public_header_files = 'TTGKVOGuard/Classes/*.h'

s.frameworks = 'UIKit', 'CoreFoundation'
s.dependency 'TTGDeallocTaskHelper'
end