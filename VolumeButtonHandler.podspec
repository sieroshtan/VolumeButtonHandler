Pod::Spec.new do |s|
  s.name         = "VolumeButtonHandler"
  s.version      = "0.1.0"
  s.summary      = "A simple handler that detects the pressing of up/down buttons on iOS devices. Also works well with Bluetooth remote controls."
  s.description      = <<-DESC
A simple handler that detects the pressing of up/down buttons on iOS devices.
Features:
* Volume button presses don't affect system audio
* Works with Bluetooth remote controls
* The volume HUD is not displayed
* Works when the system volume is muted or is at the maximum or minimum
                       DESC
  s.homepage     = "https://github.com/sieroshtan/VolumeButtonHandler"
  s.license      = { :type => "MIT" }
  s.author       = { "Alex Sieroshtan" => "alexseroshtan@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/sieroshtan/VolumeButtonHandler.git", :tag => s.version.to_s }
  s.source_files = "Classes", "VolumeButtonHandler.{swift}"
  s.requires_arc = true
  s.swift_version = "4"
end
