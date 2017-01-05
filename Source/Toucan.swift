// Toucan.swift
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
import CoreGraphics

/**
 Toucan - Fabulous Image Processing in Swift.
 
 The Toucan class provides two methods of interaction - either through an instance, wrapping an single image,
 or through the static functions, providing an image for each invocation.
 
 This allows for some flexible usage. Using static methods when you need a single operation:
 let resizedImage = Toucan.resize(myImage, size: CGSize(width: 100, height: 150))
 
 Or create an instance for easy method chaining:
 let resizedAndMaskedImage = Toucan(withImage: myImage).resize(CGSize(width: 100, height: 150)).maskWithEllipse().image
 */
public class Toucan : NSObject {
    
    public var image : UIImage
    
    public init(image withImage: UIImage) {
        self.image = withImage
    }
    
    // MARK: - Resize
    
    /**
     Resize the contained image to the specified size. Depending on what fitMode is supplied, the image
     may be clipped, cropped or scaled. @see documentation on FitMode.
     
     The current image on this toucan instance is replaced with the resized image.
     
     - parameter size:    Size to resize the image to
     - parameter fitMode: How to handle the image resizing process
     
     - returns: Self, allowing method chaining
     */
    public func resize(_ size: CGSize, fitMode: Toucan.Resize.FitMode = .clip) -> Toucan {
        self.image = Toucan.Resize.resizeImage(self.image, size: size, fitMode: fitMode)
        return self
    }
    
    /**
     Resize the contained image to the specified size by resizing the image to fit
     within the width and height boundaries without cropping or scaling the image.
     
     The current image on this toucan instance is replaced with the resized image.
     
     - parameter size:    Size to resize the image to
     
     - returns: Self, allowing method chaining
     */
    @objc
    public func resizeByClipping(_ size: CGSize) -> Toucan {
        self.image = Toucan.Resize.resizeImage(self.image, size: size, fitMode: .clip)
        return self
    }
    
    /**
     Resize the contained image to the specified size by resizing the image to fill the
     width and height boundaries and crops any excess image data.
     The resulting image will match the width and height constraints without scaling the image.
     
     The current image on this toucan instance is replaced with the resized image.
     
     - parameter size:    Size to resize the image to
     
     - returns: Self, allowing method chaining
     */
    @objc
    public func resizeByCropping(_ size: CGSize) -> Toucan {
        self.image = Toucan.Resize.resizeImage(self.image, size: size, fitMode: .crop)
        return self
    }
    
    /**
     Resize the contained image to the specified size by scaling the image to fit the
     constraining dimensions exactly.
     
     The current image on this toucan instance is replaced with the resized image.
     
     - parameter size:    Size to resize the image to
     
     - returns: Self, allowing method chaining
     */
    @objc
    public func resizeByScaling(_ size: CGSize) -> Toucan {
        self.image = Toucan.Resize.resizeImage(self.image, size: size, fitMode: .scale)
        return self
    }
    
    /**
     Container struct for all things Resize related
     */
    public struct Resize {
        
        /**
         FitMode drives the resizing process to determine what to do with an image to
         make it fit the given size bounds.
         
         - Clip:  Resizes the image to fit within the width and height boundaries without cropping or scaling the image.
         
         - Crop:  Resizes the image to fill the width and height boundaries and crops any excess image data.
         
         - Scale: Scales the image to fit the constraining dimensions exactly.
         */
        public enum FitMode {
            /**
             Resizes the image to fit within the width and height boundaries without cropping or scaling the image.
             The resulting image is assured to match one of the constraining dimensions, while
             the other dimension is altered to maintain the same aspect ratio of the input image.
             */
            case clip
            
            /**
             Resizes the image to fill the width and height boundaries and crops any excess image data.
             The resulting image will match the width and height constraints without scaling the image.
             */
            case crop
            
            /**
             Scales the image to fit the constraining dimensions exactly.
             */
            case scale
        }
        
        /**
         Resize an image to the specified size. Depending on what fitMode is supplied, the image
         may be clipped, cropped or scaled. @see documentation on FitMode.
         
         - parameter image:   Image to Resize
         - parameter size:    Size to resize the image to
         - parameter fitMode: How to handle the image resizing process
         
         - returns: Resized image
         */
        public static func resizeImage(_ image: UIImage, size: CGSize, fitMode: FitMode = .clip) -> UIImage {
            guard let imgRef = Util.CGImageWithCorrectOrientation(image) else { return UIImage() }

            let originalWidth  = CGFloat(imgRef.width)
            let originalHeight = CGFloat(imgRef.height)
            let widthRatio = size.width / originalWidth
            let heightRatio = size.height / originalHeight
            
            let scaleRatio = widthRatio > heightRatio ? widthRatio : heightRatio
            
            let resizedImageBounds = CGRect(x: 0, y: 0, width: round(originalWidth * scaleRatio), height: round(originalHeight * scaleRatio))
            let resizedImage = Util.drawImageInBounds(image, bounds: resizedImageBounds)
            
            switch (fitMode) {
            case .clip:
                return resizedImage
            case .crop:
                let croppedRect = CGRect(x: (resizedImage.size.width - size.width) / 2,
                                         y: (resizedImage.size.height - size.height) / 2,
                                         width: size.width, height: size.height)
                return Util.croppedImageWithRect(resizedImage, rect: croppedRect)
            case .scale:
                return Util.drawImageInBounds(resizedImage, bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
        }
    }
    
    // MARK: - Mask
    
    /**
     Mask the contained image with another image mask.
     Note that the areas in the original image that correspond to the black areas of the mask
     show through in the resulting image. The areas that correspond to the white areas of
     the mask aren’t painted. The areas that correspond to the gray areas in the mask are painted
     using an intermediate alpha value that’s equal to 1 minus the image mask sample value.
     
     - parameter maskImage: Image Mask to apply to the Image
     
     - returns: Self, allowing method chaining
     */
    public func maskWithImage(maskImage : UIImage)  -> Toucan {
        self.image = Toucan.Mask.maskImageWithImage(self.image, maskImage: maskImage)
        return self
    }
    
    /**
     Mask the contained image with an ellipse.
     Allows specifying an additional border to draw on the clipped image.
     For a circle, ensure the image width and height are equal!
     
     - parameter borderWidth: Optional width of the border to apply - default 0
     - parameter borderColor: Optional color of the border - default White
     
     - returns: Self, allowing method chaining
     */
    public func maskWithEllipse(borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.white) -> Toucan {
        self.image = Toucan.Mask.maskImageWithEllipse(self.image, borderWidth: borderWidth, borderColor: borderColor)
        return self
    }
    
    /**
     Mask the contained image with a path (UIBezierPath) that will be scaled to fit the image.
     
     - parameter path: UIBezierPath to mask the image
     
     - returns: Self, allowing method chaining
     */
    public func maskWithPath(path: UIBezierPath) -> Toucan {
        self.image = Toucan.Mask.maskImageWithPath(self.image, path: path)
        return self
    }
    
    /**
     Mask the contained image with a path (UIBezierPath) which is provided via a closure.
     
     - parameter path: closure that returns a UIBezierPath. Using a closure allows the user to provide the path after knowing the size of the image
     
     - returns: Self, allowing method chaining
     */
    public func maskWithPathClosure(path: (_ rect: CGRect) -> (UIBezierPath)) -> Toucan {
        self.image = Toucan.Mask.maskImageWithPathClosure(self.image, pathInRect: path)
        return self
    }
    
    /**
     Mask the contained image with a rounded rectangle border.
     Allows specifying an additional border to draw on the clipped image.
     
     - parameter cornerRadius: Radius of the rounded rect corners
     - parameter borderWidth:  Optional width of border to apply - default 0
     - parameter borderColor:  Optional color of the border - default White
     
     - returns: Self, allowing method chaining
     */
    public func maskWithRoundedRect(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.white) -> Toucan {
        self.image = Toucan.Mask.maskImageWithRoundedRect(self.image, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor)
        return self
    }
    
    /**
     Container struct for all things Mask related
     */
    public struct Mask {
        
        /**
         Mask the given image with another image mask.
         Note that the areas in the original image that correspond to the black areas of the mask
         show through in the resulting image. The areas that correspond to the white areas of
         the mask aren’t painted. The areas that correspond to the gray areas in the mask are painted
         using an intermediate alpha value that’s equal to 1 minus the image mask sample value.
         
         - parameter image:     Image to apply the mask to
         - parameter maskImage: Image Mask to apply to the Image
         
         - returns: Masked image
         */
        public static func maskImageWithImage(_ image: UIImage, maskImage: UIImage) -> UIImage {
            guard let imgRef = Util.CGImageWithCorrectOrientation(image),
                let maskRef = maskImage.cgImage,
                let dataProvider = maskRef.dataProvider,
                let mask = CGImage(maskWidth: maskRef.width,
                                   height: maskRef.height,
                                   bitsPerComponent: maskRef.bitsPerComponent,
                                   bitsPerPixel: maskRef.bitsPerPixel,
                                   bytesPerRow: maskRef.bytesPerRow,
                                   provider: dataProvider, decode: nil, shouldInterpolate: false),
                let masked = imgRef.masking(mask) else {
                    return UIImage()
            }
            
            return Util.drawImageWithClosure(size: image.size) { (size: CGSize, context: CGContext) -> () in
                
                // need to flip the transform matrix, CoreGraphics has (0,0) in lower left when drawing image
                context.scaleBy(x: 1, y: -1)
                context.translateBy(x: 0, y: -size.height)

                context.draw(masked, in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
            }
        }
        
        /**
         Mask the given image with an ellipse.
         Allows specifying an additional border to draw on the clipped image.
         For a circle, ensure the image width and height are equal!
         
         - parameter image:       Image to apply the mask to
         - parameter borderWidth: Optional width of the border to apply - default 0
         - parameter borderColor: Optional color of the border - default White
         
         - returns: Masked image
         */
        public static func maskImageWithEllipse(_ image: UIImage,
                                                borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.white) -> UIImage {

            guard let imgRef = Util.CGImageWithCorrectOrientation(image) else { return UIImage() }

            let size = CGSize(width: CGFloat(imgRef.width) / image.scale, height: CGFloat(imgRef.height) / image.scale)
            
            return Util.drawImageWithClosure(size: size) { (size: CGSize, context: CGContext) -> () in
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                context.addEllipse(in: rect)
                context.clip()
                image.draw(in: rect)
                
                if (borderWidth > 0) {
                    context.setStrokeColor(borderColor.cgColor);
                    context.setLineWidth(borderWidth);
                    context.addEllipse(in: CGRect(x: borderWidth / 2,
                                                  y: borderWidth / 2,
                                                  width: size.width - borderWidth,
                                                  height: size.height - borderWidth));
                    context.strokePath();
                }
            }
        }
        
        /**
         Mask the given image with a path(UIBezierPath) that will be scaled to fit the image.
         
         - parameter image:       Image to apply the mask to
         - parameter path: UIBezierPath to make as the mask
         
         - returns: Masked image
         */
        public static func maskImageWithPath(_ image: UIImage,
                                             path: UIBezierPath) -> UIImage {

            guard let imgRef = Util.CGImageWithCorrectOrientation(image) else { return UIImage() }
            
            let size = CGSize(width: CGFloat(imgRef.width) / image.scale, height: CGFloat(imgRef.height) / image.scale)
            
            return Util.drawImageWithClosure(size: size) { (size: CGSize, context: CGContext) -> () in
                
                let boundSize = path.bounds.size
                
                let pathRatio = boundSize.width / boundSize.height
                let imageRatio = size.width / size.height
                
                
                if pathRatio > imageRatio {
                    //scale based on width
                    let scale = size.width / boundSize.width
                    path.apply(CGAffineTransform(scaleX: scale, y: scale))
                    path.apply(CGAffineTransform(translationX: 0, y: (size.height - path.bounds.height) / 2.0))
                } else {
                    //scale based on height
                    let scale = size.height / boundSize.height
                    path.apply(CGAffineTransform(scaleX: scale, y: scale))
                    path.apply(CGAffineTransform(translationX: (size.width - path.bounds.width) / 2.0, y: 0))
                }
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                context.addPath(path.cgPath)
                context.clip()
                image.draw(in: rect)
            }
        }
        
        /**
         Mask the given image with a path(UIBezierPath) provided via a closure. This allows the user to get the size of the image before computing their path variable.
         
         - parameter image:       Image to apply the mask to
         - parameter path: UIBezierPath to make as the mask
         
         - returns: Masked image
         */
        public static func maskImageWithPathClosure(_ image: UIImage,
                                                    pathInRect:(_ rect: CGRect) -> (UIBezierPath)) -> UIImage {

            guard let imgRef = Util.CGImageWithCorrectOrientation(image) else { return UIImage() }
            let size = CGSize(width: CGFloat(imgRef.width) / image.scale, height: CGFloat(imgRef.height) / image.scale)
            
            return maskImageWithPath(image, path: pathInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height)))
        }
        
        /**
         Mask the given image with a rounded rectangle border.
         Allows specifying an additional border to draw on the clipped image.
         
         - parameter image:        Image to apply the mask to
         - parameter cornerRadius: Radius of the rounded rect corners
         - parameter borderWidth:  Optional width of border to apply - default 0
         - parameter borderColor:  Optional color of the border - default White
         
         - returns: Masked image
         */
        public static func maskImageWithRoundedRect(_ image: UIImage, cornerRadius: CGFloat,
                                                    borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.white) -> UIImage {

            guard let imgRef = Util.CGImageWithCorrectOrientation(image) else { return UIImage() }

            let size = CGSize(width: CGFloat(imgRef.width) / image.scale, height: CGFloat(imgRef.height) / image.scale)
            
            return Util.drawImageWithClosure(size: size) { (size: CGSize, context: CGContext) -> () in
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                UIBezierPath(roundedRect:rect, cornerRadius: cornerRadius).addClip()
                image.draw(in: rect)
                
                if (borderWidth > 0) {
                    context.setStrokeColor(borderColor.cgColor);
                    context.setLineWidth(borderWidth);
                    
                    let borderRect = CGRect(x: 0, y: 0,
                                            width: size.width, height: size.height)
                    
                    let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius)
                    borderPath.lineWidth = borderWidth * 2
                    borderPath.stroke()
                }
            }
        }
    }
    
    // MARK: - Layer
    
    /**
     Overlay an image ontop of the current image.
     
     - parameter image:        Image to be on the bottom layer
     - parameter overlayImage: Image to be on the top layer, i.e. drawn on top of image
     - parameter overlayFrame: Frame of the overlay image
     
     - returns: Self, allowing method chaining
     */
    public func layerWithOverlayImage(_ overlayImage: UIImage, overlayFrame: CGRect) -> Toucan {
        self.image = Toucan.Layer.overlayImage(self.image, overlayImage:overlayImage, overlayFrame:overlayFrame)
        return self
    }
    
    /**
     Container struct for all things Layer related.
     */
    public struct Layer {
        
        /**
         Overlay the given image into a new layout ontop of the image.
         
         - parameter image:        Image to be on the bottom layer
         - parameter overlayImage: Image to be on the top layer, i.e. drawn on top of image
         - parameter overlayFrame: Frame of the overlay image
         
         - returns: Masked image
         */
        public static func overlayImage(_ image: UIImage, overlayImage: UIImage, overlayFrame: CGRect) -> UIImage {

            guard let imgRef = Util.CGImageWithCorrectOrientation(image) else { return UIImage() }

            let size = CGSize(width: CGFloat(imgRef.width) / image.scale, height: CGFloat(imgRef.height) / image.scale)
            
            return Util.drawImageWithClosure(size: size) { (size: CGSize, context: CGContext) -> () in
                
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                image.draw(in: rect)
                overlayImage.draw(in: overlayFrame);
            }
        }
    }
    
    /**
     Container struct for internally used utility functions.
     */
    internal struct Util {
        
        /**
         Get the CGImage of the image with the orientation fixed up based on EXF data.
         This helps to normalise input images to always be the correct orientation when performing
         other core graphics tasks on the image.
         
         - parameter image: Image to create CGImageRef for
         
         - returns: CGImageRef with rotated/transformed image context
         */
        static func CGImageWithCorrectOrientation(_ image : UIImage) -> CGImage? {
            guard let cgImage = image.cgImage else { return nil }

            if (image.imageOrientation == UIImageOrientation.up) {
                return cgImage
            }
            
            var transform : CGAffineTransform = CGAffineTransform.identity;
            
            switch (image.imageOrientation) {
            case UIImageOrientation.right, UIImageOrientation.rightMirrored:
                transform = transform.translatedBy(x: 0, y: image.size.height)
                transform = transform.rotated(by: CGFloat(-1.0 * M_PI_2))
                break
            case UIImageOrientation.left, UIImageOrientation.leftMirrored:
                transform = transform.translatedBy(x: image.size.width, y: 0)
                transform = transform.rotated(by: CGFloat(M_PI_2))
                break
            case UIImageOrientation.down, UIImageOrientation.downMirrored:
                transform = transform.translatedBy(x: image.size.width, y: image.size.height)
                transform = transform.rotated(by: CGFloat(M_PI))
                break
            default:
                break
            }
            
            switch (image.imageOrientation) {
            case UIImageOrientation.rightMirrored, UIImageOrientation.leftMirrored:
                transform = transform.translatedBy(x: image.size.height, y: 0);
                transform = transform.scaledBy(x: -1, y: 1);
                break
            case UIImageOrientation.downMirrored, UIImageOrientation.upMirrored:
                transform = transform.translatedBy(x: image.size.width, y: 0);
                transform = transform.scaledBy(x: -1, y: 1);
                break
            default:
                break
            }
            
            let contextWidth : Int
            let contextHeight : Int
            
            switch (image.imageOrientation) {
            case UIImageOrientation.left, UIImageOrientation.leftMirrored,
                 UIImageOrientation.right, UIImageOrientation.rightMirrored:
                contextWidth = cgImage.height
                contextHeight = cgImage.width
                break
            default:
                contextWidth = cgImage.width
                contextHeight = cgImage.height
                break
            }

            guard let colorSpace = cgImage.colorSpace,
                let context = CGContext(data: nil,
                                        width: contextWidth,
                                        height: contextHeight,
                                        bitsPerComponent: cgImage.bitsPerComponent,
                                        bytesPerRow: cgImage.bytesPerRow,
                                        space: colorSpace,
                                        bitmapInfo: cgImage.bitmapInfo.rawValue) else {
                                            return nil
            }

            context.concatenate(transform);
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(contextWidth), height: CGFloat(contextHeight)));

            return context.makeImage()
        }
        
        /**
         Draw the image within the given bounds (i.e. resizes)
         
         - parameter image:  Image to draw within the given bounds
         - parameter bounds: Bounds to draw the image within
         
         - returns: Resized image within bounds
         */
        static func drawImageInBounds(_ image: UIImage, bounds : CGRect) -> UIImage {
            return drawImageWithClosure(size: bounds.size) { (size: CGSize, context: CGContext) -> () in
                image.draw(in: bounds)
            };
        }
        
        /**
         Crop the image within the given rect (i.e. resizes and crops)
         
         - parameter image: Image to clip within the given rect bounds
         - parameter rect:  Bounds to draw the image within
         
         - returns: Resized and cropped image
         */
        static func croppedImageWithRect(_ image: UIImage, rect: CGRect) -> UIImage {
            return drawImageWithClosure(size: rect.size) { (size: CGSize, context: CGContext) -> () in
                let drawRect = CGRect(x: -rect.origin.x, y: -rect.origin.y, width: image.size.width, height: image.size.height)
                context.clip(to: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
                image.draw(in: drawRect)
            };
        }
        
        /**
         Closure wrapper around image context - setting up, ending and grabbing the image from the context.
         
         - parameter size:    Size of the graphics context to create
         - parameter closure: Closure of magic to run in a new context
         
         - returns: Image pulled from the end of the closure
         */
        static func drawImageWithClosure(size: CGSize!, closure: (_ size: CGSize, _ context: CGContext) -> ()) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            closure(size, UIGraphicsGetCurrentContext()!)
            let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
    }
}
