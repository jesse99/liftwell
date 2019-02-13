//  Created by Jesse Jones on 1/13/19.
//  Copyright © 2019 MushinApps. All rights reserved.
import Foundation

func Move1() -> Program {
    let exercises = [
        // Stength and Body Control
        bodyweight("Wrist Mobility",  "GMB Wrist Prep",    1, secs: 2*60, targetSecs: 5*60),
        bodyweight("Scapular Shrugs", "Scapular Shrugs",   "10".x(3), restMins: 0.5),
        bodyweight("Scapular Rows",   "Scapular Rows",     "10".x(3), restMins: 0.5),
        bodyweight("Plank",           "Front Plank",       1, secs: 10, targetSecs: 60),
        bodyweight("Reverse Plank",   "Reverse Plank",     1, secs: 10, targetSecs: 60),
        bodyweight("Bear Crawl",      "Bear Crawl",        1, secs: 2*60),
        bodyweight("Sitting Squat",   "Third World Squat", 3, secs: 10, targetSecs: 30),
        
        // Stretching and Mobility
        bodyweight("Child's Pose",   "Child's Pose", 1, secs: 30, targetSecs: 60),
        bodyweight("Child's Pose with Lat Stretch",   "Child's Pose with Lat Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Wall Extensions (floor)", "Wall Extensions (floor)",   "10".x(1), restMins: 0.5),
        bodyweight("Chest Wall Stretch",   "Chest Wall Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Bent-legged Calf Stretch",   "Bent-legged Calf Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Hamstring Lunge Stretch",   "Hamstring Lunge Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Front Scale Leg Lifts", "Front Scale Leg Lifts",   "10".x(3), restMins: 0.25),
        bodyweight("Hip Flexor Lunge Stretch",   "Hip Flexor Lunge Stretch", 2, secs: 30, targetSecs: 60),
    ]
    let workouts = [
        Workout("Stength and Body Control", ["Wrist Mobility", "Scapular Shrugs", "Scapular Rows", "Plank", "Reverse Plank", "Bear Crawl", "Sitting Squat"], scheduled: false, optional: []),
        Workout("Stretching and Mobility", ["Child's Pose", "Child's Pose with Lat Stretch", "Wall Extensions (floor)", "Chest Wall Stretch", "Bent-legged Calf Stretch", "Hamstring Lunge Stretch", "Front Scale Leg Lifts", "Hip Flexor Lunge Stretch"], scheduled: false, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .strength, .minimal, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is a bodyweight fitness [program](https://www.reddit.com/r/bodyweightfitness/wiki/move) from reddit. It will help build strength but also has an emphasis on mobility and flexibility. It's suitable for beginners and can be run for two years or even longer. It's divided up into five phases. The [first phase](https://www.reddit.com/r/bodyweightfitness/wiki/move/phase1) looks like this:

**Stength and Body Control**
* Wrist Mobility 2-5 mins
* Scapula Shrugs 3x10
* Scapula Rows 3x10
* Plank 10-60s
* Reverse Plank 10-60s
* Bear Crawl 2 mins (counting any rest you may need)
* Sitting Squat 3x10-30s

**Stretching and Mobility**
* Child's Pose 30-60s
* Child's Pose with Lat Stretch 30-60s (for each side)
* Wall Extensions 1x10
* Chest Wall Stretch 30-60s (for each side)
* Calf Stretch 30-60s (for each side)
* Hamstring Lunge 30-60s (for each side)
* Leg Lifts 3x10 (alternate sides)
* Hip Flexor Stretch 30-60s

**Notes**
* Move on to phase two when you can do the plank and reverse plank for 30s.
* But spend at least two weeks on this phase.
* Do the above 3x a week.
"""
    return Program("Body Weight Move 1", workouts, exercises, tags, description, maxWorkouts: nil, nextProgram: "Body Weight Move 2")
}
