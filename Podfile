# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

def shared_pods
  # Pods for NAME
  pod 'RealmSwift'
  pod 'SnapKit'
end

use_frameworks!

target 'NAME' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks

  shared_pods

  target 'NAMETests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# Based on https://github.com/CocoaPods/CocoaPods/issues/4752#issuecomment-305101269
target 'NAMEUITests' do
  inherit! :search_paths
  # Pods for testing
  shared_pods
end
