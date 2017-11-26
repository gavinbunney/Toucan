// Copyright (c) 2014-2017 Gavin Bunney
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import XCTest

class ToucanTestCase : XCTestCase {

    internal var portraitImage : UIImage {
        let imageData = try? Data(contentsOf: Bundle(for: ToucanTestCase.self).url(forResource: "Portrait", withExtension: "jpg")!)
        let image = UIImage(data: imageData!)
        XCTAssertEqual(image!.size, CGSize(width: 1593, height: 2161), "Verify portrait image size")
        return image!
    }
    
    internal var landscapeImage : UIImage {
        let imageData = try? Data(contentsOf: Bundle(for: ToucanTestCase.self).url(forResource: "Landscape", withExtension: "jpg")!)
        let image = UIImage(data: imageData!)
        XCTAssertEqual(image!.size, CGSize(width: 3872, height: 2592), "Verify landscape image size")
        return image!
    }
    
    internal var maskImage : UIImage {
        let imageData = try? Data(contentsOf: Bundle(for: ToucanTestCase.self).url(forResource: "OctagonMask", withExtension: "png")!)
        let image = UIImage(data: imageData!)
        XCTAssertEqual(image!.size, CGSize(width: 500, height: 500), "Verify mask image size")
        return image!
    }

    internal func getPixelRGBA(_ image: UIImage, point: CGPoint) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let pixelData : CFData = image.cgImage!.dataProvider!.data!
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((image.cgImage!.width * Int(point.y)) + Int(point.x)) * 4
        
        let red = CGFloat((data[pixelInfo]))
        let green = CGFloat((data[pixelInfo + 1]))
        let blue = CGFloat((data[pixelInfo + 2]))
        let alpha = CGFloat((data[pixelInfo + 3]))
        
        return (red, green, blue, alpha)
    }
}
