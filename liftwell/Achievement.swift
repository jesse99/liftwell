//  Created by Jesse Jones on 11/10/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

struct Award: Storable {
    let key: String         // used for sorting
    let title: String
    let details: String
    let date: Date?

    init(key: String, title: String, details: String, date: Date?) {
        self.key = key
        self.title = title
        self.details = details
        self.date = date
    }
    
    init(from store: Store) {
        self.key = store.getStr("key")
        self.title = store.getStr("title")
        self.details = store.getStr("details")
        if store.hasKey("details") {
            self.date = store.getDate("date")
        } else {
            self.date = nil
        }
    }
    
    func save(_ store: Store) {
        store.addStr("key", key)
        store.addStr("title", title)
        store.addStr("details", details)
        if let date = self.date {
            store.addDate("date", date)
        }
    }
}

protocol Achievement {
    func save(_ app: AppDelegate)
    
    /// Returns the achievements the user has completed in the past.
    func oldAwards() -> [Award]

    /// Returns achievements the user has completed after the last call to updateCompletions.
    func checkForNewAwards(_ exercise: Exercise) -> [Award]
    
    /// Moves new achievements into haveCompleted.
    func updateAwards(_ exercise: Exercise)
    
    /// Returns the next couple achievements the user can earn. Note that a lot of achievements
    /// have an unbounded cardinality, e.g. an achievement might fire for every 50 pounds the user
    /// is able to life for an exercise.
    func upcomingAwards() -> [Award]
}
