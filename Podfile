# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
def shared_pods
pod 'Alamofire', '~>  5.0.0-rc.2'
pod 'IQKeyboardManagerSwift'
pod 'ReachabilitySwift'
pod 'Firebase/Analytics'
pod 'Firebase/Messaging'
pod 'FirebaseCore'
pod 'Firebase/Crashlytics'
pod 'Firebase/RemoteConfig'
pod 'EmptyDataSet-Swift', '~> 5.0.0'
pod 'TweeTextField'
pod 'PanModal'
pod "SkeletonView"
end

target 'ExpensesApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  shared_pods
end
target 'ExpensesAppTarget' do
  # Comment the next line if you don't want to use dynamic frameworks
  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end