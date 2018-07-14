//
//  MoleculeConfigurations.swift
//  MoleculeAnimationDev
//
//  Created by Anton Nechayuk on 6/30/17.
//  Copyright © 2017 Anton Nechayuk. All rights reserved.
//

import UIKit

enum MoleculeMemberType {
    case polygone
    case branch
    case dot
}

protocol MoleculeConfigurationProtocol {
    func moleculeType() -> MoleculeMemberType
}

class MoleculeConfiguration {
    public static let offsetRadius: CGFloat = 60
    public static let colors: [UIColor] = [#colorLiteral(red: 0.3996295631, green: 0.396104455, blue: 0.3959799409, alpha: 1), #colorLiteral(red: 0.3077869713, green: 0.6661467552, blue: 0.6574529409, alpha: 1), #colorLiteral(red: 0.9650971293, green: 0.3788683414, blue: 0.2159076929, alpha: 1)]
    
    
    public static var moleculeTree: MoleculeNode? = nil
    
    
    class func defaultMoleculeTree() -> MoleculeNode {
        let root = MoleculeNode(config: ConfigForBranch(deepness: 2, radius: 25, angle: 90, innerPoint: nil))
        
        let child1 = MoleculeNode(config: ConfigForPolygons(facets: 4, angle: 90))
        let child2 = MoleculeNode(config: ConfigForDot())
        child2.add(child: child1)
        root.add(child: child2)
        child1.add(child: MoleculeNode(config: ConfigForBranch(angle: 90)))
        child1.add(child: MoleculeNode(config: ConfigForDot()))
        
        return root
    }
}

struct ConfigForDot: MoleculeConfigurationProtocol {
    var radius: Int
    var color: UIColor
    var center: CGPoint?
    init(radius: Int = 6, color: UIColor = MoleculeConfiguration.colors.first!, center: CGPoint? = nil) {
        self.radius = radius
        self.color = color
        self.center = center
    }
    
    func moleculeType() -> MoleculeMemberType {
        return .dot
    }
}

struct ConfigForPolygons: MoleculeConfigurationProtocol {
    let facets: Int
    let radius: CGFloat
    let angle: CGFloat
    let centerFrameView: CGPoint?
    let innerPointIndex: Int
    let outputPointIndex: Int
    
    init(facets: Int = 5, radius: CGFloat = 25, angle: CGFloat = 0, centerFrameView: CGPoint? = nil, innerPointIndex: Int = 0, outputPointIndex: Int = 2) {
        self.facets = facets
        self.radius = radius
        self.angle = angle
        self.centerFrameView = centerFrameView
        self.innerPointIndex = innerPointIndex
        self.outputPointIndex = outputPointIndex
    }
    
    func moleculeType() -> MoleculeMemberType {
        return .polygone
    }
}

struct ConfigForBranch: MoleculeConfigurationProtocol {
    let deepness: Int
    let radius: CGFloat
    let angle: CGFloat
    let innerPoint: CGPoint?
    
    init(deepness: Int = 2, radius: CGFloat = 25, angle: CGFloat = 270, innerPoint: CGPoint? = nil) {
        self.deepness = deepness
        self.radius = radius
        self.angle = angle
        self.innerPoint = innerPoint
    }
    
    func moleculeType() -> MoleculeMemberType {
        return .branch
    }
}
