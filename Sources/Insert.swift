//
//  Insert.swift
//  SQLiteStORM
//
//  Created by Jonathan Guthrie on 2016-10-07.
//
//

import StORM

extension SQLiteStORM {


	@discardableResult
	public func insert(_ data: [(String, Any)]) throws -> Any {

		var keys = [String]()
		var vals = [String]()
		for i in data {
			keys.append(i.0)
			vals.append(String(describing: i.1))
		}
		do {
			return try insert(cols: keys, params: vals)
		} catch {
			throw StORMError.error(error as! String)
		}
	}

	public func insert(cols: [String], params: [Any]) throws -> Any {

		// PostgreSQL specific insert staement exec
		var paramString = [String]()
		var substString = [String]()
		for i in 0..<params.count {
			paramString.append(String(describing: params[i]))
			substString.append(":\(i+1)")
		}
		let str = "INSERT INTO \(self.table()) (\(cols.joined(separator: ","))) VALUES(\(substString.joined(separator: ",")))"

		do {
			return try execReturnID(str, params: paramString)
		} catch {
			self.error = StORMError.error(error as! String)
			throw error
		}
		
	}
	
	
}