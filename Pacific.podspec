Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "Pacific"
  s.summary = "Pacific iOS boostrap library'
  s.requires_arc = true
  s.version = "0.1.5"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "[Andrew Aquino]" => "[andrew@totemv.com]" }
  s.homepage = 'http://totemv.com/drewkiino.github.io'
  s.framework = "UIKit"
  s.source = { :git => 'https://github.com/DrewKiino/Pacific.git', :tag => 'master' }
  s.dependency 'AsyncSwift'
  s.source_files = "Pacific/Source/*.{swift}"

end