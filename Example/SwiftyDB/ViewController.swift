//
//  ViewController.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/17/2016.
//  Copyright (c) 2016 Øyvind Grimnes. All rights reserved.
//

import UIKit
import TinySQLite

class ViewController: UIViewController {

    let configuration: Configuration = {
        var configuration = Configuration(name: "database.sqlite")
        
        configuration.mode = .sandbox
        
        return configuration
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? FileManager.default.removeItem(atPath: configuration.path)
        
        let swifty = Swifty(configuration: configuration)
    
        
        let queue = DatabaseQueue(path: configuration.path)
        

        
        let dogs: [Dog] = (0 ..< 1000).map { _ in Dog() }
        
        
        let addStart = Date()
        
        swifty.add(dogs) { result in
            print("Added:", -addStart.timeIntervalSinceNow, result)
            
            let start = Date()
            
            swifty.get(Dog.self).filter("age" < 50).sortBy("name") { result in
                print(result.value?.count)
                print("Get:", -start.timeIntervalSinceNow)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

