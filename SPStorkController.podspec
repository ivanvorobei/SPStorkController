Pod::Spec.new do |s|
  s.name          = "SPStorkController"
  s.version       = "1.5.1"
  s.summary       = "Modal controller as mail or Apple music application"
  s.homepage      = "https://github.com/IvanVorobei/SPStorkController"
  s.source        = { :git => "https://github.com/IvanVorobei/SPStorkController.git", :tag => s.version }
  s.license       = { :type => "MIT", :file => "LICENSE" }
  
  s.author        = { "Ivan Vorobei" => "hello@ivanvorobei.by" }
  
  s.swift_version = '4.2'
  s.platform      = :ios
  s.ios.deployment_target = "10.0"

  s.source_files  = "Source/SPStorkController/**/*.swift"
end


