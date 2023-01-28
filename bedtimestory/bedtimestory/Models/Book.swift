//
//  Book.swift
//  bedtimestory
//
//  Created by Tarun  on 1/28/23.
//

import Foundation
import UIKit
struct Page {
    let text: String
    let image: UIImage?
}

struct Book {
    let title: String
    var pages: [Page]

    init(title: String) {
        self.title = title
        self.pages = []
    }
}
