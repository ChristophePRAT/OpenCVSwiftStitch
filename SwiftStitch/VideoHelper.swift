//
//  VideoHelper.swift
//  SwiftStitch
//
//  Created by Christophe Prat on 29/03/21.
//  Copyright © 2021 ellipsis.com. All rights reserved.
//

import Foundation
import CoreGraphics
import AVKit

class VideoSplitter {
    
    init(urlVideo: URL) {
        self.videoUrl = urlVideo
    }
    var videoUrl:URL // use your own url
    var frames: [UIImage] = []
    private var generator:AVAssetImageGenerator!
    
    func getAllFrames() {
        let asset:AVAsset = AVAsset(url:self.videoUrl)
        let duration:Float64 = CMTimeGetSeconds(asset.duration)
        self.generator = AVAssetImageGenerator(asset:asset)
        self.generator.appliesPreferredTrackTransform = true
        self.frames = []
        for index:Int in 0 ..< Int(duration) {
            self.getFrame(fromTime:Float64(index))
        }
        self.generator = nil
    }
    
    private func getFrame(fromTime:Float64) {
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale:600)
        let image:CGImage
        do {
            try image = self.generator.copyCGImage(at:time, actualTime:nil)
        } catch {
            return
        }
        self.frames.append(UIImage(cgImage:image))
    }
    
//    var videoUrl: URL // use your own url
//
//
//    var frames:[UIImage] = []
//
//    func getAllFrames() -> Array<UIImage> {
//        let asset:AVAsset = AVAsset(url:self.videoUrl)
//        let duration:Float64 = CMTimeGetSeconds(asset.duration)
//        self.generator = AVAssetImageGenerator(asset:asset)
//        self.generator.appliesPreferredTrackTransform = true
//        var localFrames: Array<UIImage> = []
//        for index:Int in 0 ..< Int(duration) {
//            guard let frameToAdd = getFrame(fromTime:Float64(index)) else { continue }
//            localFrames.append(frameToAdd)
//        }
//        self.generator = nil
//        return localFrames
//    }
//
//    func getFrames(every seconds: Int) -> [UIImage] {
//        let asset:AVAsset = AVAsset(url:self.videoUrl)
//        let duration:Float64 = CMTimeGetSeconds(asset.duration)
//        self.generator = AVAssetImageGenerator(asset:asset)
//        self.generator.appliesPreferredTrackTransform = true
//        var localFrames: Array<UIImage> = []
//
//        let period = duration / Double(seconds)
//        for index in 0 ..< Int(period) {
//            print(index * seconds)
//            guard let imageToAdd = self.getFrame(fromTime:Float64(Double(index) * period)) else { continue }
//            localFrames.append(imageToAdd)
//        }
//        self.generator = nil
//        return localFrames
//    }
//    func imageFromVideo(at time: TimeInterval, completion: @escaping (UIImage?) -> Void) {
//        let asset = AVURLAsset(url: self.videoUrl)
//
//        let assetIG = AVAssetImageGenerator(asset: asset)
//        assetIG.appliesPreferredTrackTransform = true
//        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
//
//        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
//        let thumbnailImageRef: CGImage
//        do {
//            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
//        } catch let error {
//            fatalError("Error: \(error.localizedDescription)")
//            //                return completion(nil)
//        }
//
//        DispatchQueue.main.async {
//            let imageToCompletion = UIImage(cgImage: thumbnailImageRef)
//            completion(imageToCompletion)
//        }
//    }
//    func imagesForVideo(_ numberOfImages: Int) -> [UIImage] {
//        let asset = AVURLAsset(url: videoUrl)
//
//        let totalTimeLength = Int(asset.duration.seconds * Double(asset.duration.timescale))
//        let step = totalTimeLength / numberOfImages
//
//        var imagesToReturn: Array<UIImage> = []
//
//
//        for i in 0..<numberOfImages {
//            imageFromVideo(at: TimeInterval(i * step)) { image in
//                if let img = image {
//                    imagesToReturn.append(img)
//                }
//            }
//        }
//        return imagesToReturn
//    }
//    //    func getFrame(fromTime:Float64) -> UIImage? {
//    //        let time:CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale:600)
//    //        let image:CGImage
//    //        let asset = AVAsset(url:self.videoURL)
//    //        let generator = AVAssetImageGenerator(asset:asset)
//    //
//    //        generator.appliesPreferredTrackTransform = true
//    //
//    //        do {
//    //            try image = generator.copyCGImage(at:time, actualTime: nil)
//    //        } catch {
//    //            fatalError(error.localizedDescription)
//    //        }
//    //        return UIImage(cgImage:image)
//    //    }
//    func getManyFrames() -> [UIImage] {
//        let asset = AVAsset(url:self.videoUrl)
//        let generator = AVAssetImageGenerator(asset:asset)
//        generator.requestedTimeToleranceAfter = CMTime.zero
//        generator.requestedTimeToleranceBefore = CMTime.zero
//
//        let videoDuration = asset.duration
//        var frameForTimes = [CMTime]()
//        let sampleCounts = 20
//        let totalTimeLength = Int(videoDuration.seconds * Double(videoDuration.timescale))
//        let step = totalTimeLength / sampleCounts
//
//        for i in 0 ..< sampleCounts {
//            let cmTime = CMTimeMake(value: Int64(i * step), timescale: Int32(videoDuration.timescale))
//            frameForTimes.append(cmTime)
//            //            frameForTimes.append(NSValue(time: cmTime))
//
//        }
//        var localFrames: [UIImage] = []
//        frameForTimes.forEach { timeI in
//            localFrames.append(extractFrame(at: timeI))
//        }
//        return localFrames
//    }
//    func extractFrame(at frameTime: CMTime) -> UIImage {
//        let video = videoUrl
//
//        print (video)     //used for debugging
//
//        let videoImage = AVAsset(url: video)
//
//        let generator: AVAssetImageGenerator = AVAssetImageGenerator.init(asset: videoImage)
//        generator.requestedTimeToleranceAfter = CMTime.zero
//        generator.requestedTimeToleranceBefore = CMTime.zero
//
//        var time = videoImage.duration
//
//        time.value = 0
//
//        let framePhoto = try! generator.copyCGImage(at: time, actualTime: nil)
//
//        let frameFirstPhoto = UIImage(cgImage: framePhoto)
//
//        return frameFirstPhoto    //firstFrame is UIImage in table cell
//    }
}


import UIKit
import AVFoundation

class GIF2MP4 {
    private(set) var gif: GIF
    private var outputURL: URL!
    private(set) var videoWriter: AVAssetWriter!
    private(set) var videoWriterInput: AVAssetWriterInput!
    private(set) var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor!
    var videoSize: CGSize {
        //The size of the video must be a multiple of 16
        return CGSize(width: max(1, floor(gif.size.width / 16)) * 16, height: max(1, floor(gif.size.height / 16)) * 16)
    }
    init?(data: Data) {
        guard let gif = GIF(data: data) else { return nil }
        self.gif = gif
    }
    private func prepare() {
        try? FileManager.default.removeItem(at: outputURL)
        let avOutputSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: NSNumber(value: Float(videoSize.width)),
            AVVideoHeightKey: NSNumber(value: Float(videoSize.height))
        ]
        let sourcePixelBufferAttributesDictionary = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: NSNumber(value: Float(videoSize.width)),
            kCVPixelBufferHeightKey as String: NSNumber(value: Float(videoSize.height))
        ]
        videoWriter = try! AVAssetWriter(outputURL: outputURL, fileType: AVFileType.mp4)
        videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: avOutputSettings)
        videoWriter.add(videoWriterInput)
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: CMTime.zero)
    }
    func convertAndExport(to url: URL, completion: @escaping () -> Void ) {
        outputURL = url
        prepare()
        var index = 0
        var delay = 0.0 - gif.frameDurations[0]
        let queue = DispatchQueue(label: "mediaInputQueue")
        videoWriterInput.requestMediaDataWhenReady(on: queue) {
            var isFinished = true
            while index < self.gif.frames.count {
                if self.videoWriterInput.isReadyForMoreMediaData == false {
                    isFinished = false
                    break
                }
                if let cgImage = self.gif.getFrame(at: index) {
                    let frameDuration = self.gif.frameDurations[index]
                    delay += Double(frameDuration)
                    let presentationTime = CMTime(seconds: delay, preferredTimescale: 600)
                    let result = self.addImage(image: UIImage(cgImage: cgImage), withPresentationTime: presentationTime)
                    if result == false {
                        fatalError("addImage() failed")
                    } else {
                        index += 1
                    }
                }
            }
            if isFinished {
                self.videoWriterInput.markAsFinished()
                self.videoWriter.finishWriting {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            } else {
                // Fall through. The closure will be called again when the writer is ready.
            }
        }
    }
    private func addImage(image: UIImage, withPresentationTime presentationTime: CMTime) -> Bool {
        guard let pixelBufferPool = pixelBufferAdaptor.pixelBufferPool else {
            print("pixelBufferPool is nil ")
            return false
        }
        let pixelBuffer = pixelBufferFromImage(image: image, pixelBufferPool: pixelBufferPool, size: videoSize)
        return pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
    }
    private func pixelBufferFromImage(image: UIImage, pixelBufferPool: CVPixelBufferPool, size: CGSize) -> CVPixelBuffer {
        var pixelBufferOut: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pixelBufferOut)
        if status != kCVReturnSuccess {
            fatalError("CVPixelBufferPoolCreatePixelBuffer() failed")
        }
        let pixelBuffer = pixelBufferOut!
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: data, width: Int(size.width), height: Int(size.height),
                                bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)!
        context.clear(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let horizontalRatio = size.width / image.size.width
        let verticalRatio = size.height / image.size.height
        let aspectRatio = max(horizontalRatio, verticalRatio) // ScaleAspectFill
        //let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit
        let newSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)
        let x = newSize.width < size.width ? (size.width - newSize.width) / 2: -(newSize.width-size.width)/2
        let y = newSize.height < size.height ? (size.height - newSize.height) / 2: -(newSize.height-size.height)/2
        context.draw(image.cgImage!, in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        return pixelBuffer
    }
}
import ImageIO
import MobileCoreServices
class GIF {
    private let frameDelayThreshold = 0.02
    private(set) var duration = 0.0
    private(set) var imageSource: CGImageSource!
    private(set) var frames: [CGImage?]!
    private(set) lazy var frameDurations = [TimeInterval]()
    var size: CGSize {
        guard let f = frames.first, let cgImage = f else { return .zero }
        return CGSize(width: cgImage.width, height: cgImage.height)
    }
    private lazy var getFrameQueue: DispatchQueue = DispatchQueue(label: "gif.frame.queue", qos: .userInteractive)
    init?(data: Data) {
        guard let imgSource = CGImageSourceCreateWithData(data as CFData, nil), let imgType = CGImageSourceGetType(imgSource), UTTypeConformsTo(imgType, kUTTypeGIF) else {
            return nil
        }
        self.imageSource = imgSource
        let imgCount = CGImageSourceGetCount(imageSource)
        frames = [CGImage?](repeating: nil, count: imgCount)
        for i in 0..<imgCount {
            let delay = getGIFFrameDuration(imgSource: imageSource, index: i)
            frameDurations.append(delay)
            duration += delay
            getFrameQueue.async { [unowned self] in
                self.frames[i] = CGImageSourceCreateImageAtIndex(self.imageSource, i, nil)
            }
        }
    }
    func getFrame(at index: Int) -> CGImage? {
        if index >= CGImageSourceGetCount(imageSource) {
            return nil
        }
        if let frame = frames[index] {
            return frame
        } else {
            let frame = CGImageSourceCreateImageAtIndex(imageSource, index, nil)
            frames[index] = frame
            return frame
        }
    }
    private func getGIFFrameDuration(imgSource: CGImageSource, index: Int) -> TimeInterval {
        guard let frameProperties = CGImageSourceCopyPropertiesAtIndex(imgSource, index, nil) as? [String: Any],
              let gifProperties = frameProperties[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
              let unclampedDelay = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval
        else { return 0.02 }
        var frameDuration = TimeInterval(0)
        if unclampedDelay < 0 {
            frameDuration = gifProperties[kCGImagePropertyGIFDelayTime] as? TimeInterval ?? 0.0
        } else {
            frameDuration = unclampedDelay
        }
        /* Implement as Browsers do: Supports frame delays as low as 0.02 s, with anything below that being rounded up to 0.10 s.
         http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility */
        if frameDuration < frameDelayThreshold - Double.ulpOfOne {
            frameDuration = 0.1
        }
        return frameDuration
    }
}
