//
//  SecondViewController.swift
//  LITS Timing
//
//  Created by Core PC on 12/29/18.
//  Copyright © 2018 sectionvnordic. All rights reserved.
//

import UIKit
import WebKit
import SQLite3
import Firebase

class StreamViewController: UIViewController, WKUIDelegate {
    var db: OpaquePointer?
    var webView: WKWebView!
    var streamurl: String?
    override func loadView() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("EventData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        self.navigationController?.isNavigationBarHidden = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let queryString = "SELECT * FROM Classes ORDER BY id"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            streamurl = String(cString: sqlite3_column_text(stmt, 2))
        }
        let myURL = URL(string:streamurl!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }
    
    
    @IBAction func doRefresh(_: AnyObject) {
        webView.reload()
    }
}
