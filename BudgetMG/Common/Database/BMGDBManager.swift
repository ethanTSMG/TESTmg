//
//  BMGDBManager.swift
//  TO DO: package
//
//  Created by hmarker on 2021/2/15.
//

import UIKit

public class DBManager: NSObject {

    private(set) var dbPath: String = ""
    
    private var dbPool: DatabasePool?
    private var dbQueue: DatabaseQueue?
    
    static let `default` = { DBManager() }()
 
    public override init() {
        super.init()
        createdb()
    }
    
    // MARK: - create db
    func createdb() {
        var bundleName = "BudgetMG"
        if let value = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String {
            bundleName = value
        }

        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            fatalError("The documents path does not exist !")
        }
        
        var pathURL = URL(fileURLWithPath: documentsPath)
        pathURL = pathURL.appendingPathComponent(bundleName)
        let dbPath = pathURL.path + ".sqlite"
        
        if !FileManager.default.fileExists(atPath: dbPath) {
            try? FileManager.default.createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        self.dbPath = dbPath
        
        do {
            dbPool = try DatabasePool(path: dbPath)
            dbQueue = try DatabaseQueue(path: dbPath)
        } catch {
            
        }
    
        guard let cursor = dbPool else { return }
        
        do {
            try cursor.write({ (db) in
                try db.execute(sql: """
                        CREATE TABLE IF NOT EXISTS user (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        category TEXT,
                        date TEXT,
                        currency TEXT,
                        value TEXT)
                        """
                )
            })
        } catch {
            debugPrint("create table user error")
        }
    }
    
    // MARK: - inset db
    func inset(category: String, value: String, currency: String, date: String, block: ((Bool) -> Void)? = nil) {
        guard let cursor = dbPool else { return }
        
        cursor.asyncWrite({ (db) in
            let exists = try db.tableExists("user")
            if exists {
                try db.execute(
                    sql: """
                        INSERT INTO user(category, date, currency, value)
                        VALUES(?,?,?,?)
                    """,
                    arguments: [category, date, currency, value])
            }
        }) { _,_  in
            DispatchQueue.pk.executeInMainThread {
                block?(true)
            }
        }
    }
    
    // MARK: - read db
    func read(_ block: @escaping ([Any]) -> Void) {
        guard let cursor = dbPool else { return }
        
        try? cursor.read({ db in
            let exists = try db.tableExists("user")
            
            if exists {
                let statement = try db.makeSelectStatement(sql: """
                    select * from user
                    """)
                let res = try Row.fetchAll(statement)
                print(res)
                
                let res2 = try Row.fetchCursor(db, sql: "SELECT * FROM user")
                
                var values = [Any]()
                while let r = try res2.next() {
                    var dict = [String:Any]()
                    dict.updateValue(r[Column("category")] as String, forKey: "category")
                    dict.updateValue(r[Column("currency")] as String, forKey: "currency")
                    dict.updateValue(r[Column("date")] as String, forKey: "date")
                    dict.updateValue(r[Column("value")] as Int, forKey: "value")
                    values.append(dict)
                }
                
                block(values)
            }
        })
    }
}
