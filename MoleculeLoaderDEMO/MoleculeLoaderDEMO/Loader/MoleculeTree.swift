//
//  MoleculeTree.swift
//  MoleculeAnimationDev
//
//  Created by Anton Nechayuk on 6/30/17.
//  Copyright © 2017 Anton Nechayuk. All rights reserved.
//

import UIKit

class MoleculeNode {
    public var node: MoleculeConfigurationProtocol
    public var children: [MoleculeNode] = []
    weak var parent: MoleculeNode?
    
    init(config: MoleculeConfigurationProtocol) {
        self.node = config
    }
    
    public func add(child: MoleculeNode) {
        self.children.append(child)
        child.parent = self
    }
}


extension MoleculeNode: CustomStringConvertible {
    //for debug only
    var description: String {
        var text = "\(node.moleculeType())"
        if !children.isEmpty {
            text += " {" + children.flatMap { $0.description }.joined(separator: ", ") + "} "
        }
        return text
    }
}
