//
//  SQLiteStORM.swift
//  SQLiteStORM
//
//  Created by Jonathan Guthrie on 2016-10-03.
//
//

import StORM
import SQLite
// StORMProtocol
open class SQLiteStORM: StORM {
	open var connection = SQLiteConnect()


	open func table() -> String {
		return "unset"
	}

	override public init() {
		super.init()
	}

	public init(_ connect: SQLiteConnect) {
		super.init()
		self.connection = connect
	}

	// Internal function which executes statements
	@discardableResult
	func exec(_ smt: String) throws {
		do {
			let db = try self.connection.open()
			try db.execute(statement: smt)
		} catch {
			throw StORMError.error(errorMsg)
		}
	}

	// Internal function which executes statements, with parameter binding
	// Returns an id
	@discardableResult
	func execReturnID(_ smt: String, params: [String]) throws -> Any {
		do {
			let db = try self.connection.open()

			try db.execute(statement: smt, doBindings: {

				(statement: SQLiteStmt) -> () in
				for i in 0..<params.count {
					try statement.bind(position: i, params[i])
				}
			})
			return db.lastInsertRowID()
		} catch {
			throw StORMError.error(errorMsg)
		}
	}


	// Internal function which executes statements, with parameter binding
	// Returns an array of SQLiteStmt
	@discardableResult
	func exec(_ smt: String, params: [String]) throws -> [SQLiteStmt] {
		var results = [SQLiteStmt]()
		do {
			let db = try self.connection.open()

			try db.forEachRow(statement: smt, doBindings: {

				(statement: SQLiteStmt) -> () in
				for i in 0..<params.count {
					try statement.bind(position: i, params[i])
				}

			}, handleRow: {(statement: SQLiteStmt, i:Int) -> () in
				results.append(statement)
			})

		} catch {
			throw StORMError.error(errorMsg)
		}
		return results
	}

	// Internal function which executes statements, with parameter binding
	// Returns a processed row set
	@discardableResult
	func execRows(_ smt: String, params: [String]) throws -> [StORMRow] {
		var rows = [StORMRow]()
		let results = try exec(smt, params: params)
		rows = parseRows(results)
		return rows
	}

	open func to(_ this: StORMRow) {
//		id				= this.data["id"] as! Int
//		firstname		= this.data["firstname"] as! String
//		lastname		= this.data["lastname"] as! String
//		email			= this.data["email"] as! String
	}

	open func makeRow() {
		self.to(self.results.rows[0])
	}

//	@discardableResult
//	open func save() throws {
//		do {
//			if keyIsEmpty() {
//				try insert(asData(1))
//			} else {
//				let (idname, idval) = firstAsKey()
//				try update(data: asData(1), idName: idname, idValue: idval)
//			}
//		} catch {
//			throw StORMError.error(error.localizedDescription)
//		}
//	}
//	@discardableResult
//	open func save(set: (_ id: Any)->Void) throws {
//		do {
//			if keyIsEmpty() {
//				let setId = try insert(asData(1))
//				set(setId)
//			} else {
//				let (idname, idval) = firstAsKey()
//				try update(data: asData(1), idName: idname, idValue: idval)
//			}
//		} catch {
//			throw StORMError.error(error.localizedDescription)
//		}
//	}
//
//	@discardableResult
//	override open func create() throws {
//		do {
//			try insert(asData())
//		} catch {
//			throw StORMError.error(error.localizedDescription)
//		}
//	}
//
}


