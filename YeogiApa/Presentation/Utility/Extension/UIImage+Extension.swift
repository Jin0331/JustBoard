//
//  UIImage+Extension.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/21/24.
//

import UIKit

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        let widthRatio  = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func compressImage( to maxSizeInMB: Double) -> UIImage? {
        // 최대 파일 크기 (바이트 단위로 변환)
        let maxSizeInBytes = Int(maxSizeInMB * 1024 * 1024)
        
        var compression: CGFloat = 1.0
        guard var imageData = self.jpegData(compressionQuality: compression) else {
            return nil
        }

        var minCompression: CGFloat = 0.0
        var maxCompression: CGFloat = 1.0
        let accuracy: CGFloat = 0.05
        
        while (maxCompression - minCompression) > accuracy {
            compression = (minCompression + maxCompression) / 2
            guard let newImageData = self.jpegData(compressionQuality: compression) else {
                return nil
            }
            
            if newImageData.count < maxSizeInBytes {
                imageData = newImageData
                minCompression = compression
            } else {
                maxCompression = compression
            }
        }
        
        // 압축된 이미지 반환
        guard let compressedImage = UIImage(data: imageData) else {
            return nil
        }
        
        return compressedImage
    }
}
