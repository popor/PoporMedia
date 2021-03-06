#
# Be sure to run `pod lib lint PoporMedia.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name     = 'PoporMedia'
    s.version  = '1.05'
    s.summary  = 'Contain select image video;play video;display image'
    
    s.homepage = 'https://github.com/popor/PoporMedia'
    s.license  = { :type => 'MIT', :file => 'LICENSE' }
    s.author   = { 'popor' => '908891024@qq.com' }
    s.source   = { :git => 'https://github.com/popor/PoporMedia.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    
    s.subspec 'PoporMedia' do |ss|
        ss.source_files = 'PoporMedia/Classes/*.{h,m}'
        ss.resource     = 'PoporMedia/Classes/PoporMedia.bundle'
        
        ss.ios.dependency 'Masonry'
        ss.ios.dependency 'TZImagePickerController'
        ss.ios.dependency 'SKFCamera'
        
        ss.ios.dependency 'PoporFoundation/NSFileManager'
        ss.ios.dependency 'PoporFoundation/Prefix'
        
        ss.ios.dependency 'PoporUI/UIView'
        ss.ios.dependency 'PoporUI/UIImage'
        ss.ios.dependency 'PoporUI/IToast'
        ss.ios.dependency 'PoporUI/UIDevice'
        
        ss.ios.dependency 'PoporImageBrower'
        #ss.ios.dependency 'PEPhotoCropEditor'
        
        ss.ios.dependency 'ReactiveObjC' #为了Block安全, 其实在PoporAVPlayer已经包含了
        
    end

end
