
Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "Pacific"
  s.summary = "Pacific is an iOS bootstrap framework"
  s.requires_arc = true
  s.version = "1.1.3"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "[Andrew Aquino]" => "[andrew@totemv.com]" }
  s.homepage = 'http://totemv.com/drewkiino.github.io'
  s.framework = "UIKit"
  s.source = { :git => 'https://github.com/DrewKiino/Pacific.git', :tag => 'master' }
  s.source_files  = "Pacific/**/*.{swift}"

  s.dependency "Alamofire", "3.2.1"
  s.dependency "AsyncSwift"
  s.dependency "Atlantis"
  s.dependency "Pantry"
  s.dependency "Socket.IO-Client-Swift"
  s.dependency "SwiftyJSON"

end
