install! 'cocoapods',
         :generate_multiple_pod_projects => true,
         :incremental_installation => true,
         :preserve_pod_file_structure => true

install! 'cocoapods', :disable_input_output_paths => true

use_frameworks!

target 'SuperShapes-macOS' do
  platform :osx, '10.15'
  pod 'Forge'
  pod 'Satin'
  pod 'Youi'
end

target 'SuperShapes-iOS' do
  platform :ios, '14.0'
  pod 'Forge'
  pod 'Satin'
  pod 'Youi'
end
