//
//  Loader.swift
//  MoleculeAnimationDev
//
//  Created by Anton Nechayuk on 7/4/17.
//  Copyright © 2017 Anton Nechayuk. All rights reserved.
//

import UIKit

class Loader: NSObject, CAAnimationDelegate {
    
    private var points: [MoleculePoint] = []
    private var displayLink: CADisplayLink?
    private var completionBlock: ((Loader) -> Void)?
    private weak var view: UIView?
    
    class func show(in view: UIView, initialPoints: [CGPoint]? = nil, timeInterval: CFTimeInterval? = nil,  withCompletionBlock completion: @escaping (Loader) -> Void) -> Loader {
        let loader = Loader()
        loader.start(in: view, initialPoints: initialPoints)
        if timeInterval != nil {
            _ = Timer.scheduledTimer(withTimeInterval: timeInterval!, repeats: false, block: { (timer) in
                completion(loader)
                timer.invalidate()
                loader.stop()
            })
        } else {
            //store completionBlock for manual stop() calls
            loader.completionBlock = completion
        }
        return loader
    }
    
    private func start(in view: UIView, initialPoints: [CGPoint]? = nil) {
        self.view = view
        let cgPoints = initialPoints ?? getCgPointDefault(view: view)
        let moleculePoints = self.generateMoleculePoints(from: cgPoints)
        self.points = moleculePoints
        animate(moleculePoints: moleculePoints)
    }
    
    public func stop() {
        for point in points {
            point.removeLayers()
        }
        displayLink?.invalidate()
        completionBlock?(self)
    }
    
    public func moleculePoints() -> [MoleculePoint]? {
        return (points.count > 0) ? points : nil
    }
    
    private func generateMoleculePoints(from cgPoints: [CGPoint]) -> [MoleculePoint] {
        var moleculePoints = [MoleculePoint]()
        for p in cgPoints {
            moleculePoints.append(MoleculePoint(with: p, superLayer: view?.layer, bounceAnimation: true, radius: nil, isTransparent: false))
        }
        return moleculePoints
    }
    
    private func animate(moleculePoints: [MoleculePoint]) {
        displayLink = CADisplayLink(target: self, selector: #selector(self.animationLoop))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        let destinationPoints = MoleculePolygonePointsGenerator.generateCGPoints(facetsCount: moleculePoints.count, angle: CGFloat(0), radius: 55, center: (view?.center)!)
        
        assert(destinationPoints.count == moleculePoints.count)
        
        for (index, p) in moleculePoints.enumerated() {
            let destination = destinationPoints[index]
            let currentPosition = p.currentPosition()
            let path = UIBezierPath()
            path.move(to: currentPosition)
            path.addLine(to: destination)
            p.currentPointLayer.frame.origin = destination
            p.bounceRadius = 40
            p.addPositionAnimation(to: p.currentPointLayer, duration: CFTimeInterval(Int.random(range: 1...3)), radius: 40, path: path)
            
        }
        
        //fill next points
        for p in moleculePoints {
            for basePoint in moleculePoints {
                if p == basePoint { continue }
                p.nextPoints.append(basePoint)
            }
        }
    }
    
    @objc private func animationLoop() {
        for point in points {
            
            for nextPoint in point.nextPoints {
                
                let distance = point.currentPosition().minus(nextPoint.currentPosition()).length()
                if distance <= 170 {
                    point.drawLines()
                } else {
                    point.removeLines()
                }
            }
        }
    }
    
    //4 points by default on screen
    private func getCgPointDefault(view: UIView) -> [CGPoint] {
        var points = [CGPoint]()
        
        for x in (0...1) {
            for y in (0...1) {
                let p = CGPoint(x: 20 + (UIScreen.main.bounds.width - CGFloat(40)) * CGFloat( x ),
                                y: 100 + (UIScreen.main.bounds.height - CGFloat(200)) * CGFloat( y ))
                points.append(p)
            }
        }
        return points
    }
    
}
