Pod::Spec.new do |s|
  s.name         = "GHCalendar"
  s.version      = "1.0.5"
  s.summary      = "Calendar Swift UI, supports range and multiple selection"
  s.homepage     = "https://github.com/cyber-gh/GHCalendar"
  s.source       = { :git => "https://github.com/cyber-gh/GHCalendar.git", :tag => s.version }
  s.license      = 'Apache'
  s.author       = { "cyber-gh" => "soltangh.work@gmail.com" }
  s.source_files  = "Sources/**/*.swift"
  s.ios.deployment_target  = '13.0'
  s.osx.deployment_target  = '10.15'
  s.swift_version = '5.0'
end
