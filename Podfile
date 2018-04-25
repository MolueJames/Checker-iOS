workspace 'MolueSafty.xcworkspace'
platform :ios, '8.0'
use_frameworks!
inhibit_all_warnings!

project 'MolueSafty/MolueSafty.xcodeproj'
project 'MolueCommon/MolueCommon.xcodeproj'
project 'MolueUtilities/MolueUtilities.xcodeproj'
project 'MolueNetwork/MolueNetwork.xcodeproj'
project 'MolueNavigator/MolueNavigator.xcodeproj'
project 'MolueFoundation/MolueFoundation.xcodeproj'
project 'MolueDatabase/MolueDatabase.xcodeproj'
project 'MolueMinePart/MolueMinePart.xcodeproj'
project 'MolueHomePart/MolueHomePart.xcodeproj'

target 'MolueSafty' do
    project 'MolueSafty/MolueSafty.xcodeproj'
        pod 'URLNavigator'
        pod 'IQKeyboardManagerSwift', '5.0.0'
        pod 'Kingfisher', '~> 4.0'
        pod 'Alamofire', '~> 4.7'
        pod 'SnapKit', '~> 4.0.0'
        pod 'SQLite.swift', '~> 0.11.4'
        pod 'Moya', '~> 11.0'
        pod 'ObjectMapper', '~> 3.1'
        pod 'JPush', '~> 3.0.9'
        pod 'AMapSearch', '~> 5.7.0'
        pod 'AMap3DMap', '~> 5.7.0'
        pod 'CryptoSwift'
end

target 'MolueCommon' do
    project 'MolueCommon/MolueCommon.xcodeproj'
end

target 'MolueUtilities' do
    project 'MolueUtilities/MolueUtilities.xcodeproj'
        pod 'CryptoSwift'
    target 'MolueUtilitiesTests' do
        inherit! :search_paths
    end
end

target 'MolueNetwork' do
    project 'MolueNetwork/MolueNetwork.xcodeproj'
        pod 'Alamofire', '~> 4.7'
        pod 'Moya', '~> 11.0'
end

target 'MolueNavigator' do
    project 'MolueNavigator/MolueNavigator.xcodeproj'
        pod 'URLNavigator'
    target 'MolueNavigatorTests' do
        inherit! :search_paths
    end
end

target 'MolueFoundation' do
    project 'MolueFoundation/MolueFoundation.xcodeproj'
end

target 'MolueDatabase' do
    project 'MolueDatabase/MolueDatabase.xcodeproj'
        pod 'SQLite.swift', '~> 0.11.4'
end

target 'MolueMinePart' do
    project 'MolueMinePart/MolueMinePart.xcodeproj'
        pod 'SnapKit', '~> 4.0.0'
        pod 'Kingfisher', '~> 4.0'
end

target 'MolueHomePart' do
    project 'MolueHomePart/MolueHomePart.xcodeproj'
        pod 'SnapKit', '~> 4.0.0'
        pod 'Kingfisher', '~> 4.0'
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
    end
    
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # Check if any deployment target is lower than 8
            versions = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].split('.').map{|s|s.to_i}
            if versions.first < 8
                # puts "Original deployment target for #{config} in #{target.name} is #{config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].inspect}"
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
                # puts "Update to #{config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].inspect}"
                # puts '---'
            end
        end
    end
end
