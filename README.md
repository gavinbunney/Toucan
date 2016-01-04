![Toucan: Fabulous Image Processing in Swift](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/toucan.png)

[![Build Status](https://travis-ci.org/gavinbunney/Toucan.svg)](https://travis-ci.org/gavinbunney/Toucan)
[![Cocoapods](https://img.shields.io/cocoapods/v/Toucan.svg?style=flat)](https://cocoapods.org/pods/Toucan)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Toucan is a Swift library that provides a clean, quick API for processing images. It greatly simplifies the production of images, supporting resizing, cropping and stylizing your images.

## Features ##

- Easy and smart resizing
- Elliptical and rounded rect masking
- Mask with custom images
- Chainable image processing stages

### Planned for 1.0 Release ###

- 100% Unit Test Coverage - once image loading in XCTests are fixed!
- Add crop options for crop location & faces
- Add enhancement filters to beautify images
- Add stylize filters
- Add rotation and flip support
- Lazy evaluation of image contexts to prevent having to create and close multiple contexts during method chaining

## Requirements ##

- Xcode 7.2
- iOS 8.0+

*As of version 0.4, Toucan only supports Swift 2. Use version 0.3.x for the latest Swift 1.2 compatible release*

## Setup ##

* Install using Cocoapods: [https://cocoapods.org/pods/Toucan](https://cocoapods.org/pods/Toucan)
* or manually include the `Toucan` framework by dragging it into your project and import the library in your code using `import Toucan`

## Toucan Usage ##

Toucan provides two methods of interaction - either through wrapping an single image within a Toucan instance, or through the static functions, providing an image for each invocation. This allows for some very flexible usage.

Create an instance wrapper for easy method chaining:

```swift
let resizedAndMaskedImage = Toucan(image: myImage).resize(CGSize(width: 100, height: 150)).maskWithEllipse().image
```

Or, using static methods when you need a single operation:

```swift
let resizedImage = Toucan.Resize.resizeImage(myImage, size: CGSize(width: 100, height: 150))
let resizedAndMaskedImage = Toucan.maskWithEllipse(resizedImage)
```

Typically, the instance version is a bit cleaner to use, and the one you want.

## Resizing ##

Resize the contained image to the specified size. Depending on what `fitMode` is supplied, the image may be clipped, cropped or scaled.

```swift
Toucan(image: myImage).resize(size: CGSize, fitMode: Toucan.Resize.FitMode)
```

### Fit Mode ###

FitMode drives the resizing process to determine what to do with an image to make it fit the given size bounds.

Example | Mode
---- | ---------
![Clip](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Resize-Clip.jpg)|**Clip Mode**<br/>`Toucan.Resize.FitMode.Clip`<br/>Resizes the image to fit within the width and height boundaries without cropping or distorting the image.<br/><br/>`Toucan(image: portraitImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Clip).image`
![Crop](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Resize-Crop.jpg)|**Crop Mode**<br/>`Toucan.Resize.FitMode.Crop`<br/>Resizes the image to fill the width and height boundaries and crops any excess image data.<br/><br/>`Toucan(image: portraitImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Crop).image`
![Scale](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Resize-Scale.jpg)|**Scale Mode**<br/>`Toucan.Resize.FitMode.Scale`<br/>Scales the image to fit the constraining dimensions exactly.<br/><br/>`Toucan(image: portraitImage).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Scale).image`


## Masking ##

Alter the original image with a mask; supports ellipse, rounded rect and image masks.

### Ellipse Mask ###

Example | Function
---- | ---------
![Ellipse Mask](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Mask-Ellipse-Circle.jpg)|Mask the given image with an ellipse. Allows specifying an additional border to draw on the clipped image. For a circle, ensure the image width and height are equal!<br/><br/>`Toucan(image: myImage).maskWithEllipse().image`
![Ellipse Mask w. Border](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Mask-Ellipse-Border.jpg)|When specifying a border width, it is draw on the clipped image.<br/><br/>`Toucan(image: myImage).maskWithEllipse(borderWidth: 10, borderColor: UIColor.yellowColor()).image`

### Path Mask ###

Example | Function
---- | ---------
![Path Mask](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Mask-Path.jpg)|Mask the given image with a path. The path will be scaled to fit the image correctly!<br/><br/>`path.moveToPoint(CGPointMake(0, 50))`<br/>`path.addLineToPoint(CGPointMake(50, 0))`<br/>`path.addLineToPoint(CGPointMake(100, 50))`<br/>`path.addLineToPoint(CGPointMake(50, 100))`<br/>`path.closePath()`<br/>`Toucan(image: myImage).maskWithPath(path: path).image`
![Path Mask w. Closure](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Mask-Path.jpg)|Mask the given image with a path provided via a closure. This allows you to construct your path relative to the bounds of the image!<br/><br/>`Toucan(image: myImage).maskWithPathClosure(path: (rect: CGRect) -> (UIBezierPath)).image`

### Rounded Rect Mask ###

Example | Function
---- | ---------
![Rounded Rect Mask](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Mask-RoundedRect.jpg)|Mask the given image with a rounded rectangle border. Allows specifying an additional border to draw on the clipped image.<br/><br/>`Toucan(image: myImage).maskWithRoundedRect(cornerRadius: 30).image`
![Rounded Rect Mask w. Border](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Mask-RoundedRect-Border.jpg)|When specifying a border width, it is draw on the clipped rounded rect.<br/><br/>`Toucan(image: myImage).maskWithRoundedRect(cornerRadius: 30, borderWidth: 10, borderColor: UIColor.purpleColor()).image`

### Image Mask ###

Example | Function
---- | ---------
![Image Mask](https://raw.githubusercontent.com/gavinbunney/Toucan/master/assets/examples/Mask-Custom.jpg)|Mask the given image with another image mask. Note that the areas in the original image that correspond to the black areas of the mask show through in the resulting image. The areas that correspond to the white areas of the mask aren’t painted. The areas that correspond to the gray areas in the mask are painted using an intermediate alpha value that’s equal to 1 minus the image mask sample value.<br/><br/>`Toucan(image: myImage).maskWithImage(maskImage: octagonMask).image`

---

## Example Images ##

Example images used under Creative Commons with thanks to:

- [David Amsler](https://www.flickr.com/photos/amslerpix/13685763725/in/photolist-mRn7Kx-mRnin2-nzyjCg-m3eSyR-nGRbHm-m5NTzH-nBs2zA-n1vE5X-oenJtQ-mp1vjZ-mp1HxX-niw2vi-mp2vTv-mPxFPE-oo51aY-onZZZx-m3ypFM-kPP6St-o7cw7M-HUV9E-bXegkJ-kcTTki-kcTRDT-e1HGVe-7FG1t5-e3jPE6-e9YgDw-c3rhzL-3evWDz-7n3iKL-e3jY8R-e3jPXz-9biMcK-5nqaP6-a1z87J-bXei17-6q25KQ-cYu7Nw-9Gsrmz-9EiTHi-5R2w7E-fFFT8i-a1z9vq-diYNrA-diYQP6-diYQHc-6q276y-cb1FqQ-d9yGhj-nb4XbV)
- [Sheila Sund](https://www.flickr.com/photos/sheila_sund/8540775223/in/photolist-mRn7Kx-mRnin2-nzyjCg-m3eSyR-nGRbHm-m5NTzH-nBs2zA-n1vE5X-oenJtQ-mp1vjZ-mp1HxX-niw2vi-mp2vTv-mPxFPE-oo51aY-onZZZx-m3ypFM-kPP6St-o7cw7M-HUV9E-bXegkJ-kcTTki-kcTRDT-e1HGVe-7FG1t5-e3jPE6-e9YgDw-c3rhzL-3evWDz-7n3iKL-e3jY8R-e3jPXz-9biMcK-5nqaP6-a1z87J-bXei17-6q25KQ-cYu7Nw-9Gsrmz-9EiTHi-5R2w7E-fFFT8i-a1z9vq-diYNrA-diYQP6-diYQHc-6q276y-cb1FqQ-d9yGhj-nb4XbV/)


## Contributing ##

1. Please fork this project
2. Implement new methods or changes in the `Toucan.swift` file.
3. Write tests in the `ToucanTests` folder.
4. Write appropriate docs and comments in the README.md
5. Submit a pull request.


## Contact ##

Raise an [Issue](https://github.com/gavinbunney/Toucan/issues) or hit me up on Twitter [@gavinbunney](https://twitter.com/gavinbunney)


## License ##

Toucan is released under an MIT license. See LICENSE for more information.
