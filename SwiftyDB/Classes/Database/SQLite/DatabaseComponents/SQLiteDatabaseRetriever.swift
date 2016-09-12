//
//  SQLiteDatabaseObjectRetriever.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

class SQLiteDatabaseRetriever: DatabaseRetrieverType {
    
    let databaseQueue: DatabaseQueue
    let queryFactory: SQLiteQueryFactory
    
    
    init(databaseQueue: DatabaseQueue, queryFactory: SQLiteQueryFactory) {
        self.databaseQueue = databaseQueue
        self.queryFactory = queryFactory
    }

    func get(query: _QueryType, nested: Bool = true) throws -> [Writer] {
        
        let reader = Mapper.readerForType(query.type)
        
        var writers: [Writer] = []
        
        try databaseQueue.transaction { database in
            writers = try self.getWritersForReader(reader, filter: query.filter as? SQLiteFilterStatement, sorting: query.sorting, limit: query.max, offset: query.start, database: database)
        }
                
        return writers
    }
    
    // TODO: Make this prettier
    private func getWritersForReader(reader: Reader, filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?, database: DatabaseConnection) throws -> [Writer] {
        let query = queryFactory.selectQueryForType(reader.storeableType, andFilter: filter, sorting: sorting, limit: limit, offset: offset)
        
        
        let statement = try database.prepare(query.query)
        
        try! statement.execute(query.parameters)
        
        let writers = statement.map { row -> Writer in
            let writer = Writer(type: reader.type)
            
            for (property, value) in row.dictionary {
                writer.storeableValues[property] = value as? StoreableValue
            }
            
            return writer
        }
        
        try statement.finalize()
        
        for writer in writers {
            try getStoreableWritersForWriter(writer, database: database)
        }
        
        return writers
    }
    
    
    // MARK: - Storeable properties
    
    private func getStoreableWritersForWriter(writer: Writer, database: DatabaseConnection) throws {
        let reader = Mapper.readerForType(writer.type)
        
        for (property, type) in reader.types {
            if let storeableType = type as? Storeable.Type {
                writer.mappables[property] = try getStoreableWriterForProperty(property, ofType: storeableType, forWriter: writer, database: database)
                
            } else if let storeableArrayType = type as? StoreableArrayType.Type {
                if let storeableType = storeableArrayType.storeableType {
                    let maps: [MapType] = try getStoreableWritersForProperty(property, ofType: storeableType, forWriter: writer, database: database).matchType()
                    
                    writer.mappableArrays[property] = maps
                }
            }
        }
    }
    
    private func getStoreableWriterForProperty(property: String, ofType type: Storeable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> Writer? {
        return try getStoreableWritersForProperty(property, ofType: type, forWriter: writer, database: database).first
    }
    
    private func getStoreableWritersForProperty(property: String, ofType type: Storeable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> [Writer] {
        let propertyReader = Mapper.readerForType(type)
        
        let ids: [String?] = JSONSerialisation.arrayFor(writer.storeableValues[property] as? String)!
        
        let filter = type.identifier() << ids
        
        return try! getWritersForReader(propertyReader, filter: filter as! SQLiteFilterStatement,  sorting: .None, limit: nil, offset: nil, database: database)
    }
}



