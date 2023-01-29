import Foundation
import UIKit
import SwiftUI

// Initialization for use in Book
struct Page {
    let image: Image
}

// Array of Page objects and identifying Title string
struct Book {
    let title: String
    var pages: [Page]

    init(title: String) {
        self.title = title
        self.pages = [Page(image: Image("HackathonBook")), Page(image: Image("hackathon1")), Page(image:Image("hackathon2")), Page(image: Image("hackathon3")), Page(image:Image("hackathon4")), Page(image: Image("hackathon5")), Page(image:Image("hackathon6"))]
    }
}
