//
//  VolumeButtonHandler.swift
//  VolumeButtonHandler
//
//  Created by Alex Sieroshtan on 2/11/18.
//  Copyright © 2018 Alex Sieroshtan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

public protocol VolumeButtonHandlerDelegate {
    func volumeChanged()
}

final class VolumeButtonHandler: NSObject {

    private var audioSession = AVAudioSession.sharedInstance()
    private var audioSessionContext = 0
    private var audioSessionIsRunning = false
    private var initialVolume: Float = 0.0
    private let minVolume: Float = 0.00001
    private let maxVolume: Float = 0.99999
    private var volumeView: MPVolumeView!
    private var pressHandler: (() -> ())?
    var delegate: VolumeButtonHandlerDelegate?

    private static var sharedInstance: VolumeButtonHandler = {
        return VolumeButtonHandler()
    }()

    static var shared: VolumeButtonHandler {
        return sharedInstance
    }

    override init() {
        super.init()
        
        volumeView = MPVolumeView(frame: .zero)
        volumeView.frame.origin = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
        volumeView.showsRouteButton = false

        UIApplication.shared.windows.first?.addSubview(volumeView)
    }

    deinit {
        self.stop()
        self.volumeView.removeFromSuperview()
    }

    func setPressHandler(pressHandler: @escaping () -> ()) {
        self.pressHandler = pressHandler
    }

    func start() {
        self.setupSession()
        self.perform(#selector(setupSession), with: nil, afterDelay: 1)
    }

    func stop() {
        if audioSessionIsRunning {
            self.audioSession.removeObserver(self, forKeyPath: "outputVolume")
        }
        audioSessionIsRunning = false
    }

    @objc private func setupSession() {
        if self.audioSessionIsRunning {
            return
        }
        
        self.setInitialVolume()
        
        try? audioSession.setCategory(AVAudioSessionCategoryAmbient)
        try? audioSession.setActive(true)
        
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: .new, context: &audioSessionContext)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground),
                                               name: .UIApplicationDidEnterBackground, object: nil)
        
        self.audioSessionIsRunning = true
    }

    private func setInitialVolume() {
        self.initialVolume = self.audioSession.outputVolume
        
        if self.initialVolume > maxVolume {
            self.initialVolume = maxVolume
            self.setSystemVolume(self.initialVolume)
        }
        else if self.initialVolume < minVolume {
            self.initialVolume = minVolume
            self.setSystemVolume(self.initialVolume)
        }
    }

    @objc func applicationDidBecomeActive(notification: NSNotification) {
        setInitialVolume()
        try? self.audioSession.setActive(true)
    }

    @objc func applicationDidEnterBackground(notification: NSNotification) {
        try? self.audioSession.setActive(false)
    }

    private func setSystemVolume(_ volume: Float) {
        MPMusicPlayerController.applicationMusicPlayer.setValue(volume, forKey: "volume")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &audioSessionContext {
            if keyPath == "outputVolume" {
                let newVolume = change?[.newKey] as! Float

                if [self.minVolume, self.maxVolume, self.initialVolume].contains(newVolume) {
                    return
                }
                else {
                    self.pressHandler?()
                    self.delegate?.volumeChanged()
                }

                self.setSystemVolume(self.initialVolume)
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}
