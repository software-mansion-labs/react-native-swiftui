
folly_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1'

Pod::Spec.new do |s|
  s.name                 = 'ReactSwiftUI'
  s.version              = '0.0.1'
  s.summary              = 'React Native rendering engine for SwiftUI'
  s.homepage             = 'https://swmansion.com'
  s.license              = 'MIT'
  s.authors              = 'Software Mansion'
  s.platforms            = { :ios => "14.0", :tvos => "14.0", :osx => "10.15" }
  s.source               = { :git => 'https://github.com/software-mansion-labs/react-native-swiftui.git' }
  s.swift_version        = '5.2'
  s.source_files         = 'native/**/*.{m,mm,h,cpp,swift}'
  s.preserve_paths       = 'native/**/*.{m,mm,h,cpp,swift}'
  s.private_header_files = [
    'native/Surface/RSUI{Surface,SurfacePresenter}.h',
    'native/Core/RSUI{Scheduler,Conversions,MainRunLoopEventBeat,PlatformRunLoopObserver,RuntimeEventBeat}.h',
    'native/ComponentDescriptors/**',
    'native/Mounting/**'
  ]
  s.pod_target_xcconfig  = {
    'DEFINES_MODULE' => 'YES',
    'HEADER_SEARCH_PATHS' => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/Folly\" \"$(PODS_ROOT)/Headers/Private/React-Core\""
  }
    s.xcconfig               = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost-for-react-native\" \"$(PODS_ROOT)/glog\" \"$(PODS_ROOT)/Folly\"",
                               "OTHER_CFLAGS" => "$(inherited) -DRN_FABRIC_ENABLED" + " " + folly_flags }

  # s.osx.exclude_files     =  "native/Surface/**"

  s.dependency 'React-Fabric'
  # s.dependency 'React-RCTFabric'
  # s.dependency 'Folly'
end
