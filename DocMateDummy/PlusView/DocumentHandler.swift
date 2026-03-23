//
//  DocumentHandler.swift
//  DocMateDummy
//
//  Created by Naman Yadav on 24/03/26.
//

import UIKit

class DocumentHandler {

    // Camera se scanned pages (VisionKit)
    static func handleScannedPages(_ pages: [UIImage], name: String, categoryId: UUID) {
        print("📄 Scanned document saved: \(name), category: \(categoryId), pages: \(pages.count)")
        // TODO: pages ko PDF ya image array me convert karke save karo
    }

    // Gallery se selected images
    static func handleImages(_ images: [UIImage]) {
        print("🖼️ \(images.count) image(s) selected from gallery")
        // TODO: save / upload karo
    }

    // Files App se URLs
    static func handleFiles(_ urls: [URL]) {
        for url in urls {
            print("📁 File selected:", url)
        }
        // TODO: files ko process karo
    }
}
