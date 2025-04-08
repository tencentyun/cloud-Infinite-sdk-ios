#
# Be sure to run `pod lib lint CloudInfinite.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CloudInfinite"
  s.version          = "1.5.6"
  s.summary          = "CloudInfinite 腾讯云iOS-SDK组件"

  s.description      = <<-DESC
  数据万象sdk
                       DESC
  
  s.homepage         = "https://cloud.tencent.com/"
  s.license          = 'MIT'
  s.author           = { 'garenwang' => 'garenwang@tencent.com' }
  s.source           = { :git => 'https://github.com/tencentyun/cloud-Infinite-sdk-ios.git', :tag => s.version.to_s}
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.platform = :ios
  s.ios.deployment_target = '10.0'
  s.static_framework = true
  s.frameworks = 'UIKit','Foundation','ImageIO'
  s.libraries = 'z','c++'
#  图片链接组装模块
  s.default_subspec  = 'CloudInfinite'
  s.subspec 'CloudInfinite' do |default|
    default.source_files = 'CloudInfinite/Classes/CloudInfinite/*' ,'CloudInfinite/Classes/CloudInfinite/CITransformItem/*';
  end
  
# 图片下载模块
  s.subspec 'Loader' do |loader|
    loader.source_files = 'CloudInfinite/Classes/Loader/*';
    loader.dependency 'QCloudCore/WithoutMTA',"6.4.6";
    loader.dependency 'CloudInfinite/CloudInfinite';
  end
    
# TPG解码模块
  s.subspec 'TPG' do |tpg|
    tpg.source_files = 'CloudInfinite/Classes/TPG/*',
                       'CloudInfinite/Classes/TPG/TPGDecoder/*',
                       'CloudInfinite/Classes/TPG/TPGDecoder/include/*',
                       'CloudInfinite/Classes/Quality/*';
     tpg.vendored_libraries='CloudInfinite/Classes/TPG/TPGDecoder/*.a','CloudInfinite/Classes/Lib/*.a';
     tpg.vendored_frameworks = 'CloudInfinite/Classes/TPG/TPGDecoder/libpng.framework';
     tpg.dependency "QCloudTrack/Beacon","6.4.6";
  end
  
  s.subspec 'TPGSlim' do |tpgslim|
    tpgslim.source_files = 'CloudInfinite/Classes/TPG/*',
                       'CloudInfinite/Classes/TPG/TPGDecoder/*',
                       'CloudInfinite/Classes/TPG/TPGDecoder/include/*',
                       'CloudInfinite/Classes/Quality/*';
    tpgslim.vendored_libraries='CloudInfinite/Classes/TPG/TPGDecoder/*.a','CloudInfinite/Classes/Lib/*.a';
    tpgslim.vendored_frameworks = 'CloudInfinite/Classes/TPG/TPGDecoder/libpng.framework';
  end
  
# AVIF解码模块
  s.subspec 'AVIF' do |avif|
    
    avif.source_files = 'CloudInfinite/Classes/AVIF/*',
                       'CloudInfinite/Classes/AVIF/AVIFDecoder/*',
                       'CloudInfinite/Classes/AVIF/Lib/include/*',
                       'CloudInfinite/Classes/Quality/*';
    avif.vendored_libraries='CloudInfinite/Classes/AVIF/Lib/*.a','CloudInfinite/Classes/Lib/*.a';
    avif.dependency "QCloudTrack/Beacon","6.4.6";
  end
  
  s.subspec 'AVIFSlim' do |avifslim|
    
    avifslim.source_files = 'CloudInfinite/Classes/AVIF/*',
                       'CloudInfinite/Classes/AVIF/AVIFDecoder/*',
                       'CloudInfinite/Classes/AVIF/LibSlim/include/*',
                       'CloudInfinite/Classes/Quality/*';
    avifslim.vendored_libraries='CloudInfinite/Classes/AVIF/LibSlim/*.a';
  end
  
  
# SDWebImage 支持TPG图片加载模块
  s.subspec 'SDWebImage-CloudInfinite' do |sdtpg|
    sdtpg.source_files = 'CloudInfinite/Classes/SDWebImage-CloudInfinite/*';
    sdtpg.public_header_files = 'CloudInfinite/Classes/SDWebImage-CloudInfinite/*.h';
    sdtpg.dependency 'CloudInfinite/CloudInfinite';
    sdtpg.dependency 'SDWebImage';
    
  end

  s.subspec 'CIDownloader' do |custom|
    custom.dependency "QCloudCore/WithoutMTA";
    custom.dependency 'CloudInfinite/SDWebImage-CloudInfinite';
    custom.source_files = 'CloudInfinite/Classes/CIDownloader/*';
  end
  
  s.subspec 'CIDNS' do |tdns|
    tdns.dependency "MSDKDns_C11";
    tdns.dependency "QCloudCore/WithoutMTA";
    tdns.source_files = 'CloudInfinite/Classes/CIDNS/*';
  end
  
  s.subspec 'Quic' do |quic|
    quic.dependency 'QCloudQuic';
  end  
  
end
