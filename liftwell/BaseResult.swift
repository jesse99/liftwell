//  Created by Jesse Jones on 10/26/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation
import os.log

enum ResultTag {
    case easy
    case normal
    case hard
    case failed
}

class BaseResult {
    init(_ tag: ResultTag) {
        self.tag = tag
        self.date = Date()
    }
    
    required init(from store: Store) {
        self.date = store.getDate("date")
        
        let tag = store.getStr("tag")
        switch tag {
        case "easy": self.tag = .easy
        case "normal": self.tag = .normal
        case "hard": self.tag = .hard
        case "failed": self.tag = .failed
        default: os_log("%@ is a bad tag", tag); self.tag = .normal
        }
    }
    
    func save(_ store: Store) {
        store.addDate("date", date)
        switch tag {
        case .easy: store.addStr("tag", "easy")
        case .normal: store.addStr("tag", "normal")
        case .hard: store.addStr("tag", "hard")
        case .failed: store.addStr("tag", "failed")
        }
    }
    
    var date: Date
    var tag: ResultTag
}
