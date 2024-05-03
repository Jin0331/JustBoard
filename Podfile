# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'YeogiApa' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for YeogiApa
  pod 'SnapKit', '~> 5.7.0'
  pod 'Then'
  pod 'Alamofire', '~> 5.8'
  pod 'RxSwift', '6.6.0'
  pod 'RxCocoa', '6.6.0'
  pod 'TextFieldEffects'
  pod 'STTextView'
  pod 'IQKeyboardManagerSwift'
  pod 'Toast-Swift', '~> 5.1.0'
  pod 'RxViewController'
  pod 'Kingfisher', '~> 7.0'
  pod 'NVActivityIndicatorView'
  pod 'RxDataSources', '~> 5.0'
  pod 'Reusable'
  pod 'Tabman', '~> 3.2'
  pod 'SideMenu', '~> 6.0'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      end
    end
  end
end
