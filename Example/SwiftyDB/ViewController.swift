//
//  ViewController.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/17/2016.
//  Copyright (c) 2016 Øyvind Grimnes. All rights reserved.
//

import UIKit
import SwiftyDB
import PromiseKit

class ViewController: UIViewController {

    let configuration: Configuration = {
        var configuration = Configuration(name: "database.sqlite")
        
        configuration.mode = .sandbox
        
        return configuration
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? FileManager.default.removeItem(atPath: configuration.location.path)
        
        let swifty = Swifty(configuration: configuration)
    

        
        let dogs: [Dog] = (0 ..< 1000).map { _ in Dog() }
        
        
        let addStart = Date()
        
        var start: Date?
        
        _ = firstly {
            swifty.add(objects: dogs)
        }.then { _ -> Void in
            print("Added:", -addStart.timeIntervalSinceNow)
            
            start = Date()
        }.then {
            swifty.get(Dog.self).order(by: "name")
        }.then { dogs -> Void in
            print(dogs.count)
            print("Get:", -start!.timeIntervalSinceNow)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

