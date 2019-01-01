//
//  ClassTableViewController.swift
//  Steer
//
//  Created by Mac Sierra on 12/28/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import UIKit
import Firebase
import SQLite3

class EventTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var db: OpaquePointer?
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 30.0
        tableView.rowHeight = UITableViewAutomaticDimension
        

        loadEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    //Segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let even = events[indexPath.row]
        print(even.spliturl)
        print(even.streamurl)
        storeEvent(splits_URL: even.spliturl, stream_URL: even.streamurl)
    }
    //Setup Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EventTableViewCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HomeTableViewCell.")
        }
        let even = events[indexPath.row]
        cell.nameLabel.text = even.name
        cell.statusLabel.text = even.status
        cell.streamURL.text = even.streamurl
        cell.splitsURL.text = even.spliturl
        cell.contentView.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 140))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        cell.selectionStyle = .none
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    private func loadEvents() {
        ref = Database.database().reference().child("Events");
        ref.observe(DataEventType.value, with: { (snapshot) in
            self.events.removeAll()
            for classes in snapshot.children.allObjects as! [DataSnapshot] {
                let classObject = classes.value as? [String: AnyObject]
                let names = classObject?["Name"]
                let stat = classObject?["Status"]
                let split = classObject?["splitURL"]
                let stream = classObject?["streamURL"]
                let event1 = Event(name: names as! String?, status : stat as! String?, spliturl: split as! String?, streamurl: stream as! String?)
                self.events += [event1]
            }
            self.tableView.reloadData()
        })
    }
    
    private func storeEvent(splits_URL: String?, stream_URL: String?) {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("EventData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Classes (id INTEGER PRIMARY KEY NOT NULL, splitURL TEXT, streamURL TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        var stmt: OpaquePointer?
        let queryString = "INSERT INTO Classes (spliturl, streamurl) VALUES (?,?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, splits_URL, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 2, stream_URL, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        print("SUCcESS",splits_URL!, stream_URL!)
    }
    
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        loadEvents()
        self.tableView.reloadData()
    }
    
}


