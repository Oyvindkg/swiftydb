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
        
        
        let database = Database(configuration: configuration)

        firstly {
            database.add(Dog())
        }.then {
            print("Added!")
        }.then {
            database.get(Dog.self)
        }.then { dogs -> Void in
            for dog in dogs {
                print(dog)
            }
        }.catch { error in
            print(error)
        }
        
        return
        
        let dogs: [Dog] = (0 ..< 1000).map { _ in Dog() }
        
        
        let addStart = Date()
        
        var start: Date?
        
        _ = firstly {
            database.add(objects: dogs)
        }.then { _ -> Void in
            print("Added:", -addStart.timeIntervalSinceNow)
            
            start = Date()
        }.then { _ -> Promise<[Dog]> in
            
            let query = Query.get(Dog.self)
                             .order(by: "name", ascending: true)

            return database.get(using: query)
        }.then { dogs -> Void in
            print(dogs.count)
            print("Get:", -start!.timeIntervalSinceNow)
        }.catch { error in
            print(error)
        }
    }
}

