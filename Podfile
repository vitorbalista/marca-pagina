# Uncomment the next line to define a global platform for your project
platform :ios, '15.4'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Marca-pagina' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Marca-pagina
  pod 'FirebaseCore'
  pod 'FirebaseFirestore'
  pod 'FirebaseFirestoreSwift'
  pod 'FirebaseStorage'
  pod 'Firebase/Auth'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.4'
      config.build_settings['DEVELOPMENT_TEAM'] = 'L75FD36UA6'
    end
  end
end
