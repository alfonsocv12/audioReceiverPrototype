import Foundation
import ArgumentParser

func initState() {
    var isDir:ObjCBool = true
    let filePath = "\(NSHomeDirectory())/.audioReceiver"
    let fileName = "state.json"

    if (!FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir)) {
        do {
            try FileManager.default.createDirectory(
            atPath: filePath,
            withIntermediateDirectories: false,
            attributes: nil)
        } catch {
            print("Error while creating system state the program will not work as intendet")
        }
    }

    if (!FileManager.default.fileExists(atPath: "\(filePath)/\(fileName)")) {
        FileManager.default.createFile(
            atPath: "\(filePath)/\(fileName)", contents: nil, attributes: nil)
    }
}

struct AudioReceiver: ParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Select the action you want to execute",
        subcommands: [ListAudioDevices.self, StartStream.self]
    )

    struct ListAudioDevices: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "This Command returns the the list of current input with ids"
        )

        func run() {
            AudioDeviceFinder.findDevices()
        }
    }

    struct StartStream: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Streaming the input signal"
        )

        @Argument() var uid: String

        func run() {
            // currentDevices()
            makeASound()
            currentDevices()
        }
    }

    func run() {
        print("hello sir")
    }
}

initState()
AudioReceiver.main()