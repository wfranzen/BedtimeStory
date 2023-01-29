import Foundation

struct Recording : Equatable {
    
    let fileURL : URL
    let createdAt : Date
    var isPlaying : Bool
    
}

struct MergedRecording {
    let fileURL: URL
    let createdAt: Date
    let updatedAt: Date
    var isPlaying: Bool? = false
    let timestampDict: [String: Int]
}

