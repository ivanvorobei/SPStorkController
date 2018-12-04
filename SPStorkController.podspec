Pod::Spec.new do |s|
  s.name          = "SPStorkController"
  s.version       = "1.1.0"
  s.summary       = "Modal controller as mail or Apple music application"
  s.homepage      = "https://github.com/IvanVorobei/SPStorkController"
  s.source        = { :git => "https://github.com/finngaida/SPStorkController.git", :tag => s.version }
  s.source_files = 'SPStorkController/Classes/**/*'
  s.license       = { :type => "MIT", :file => "LICENSE" }
  
  s.author        = { "Ivan Vorobei" => "ivanvorobei@icloud.com" }
  s.social_media_url   = "http://t.me/ivanvorobei"
  
  s.swift_version = '4.2'
  s.platform      = :ios
  s.ios.deployment_target = "10.0"
end


