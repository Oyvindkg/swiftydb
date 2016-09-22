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
    

    private func getWritersForReader(reader: Reader, filter: SQLiteFilterStatement?, sorting: Sorting, limit: Int?, offset: Int?, database: DatabaseConnection) throws -> [Writer] {
        let query = queryFactory.selectQueryForType(reader.storableType, andFilter: filter, sorting: sorting, limit: limit, offset: offset)
        
        let statement = try database.prepare(query.query)
        
        defer {
            try! statement.finalize()
        }

        try statement.execute(query.parameters)

        /* Create writers and populate them with nested objects */
        return try statement.map { row -> Writer in
            let writer = Writer(type: reader.type)
            
            for (property, value) in row.dictionary {
                writer.storableValues[property] = value as? StorableValue
            }
            
            try getStorableWritersForWriter(writer, database: database)
            
            return writer
        }
    }
    
    
    // MARK: - Storable properties
    
    private func getStorableWritersForWriter(writer: Writer, database: DatabaseConnection) throws {
        let reader = Mapper.readerForType(writer.type)
        
        for (property, type) in reader.types {
            if let storableType = type as? Storable.Type {
                writer.mappables[property] = try getStorableWriterForProperty(property, ofType: storableType, forWriter: writer, database: database)
                
            } else if let storableArrayType = type as? StorableArrayType.Type {
                if let storableType = storableArrayType.storableType {
                    let maps: [MapType]? = try getStorableWritersForProperty(property, ofType: storableType, forWriter: writer, database: database)?.matchType()
                    
                    writer.mappableArrays[property] = maps
                }
            }
        }
    }
    
    private func getStorableWriterForProperty(property: String, ofType type: Storable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> Writer? {
        return try getStorableWritersForProperty(property, ofType: type, forWriter: writer, database: database)?.first
    }
    
    private func getStorableWritersForProperty(property: String, ofType type: Storable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> [Writer]? {
        let propertyReader = Mapper.readerForType(type)
        
        guard let storableValue = writer.storableValues[property] as? String else {
            return nil
        }
        
        let ids: [String?] = JSONSerialisation.arrayFor(storableValue)!
        
        return try ids.flatMap { id -> [Writer] in
            let filter = type.identifier() == id
            
            return try self.getWritersForReader(propertyReader, filter: filter as? SQLiteFilterStatement,  sorting: .none, limit: nil, offset: nil, database: database)
        }
    }
}



