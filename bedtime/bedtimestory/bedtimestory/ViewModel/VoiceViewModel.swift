import Foundation
import AVFoundation

class VoiceViewModel : NSObject, ObservableObject , AVAudioPlayerDelegate{
    let fileManager = FileManager.default
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var bookID:Int = 1  // Only used for creating file name
    //var indexOfPlayer = 0       Unused
    //var pageNum = 1       Unused
    //var timestamps = {}       No use in minimal product
    @Published var isRecording : Bool = false
    
    @Published var recordingsList = [Recording]()
    
    @Published var countSec = 0
    @Published var timerCount : Timer?
    @Published var blinkingCount : Timer?
    @Published var timer : String = "0:00"
    @Published var toggleColor : Bool = false
    
    
    var playingURL : URL?

    convenience init(bookid:Int) {
        self.init()
        self.bookID = 1
    }
    override init(){
        super.init()
        fetchAllRecording()
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == playingURL {
                recordingsList[i].isPlaying = false
            }
        }
    }

    func startRecording() {
        
        // Attempt to begin recording, otherwise throw error
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryPath = path.appendingPathComponent("\(self.bookID)")
        let directoryPathStr:String = directoryPath.absoluteString
        if !fileManager.fileExists(atPath: directoryPathStr) {
            try? FileManager.default.createDirectory(atPath: directoryPathStr, withIntermediateDirectories: true, attributes: nil)
        }
        // Saving recording naming conventions and path location
        let fileName = directoryPath.appendingPathComponent("Rec:\(Date().toString(dateFormat: "dd-MM-YY 'at' HH:mm:ss")).m4a")
        
        
        // Audio playback settings
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
            
            timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (value) in
                self.countSec += 1
                self.timer = self.convertSecToMinAndHour(seconds: self.countSec)
            })
            blinkColor()
            
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    
    func stopRecording(){
        
        audioRecorder.stop()
        
        isRecording = false
        
        self.countSec = 0
        
        timerCount!.invalidate()
        blinkingCount!.invalidate()
        // To be fixed: This should be in a nextRecording() func w stopRecording() optionally deleting recording to restart page reading
        
    }
    
    // ???
    func fetchRecording(title: String) {
        
    }
    
    // Present the user with a list of all saved recordings, ordered with oldest at top
    func fetchAllRecording(){
        
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        path =  path.appendingPathComponent("\(self.bookID)")
        let directoryPathStr:String = path.absoluteString
        if !fileManager.fileExists(atPath: directoryPathStr) {
            try? FileManager.default.createDirectory(atPath: directoryPathStr, withIntermediateDirectories: true, attributes: nil)
        }
        print(path)
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        print(directoryContents)
        for i in directoryContents {
            recordingsList.append(Recording(fileURL : i, createdAt:getFileDate(for: i), isPlaying: false))
        }
        
        recordingsList.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        
    }
    
    // Play the audio from a saved recording
    func startPlaying(url : URL) {
        
        playingURL = url
        
        let playSession = AVAudioSession.sharedInstance()
        
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            for i in 0..<recordingsList.count {
                if recordingsList[i].fileURL == url {
                    recordingsList[i].isPlaying = true
                }
            }
            
        } catch {
            print("Playing Failed")
        }
        
        
    }
    
    // Pause the playback from a saved recording
    func pausePlaying(url: URL) {
        audioPlayer.pause()
        
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == url {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    // Stop the playback from a saved recording
    func stopPlaying(url : URL) {
        
        audioPlayer.stop()
        
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == url {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    // Delete a saved recording
    func deleteRecording(url : URL) {
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Can't delete")
        }
        
        for i in 0..<recordingsList.count {
            
            if recordingsList[i].fileURL == url {
                if recordingsList[i].isPlaying == true{
                    stopPlaying(url: recordingsList[i].fileURL)
                }
                recordingsList.remove(at: i)
                
                break
            }
        }
    }
    
    // Visualization for use during live recording
    func blinkColor() {
        
        blinkingCount = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (value) in
            self.toggleColor.toggle()
        })
        
    }
    
    // ???
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    
    
}
