import UIKit

class SPStorkCodeDraw : NSObject {
    
    private struct Cache {
        static let gradient: CGGradient = CGGradient(colorsSpace: nil, colors: [UIColor.red.cgColor, UIColor.red.cgColor] as CFArray, locations: [0, 1])!
    }
    
    @objc dynamic class var gradient: CGGradient { return Cache.gradient }
    
    @objc dynamic class func drawClose(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), resizing: ResizingBehavior = .aspectFit, color: UIColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)) {
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 100, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 100, y: resizedFrame.height / 100)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 92.02, y: 22.92))
        bezierPath.addLine(to: CGPoint(x: 64.42, y: 50.52))
        bezierPath.addLine(to: CGPoint(x: 92.02, y: 78.13))
        bezierPath.addCurve(to: CGPoint(x: 92.02, y: 92.99), controlPoint1: CGPoint(x: 96.13, y: 82.23), controlPoint2: CGPoint(x: 96.13, y: 88.89))
        bezierPath.addCurve(to: CGPoint(x: 84.59, y: 96.07), controlPoint1: CGPoint(x: 89.97, y: 95.05), controlPoint2: CGPoint(x: 87.28, y: 96.07))
        bezierPath.addCurve(to: CGPoint(x: 77.16, y: 92.99), controlPoint1: CGPoint(x: 81.9, y: 96.07), controlPoint2: CGPoint(x: 79.22, y: 95.05))
        bezierPath.addLine(to: CGPoint(x: 49.55, y: 65.38))
        bezierPath.addLine(to: CGPoint(x: 21.95, y: 92.99))
        bezierPath.addCurve(to: CGPoint(x: 14.51, y: 96.07), controlPoint1: CGPoint(x: 19.89, y: 95.05), controlPoint2: CGPoint(x: 17.2, y: 96.07))
        bezierPath.addCurve(to: CGPoint(x: 7.08, y: 92.99), controlPoint1: CGPoint(x: 11.82, y: 96.07), controlPoint2: CGPoint(x: 9.13, y: 95.05))
        bezierPath.addCurve(to: CGPoint(x: 7.08, y: 78.13), controlPoint1: CGPoint(x: 2.97, y: 88.89), controlPoint2: CGPoint(x: 2.97, y: 82.23))
        bezierPath.addLine(to: CGPoint(x: 34.69, y: 50.52))
        bezierPath.addLine(to: CGPoint(x: 7.08, y: 22.92))
        bezierPath.addCurve(to: CGPoint(x: 7.08, y: 8.04), controlPoint1: CGPoint(x: 2.97, y: 18.8), controlPoint2: CGPoint(x: 2.97, y: 12.15))
        bezierPath.addCurve(to: CGPoint(x: 21.94, y: 8.04), controlPoint1: CGPoint(x: 11.18, y: 3.94), controlPoint2: CGPoint(x: 17.84, y: 3.94))
        bezierPath.addLine(to: CGPoint(x: 49.55, y: 35.65))
        bezierPath.addLine(to: CGPoint(x: 77.16, y: 8.04))
        bezierPath.addCurve(to: CGPoint(x: 92.02, y: 8.04), controlPoint1: CGPoint(x: 81.26, y: 3.94), controlPoint2: CGPoint(x: 87.92, y: 3.94))
        bezierPath.addCurve(to: CGPoint(x: 92.02, y: 22.92), controlPoint1: CGPoint(x: 96.13, y: 12.15), controlPoint2: CGPoint(x: 96.13, y: 18.8))
        bezierPath.close()
        color.setFill()
        bezierPath.fill()
        
        context.restoreGState()
        
    }
    
    @objc(StyleKitNameResizingBehavior)
    enum ResizingBehavior: Int {
        case aspectFit
        case aspectFill
        case stretch
        case center
        
        func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
    
    private override init() {}
}
