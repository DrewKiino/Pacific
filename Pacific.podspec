Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "Pacific"
  s.summary = "Pacific iOS boostrap library'
  s.requires_arc = true
  s.version = "0.1.0"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "[Andrew Aquino]" => "[andrew@totemv.com]" }
  s.homepage = 'http://totemv.com/drewkiino.github.io'
  s.framework = "UIKit"
  s.framework = "Foundation"
  s.source = { :git => 'https://github.com/DrewKiino/Pacific.git', :tag => 'master' }
  
  s.dependency 'Alamofire', '3.2.1'
  s.dependency 'UIColor_Hex_Swift'
  s.dependency 'Atlantis'
  s.dependency 'Socket.IO-Client-Swift'
  s.dependency 'SwiftyJSON'
  s.dependency 'SwiftDate'
  s.dependency 'Neon'
  s.dependency 'AsyncSwift'
  s.dependency 'SDWebImage'
  s.dependency 'Tide'
  s.dependency 'Pantry'

  s.source_files = "Pacific/Source/*.{swift}"

end