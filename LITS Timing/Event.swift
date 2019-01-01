//
//  Classes.swift
//  Steer
//
//  Created by Mac Sierra on 12/29/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import Foundation

class Event {
    var name : String
    var status : String
    var spliturl: String
    var streamurl: String
    init(name: String?, status: String?, spliturl: String?, streamurl: String?){
        self.name = name!
        self.status = status!
        self.spliturl = spliturl!
        self.streamurl = streamurl!
    }
}
