// Copyright (c) 2014-2016 Gavin Bunney, Simple Labs (http://thesimplelab.co)
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

class ResizeTests : ToucanTestCase {
    
    func testResizePortraitClipped() {
        let resized = Toucan(image: portraitImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Clip).image
        XCTAssertEqual(resized.size.width, CGFloat(500), "Verify width equal")
        XCTAssertEqual(resized.size.height, CGFloat(678), "Verify height clipped, so not equal")
    }
    
    func testResizeLandscapeClipped() {
        let resized = Toucan(image: landscapeImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Clip).image
        XCTAssertEqual(resized.size.width, CGFloat(747), "Verify width clipped, so not equal")
        XCTAssertEqual(resized.size.height, CGFloat(500), "Verify height equal")
    }
    
    func testResizePortraitCropped() {
        let resized = Toucan(image: portraitImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Crop).image
        XCTAssertEqual(resized.size, CGSize(width: 500, height: 500), "Verify size equal")
    }
    
    func testResizeLandscapeCropped() {
        let resized = Toucan(image: landscapeImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Crop).image
        XCTAssertEqual(resized.size, CGSize(width: 500, height: 500), "Verify size equal")
    }
    
    func testResizePortraitScaled() {
        let resized = Toucan(image: portraitImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Scale).image
        XCTAssertEqual(resized.size, CGSize(width: 500, height: 500), "Verify size equal")
    }
    
    func testResizeLandscapeScaled() {
        let resized = Toucan(image: landscapeImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Scale).image
        XCTAssertEqual(resized.size, CGSize(width: 500, height: 500), "Verify size equal")
    }
}
