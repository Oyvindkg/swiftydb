//
//  TinyError.swift
//  TinySQLite
//
//  Created by Øyvind Grimnes on 13/02/17.
//  Copyright © 2017 Øyvind Grimnes. All rights reserved.
//

import Foundation

public enum TinyError: Int32, Error, CustomStringConvertible {
    case ok                 = 0
    case error
    case internalError
    case permissionDenied
    case abort
    case busy
    case tableLocked
    case noMemory
    case readOnly
    case interrupted
    case ioError
    case corrupted
    case notFound
    case full
    case cannotOpen
    case lockProtocol
    case empty
    case schema
    case tooBig
    case constraintViolation
    case datatypeMismatch
    case libraryMisuse
    case noLSF
    case authorization
    case invalidFormat
    case outOfRange
    case notADatabase
    case notification
    case warning
    case row                = 100
    case done               = 101
    case bindingType
    case numberOfBindings
    
    public var description: String {
        return "TinySQLite.TinyError: \(self.message) (\(rawValue))"
    }
    
    public var message: String {
        switch self {
        case .ok:
            return "Successful result"
        case .error:
            return "SQL error or missing database"
        case .internalError:
            return "Internal logic error in SQLite"
        case .permissionDenied:
            return "Access permission denied"
        case .abort:
            return "Callback routine requested an abort"
        case .busy:
            return "The database file is locked"
        case .tableLocked:
            return "A table in the database is locked"
        case .noMemory:
            return "A malloc() failed"
        case .readOnly:
            return "Attempt to write a readonly database"
        case .interrupted:
            return "Operation terminated by sqlite3_interrupt()"
        case .ioError:
            return "Some kind of disk I/O error occurred"
        case .corrupted:
            return "The database disk image is malformed"
        case .notFound:
            return "Unknown opcode in sqlite3_file_control()"
        case .full:
            return "Insertion failed because database is full"
        case .cannotOpen:
            return "Unable to open the database file"
        case .lockProtocol:
            return "Database lock protocol error"
        case .empty:
            return "Database is empty"
        case .schema:
            return "The database schema changed"
        case .tooBig:
            return "String or BLOB exceeds size limit"
        case .constraintViolation:
            return "Abort due to constraint violation"
        case .datatypeMismatch:
            return "Data type mismatch"
        case .libraryMisuse:
            return "Library used incorrectly"
        case .noLSF:
            return "Uses OS features not supported on host"
        case .authorization:
            return "Authorization denied"
        case .invalidFormat:
            return "Auxiliary database format error"
        case .outOfRange:
            return "2nd parameter to sqlite3_bind out of range"
        case .notADatabase:
            return "File opened that is not a database file"
        case .notification:
            return "Notifications from sqlite3_log()"
        case .warning:
            return "Warnings from sqlite3_log()"
        case .row:
            return "sqlite3_step() has another row ready"
        case .done:
            return "sqlite3_step() has finished executing"
        case .bindingType:
            return "Tried to bind an unrecognized data type, or an NSNumber wrapping an unrecognized type"
        case .numberOfBindings:
            return "Incorrect number of bindings"
        }
    }
}
