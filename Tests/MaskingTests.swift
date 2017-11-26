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
import Toucan

class MaskingTests : ToucanTestCase {

    func testMaskWithEllipse() {
        let masked = Toucan(image: landscapeImage).maskWithEllipse().image!
        
        let cornerRGBA = getPixelRGBA(masked, point: CGPoint(x: 0, y: 0))
        XCTAssertEqual(cornerRGBA.alpha, 0.0 as CGFloat, "Check corner is transparent")
        
        let centerRGBA = getPixelRGBA(masked, point: CGPoint(x: masked.size.width / 2, y: masked.size.height / 2))
        XCTAssertEqual(centerRGBA.alpha, 255.0 as CGFloat, "Check center is not transparent")
    }
    
    func testMaskWithPath() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 50))
        path.addLine(to: CGPoint(x: 50, y: 0))
        path.addLine(to: CGPoint(x: 100, y: 50))
        path.addLine(to: CGPoint(x: 50, y: 100))
        path.close()
        let masked2 = Toucan(image: landscapeImage).resize(CGSize(width: 300, height: 250), fitMode: Toucan.Resize.FitMode.scale).maskWithPath(path: path).image!
        
        let cornerRGBA = getPixelRGBA(masked2, point: CGPoint(x: 0, y: 0))
        XCTAssertEqual(cornerRGBA.alpha, 0.0 as CGFloat, "Check corner is transparent")
    }
}
