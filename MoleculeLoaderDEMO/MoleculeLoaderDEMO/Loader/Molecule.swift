//
//  Molecule.swift
//  MoleculeAnimationDev
//
//  Created by Anton Nechayuk on 6/12/17.
//  Copyright © 2017 Anton Nechayuk. All rights reserved.
//

import UIKit

class MoleculePolygonePointsGenerator: NSObject {
    
    class func linkedPolygonePoints(fromPoint point: MoleculePoint, facetsCount: Int, angle: CGFloat = 0, radius: CGFloat, centerView: CGPoint, innerPointIndex: Int, outputPointIndex: Int, superLayer: CALayer) -> ([MoleculePoint], MoleculePoint) {
        
        let points = MoleculePolygonePointsGenerator.generateCGPoints(facetsCount: facetsCount, angle: angle, radius: radius, center: centerView)
        
        let (firstPoint, moleculePoints, lastPoint) = MoleculePolygonePointsGenerator.linkPolygonePoint(withCGPoints: points, innerPointIndex: innerPointIndex, outPointIndex: outputPointIndex, superLayer: superLayer)
        
        point.nextPoints.append(firstPoint)
        return (moleculePoints, lastPoint)
    }
    
    class func generateCGPoints(facetsCount: Int, angle: CGFloat = 0, radius: CGFloat, center: CGPoint) -> [CGPoint] {
        var points = [CGPoint]()
        let center = center
        for n in 0...(facetsCount - 1) {
            let nFloat = CGFloat(n)
            let angleRad = angle * CGFloat.pi / 180
            let expression = angleRad + CGFloat(2.0) * CGFloat.pi * nFloat / CGFloat(facetsCount)
            
            let x = center.x - radius * cos( expression)
            let y = center.y - radius * sin( expression)
            let point = CGPoint(x: x, y: y)
            points.append(point)
        }
        return points
    }
    
    fileprivate class func linkPolygonePoint(withCGPoints cgPoints: [CGPoint], innerPointIndex: Int, outPointIndex: Int, superLayer: CALayer) -> (MoleculePoint, [MoleculePoint], MoleculePoint) {
        var points = [MoleculePoint]()
        for cgPoint in cgPoints {
            points.append(MoleculePoint(with: cgPoint, superLayer: superLayer))
        }
        let halfIndex = cgPoints.count / 2
        for (index, point) in points.enumerated() {
            if index >= halfIndex { 
                break
            }
            let nextPoint = points[index + 1]
            point.nextPoints.append(nextPoint)
        }
        let pointsReversed = Array(points.reversed())
        for (index, point) in pointsReversed.enumerated() {
            if index >= (points.count - halfIndex - 1) {
                break
            }
            let nextPoint = pointsReversed[index + 1]
            point.nextPoints.append(nextPoint)
        }
        let firstPoint = points.first!
        let lastPoint = points.last!
        firstPoint.nextPoints.append(lastPoint)
        
        return (points[innerPointIndex], points, points[outPointIndex])
    }
    
    fileprivate class func calculateCenter(from innerPoint: CGPoint, radius: CGFloat) -> CGPoint {
        let center = CGPoint(x: innerPoint.x + radius, y: innerPoint.y)
        return center
    }
}

class MoleculeLine: NSObject {
    fileprivate var lineLayer = CAShapeLayer()
    private var lineWidth: CGFloat
    private var innerPoint: MoleculePoint
    private var nextPoint: MoleculePoint
    
    class func generateLine(from innerPoint: MoleculePoint, to nextPoint: MoleculePoint) -> MoleculeLine {
        let moleculeLine = MoleculeLine(innerPoint: innerPoint, nextPoint: nextPoint)
        let path = moleculeLine.linePath(from: innerPoint.currentPointLayer.position, to: nextPoint.currentPointLayer.position)
        moleculeLine.lineLayer.path = path.cgPath
        moleculeLine.lineLayer.opacity = innerPoint.currentPointLayer.opacity
        
        return moleculeLine
    }
    
    init(lineWidth: CGFloat = 1, innerPoint: MoleculePoint, nextPoint: MoleculePoint) {
        self.lineWidth = lineWidth
        self.innerPoint = innerPoint
        self.nextPoint = nextPoint
    }
    
    private func linePath(from innerPoint: CGPoint, to nextPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.move(to: innerPoint)
        path.addLine(to: nextPoint)
        path.close()
        
        return path
    }
    
    class func linePath(from innerPoint: CGPoint, to nextPoint: CGPoint, lineWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.move(to: innerPoint)
        path.addLine(to: nextPoint)
        path.close()
        
        return path
    }
    
    public func updatePath() {
        let path = linePath(from: innerPoint.currentPosition(), to: nextPoint.currentPosition())
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.gray.cgColor
    }
    
    public func updateOpacity(opacity: Float) {
        lineLayer.opacity = opacity
    }
    
    public func removeLineLayerFromSuperLayer() {
        lineLayer.removeFromSuperlayer()
    }
}

open class MoleculePoint: NSObject, CAAnimationDelegate {
    
    public var bounceRadius: CGFloat?
    public var currentPointLayer = CAShapeLayer()
    public var nextPoints: [MoleculePoint]
    
    private let superLayer: CALayer?
    private var pointRadius: Int
    private var lines = [MoleculePoint : MoleculeLine]()
    
    
    
    public class func createPoint(from point: CGPoint, to layer: CALayer, radius: Int? = nil) -> MoleculePoint {
        return MoleculePoint(with: point, superLayer: layer, radius: radius)
    }
    
    init(with position: CGPoint, superLayer: CALayer? = nil, bounceAnimation: Bool = true, radius: Int? = nil, color: UIColor? = nil, isTransparent: Bool = true) {
        self.superLayer = superLayer
        self.pointRadius = radius ?? Int.random(range: 6...13)
        self.nextPoints = [MoleculePoint]()
        
        super.init()
        self.currentPointLayer = createPointLayer(point: position, radius: pointRadius, color: color)
        self.currentPointLayer.opacity = isTransparent ? 0 : 1
        
        if bounceAnimation == true {
            let bounceAnimationDuration = pointRadius < 5 ? Int.random(range: 2...5) : Int.random(range: 6...10)
            addPositionAnimation(to: currentPointLayer, duration: CFTimeInterval(bounceAnimationDuration))
        }
        if let layer = superLayer {
            layer.addSublayer(currentPointLayer)
        } else {
            print("---- Ignore addLayer!!")
        }
    }
    
    private func createPointLayer(point: CGPoint, radius: Int, color: UIColor? = nil) -> CAShapeLayer {
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: CGFloat(radius), startAngle: CGFloat(), endAngle: CGFloat.pi * 2, clockwise: true)
        let pointLayer = CAShapeLayer()
        let colors: [UIColor] = [#colorLiteral(red: 0.3996295631, green: 0.396104455, blue: 0.3959799409, alpha: 1), #colorLiteral(red: 0.3077869713, green: 0.6661467552, blue: 0.6574529409, alpha: 1), #colorLiteral(red: 0.9650971293, green: 0.3788683414, blue: 0.2159076929, alpha: 1)]
        let color = color ?? colors[Int.random(range: 0...(colors.count))]
        pointLayer.strokeColor = color.cgColor
        pointLayer.fillColor = pointLayer.strokeColor
        pointLayer.lineWidth = 1
        pointLayer.position = point
        pointLayer.path = path.cgPath
        
        return pointLayer
    }
    
    //MARK: Animation
    public func addPositionAnimation(to layer: CALayer, duration: CFTimeInterval, radius: CGFloat? = nil, path: UIBezierPath? = nil) {
        let path = path ?? generateAnimationPath(to: layer)
        let animPosition = CAKeyframeAnimation(keyPath: "position")
        animPosition.path = path.cgPath
        animPosition.duration = duration
        animPosition.delegate = self
        animPosition.repeatCount = 1
        layer.add(animPosition, forKey: animPosition.keyPath)
    }
    
    private func generateAnimationPath(to layer: CALayer) -> UIBezierPath {
        let path = UIBezierPath()
        var points = [CGPoint]()
        let pointsCount = 5
        let radius = bounceRadius ?? CGFloat(Int.random(range: 3...6))
        for _ in 0...pointsCount {
            let center = layer.frame.origin
            let angleRadian = CGFloat(Int.random(range: 0...360)) * CGFloat.pi / 180
            let x = radius * -cos(angleRadian) + center.x
            let y = radius * sin(angleRadian) + center.y
            points.append(CGPoint(x: x, y: y))
        }
        path.move(to: layer.frame.origin)
        for p in points {
            path.addLine(to: p)
        }
        path.close()
        
        return path
    }
    
    //MARK: Lines
    
    public func drawLines() {
        if nextPoints.isEmpty {
            return
        }
        for nextPoint in nextPoints {
            
            let moleculeLine = lines[nextPoint] ?? {
                let line = lineToPoint(nextPoint: nextPoint)
                lines[nextPoint] = line
                superLayer?.addSublayer(line.lineLayer)
                superLayer?.insertSublayer(line.lineLayer, below: superLayer?.sublayers?.first)
                return line
                }()
            moleculeLine.updatePath()
            moleculeLine.updateOpacity(opacity: nextPoint.currentOpacity())
        }
    }
    
    public func removeLines() {
        for l in lines {
            l.value.removeLineLayerFromSuperLayer()
        }
        lines.removeAll()
    }
    
    public func removeLayers() {
        removeLines()
        if currentPointLayer.superlayer != nil {
            currentPointLayer.removeFromSuperlayer()
        }
    }
    
    private func lineToPoint(nextPoint: MoleculePoint) -> MoleculeLine {
        if let line = lines[nextPoint] {
            return line
        }
        return MoleculeLine.generateLine(from: self, to: nextPoint)
    }
    
    //MARK: CAAnimationDelegate
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            if let animationPosition = anim as? CAKeyframeAnimation, animationPosition.keyPath == "position" {
                let bounceAnimationDuration = pointRadius < 5 ? Int.random(range: 1...4) : Int.random(range: 3...10)
                addPositionAnimation(to: currentPointLayer, duration: CFTimeInterval(bounceAnimationDuration))
            }
        }
    }
    
    public func currentPosition() -> CGPoint {
        if let presentationPoint = currentPointLayer.presentation() {
            return presentationPoint.frame.origin
        }
        return currentPointLayer.frame.origin
    }
    
    public func currentOpacity() -> Float {
        if let presentationPoint = currentPointLayer.presentation() {
            return presentationPoint.opacity
        }
        return currentPointLayer.opacity
    }
}




