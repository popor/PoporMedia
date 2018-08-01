#
# Be sure to run `pod lib lint PoporMedia.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'PoporMedia'
    s.version          = '0.0.4'
    s.summary          = 'Contain select image video;play video;display image'
    
    s.homepage         = 'https://github.com/popor/PoporMedia'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'popor' => '908891024@qq.com' }
    s.source           = { :git => 'https://github.com/popor/PoporMedia.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '8.0'
    
    
    s.subspec 'UIImageView' do |ss|
        ss.ios.dependency 'PoporSDWebImage'
        
        ss.source_files = 'PoporMedia/Classes/UIImageView/*.{h,m}'
    end
    
    s.subspec 'Entity' do |ss|
        ss.ios.dependency 'PoporSDWebImage'
        
        ss.source_files = 'PoporMedia/Classes/Entity/*.{h,m}'
    end
    
    s.subspec 'NSObject+PickImage' do |ss|
        ss.ios.dependency 'Masonry'
        ss.ios.dependency 'TZImagePickerController'
        ss.ios.dependency 'SKFCamera'
        
        ss.ios.dependency 'PoporUI/Tool'
        ss.ios.dependency 'PoporUI/UIView'
        ss.ios.dependency 'PoporUI/UIImage'
        ss.ios.dependency 'PoporUI/IToast'
        ss.ios.dependency 'PoporMedia/Entity'
        ss.ios.dependency 'PoporMedia/ImageDisplaySV'
        
        ss.source_files = 'PoporMedia/Classes/NSObject+PickImage/*.{h,m}'
    end
    
    s.subspec 'ImageDisplaySV' do |ss|
        ss.ios.dependency 'Masonry'
        
        ss.ios.dependency 'PoporFoundation/PrefixCore'
        
        ss.ios.dependency 'PoporUI/UIView'
        ss.ios.dependency 'PoporUI/IToast'
        ss.ios.dependency 'PoporUI/ProgressView'
        ss.ios.dependency 'PoporUI/Tool'
        
        ss.ios.dependency 'PoporMedia/Entity'
        ss.ios.dependency 'PoporMedia/UIImageView'
        
        ss.source_files = 'PoporMedia/Classes/ImageDisplaySV/*.{h,m}'
    end
    
    s.subspec 'PoporImageBrowseVC' do |ss|
        ss.ios.dependency 'Masonry'
        ss.ios.dependency 'SDWebImage'
        
        ss.ios.dependency 'PoporFoundation/PrefixCore'
        ss.ios.dependency 'PoporFoundation/NSAssistant'
        
        ss.ios.dependency 'PoporUI/UIView'
        ss.ios.dependency 'PoporUI/IToast'
        ss.ios.dependency 'PoporUI/ProgressView'
        ss.ios.dependency 'PoporUI/Tool'
        
        ss.ios.dependency 'PoporMedia/Entity'
        ss.ios.dependency 'PoporMedia/UIImageView'
        
        ss.source_files = 'PoporMedia/Classes/PoporImageBrowseVC/*.{h,m}'
    end

end
