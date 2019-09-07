//  Created by Jesse Jones on 10/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import UIKit

class ProgramsTabControllerController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        let a = Array(tags.map {tagToString($0)})
        coder.encode(a, forKey: "tags.tags")
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        let a = coder.decodeObject(forKey: "tags.tags") as! [String]
        tags = Swift.Set(Array(a.map {stringToTag($0)}))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    @IBAction func unwindToPrograms(_ segue:UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramCellID")!
        cell.backgroundColor = tableView.backgroundColor
        
        let index = path.item
        cell.textLabel!.text = programs[index].name
        
        // TODO: use bold for custom programs
        let app = UIApplication.shared.delegate as! AppDelegate
        let color = programs[index].name == app.program.name ? UIColor.blue : UIColor.black  // TODO: use targetColor
        cell.textLabel!.setColor(color)
        
        var labels: [String] = []
        var tags = programs[index].tags
        if tags.isStrictSuperset(of: anySex) {
            labels.append("Any Sex")
            tags = tags.subtracting(anySex)
        }
        if tags.isStrictSuperset(of: anyDays) {
            labels.append("Any Days")
            tags = tags.subtracting(anyDays)
        }
        if tags.isStrictSuperset(of: anyAge) {
            labels.append("Any Age")
            tags = tags.subtracting(anyAge)
        }
        labels.append(contentsOf: tags.map {tagToString($0)})
        labels = labels.sorted()
        
        cell.detailTextLabel!.text = labels.joined(separator: ", ")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt path: IndexPath) {
        let index = path.item
        let app = UIApplication.shared.delegate as! AppDelegate
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let program = programs[index]
        
        var action = UIAlertAction(title: "About", style: .default) {_ in
            self.showAbout(program)
        }
        alert.addAction(action)
        
        if programs[index].name != app.program.name {
            action = UIAlertAction(title: "Activate", style: .default) {_ in
                self.activate(program)
                self.tableView.reloadData()
            }
            alert.addAction(action)
        }
        
        action = UIAlertAction(title: "Cancel", style: .default) {_ in
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAbout(_ program: Program) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "MarkdownID") as! MarkdownController
        view.initialize(program.description, "\(program.name) ª Description", "unwindToProgramsID")
        present(view, animated: true, completion: nil)
    }
    
    private func activate(_ program: Program) {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.changeProgram(program)
        tableView.reloadData()
    }
    
    @IBAction func stagePressed(_ sender: Any) {
        let alert = createAlert("Any Level", [.beginner, .intermediate, .advanced])
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func typePressed(_ sender: Any) {
        let alert = createAlert("Any Type", [.strength, .hypertrophy, .conditioning])
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func daysPressed(_ sender: Any) {
        let alert = createAlert("Any Number of Days", anyDays)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func apparatusPressed(_ sender: Any) {
        let alert = createAlert("Any Apparatus", [.gym, .barbell, .dumbbell, .minimal])
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sexPressed(_ sender: Any) {
        let alert = createAlert("Any Sex", anySex)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func agePressed(_ sender: Any) {
        let alert = createAlert("Any Age", anyAge)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createAlert(_ noTag: String, _ tags: [Program.Tags]) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        var action = UIAlertAction(title: noTag, style: .default) {_ in
            for t in tags {
                self.tags.remove(t)
            }
            self.updateUI()
        }
        alert.addAction(action)
        
        for tag in tags {
            action = UIAlertAction(title: tagToString(tag), style: .default) {_ in
                for t in tags {
                    self.tags.remove(t)
                }
                self.tags.insert(tag)
                self.updateUI()
            }
            alert.addAction(action)
            if self.tags.contains(tag) {
                alert.preferredAction = action
            }
        }
        
        return alert
    }
    
    private func updateUI() {
        var stageText = "Any Level"
        var typeText = "Any Type"
        var daysText = "Any Number of Days"
        var apparatusText = "Any Apparatus"
        var sexText = "Any Sex"
        var ageText = "Any Age"
        
        for tag in tags {
            switch tag {
            case .beginner:     stageText = tagToString(tag)
            case .intermediate: stageText = tagToString(tag)
            case .advanced:     stageText = tagToString(tag)
            case .strength:     typeText = tagToString(tag)
            case .hypertrophy:  typeText = tagToString(tag)
            case .conditioning: typeText = tagToString(tag)
            case .gym:          apparatusText = tagToString(tag)
            case .barbell:      apparatusText = tagToString(tag)
            case .dumbbell:     apparatusText = tagToString(tag)
            case .minimal:      apparatusText = tagToString(tag)
            case .threeDays:    daysText = tagToString(tag)
            case .fourDays:     daysText = tagToString(tag)
            case .fiveDays:     daysText = tagToString(tag)
            case .sixDays:      daysText = tagToString(tag)
            case .male:         sexText = tagToString(tag)
            case .female:       sexText = tagToString(tag)
            case .ageUnder40:   ageText = tagToString(tag)
            case .age40s:       ageText = tagToString(tag)
            case .age50s:       ageText = tagToString(tag)
            }
        }
        
        stageButton.setTitle(stageText + " ^", for: .normal)
        typeButton.setTitle(typeText + " ^", for: .normal)
        daysButton.setTitle(daysText + " ^", for: .normal)
        apparatusButton.setTitle(apparatusText + " ^", for: .normal)
        sexButton.setTitle(sexText + " ^", for: .normal)
        ageButton.setTitle(ageText + " ^", for: .normal)
        
        let app = UIApplication.shared.delegate as! AppDelegate
        programs = app.programs.filter {$0.tags.isSuperset(of: tags)}
        tableView.reloadData()
    }
    
    private func tagToString(_ tag: Program.Tags) -> String {
        switch tag {
        case .beginner:     return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced:     return "Advanced"
        case .strength:     return "Strength"
        case .hypertrophy:  return "Hypertrophy"
        case .conditioning: return "Conditioning"
        case .gym:          return "Gym"
        case .barbell:      return "Barbell"
        case .dumbbell:     return "Dumbbell"
        case .minimal:      return "Minimal"
        case .threeDays:    return "3 Days/Week"
        case .fourDays:     return "4 Days/Week"
        case .fiveDays:     return "5 Days/Week"
        case .sixDays:      return "6 Days/Week"
        case .male:         return "Male"
        case .female:       return "Female"
        case .ageUnder40:   return "Under 40"
        case .age40s:       return "40s"
        case .age50s:       return "50s"
        }
    }
    
    private func stringToTag(_ str: String) -> Program.Tags {
        switch str {
        case "Beginner":        return .beginner
        case "Intermediate":    return .intermediate
        case "Advanced":        return .advanced
        case "Strength":        return .strength
        case "Hypertrophy":     return .hypertrophy
        case "Conditioning":    return .conditioning
        case "Gym":             return .gym
        case "Barbell":         return .barbell
        case "Dumbbell":        return .dumbbell
        case "Minimal":         return .minimal
        case "3 Days/Week":     return .threeDays
        case "4 Days/Week":     return .fourDays
        case "5 Days/Week":     return .fiveDays
        case "6 Days/Week":     return .sixDays
        case "Male":            return .male
        case "Female":          return .female
        case "Under 40":        return .ageUnder40
        case "40s":             return .age40s
        case "50s":             return .age50s
        default: assert(false, "\(str) is an unknown tag"); abort()
        }
    }
    
    @IBOutlet private var stageButton: UIButton!
    @IBOutlet private var typeButton: UIButton!
    @IBOutlet private var daysButton: UIButton!
    @IBOutlet private var apparatusButton: UIButton!
    @IBOutlet private var sexButton: UIButton!
    @IBOutlet private var ageButton: UIButton!
    
    @IBOutlet private var tableView: UITableView!
    
    private var tags: Swift.Set<Program.Tags> = [.beginner, .strength, .threeDays, .ageUnder40]
    private var programs: [Program] = []
}

