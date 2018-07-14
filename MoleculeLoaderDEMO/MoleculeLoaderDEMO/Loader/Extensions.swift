//
//  Extensions.swift
//  MoleculeAnimationDev
//
//  Created by Anton Nechayuk on 6/12/17.
//  Copyright © 2017 Anton Nechayuk. All rights reserved.
//

import UIKit


extension Int
{
    static func random(range: CountableClosedRange<Int> ) -> Int
    {
        var offset = 0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

extension CGFloat {
    func radian() -> CGFloat {
        return self * CGFloat.pi / 180
    }
}

extension CGPoint {
    func plus(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
    
    func minus(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
    
    func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
}

