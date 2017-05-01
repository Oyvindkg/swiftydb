//
//  IndexingUtilitiesTests.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 01/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import SwiftyDB

public class IndexingUtilitiesTests: XCTestCase {
    
    func testIndexNameIsCorrect() {
        let name = "StarknameOptionalSwiftyDBConnectivedisjunctionSwiftyDBConnectiveconjunctionSwiftyDBExpressionequalnameOptionalSansaSwiftyDBExpressiongreaterage10SwiftyDBConnectiveconjunctionSwiftyDBExpressionequalwolfOptionalGhostSwiftyDBExpressionbetweenage020"
        
        expect(IndexingUtilities.name(of: Stark.indices().first!, for: Stark.self)) == name
    }
    
    func testIndexNamesForTypeAreCorrect() {
        let name = "StarknameOptionalSwiftyDBConnectivedisjunctionSwiftyDBConnectiveconjunctionSwiftyDBExpressionequalnameOptionalSansaSwiftyDBExpressiongreaterage10SwiftyDBConnectiveconjunctionSwiftyDBExpressionequalwolfOptionalGhostSwiftyDBExpressionbetweenage020"
        
        expect(IndexingUtilities.indexNames(for: Stark.self)).to(contain(name))
    }
    
    func testIndexNamesForNonIndexableTypesIsEmptySet() {
        expect(IndexingUtilities.indexNames(for: Wolf.self)) == []
    }
}
