//
//  SQLiteDatabaseObjectRetriever.swift
//  SwiftyDB
//
//  Created by Øyvind Grimnes on 22/08/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TinySQLite

struct SQLiteDatabaseRetriever {
}

extension SQLiteDatabaseRetriever {

    static func get(using query: AnyQuery, on queue: DatabaseQueue) throws -> [Writer] {
        print("#### Get using:", query)
        let reader = ObjectMapper.read(type: query.type)
        
        var writers: [Writer] = []
        
        try queue.transaction { database in
            guard try database.contains(table: String(describing: query.type)) else {
                return
            }
            
            writers = try self.getWritersFor(reader: reader, using: query, in: database)
        }
                
        return writers
    }
    

    fileprivate static  func getWritersFor(reader: Reader, using query: AnyQuery, in database: DatabaseConnection) throws -> [Writer] {
        
        let query = SQLiteQueryFactory.selectQuery(for:     reader.storableType,
                                                   filter:  query.filter as? SQLiteFilterStatement,
                                                   sorting: query.sorting,
                                                   limit:   query.max,
                                                   offset:  query.start)
        
        let statement = try database.statement(for: query.query)
        
        defer {
            try! statement.finalize()
        }

        //FIXME: Rewrite
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
    
    fileprivate static func getStorableWritersFor(writer: Writer, database: DatabaseConnection) throws {
        let reader = ObjectMapper.read(type: writer.type)
        
        for (property, type) in reader.propertyTypes {
            if let storableType = type as? Storable.Type {
                writer.mappables[property] = try getStorableWriterFor(property: property, ofType: storableType, forWriter: writer, database: database)
                
            } else if let storableArrayType = type as? StorableArray.Type {
                if let storableType = storableArrayType.storableType {
                    let maps = try getStorableWritersFor(property:  property,
                                                         ofType:    storableType,
                                                         forWriter: writer,
                                                         database:  database)
                    
                    writer.mappableArrays[property] = maps
                }
            }
        }
    }
    
    fileprivate static func getStorableWriterFor(property: String, ofType type: Storable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> Writer? {
        return try getStorableWritersFor(property: property, ofType: type, forWriter: writer, database: database)?.first
    }
    
    fileprivate static func getStorableWritersFor(property: String, ofType type: Storable.Type, forWriter writer: Writer, database: DatabaseConnection) throws -> [Writer]? {
        let propertyReader = ObjectMapper.read(type: type)
        
        guard let storableValue = writer.storableValues[property] as? String else {
            return nil
        }
        
        var ids = [storableValue]
        
        if storableValue.characters.first == "[" {
            ids = try! JSONSerialization.jsonObject(with: storableValue.data(using: .utf8)!, options: []) as! [String]
        }

        return try ids.flatMap { id -> [Writer] in
            
            let query = SimpleQuery(type: type, filter: type.identifier() == id)
            
            return try self.getWritersFor(reader: propertyReader, using: query, in: database)
        }
    }
}


