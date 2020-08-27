
Pod::Spec.new do |s|
  s.name                 = 'ReactSwiftUI'
  s.version              = '0.1'
  s.summary              = 'React Native rendering engine for SwiftUI'
  s.homepage             = 'https://swmansion.com'
  s.license              = 'MIT'
  s.authors              = 'Software Mansion'
  s.platform             = :ios, '13.0'
  s.source               = { :git => 'https://github.com/software-mansion-labs/react-native-swiftui.git' }
  s.swift_version        = '5.2'
  s.source_files         = 'swiftui/**/*.{m,mm,cpp,h,swift}'
  s.pod_target_xcconfig  = { 'DEFINES_MODULE' => 'YES', 'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/ReactCommon"' }

  s.dependency 'React-Fabric'
end
