import AVFoundation
import CoreAudio

// var player: AVAudioPlayer! = nil

func makeASound() {
    do {
        let audioFile = try AVAudioFile(
            forReading: URL(fileURLWithPath: "\(NSHomeDirectory())/Desktop/test.wav")
        )
        
        let audioEngine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()

        audioEngine.attach(playerNode)
        audioEngine.connect(
            playerNode,
            to: audioEngine.outputNode,
            format: audioFile.processingFormat
        )

        try audioEngine.start()
        playerNode.play()
        if #available(macOS 10.13, *) {
            playerNode.scheduleFile(
                audioFile,
                at: nil,
                completionCallbackType: .dataPlayedBack) { _ in
                print("ready")
            }
        } else {
            // Fallback on earlier versions
        }
        // try audioEngine.start()
        // playerNode.play()
        // playerNode.stop()
        // audioEngine.stop()
    } catch {
        print(error)
    }

    // do {
    //     player = try AVAudioPlayer(
    //         contentsOf: URL(
    //             fileURLWithPath: "\(NSHomeDirectory())/Desktop/test.wav"
    //         ),
    //         fileTypeHint: "mp3"
    //     )
    //     player.prepareToPlay()
    // } catch {
    //     print(error)
    // }
    // player.play()
}

func currentDevices() {
    // var outputDefault = CoreAudio.kAudioHardwarePropertyDefaultOutputDevice
    // kAudioHardwarePropertyDefaultInputDevice
    
    var propertyAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultOutputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMaster
    )

    var propertySize:UInt32 = 0

    // Check if propertyAddress fits into propertySize
    if AudioObjectGetPropertyDataSize(
        AudioObjectID(kAudioObjectSystemObject),
        &propertyAddress,
        0,
        nil,
        &propertySize
    ) != noErr { return }

    let numDevices = Int(propertySize) / MemoryLayout<AudioDeviceID>.size
    var deviceIDs = [AudioDeviceID](repeating: 0, count: numDevices)

    if AudioObjectGetPropertyData(
        AudioObjectID(kAudioObjectSystemObject),
        &propertyAddress,
        0,
        nil,
        &propertySize,
        &deviceIDs
    ) != noErr { return }

    var deviceAddress = AudioObjectPropertyAddress()
    var deviceNameCString = [CChar](repeating:0, count: 64)
    var manufacturerNameCString = [CChar](repeating:0, count: 64)
    

    for idx in (0..<numDevices) {
        propertySize = UInt32(MemoryLayout<CChar>.size * 64)
        deviceAddress.mSelector = kAudioDevicePropertyDeviceName
        deviceAddress.mScope = kAudioObjectPropertyScopeGlobal
        deviceAddress.mElement = kAudioObjectPropertyElementMaster

        if AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, nil, &propertySize, &deviceNameCString) == noErr {

            let deviceName = String(cString:deviceNameCString)

            propertySize = UInt32(MemoryLayout<CChar>.size * 64)
            deviceAddress.mSelector = kAudioDevicePropertyDeviceManufacturer
            deviceAddress.mScope = kAudioObjectPropertyScopeGlobal
            deviceAddress.mElement = kAudioObjectPropertyElementMaster

            if (AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, nil, &propertySize, &manufacturerNameCString) == noErr) {

                let manufacturerName = String(cString:manufacturerNameCString)

                var uidString = "" as CFString
                propertySize = UInt32(MemoryLayout.size(ofValue: uidString))

                deviceAddress.mSelector = kAudioDevicePropertyDeviceUID
                deviceAddress.mScope = kAudioObjectPropertyScopeGlobal
                deviceAddress.mElement = kAudioObjectPropertyElementMaster

                if (AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, nil, &propertySize, &uidString) == noErr) {
                    print("device \(deviceName)\nby \(manufacturerName)\nid \(uidString)\n\n")
                }

            }
        }

    }
}


func listDevices() {
    var propertyAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDevices,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMaster
    )
    var propertySize:UInt32 = 0

    if AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &propertyAddress, 0, nil, &propertySize) == noErr {

        let numDevices = Int(propertySize) / MemoryLayout<AudioDeviceID>.size

        var deviceIDs = [AudioDeviceID](repeating: 0, count: numDevices)

        if AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &propertyAddress, 0, nil, &propertySize, &deviceIDs) == noErr {

            var deviceAddress = AudioObjectPropertyAddress()
            var deviceNameCString = [CChar](repeating:0, count: 64)
            var manufacturerNameCString = [CChar](repeating:0, count: 64)

            for idx in (0..<numDevices) {
                print("\(deviceIDs[idx])\n")
                propertySize = UInt32(MemoryLayout<CChar>.size * 64)
                deviceAddress.mSelector = kAudioDevicePropertyDeviceName
                deviceAddress.mScope = kAudioObjectPropertyScopeGlobal
                deviceAddress.mElement = kAudioObjectPropertyElementMaster

                if AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, nil, &propertySize, &deviceNameCString) == noErr {

                    let deviceName = String(cString:deviceNameCString)

                    propertySize = UInt32(MemoryLayout<CChar>.size * 64)
                    deviceAddress.mSelector = kAudioDevicePropertyDeviceManufacturer
                    deviceAddress.mScope = kAudioObjectPropertyScopeGlobal
                    deviceAddress.mElement = kAudioObjectPropertyElementMaster

                    if (AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, nil, &propertySize, &manufacturerNameCString) == noErr) {

                        let manufacturerName = String(cString:manufacturerNameCString)

                        var uidString = "" as CFString
                        propertySize = UInt32(MemoryLayout.size(ofValue: uidString))

                        deviceAddress.mSelector = kAudioDevicePropertyDeviceUID
                        deviceAddress.mScope = kAudioObjectPropertyScopeGlobal
                        deviceAddress.mElement = kAudioObjectPropertyElementMaster

                        if (AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, nil, &propertySize, &uidString) == noErr) {
                            print("device \(deviceName)\nby \(manufacturerName)\nid \(uidString)\n\n")
                        }

                    }
                }

            }
        }
    }
}