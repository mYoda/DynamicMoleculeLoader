//
//  ViewController.swift
//  MoleculeLoaderDEMO
//
//  Created by Anton Nechayuk on 14.07.18.
//  Copyright © 2018 Anton Nechayuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    var loader: Loader?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
        gesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc private func tapAction() {
        
        self.loader?.stop()
        self.loader = Loader.show(in: self.view, initialPoints: nil, timeInterval: nil, withCompletionBlock: { (loader) in
            print("stop loader")
        })
    }

}

