//
//  ViewController.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 08/17/2016.
//  Copyright (c) 2016 Øyvind Grimnes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let configuration: Configuration = {
        var configuration = Configuration(databaseName: "database.sqlite")
        
//        configuration.dryRun = true
        
        return configuration
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? NSFileManager.defaultManager().removeItemAtPath(configuration.databasePath)
        
        let swifty = Swifty(configuration: configuration)
        
        
        
        let dogs: [Dog] = (0 ..< 100).map { _ in Dog() }
        

        swifty.add(dogs) { result in
            print("Added", result)
            
            let start = NSDate()
            
            swifty.get(Dog.self).sortBy("name", ascending: false) { result in
                print(result.value?.count)
                print("Get:", -start.timeIntervalSinceNow)
            }
            
            let query = swifty.get(Dog.self).filter("age" > 96).sortBy("name", ascending: false)
            
            query.start(20).max(20) { result in
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

