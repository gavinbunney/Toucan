// ToucanPlayground.playground
//
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
import Toucan

//
// Toucan Playground!
//
// Note: Due to a current limitation in Xcode7, you need to first Build the
//       Toucan.framework for a 64bit device before running this playground :)
//

let portraitImage = UIImage(named: "Portrait.jpg")
let landscapeImage = UIImage(named: "Landscape.jpg")
let octagonMask = UIImage(named: "OctagonMask.png")

// ------------------------------------------------------------
// Resizing
// ------------------------------------------------------------

// Crop will resize to fit one dimension, then crop the other
Toucan(image: portraitImage!).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Crop).image

// Clip will resize so one dimension is equal to the size, the other shrunk down to retain aspect ratio
Toucan(image: portraitImage!).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Clip).image

// Scale will resize so the image fits exactly, altering the aspect ratio
Toucan(image: portraitImage!).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Scale).image

// ------------------------------------------------------------
// Masking
// ------------------------------------------------------------

let landscapeCropped = Toucan(image: landscapeImage!).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Crop).image

// We can mask with an ellipse!
Toucan(image: landscapeImage!).maskWithEllipse().image

// Demonstrate creating a circular mask -> resizes to a square image then mask with an ellipse
Toucan(image: landscapeCropped).maskWithEllipse().image

// Mask with borders too!
Toucan(image: landscapeCropped).maskWithEllipse(borderWidth: 10, borderColor: UIColor.yellowColor()).image

// Rounded Rects are all in style
Toucan(image: landscapeCropped).maskWithRoundedRect(cornerRadius: 30).image

// And can be fancy with borders
Toucan(image: landscapeCropped).maskWithRoundedRect(cornerRadius: 30, borderWidth: 10, borderColor: UIColor.purpleColor()).image

// Masking with an custom image mask
Toucan(image: landscapeCropped).maskWithImage(maskImage: octagonMask!).image

//testing the path stuff
let path = UIBezierPath()
path.moveToPoint(CGPointMake(0, 50))
path.addLineToPoint(CGPointMake(50, 0))
path.addLineToPoint(CGPointMake(100, 50))
path.addLineToPoint(CGPointMake(50, 100))
path.closePath()
Toucan(image: landscapeCropped).maskWithPath(path: path).image

Toucan(image: landscapeCropped).maskWithPathClosure(path: {(rect) -> (UIBezierPath) in
    return UIBezierPath(roundedRect: rect, cornerRadius: 50.0)
}).image


// ------------------------------------------------------------
// Layers
// ------------------------------------------------------------

// We can draw ontop of another image
Toucan(image: portraitImage!).layerWithOverlayImage(octagonMask!, overlayFrame: CGRectMake(450, 400, 200, 200)).image


