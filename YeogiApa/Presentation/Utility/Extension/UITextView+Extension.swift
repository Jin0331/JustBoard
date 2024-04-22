//
//  UITextView+Extension.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/20/24.
//

import UIKit

extension UITextView {
    func alignTextVerticallyInContainer() {
        let topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        self.contentInset.top = topCorrect
        self.contentInset.left = 10
        self.contentInset.bottom = 0
    }
    
    func getNumberOfImages() -> Int {
        var imageCount = 0
        self.attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: self.attributedText.length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, attachment.image != nil {
                imageCount += 1
            }
        }
        return imageCount
    }
    
    func getImageURLs() -> [Data] {
        var imageURLs: [Data] = []
        self.attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: self.attributedText.length), options: []) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment, let image = attachment.image {
                if let imageData = image.pngData() {
                    imageURLs.append(imageData)
                }
            }
        }
        return imageURLs
    }
    
    func getImageLocations() -> [Int] {
        var imageLocations: [Int] = []
        self.attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: self.attributedText.length), options: []) { (value, range, stop) in
            if let _ = value as? NSTextAttachment {
                imageLocations.append(range.location)
            }
        }
        return imageLocations
    }
}
