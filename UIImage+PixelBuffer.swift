
import UIKit
import CoreVideo
import CoreML

func imageToMultiArray(image: UIImage) -> MLMultiArray? {
    guard let cgImage = image.cgImage else { return nil }

    let width = 48
    let height = 48

    guard let context = CGContext(
        data: nil,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: width,
        space: CGColorSpaceCreateDeviceGray(),
        bitmapInfo: CGImageAlphaInfo.none.rawValue
    ) else {
        return nil
    }

    context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
    guard let pixelData = context.data else { return nil }

    guard let array = try? MLMultiArray(shape: [1, 48, 48, 1], dataType: .float16) else {
        return nil
    }

    for y in 0..<height {
        for x in 0..<width {
            let pixel = pixelData.load(fromByteOffset: y * width + x, as: UInt8.self)
            let normalized = Float(pixel) / 255.0
            let float16 = Float16(normalized)
            array[[0, y, x, 0] as [NSNumber]] = NSNumber(value: Float(float16))
        }
    }

    return array
}
