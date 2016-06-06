//
//  Tide.swift
//  Tide
//
//  Created by Andrew Aquino on 6/4/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import UIKit
import CoreGraphics
import Async

public class Tide {
  
  private struct Singleton {
    private static var queue1: Async?
    private static var queue2: Async?
  }
  
  public var image: UIImage?
  
  public init(image: UIImage?) {
    self.image = image
  }
  
  public func fitClip(size: CGSize?) -> Tide {
    image = Tide.resizeImage(image, size: size)
    return self
  }
  
  public func rounded() -> Tide {
    image = Tide.Util.maskImageWithEllipse(image)
    return self
  }
  
  public static func resizeImage(image: UIImage?, size: CGSize?) -> UIImage? {
    guard let image = image, let size = size where size.height > 0 && size.width > 0 else { return nil }
    
    let imgRef = Util.CGImageWithCorrectOrientation(image)
    let originalWidth  = CGFloat(CGImageGetWidth(imgRef))
    let originalHeight = CGFloat(CGImageGetHeight(imgRef))
    let widthRatio = size.width / originalWidth
    let heightRatio = size.height / originalHeight
    let scaleRatio = widthRatio > heightRatio ? widthRatio : heightRatio
    let resizedImageBounds: CGRect? = CGRect(x: 0, y: 0, width: round(originalWidth * scaleRatio), height: round(originalHeight * scaleRatio))
    
    guard let resizedImage: UIImage = Util.drawImageInBounds(image, bounds: resizedImageBounds) else { return nil }
    
    let croppedRect = CGRect(
      x: (resizedImage.size.width - size.width) / 2,
      y: (resizedImage.size.height - size.height) / 2,
      width: size.width, height: size.height
    )
    
    return Util.croppedImageWithRect(resizedImage, rect: croppedRect)
  }
  
  /**
   Container struct for internally used utility functions.
   */
  internal struct Util {
    
    /**
     Mask the given image with an ellipse.
     Allows specifying an additional border to draw on the clipped image.
     For a circle, ensure the image width and height are equal!
     
     - parameter image:       Image to apply the mask to
     - parameter borderWidth: Optional width of the border to apply - default 0
     - parameter borderColor: Optional color of the border - default White
     
     - returns: Masked image
     */
    static func maskImageWithEllipse(
      image: UIImage?,
      borderWidth: CGFloat = 0,
      borderColor: UIColor = UIColor.whiteColor()
    ) -> UIImage? {
      
      guard let image = image else { return nil }
      
      let imgRef = Util.CGImageWithCorrectOrientation(image)
      let size = CGSize(width: CGFloat(CGImageGetWidth(imgRef)) / image.scale, height: CGFloat(CGImageGetHeight(imgRef)) / image.scale)
      
      return Util.drawImageWithClosure(size: size) { (size: CGSize, context: CGContext) -> () in
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        CGContextAddEllipseInRect(context, rect)
        CGContextClip(context)
        image.drawInRect(rect)
        
        if (borderWidth > 0) {
          CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
          CGContextSetLineWidth(context, borderWidth);
          CGContextAddEllipseInRect(context, CGRect(x: borderWidth / 2,
            y: borderWidth / 2,
            width: size.width - borderWidth,
            height: size.height - borderWidth));
          CGContextStrokePath(context);
        }
      }
    }
    
    /**
     Get the CGImage of the image with the orientation fixed up based on EXF data.
     This helps to normalise input images to always be the correct orientation when performing
     other core graphics tasks on the image.
     
     - parameter image: Image to create CGImageRef for
     
     - returns: CGImageRef with rotated/transformed image context
     */
    static func CGImageWithCorrectOrientation(image : UIImage?) -> CGImageRef? {
      guard let image = image else { return nil }
      
      if (image.imageOrientation == UIImageOrientation.Up) { return image.CGImage! }
      
      var transform : CGAffineTransform = CGAffineTransformIdentity;
      
      switch (image.imageOrientation) {
      case UIImageOrientation.Right, UIImageOrientation.RightMirrored:
        transform = CGAffineTransformTranslate(transform, 0, image.size.height)
        transform = CGAffineTransformRotate(transform, CGFloat(-1.0 * M_PI_2))
        break
      case UIImageOrientation.Left, UIImageOrientation.LeftMirrored:
        transform = CGAffineTransformTranslate(transform, image.size.width, 0)
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        break
      case UIImageOrientation.Down, UIImageOrientation.DownMirrored:
        transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height)
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        break
      default:
        break
      }
      
      switch (image.imageOrientation) {
      case UIImageOrientation.RightMirrored, UIImageOrientation.LeftMirrored:
        transform = CGAffineTransformTranslate(transform, image.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break
      case UIImageOrientation.DownMirrored, UIImageOrientation.UpMirrored:
        transform = CGAffineTransformTranslate(transform, image.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break
      default:
        break
      }
      
      let contextWidth : Int
      let contextHeight : Int
      
      switch (image.imageOrientation) {
      case UIImageOrientation.Left, UIImageOrientation.LeftMirrored,
      UIImageOrientation.Right, UIImageOrientation.RightMirrored:
        contextWidth = CGImageGetHeight(image.CGImage)
        contextHeight = CGImageGetWidth(image.CGImage)
        break
      default:
        contextWidth = CGImageGetWidth(image.CGImage)
        contextHeight = CGImageGetHeight(image.CGImage)
        break
      }
      
      let context : CGContextRef = CGBitmapContextCreate(nil, contextWidth, contextHeight,
        CGImageGetBitsPerComponent(image.CGImage),
        CGImageGetBytesPerRow(image.CGImage),
        CGImageGetColorSpace(image.CGImage),
        CGImageGetBitmapInfo(image.CGImage).rawValue)!;
      
      CGContextConcatCTM(context, transform);
      CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(contextWidth), CGFloat(contextHeight)), image.CGImage);
      
      let cgImage = CGBitmapContextCreateImage(context);
      return cgImage!;
    }
    
    /**
     Draw the image within the given bounds (i.e. resizes)
     
     - parameter image:  Image to draw within the given bounds
     - parameter bounds: Bounds to draw the image within
     
     - returns: Resized image within bounds
     */
    static func drawImageInBounds(image: UIImage?, bounds : CGRect?) -> UIImage? {
      return drawImageWithClosure(size: bounds?.size) { [weak image] (size: CGSize, context: CGContext) -> () in
        var _bounds: CGRect? = bounds
        if let bounds = _bounds { image?.drawInRect(bounds) }
        image = nil
        _bounds = nil
      };
    }
    
    /**
     Crop the image within the given rect (i.e. resizes and crops)
     
     - parameter image: Image to clip within the given rect bounds
     - parameter rect:  Bounds to draw the image within
     
     - returns: Resized and cropped image
     */
    static func croppedImageWithRect(image: UIImage?, rect: CGRect?) -> UIImage? {
      return drawImageWithClosure(size: rect?.size) { [weak image] (size: CGSize, context: CGContext) -> () in
        guard let image = image else { return }
        var _rect: CGRect? = rect
        let drawRect = CGRectMake(-_rect!.origin.x, -_rect!.origin.y, image.size.width, image.size.height)
        CGContextClipToRect(context, CGRectMake(0, 0, _rect!.size.width, _rect!.size.height))
        image.drawInRect(drawRect)
        _rect = nil
      }
    }
    
    /**
     Closure wrapper around image context - setting up, ending and grabbing the image from the context.
     
     - parameter size:    Size of the graphics context to create
     - parameter closure: Closure of magic to run in a new context
     
     - returns: Image pulled from the end of the closure
     */
    static func drawImageWithClosure(size size: CGSize?, closure: (size: CGSize, context: CGContext) -> ()) -> UIImage? {
      var _closure: ((size: CGSize, context: CGContext) -> ())? = closure
      var _size: CGSize? = size
      var _image: UIImage?
      UIGraphicsBeginImageContextWithOptions(_size!, false, 0)
      if let context = UIGraphicsGetCurrentContext() {
        _closure?(size: _size!, context: context)
        _image = UIGraphicsGetImageFromCurrentImageContext()
      }
      UIGraphicsEndImageContext()
      _size = nil
      _closure = nil
      return _image
    }
  
    private static func utility(execute: dispatch_block_t) {
      if Tide.Singleton.queue1 == nil {
        Tide.Singleton.queue1 = Async.utility(block: execute)
      } else {
        execute()
      }
    }
    
    private static func main(execute: dispatch_block_t) {
      if Tide.Singleton.queue2 == nil {
        Tide.Singleton.queue2 = Async.main(block: execute)
      } else {
        execute()
      }
    }
  }
}

extension UIImageView {
  
  public func fitClip(image: UIImage? = nil, completionHandler: ((image: UIImage?) -> Void)? = nil) -> Self {
    Async.utility { [weak self] in
      var imageMod: UIImage? = Tide.resizeImage(image != nil ? image : self?.image, size: self?.frame.size)
      Async.main { [weak self] in
        if let completionHandler = completionHandler {
          completionHandler(image: imageMod)
        } else {
          self?.image = imageMod
        }
        imageMod = nil
      }
    }
    return self
  }
  
  public func rounded(image: UIImage? = nil, completionHandler: ((image: UIImage?) -> Void)? = nil) -> Self {
    Async.utility { [weak self] in
      var imageMod: UIImage? = Tide.Util.maskImageWithEllipse(image != nil ? image : self?.image)
      Async.main { [weak self] in
        if let completionHandler = completionHandler {
          completionHandler(image: imageMod)
        } else {
          self?.image = imageMod
        }
        imageMod = nil
      }
    }
    return self
  }
}











