Pod::Spec.new do |s|
  s.name         = 'BiometricAuthKit'
  s.version      = '1.0.0'
  s.summary      = 'Small Swift SDK for biometric authentication and Keychain token storage.'
  s.homepage     = 'https://github.com/irfantotti5199/BiometricAuthKit'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Irfan Totti' => 'irfantotti77777@gmail.com' }
  s.source       = { :git => 'https://github.com/irfantotti5199/BiometricAuthKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.swift_version = '5.9'
  s.source_files = 'Sources/BiometricAuthKit/**/*.swift'
  s.frameworks   = 'LocalAuthentication', 'Security'
end
