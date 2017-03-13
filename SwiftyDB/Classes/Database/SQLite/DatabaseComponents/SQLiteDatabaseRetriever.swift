//
//  SQLiteDatabaseObjectRetriever.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

protocol SQLiteDatabaseRetriever: DatabaseRetriever {
    var databaseQueue: DatabaseQueue { get }
}

extension SQLiteDatabaseRetriever {

    func get(query: _QueryProtocol) throws -> [Writer] {
        
        let reader = Mapper.reader(for: query.type)
        
        var writers: [Writer] = []
        
        try databaseQueue.transaction { database in
            writers = try self.getWritersFor(reader: reader, filter: query.filter as? SQLiteFilterStatement, sorting: query.sorting, limit: query.max, offset: query.start, database: database)
        }
                
        return writers
    }
    

    fileprivate func getWritersFor(reader: Reader, filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?, database: DatabaseConnection) throws -> [Writer] {
        
        let query = SQLiteQueryFactory.selectQuery(for: reader.storableType,
                                             filter: filter,
                                             sorting: sorting,
                                             limit: limit,
                                             offset: offset)
        
        let statement = try database.statement(for: query.query)
        
        defer {
            try! statement.finalize()
        }

        /* Create writers and populate them with nested objects */
        return try statement.execute(withParameters: query.parameters).map { row -> Writer in
            let writer = Writer(type: reader.type)
            
            for (property, value) in row.dictionary {
                writer.storableValues[property] = value as? StorableValue
            }
            
            try getStorableWritersFor(writer: writer, database: database)
            
            return writer
        }
    }
    
    
    // MARK: - Storable properties
    
    fileprivate func getStorableWritersFor(writer: Writer, database: DatabaseConnection) throws {
        let reader = Mapper.reader(for: writer.type)
        
        for (property, type) in reader.propertyTypes {
            if let storableType = type as? Storable.Type {
                writer.mappables[property] = try getStorableWriterFor(property: property, ofType: storableType, forWriter: writer, database: database)
                
            } else if let storableArrayType = type as? StorableArray.Type {
                if let storableType = storableArrayType.storableType {
                    let maps: [Map]? = try getStorableWritersFor(property: property, ofType: storableType, forWriter: writer, database: database)?.matchType()
                    
                    writer.mappableArrays[property] = maps
                }
            }
        }
    }
    
    fileprivate func getStorableWriterFor(property: String, ofType type: Storable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> Writer? {
        return try getStorableWritersFor(property: property, ofType: type, forWriter: writer, database: database)?.first
    }
    
    fileprivate func getStorableWritersFor(property: String, ofType type: Storable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> [Writer]? {
        let propertyReader = Mapper.reader(for: type)
        
        guard let storableValue = writer.storableValues[property] as? String else {
            return nil
        }
        
        let ids: [String?] = CollectionSerialization.arrayFor(string: storableValue)!
        
        return try ids.flatMap { id -> [Writer] in
            let filter = type.identifier() == id
            
            return try self.getWritersFor(reader: propertyReader, filter: filter as? SQLiteFilterStatement,  sorting: .none, limit: nil, offset: nil, database: database)
        }
    }
}



