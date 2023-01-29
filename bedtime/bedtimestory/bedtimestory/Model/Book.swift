import Foundation
import UIKit
struct Page {
    let text: String
    let image: UIImage? = nil
}

struct Book {
    let title: String
    var pages: [Page]

    init(title: String) {
        self.title = title
        self.pages = [Page(text:"Test text text4iohfrbfofe n eduovbqhi0r 0gro jhior"), Page(text:"second page")]
    }
}
