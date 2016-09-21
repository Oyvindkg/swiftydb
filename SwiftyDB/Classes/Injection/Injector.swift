//
//  Injector.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 03/09/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

enum Scope {
    case singleton
}

class Injector {
    
    var singletons: [Injector -> Any] = []
    
    static var defaultInstance = Injector()
    
    
    func bind<T>(type: T.Type, instantiator: Injector -> T) {
        singletons.append( instantiator )
    }
    
    func autowire<T>(scope: Scope = .singleton) -> T? {
        for instantiator in singletons {
            if let object = instantiator(self) as? T {
                return object
            }
        }
        
        return nil
    }
    
    func autowire<T>(scope: Scope = .singleton) -> T {
        return autowire()!
    }
}
