//
//  ConfigurationTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 28/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class ConfigurationTests: XCTestCase {
    
    func testDefaultDirectoryIsUserDocumentsDirectory() {
        let configuration = Database.Configuration(name: "Hamlet")
        
        let userDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        expect(configuration.directory) == userDocuments
    }
    
    func testLocationWhenInNormalModeIsInASubdirectory() {
        var configuration = Database.Configuration(name: "Hamlet")
        
        configuration.mode = .normal
        
        let expectedLocation = configuration.directory.appendingPathComponent("Hamlet")
                                                      .appendingPathComponent("normal")
                                                      .appendingPathComponent("database")
                                                      .appendingPathExtension("sqlite")
        
        expect(configuration.location) == expectedLocation
    }
    
    func testLocationForModeIsInTheConfigurationsDirectory() {
        let directory = URL(fileURLWithPath: "")
        
        var configuration = Database.Configuration(name: "Hamlet")
        
        configuration.directory = directory
        
        let expectedLocation = configuration.directory.appendingPathComponent("Hamlet")
            .appendingPathComponent("normal")
            .appendingPathComponent("database")
            .appendingPathExtension("sqlite")
        
        expect(configuration.location(for: .normal)) == expectedLocation
    }
    
    func testLocationWhenInSandboxModeIsInASubdirectory() {
        var configuration = Database.Configuration(name: "Hamlet")
        
        configuration.mode = .sandbox
        
        let expectedLocation = configuration.directory.appendingPathComponent("Hamlet")
            .appendingPathComponent("sandbox")
            .appendingPathComponent("database")
            .appendingPathExtension("sqlite")
        
        expect(configuration.location) == expectedLocation
    }
    
    func testLocationForSandboxModeIsInASubdirectory() {
        let configuration = Database.Configuration(name: "Hamlet")
        
        let expectedLocation = configuration.directory.appendingPathComponent("Hamlet")
            .appendingPathComponent("sandbox")
            .appendingPathComponent("database")
            .appendingPathExtension("sqlite")
        
        expect(configuration.location(for: .sandbox)) == expectedLocation
    }
    
    func testLocationForNormalModeIsInASubdirectory() {
        let configuration = Database.Configuration(name: "Hamlet")
        
        let expectedLocation = configuration.directory.appendingPathComponent("Hamlet")
            .appendingPathComponent("normal")
            .appendingPathComponent("database")
            .appendingPathExtension("sqlite")
        
        expect(configuration.location(for: .normal)) == expectedLocation
    }
}
