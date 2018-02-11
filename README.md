## VolumeButtonHandler

## Description

A simple handler that detects the pressing of up/down buttons on iOS devices.

Features:
* Volume button presses don't affect system audio
* Works with Bluetooth remote controls
* The volume HUD is not displayed
* Works when the system volume is muted or is at the maximum or minimum

Used in [Optika - Manual RAW Camera](https://itunes.apple.com/us/app/optika-manual-raw-camera/id1337913746)

## Installation

#### CocoaPods

Add the following line to your Podfile.
````ruby
pod 'VolumeButtonHandler'
````

#### Manually

Copy the `VolumeButtonHandler.swift` file into your project.

## Usage

#### Press Handler

````swift
VolumeButtonHandler.shared.setPressHandler {

}
````

#### Delegate
````swift
VolumeButtonHandler.shared.delegate = self

extension ViewController: VolumeButtonHandlerDelegate {
    func volumeChanged() {
        
    }
}
````

##### To start/stop the handler:

````swift
VolumeButtonHandler.shared.start()
VolumeButtonHandler.shared.stop()
````

## License

VolumeButtonHandler is available under the MIT license. See the LICENSE file for more info.
