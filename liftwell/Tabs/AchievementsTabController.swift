//  Created by Jesse Jones on 11/10/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit

class AchievementsTabControllerController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let app = UIApplication.shared.delegate as! AppDelegate
        awards.removeAll()
        for achievement in app.achievements {
            awards.append(contentsOf: achievement.oldAwards())
            awards.append(contentsOf: achievement.upcomingAwards())
        }
        awards.sort(by: self.doSort)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return awards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let index = (path as NSIndexPath).item
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsCellID")!
        let color: UIColor
        
        cell.textLabel!.text = awards[index].title
        if let date = awards[index].date {
            cell.detailTextLabel!.text = awards[index].details + " " + date.daysName()
            
            let calendar = Calendar.current
            if calendar.isDate(date, inSameDayAs: Date()) {
                color = UIColor.fromName("darkGreen")!
            } else {
                color = .black
            }

        } else {
            cell.detailTextLabel!.text = awards[index].details
            color = .gray
        }
        
        cell.textLabel!.setColor(color)
        cell.detailTextLabel!.setColor(color)

        return cell
    }
    
    private func doSort(lhs: Award, rhs: Award) -> Bool {
        // Sort first by key,
        if lhs.key < rhs.key {
            return true
        } else if lhs.key > rhs.key {
            return false
        }

        // then by completed vs not completed,
        if lhs.date != nil && rhs.date == nil {
            return true
        } else if lhs.date == nil && rhs.date != nil {
            return false
        }
        
        // then by date,
        if let lhsDate = lhs.date, let rhsDate = rhs.date {
            if lhsDate.compare(rhsDate) == .orderedAscending {
                return true
            } else if lhsDate.compare(rhsDate) == .orderedDescending {
                return false
            }
        }
        
        // then by subtitle (really shouldn't land here).
        return lhs.details < rhs.details
    }

    @IBOutlet var tableView: UITableView!
    
    private var awards: [Award] = []
}

