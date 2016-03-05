//
//  RecordViewController.swift
//  Ho
//
//  Created by 千葉 俊輝 on 2016/03/05.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import UIKit
import EZAudio
import KYShutterButton

class RecordViewController: UIViewController, EZMicrophoneDelegate {
    @IBOutlet weak var recordButton: KYShutterButton!
    @IBOutlet weak var audioPlot: EZAudioPlot! {
        didSet {
            audioPlot.plotType = EZPlotType.Buffer
            audioPlot.shouldFill = true
            audioPlot.shouldMirror = true
        }
    }
    
    private var audioFile: EZAudioFile!
    private var mic: EZMicrophone! = {
        let _mic = EZMicrophone.sharedMicrophone()
        _mic.startFetchingAudio()
        _mic.device = EZAudioDevice.inputDevices().last as! EZAudioDevice!
        return _mic
    }()
    
    @IBAction func didPushRecordButton(sender: AnyObject) {
        switch self.recordButton.buttonState {
        case .Normal:
            self.recordButton.buttonState = .Recording
            break
        case .Recording:
            self.recordButton.buttonState = .Normal
            break
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mic.delegate = self
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            self.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
}