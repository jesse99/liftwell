//  Created by Jesse Jones on 10/13/18.
//  Copyright © 2018 MushinApps. All rights reserved.
/// Types used to manage weights.
import Foundation
import os.log

protocol WeightGenerator {
    func first() -> (Double, String)
    
    // These are ordered by complexity, e.g. the combinations with the fewest plates are returned first
    func next() -> (Double, String)?
}

// TODO:
// units
public struct Weight: CustomStringConvertible {
    public struct Info: Storable {
        // 145.0
        public let weight: Double
        
        // "145 lbs"
        public let text: String
        
        // "45 + 5"
        public let plates: String
        
        public init(weight: Double, text: String, plates: String) {
            self.weight = weight
            self.text = text
            self.plates = plates
        }
        
        public init(from store: Store) {
            self.weight = store.getDbl("weight")
            self.text = store.getStr("text")
            self.plates = store.getStr("plates")
        }
        
        public func save(_ store: Store) {
            store.addDbl("weight", weight)
            store.addStr("text", text)
            store.addStr("plates", plates)
        }
    }
    
    init(_ weight: Double, _ apparatus: Apparatus) {
        self.weight = weight
        self.apparatus = apparatus
    }
    
    /// Best effort at returning something closest to weight.
    func closest() -> Info {
        let candidates = closestRange()
        
        var delta = Double.infinity
        var index = candidates.count
        for (i, x) in candidates.enumerated() {
            let d = abs(x.weight - weight)
            if d < delta {
                delta = d
                index = i
            }
        }
        
        return candidates[index]
    }
    
    /// Best effort at returning something closest to weight while remaining below another weight.
    func closest(below: Double) -> Info {
        let candidates = closestRange()
        let limit = Weight(below, apparatus).closest().weight
        
        var delta = Double.infinity
        var index = 0
        for (i, x) in candidates.enumerated() {
            let d = abs(x.weight - weight)
            if d < delta && x.weight < limit {
                delta = d
                index = i
            }
        }
        
        return candidates[index]
    }
    
    /// Best effort at returning something closest to weight while remaining above another weight.
    func closest(above: Double) -> Info {
        let candidates = closestRange()
        let limit = Weight(above, apparatus).closest().weight
        
        var delta = Double.infinity
        var index = candidates.count - 1
        for (i, x) in candidates.enumerated() {
            let d = abs(x.weight - weight)
            if d < delta && x.weight > limit {
                delta = d
                index = i
            }
        }
        
        return candidates[index]
    }
    
    /// Returns the weight immediately above weight.
    func nextWeight() -> Double {
        let temp = Weight(weight + 0.0001, apparatus)
        return temp.closest(above: weight).weight
    }
    
    /// Returns the weight immediately below weight.
    func prevWeight() -> Double {
        let temp = Weight(weight - 0.0001, apparatus)
        return temp.closest(below: weight).weight
    }
    
    public var description: String {
        return String(format: "%.3f", weight)
    }
    
    static func friendlyStr(_ weight: Double) -> String {
        var result: String
        
        // Note that weights are always stored as lbs internally.
        //        let app = UIApplication.shared.delegate as! AppDelegate
        //        switch app.units()
        //        {
        //        case .imperial:
        //            // Kind of annoying to use three decimal places but people
        //            // sometimes use 0.625 fractional plates (5/8 lb).
        result = String(format: "%.3f", weight)
        //
        //        case .metric:
        //            result = String(format: "%.2f", arguments: [weight*Double.lbToKg])
        //        }
        
        while result.hasSuffix("0") {
            let start = result.index(result.endIndex, offsetBy: -1)
            let end = result.endIndex
            result.removeSubrange(start..<end)
        }
        if result.hasSuffix(".") {
            let start = result.index(result.endIndex, offsetBy: -1)
            let end = result.endIndex
            result.removeSubrange(start..<end)
        }
        
        return result
    }
    
    static func friendlyUnitsStr(_ weight: Double, plural: Bool = true) -> String {
        if plural {
            return Weight.friendlyStr(weight) + " lbs"  // TODO: also kg
        } else {
            return Weight.friendlyStr(weight) + " lb"
        }
    }
    
    // Returns a range about weight sorted from smallest to largest.
    private func closestRange() -> [Info] {
        switch apparatus {
        case .barbell(bar: let barWeight, collar: let collarWeight, plates: let plates, bumpers: let bumpers, magnets: let magnets):
            let limit = 18
            let smallest = 2*min(plates.first ?? 45.0, bumpers.first ?? 45.0, magnets.first ?? 45.0)
            let floor = max(barWeight, weight - Double(limit/2)*smallest)
            
            // This can get a bit squirrelly when magnets are used because they can be much smaller than the
            // smallest plate and when bumpers are used because we don't want to just use the bare bar and the
            // smallest bumper can be a lot larger than the smallest plate. So we'll just find a bunch of
            // candidates about the target weight and select lowest, closest, and upper from those.
            var candidates: [Info] = []
            for n in 0..<limit {
                let x = findPairedPlates(floor + Double(n)*smallest, barWeight, collarWeight, plates, bumpers, magnets)
                candidates.append(x)
            }
            
            return candidates
            
        case .pairedPlates(plates: let plates):
            let limit = 18
            let smallest = 2*(plates.first ?? 45.0)
            let floor = max(0.0, weight - Double(limit/2)*smallest)
            
            var candidates: [Info] = []
            for n in 0..<limit {
                let x = findPairedPlates(floor + Double(n)*smallest, 0.0, 0.0, plates, [], [])
                candidates.append(x)
            }
            
            return candidates
            
        case .singlePlates(plates: let plates):
            let limit = 40
            let smallest = plates.first ?? 5.0
            
            var candidates: [Info] = []
            for n in 0..<limit {
                let x = findSinglePlates(Double(n)*smallest, plates)
                candidates.append(x)
            }
            
            return candidates
            
        case .dumbbells(let weights, let magnets):
            return findDumbbells(weights, magnets, multipler: 1)
            
        case .machine(range1: let range1, range2: let range2, extra: let inExtra):
            var extra = inExtra
            if !extra.contains(0.0) {
                extra.append(0.0)
            }
            
            var infos: [Info] = []
            if range1.step > 0.0 {
                infos.append(contentsOf: findMachineInfos(range1, extra))
            }
            if range2.step > 0.0 {
                infos.append(contentsOf: findMachineInfos(range2, extra))
            }
            infos.sort {$0.weight < $1.weight}
            return infos
        }
    }
    
    private func findDumbbells(_ weights: [Double], _ magnets: [Double], multipler: Double) -> [Info] {
        var infos: [Info] = []
        
        let magnets2 = [0.0] + magnets
        for weight in weights {
            for magnet1 in magnets2 {
                for magnet2 in magnets2 {   // we allow 0, 1, or 2 magnets
                    var plates = Weight.friendlyUnitsStr(weight, plural: false)
                    if magnet1 != 0.0 {
                        plates += " + " + Weight.friendlyStr(magnet1)
                    }
                    
                    if magnet2 == 0.0 {
                        let total = multipler*(weight+magnet1)
                        let text = Weight.friendlyUnitsStr(total)
                        infos.append(Info(weight: total, text: text, plates: plates))
                    } else if magnet2 > magnet1 {
                        let total = multipler*(weight+magnet1+magnet2)
                        let text = Weight.friendlyUnitsStr(total)
                        plates += " + " + Weight.friendlyStr(magnet2)
                        infos.append(Info(weight: total, text: text, plates: plates))
                    }
                }
            }
        }
        infos.sort {$0.weight < $1.weight}
        
        return infos
    }
    
    private func findMachineInfos(_ range: MachineRange, _ extra: [Double]) -> [Info] {
        var infos: [Info] = []
        
        var w = range.min
        while w <= range.max {
            for e in extra {
                let candidate = w + e
                infos.append(Info(weight: candidate, text: Weight.friendlyUnitsStr(candidate), plates: ""))
            }
            w += range.step
        }
        
        return infos
    }
    
    private func findPairedPlates(_ target: Double, _ barWeight: Double, _ collarWeight: Double, _ plates: [Double], _ bumpers: [Double], _ magnets: [Double]) -> Info {
        var used: [(Double, String)] = []
        var sum = barWeight + 2*collarWeight
        
        var candidates = bumpers.map {($0, "bumper")}
        for p in plates {
            if !candidates.contains(where: {(x, _) -> Bool in x == p}) {
                candidates.append((p, "plate"))
            }
        }
        for m in magnets {
            if !candidates.contains(where: {(x, _) -> Bool in x == m}) {
                candidates.append((m, "magnet"))
            }
        }
        candidates.sort {$0.0 < $1.0}
        
        // Biggest plate can be added as many times as neccesary.
        if let (last, kind) = candidates.last {
            while sum + 2*last <= target {
                sum += 2*last
                used.append((last, kind))
            }
        }
        
        // Remaining plates can be added up to 2x.
        var addedMagnet = false
        for (plate, kind) in candidates.reversed() {
            if kind != "magnet" || (!used.isEmpty && !addedMagnet) {  // magnets require a plate and are only added once
                if sum + 2*plate <= target {
                    sum += 2*plate
                    used.append((plate, kind))
                    if kind == "magnet" {
                        addedMagnet = true
                    }
                }
                
                if kind != "magnet" {
                    if sum + 2*plate <= target {
                        sum += 2*plate
                        used.append((plate, kind))
                    }
                }
            }
        }
        
        // If there are bumpers then make sure that the user isn't using just the bar or a baby plate (or low weight deadlifts suck).
        if let first = bumpers.first, sum < barWeight + 2*collarWeight + 2*first {
            sum = barWeight + 2*collarWeight + 2*first
            used = [(first, "bumper")]
        }
        
        // Only use collars if we used a plate.
        if used.isEmpty {
            sum -= 2*collarWeight
        }
        
        return Info(weight: sum, text: Weight.friendlyUnitsStr(sum), plates: Weight.platesStr(used))
    }
    
    private func findSinglePlates(_ target: Double, _ plates: [Double]) -> Info {
        var used: [(Double, String)] = []
        var sum = 0.0
        
        var candidates: [(Double, String)] = []
        for p in plates {
            if !candidates.contains(where: {(x, _) -> Bool in x == p}) {
                candidates.append((p, "plate"))
            }
        }
        candidates.sort {$0.0 < $1.0}
        
        // Biggest plate can be added as many times as neccesary.
        if let (last, kind) = candidates.last {
            while sum + last <= target {
                sum += last
                used.append((last, kind))
            }
        }
        
        // Remaining plates can be added up to 2x.
        for (plate, kind) in candidates.reversed() {
            if sum + plate <= target {
                sum += plate
                used.append((plate, kind))
            }
            
            if sum + plate <= target {
                sum += plate
                used.append((plate, kind))
            }
        }
        
        return Info(weight: sum, text: Weight.friendlyUnitsStr(sum), plates: Weight.platesStr(used))
    }
    
    private static func platesStr(_ plates: [(Double, String)]) -> String {
        if plates.count == 0 {
            return "no plates"
            
            // "45 lb plate"
        } else if plates.count == 1 {
            return "\(Weight.friendlyUnitsStr(plates[0].0, plural: false)) \(plates[0].1)"
            
        } else {
            var s = plates.reversed().map {(w) -> String in Weight.friendlyStr(w.0)}
            
            // "2 10s"
            // "10 + 5 + 2.5"
            var text = ""
            while let plate = s.popLast() {
                var count = 1
                while let plate2 = s.last, plate2 == plate {
                    count += 1
                    _ = s.popLast()
                }
                
                if !text.isEmpty {
                    text += " + "
                }
                if count == 1 {
                    text += plate
                } else {
                    text += "\(count) \(plate)s"
                }
            }
            
            return text
        }
    }
    
    private let weight: Double
    private let apparatus: Apparatus
}

//func daysAgo(_ exerciseName: String) -> Int {
//    switch findVariableWeightSetting(exerciseName) {
//    case .right(let setting):
//        let weeks = Int(Date().daysSinceDate(setting.updatedWeight))
//        return weeks
//
//    case .left(_):
//        return 0
//    }
//}

