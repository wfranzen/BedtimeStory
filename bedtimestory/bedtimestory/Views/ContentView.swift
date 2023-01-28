import SwiftUI
import AVFoundation

struct RecordingView: View {
    @State private var audioRecorder: AVAudioRecorder?
    @State private var isRecording = false
    @State private var text: String = ""
    @State private var user: User?

    var body: some View {
        VStack {
            TextField("Enter text here", text: $text)
                .padding()
                .frame(height: 40)
                .border(Color.black, width: 2)

            HStack {
                Button(action: {
                       if self.isRecording {
                           try? self.audioRecorder?.stop()
                           self.audioRecorder = nil
                       } else {
                           let recordingSession = AVAudioSession.sharedInstance()
                           try? recordingSession.setCategory(.playAndRecord, mode: .default)
                           try? recordingSession.setActive(true)
                           let settings = [
                               AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                               AVSampleRateKey: 12000,
                               AVNumberOfChannelsKey: 1,
                               AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                           ]
                           let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a");
                           self.audioRecorder = try? AVAudioRecorder(url: audioFilename, settings: settings);
                           self.audioRecorder?.delegate = self;
                           self.audioRecorder?.record();
                           try? self.isRecording.toggle();
                       }
                   }) {
                       Text(self.isRecording ? "Stop Recording" : "Start Recording");
                   }) {
                    Image(systemName: isRecording ? "stop.circle" : "circle")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(isRecording ? .red : .green)
                }
                .padding()
                .border(Color.black, width: 2)
            }
        }
    }
}

extension RecordingView: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // Save the recording and the text to the user's account
            user?.addRecording(audioURL: recorder.url, text: text)
        }
    }
}
