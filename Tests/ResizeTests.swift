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

class ResizeTests : ToucanTestCase {
    
    func testResizePortraitClipped() {
        let resized = Toucan(image: portraitImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.clip).image!
        XCTAssertEqual(resized.size.width, CGFloat(369), "Verify width clipped, so smaller than original")
        XCTAssertEqual(resized.size.height, CGFloat(500), "Verify height largest, so equal")
    }
    
    func testResizeLandscapeClipped() {
        let resized = Toucan(image: landscapeImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.clip).image!
        XCTAssertEqual(resized.size.width, CGFloat(500), "Verify width largest, so value same")
        XCTAssertEqual(resized.size.height, CGFloat(335), "Verify height smallest, so clipped lower")
    }
    
    func testResizeSquareClipped() {
        let resized = Toucan(image: maskImage).resize(CGSize(width: 350, height: 350), fitMode: Toucan.Resize.FitMode.clip).image!
        XCTAssertEqual(resized.size.width, CGFloat(350), "Verify width not changed")
        XCTAssertEqual(resized.size.height, resized.size.width, "Verify height same as width")
    }
    
    func testResizePortraitCropped() {
        let resized = Toucan(image: portraitImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.crop).image!
        XCTAssertEqual(resized.size, CGSize(width: 500, height: 500), "Verify size equal")
    }
    
    func testResizeLandscapeCropped() {
        let resized = Toucan(image: landscapeImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.crop).image!
        XCTAssertEqual(resized.size, CGSize(width: 500, height: 500), "Verify size equal")
    }
    
    func testResizeSquareCropped() {
        let resized = Toucan(image: maskImage).resize(CGSize(width: 300, height: 300), fitMode: Toucan.Resize.FitMode.crop).image!
        XCTAssertEqual(resized.size, CGSize(width: 300, height: 300), "Verify size equal")
    }
    
    func testResizePortraitScaled() {
        let resized = Toucan(image: portraitImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.scale).image!
        XCTAssertEqual(resized.size, CGSize(width: 500, height: 500), "Verify size equal")
    }
    
    func testResizeLandscapeScaled() {
        let resized = Toucan(image: landscapeImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.scale).image!
        XCTAssertEqual(resized.size, CGSize(width: 500, height: 500), "Verify size equal")
    }
    
    func testResizeSquareScaled() {
        let resized = Toucan(image: maskImage).resize(CGSize(width: 250, height: 250), fitMode: Toucan.Resize.FitMode.scale).image!
        XCTAssertEqual(resized.size, CGSize(width: 250, height: 250), "Verify size equal")
    }
    
    func testResizeInvalidSize() {
        let resized = Toucan(image: maskImage).resize(CGSize(width: 0, height: 250), fitMode: Toucan.Resize.FitMode.scale).image
        XCTAssertNil(resized)
        
        let resized2 = Toucan(image: maskImage).resize(CGSize(width: 250, height: 0), fitMode: Toucan.Resize.FitMode.scale).image
        XCTAssertNil(resized2)
    }
}
