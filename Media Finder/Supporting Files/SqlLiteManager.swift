//
//  SqlLiteManager.swift
//  Media Finder
//
//  Created by ReMoSTos on 22/07/2023.
//

import Foundation
import SQLite

class SqlLiteManager {
    static let shared = SqlLiteManager()
    //MARK: properties
    var database: Connection!
    //MARK: table properties
    let userTable: Table = Table("UserData")
    let userData = Expression<Data>("userData")
    
    /*
    let name = Expression<String>("name")
    let phone = Expression<String>("phone")
    let email = Expression<String>("email")
    let password = Expression<string>("password")
    let address = Expression<String>("address")
    let photo = Expression<Date>("photo")
    */
    
    
    
    func setupConnection() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("UserData").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    // create table
    func createTable() {
        let createTable = self.userTable.create { table in
            table.column(self.userData)
//            table.colum(self.name)
//            table.colum(self.phone)
//            table.colum(self.email)
//            table.colum(self.password)
//            table.colum(self.address)
//            table.colum(self.photo)
        }
        do{
            try self.database.run(createTable)
            print("table created")
        } catch{
            print(error.localizedDescription)
        }
    }
    
    // insert user data
    func insert(user: User, userData: Data) {
        let insertUser = self.userTable.insert(self.userData <- userData)
        do {
            try self.database.run(insertUser)
            print("user inserted")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // list user data
    func list() -> [User] {
        var users: [User] = []
        do {
            let tableUser = try self.database.prepare(self.userTable)
            for user in tableUser {
                let dataOfUser = user[self.userData]
                let listedUser = try JSONDecoder().decode(User.self, from: dataOfUser)
                users.append(listedUser)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        return users
    }
    
    
    
    
}
