workspace 'MolueSafty.xcworkspace'
platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

project 'MolueSafty/MolueSafty.xcodeproj'
project 'MolueCommon/MolueCommon.xcodeproj'
project 'MolueUtilities/MolueUtilities.xcodeproj'
project 'MolueNetwork/MolueNetwork.xcodeproj'
project 'MolueNavigator/MolueNavigator.xcodeproj'
project 'MolueFoundation/MolueFoundation.xcodeproj'
project 'MolueDatabase/MolueDatabase.xcodeproj'

def molue_safty_shared_pods
    pod 'SnapKit', '~> 4.0.0'
    pod 'Kingfisher', '~> 4.10.0'
    pod 'ViewAnimator', '~> 2.0.1'
    pod 'ImagePicker', '~> 3.0.0'
    pod 'RxSwift', '~> 4.1.2'
    pod 'ESPullToRefresh', '~> 2.7'
    pod 'ObjectMapper', '~> 3.3'
end

target 'MolueSafty' do
    project 'MolueSafty/MolueSafty.xcodeproj'
        pod 'URLNavigator', '~> 2.0.4'
        pod 'IQKeyboardManagerSwift', '~> 5.0.0'
        pod 'Alamofire', '~> 4.7'
        pod 'SQLite.swift', '~> 0.11.4'
        pod 'Locksmith', '~> 4.0.0'
        pod 'JPush', '~> 3.0.9'
        pod 'AMapSearch', '~> 5.7.0'
        pod 'AMap3DMap', '~> 5.7.0'
        pod 'CryptoSwift', '~> 0.9.0'
        pod 'Permission/Camera', '~> 2.0.4'
        pod 'Permission/Location', '~> 2.0.4'
        pod 'Permission/Notifications', '~> 2.0.4'
        pod 'NVActivityIndicatorView', '~> 4.2.0'
        pod 'JGProgressHUD', '~> 1.4'
        pod 'LeakEye', '~> 1.2.0'
        molue_safty_shared_pods
end

target 'MolueMinePart' do
    project 'MolueMinePart/MolueMinePart.xcodeproj'
        molue_safty_shared_pods
end

target 'MolueHomePart' do
    project 'MolueHomePart/MolueHomePart.xcodeproj'
        molue_safty_shared_pods
end

target 'MolueRiskPart' do
    project 'MolueRiskPart/MolueRiskPart.xcodeproj'
        molue_safty_shared_pods
end

target 'MolueBookPart' do
    project 'MolueBookPart/MolueBookPart.xcodeproj'
        molue_safty_shared_pods
end

target 'MolueLoginPart' do
    project 'MolueLoginPart/MolueLoginPart.xcodeproj'
        molue_safty_shared_pods
end

target 'MolueCommon' do
    project 'MolueCommon/MolueCommon.xcodeproj'
        pod 'CryptoSwift', '~> 0.9.0'
        molue_safty_shared_pods
    target 'MolueCommonTests' do
        inherit! :search_paths
    end
end

target 'MolueUtilities' do
    project 'MolueUtilities/MolueUtilities.xcodeproj'
        pod 'SnapKit', '~> 4.0.0'
    target 'MolueUtilitiesTests' do
        inherit! :search_paths
    end
end

target 'MolueNetwork' do
    project 'MolueNetwork/MolueNetwork.xcodeproj'
        pod 'Alamofire', '~> 4.7'
        pod 'Locksmith', '~> 4.0.0'
        pod 'ObjectMapper', '~> 3.3'
    target 'MolueNetworkTests' do
        inherit! :search_paths
    end
end

target 'MolueNavigator' do
    project 'MolueNavigator/MolueNavigator.xcodeproj'
        pod 'URLNavigator', '~> 2.0.4'
        pod 'ObjectMapper', '~> 3.3'
    target 'MolueNavigatorTests' do
        inherit! :search_paths
    end
end

target 'MolueFoundation' do
    project 'MolueFoundation/MolueFoundation.xcodeproj'
        pod 'SnapKit', '~> 4.0.0'
        pod 'JGProgressHUD', '~> 1.4'
        pod 'NVActivityIndicatorView', '~> 4.2.0'
end

target 'MolueDatabase' do
    project 'MolueDatabase/MolueDatabase.xcodeproj'
        pod 'SQLite.swift', '~> 0.11.4'
    target 'MolueDatabaseTests' do
        inherit! :search_paths
    end
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING'] = 'YES'
        config.build_settings['CLANG_WARN_NON_LITERAL_NULL_CONVERSION'] = 'YES'
        config.build_settings['CLANG_WARN_OBJC_LITERAL_CONVERSION'] = 'YES'
        config.build_settings['CLANG_WARN_COMMA'] = 'YES'
        config.build_settings['CLANG_WARN_RANGE_LOOP_ANALYSIS'] = 'YES'
        config.build_settings['CLANG_WARN_STRICT_PROTOTYPES'] = 'YES'
        config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = 'YES'
        config.build_settings['GCC_NO_COMMON_BLOCKS'] = 'YES'
        config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
    end
end
