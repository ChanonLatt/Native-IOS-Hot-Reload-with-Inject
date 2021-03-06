//
//  UIView+UIKitUtils.swift
//  
//
//  Created by 林博文 on 2021/2/5.
//

import UIKit

private var tapGestureRecognizerKey: Void?

public extension UIView {
    
    /// Get the controller of the view.
    var responderViewController: UIViewController? {
        for tempView in sequence(first: self, next: { $0.superview }) {
            if let responder = tempView.next as? UIViewController {
                return responder
            }
        }
        return nil
    }
    /// A Boolean value that indicates whether the view visible.
    var isVisible: Bool {
        guard let window = window else { return false }
        let viewFrame = window.convert(frame, from: superview)
        let screenFrame = window.bounds
        guard viewFrame.intersects(screenFrame) else { return false }
        for view in sequence(first: self, next: { $0.superview }) where view.isHidden || view.alpha == 0 {
            return false
        }
        return true
    }
    /// The radius to use when drawing rounded corners for the background.
//    @IBInspectable var cornerRadius: CGFloat {
//        get { layer.cornerRadius }
//        set { layer.cornerRadius = newValue }
//    }
    /// Interface Builder property to set `maskedCorners`.
    @IBInspectable private var maskedCornersArray: CGRect {
        get {
            CGRect(x: layer.maskedCorners.contains(.layerMinXMinYCorner) ? 1 : 0, y: layer.maskedCorners.contains(.layerMaxXMinYCorner) ? 1 : 0, width: layer.maskedCorners.contains(.layerMinXMaxYCorner) ? 1 : 0, height: layer.maskedCorners.contains(.layerMaxXMaxYCorner) ? 1 : 0)
        }
        set {
            var maskedCorners: CACornerMask = []
            if newValue.origin.x > 0 {
                maskedCorners.insert(.layerMinXMinYCorner)
            }
            if newValue.origin.y > 0 {
                maskedCorners.insert(.layerMaxXMinYCorner)
            }
            if newValue.size.width > 0 {
                maskedCorners.insert(.layerMinXMaxYCorner)
            }
            if newValue.size.height > 0 {
                maskedCorners.insert(.layerMaxXMaxYCorner)
            }
            layer.maskedCorners = maskedCorners
        }
    }
    /// Defines the curve used for rendering the rounded corners.
    @IBInspectable var isCornerContinuous: Bool {
        get {
            if #available(iOS 13.0, *) {
                return layer.cornerCurve == .continuous
            } else {
                return layer.value(forKey: "continuousCorners") as? Bool ?? false
            }
        }
        set {
            if #available(iOS 13, *) {
                layer.cornerCurve = newValue ? .continuous : .circular
            } else {
                layer.setValue(newValue, forKey: "continuousCorners")
            }
        }
    }
    /// Set the border line width.
    @IBInspectable var borderStrokeWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    static private var borderStrokeColorKey: Void?
    /// Set the border line color.
    @IBInspectable var borderStrokeColor: UIColor? {
        get {
            guard let borderColor = objc_getAssociatedObject(self, &UIView.borderStrokeColorKey) as? UIColor else { return nil }
            return borderColor
        }
        set {
            objc_setAssociatedObject(self, &UIView.borderStrokeColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if #available(iOS 13.0, *) {
                layer.borderColor = newValue?.resolvedColor(with: traitCollection).cgColor
            } else {
                layer.borderColor = newValue?.cgColor
            }
        }
    }
    /// Set the shadow radius.
    @IBInspectable var borderShadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    static private var borderShadowColorKey: Void?
    /// Set the shadow color.
    @IBInspectable var borderShadowColor: UIColor? {
        get {
            guard let shadowColor = objc_getAssociatedObject(self, &UIView.borderShadowColorKey) as? UIColor else { return nil }
            return shadowColor
        }
        set {
            objc_setAssociatedObject(self, &UIView.borderShadowColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if #available(iOS 13.0, *) {
                layer.shadowColor = newValue?.resolvedColor(with: traitCollection).cgColor
            } else {
                layer.shadowColor = newValue?.cgColor
            }
        }
    }
    /// Set the shadow opacity.
    @IBInspectable var borderShadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    /// Set the shadow offset.
    @IBInspectable var borderShadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    /// Interface Builder property to set `transform`.
    @IBInspectable private var translationTransform: CGPoint {
        get { .zero }
        set { transform = transform.translatedBy(x: newValue.x, y: newValue.y)  }
    }
    /// Interface Builder property to set `transform`.
    @IBInspectable private var scaleTransform: CGPoint {
        get { .zero }
        set { transform = transform.scaledBy(x: newValue.x, y: newValue.y)  }
    }
    /// Interface Builder property to set `transform`.
    @IBInspectable private var rotatedTransform: CGFloat {
        get { 0 }
        set { transform = transform.rotated(by: newValue) }
    }
    private var tapGestureRecognizer: UITapGestureRecognizer {
        guard let gesture = objc_getAssociatedObject(self, &tapGestureRecognizerKey) as? UITapGestureRecognizer else {
            let gesture = UITapGestureRecognizer()
            objc_setAssociatedObject(self, &tapGestureRecognizerKey, gesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return gesture
        }
        return gesture
    }
    
    /// Adds an action to perform when this view recognizes a tap gesture.
    /// - Parameter handler: The action to perform.
    func onTap(handler: (() -> Void)?) {
        if let handler = handler {
            if tapGestureRecognizer.view != self {
                addGestureRecognizer(tapGestureRecognizer)
            }
            tapGestureRecognizer.addActionHandler { _ in
                handler()
            }
        } else {
            removeGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    /// Get the constraints with the identifier in view.
    /// - Parameter identifier: The identifier of constraint
    /// - Returns: The constraints with the identifier in view.
    func constraints(with identifier: String) -> [NSLayoutConstraint] {
        constraints.filter { $0.identifier == identifier }
    }
    
    /// Get the superview of the specified type.
    /// - Parameter type: Superview's type.
    /// - Returns: The superview of the specified type.
    func superview<T: UIView>(type: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let typeView = view as? T {
                return typeView
            }
        }
        return nil
    }
    
}
