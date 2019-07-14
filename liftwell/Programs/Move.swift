//  Created by Jesse Jones on 1/13/19.
//  Copyright © 2019 MushinApps. All rights reserved.
import Foundation

func Move1() -> Program {
    let exercises = [
        // Strength and Body Control
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
        Workout("Strength and Body Control", ["Wrist Mobility", "Scapular Shrugs", "Scapular Rows", "Plank", "Reverse Plank", "Bear Crawl", "Sitting Squat"], scheduled: false, optional: []),
        Workout("Stretching and Mobility", ["Child's Pose", "Child's Pose with Lat Stretch", "Wall Extensions (floor)", "Chest Wall Stretch", "Bent-legged Calf Stretch", "Hamstring Lunge Stretch", "Front Scale Leg Lifts", "Hip Flexor Lunge Stretch"], scheduled: false, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .strength, .minimal, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is a bodyweight fitness [program](https://www.reddit.com/r/bodyweightfitness/wiki/move) from reddit. It will help build strength but also has an emphasis on mobility and flexibility. It's suitable for beginners and can be run for two years or even longer. It's divided up into five phases. The [first phase](https://www.reddit.com/r/bodyweightfitness/wiki/move/phase1) looks like this:

**Strength and Body Control**
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

func Move2() -> Program {
    let exercises = [
        // Strength and Body Control
        bodyweight("Wrist Mobility",  "GMB Wrist Prep",    1, secs: 5*60),
        bodyweight("Shoulder Shrug Circles", "Shoulder Rolls",   "10".x(1), restMins: 0.5),
        bodyweight("Plank",           "Front Plank",       1, secs: 10, targetSecs: 60),
        bodyweight("Reverse Plank",   "Reverse Plank",     1, secs: 10, targetSecs: 60),
        bodyweight("Hollow Body Hold",   "Hollow Body Hold",     1, secs: 10, targetSecs: 60),
        
        bodyweight("Frog Stance",  "Frog Stance",    1, secs: 5*60),

        bodyweight("Vertical Pushup",  "Vertical Pushup", "5-8".x(3), restMins: 1.5, main: true,                                  nextExercise: "Incline Pushup"),
        bodyweight("Incline Pushup",   "Incline Pushup",  "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Vertical Pushup", nextExercise: "Pushup"),
        bodyweight("Pushup",           "Pushup",          "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Incline Pushup",  nextExercise: "Diamond Pushup"),
        bodyweight("Diamond Pushup",   "Diamond Pushup",  "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Pushup"),

        bodyweight("Vertical Rows",   "Vertical Rows",   "5-8".x(3), restMins: 1.5, main: true,                                nextExercise: "Incline Rows"),
        bodyweight("Incline Rows",    "Incline Rows",    "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Vertical Rows", nextExercise: "Horizontal Rows"),
        bodyweight("Horizontal Rows", "Horizontal Rows", "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Incline Rows"),

        bodyweight("Assisted Squat",       "Assisted Squat",    "5-8".x(3), restMins: 1.5, main: true,                                 nextExercise: "Heel Supported Squat"),
        bodyweight("Heel Supported Squat", "Body-weight Squat", "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Assisted Squat", nextExercise: "Squat"),
        bodyweight("Squat",                "Body-weight Squat", "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Heel Supported Squat", nextExercise: "Close Squat"),
        bodyweight("Close Squat",          "Body-weight Squat", "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Squat"),

        bodyweight("Bear Crawl",      "Bear Crawl",        1, secs: 2*60),

        // Stretching and Mobility
        bodyweight("Child's Pose",   "Child's Pose", 1, secs: 30, targetSecs: 60),
        bodyweight("Child's Pose with Lat Stretch",   "Child's Pose with Lat Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Wall Extensions", "Wall Extensions",   "10".x(1), restMins: 0.5),
        bodyweight("Chest Wall Stretch",   "Chest Wall Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Bent-legged Calf Stretch",   "Bent-legged Calf Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Hamstring Lunge Stretch",   "Hamstring Lunge Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Front Scale Leg Lifts", "Front Scale Leg Lifts",   "10".x(3), restMins: 0.25),
        bodyweight("Ido's Squat Routine",   "Ido's Squat Routine", "1".x(1), restMins: 0.5),
        bodyweight("Hip Flexor Lunge Stretch",   "Hip Flexor Lunge Stretch", 2, secs: 30, targetSecs: 60),
        ]
    let workouts = [
        Workout("Strength and Body Control", ["Wrist Mobility", "Shoulder Shrug Circles", "Plank", "Reverse Plank", "Hollow Body Hold", "Frog Stance", "Vertical Pushup", "Incline Pushup", "Pushup", "Diamond Pushup", "Vertical Rows", "Incline Rows", "Horizontal Rows", "Assisted Squat", "Heel Supported Squat", "Squat", "Close Squat", "Bear Crawl"], scheduled: false, optional: ["Incline Pushup", "Pushup", "Diamond Pushup", "Incline Rows", "Horizontal Rows", "Heel Supported Squat", "Squat", "Close Squat"]),
        Workout("Stretching and Mobility", ["Child's Pose", "Child's Pose with Lat Stretch", "Wall Extensions", "Chest Wall Stretch", "Bent-legged Calf Stretch", "Hamstring Lunge Stretch", "Front Scale Leg Lifts", "Ido's Squat Routine", "Hip Flexor Lunge Stretch"], scheduled: false, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .strength, .minimal, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is a bodyweight fitness [program](https://www.reddit.com/r/bodyweightfitness/wiki/move) from reddit. It will help build strength but also has an emphasis on mobility and flexibility. It's suitable for beginners and can be run for two years or even longer. It's divided up into five phases. This is the [second phase](https://www.reddit.com/r/bodyweightfitness/wiki/move/phase2) and is where skill work begins:

**Strength and Body Control**
* Wrist Mobility 5 mins
* Shoulder Shrug Circles 1x10
* Plank 10-60s
* Reverse Plank 10-60s
* Hollow Body Hold 10-60s
* Frog Stance 5min
* Pushup Progression 3x5-8
* Rowing Progression 3x5-8
* Squat Progression 3x5-8
* Bear Crawl 2min

**Stretching and Mobility**
* Child's Pose 30-60s
* Child's Pose with Lat Stretch 30-60s (for each side)
* Wall Extensions 1x10
* Chest Wall Stretch 30-60s (for each side)
* Calf Stretch 30-60s (for each side)
* Hamstring Lunge 30-60s (for each side)
* Leg Lifts 3x10 (alternate sides)
* Ido's Squat Routine
* Hip Flexor Stretch 30-60s

**Notes**
* Move on to phase three when you can do horizontal rows and diamond pushups with good form.
* This phase introduces progressions: do the hardest version of the exercise that you can do for 3 sets of 5 reps. Once you can do 8 reps move on to the next harder exercise.
* Do the above 3x a week.
"""
    return Program("Body Weight Move 2", workouts, exercises, tags, description, maxWorkouts: nil, nextProgram: "Body Weight Move 3")
}

func Move3() -> Program {
    let exercises: [Exercise] = [
        // Dynamic Stretches
        bodyweight("Shoulder Rolls",          "Shoulder Rolls", "1".x(3), restMins: 0.0, main: false),
        bodyweight("Kneeling Shoulder Rolls", "Kneeling Shoulder Rolls", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Reverse Kneeling Shoulder Rolls", "Kneeling Shoulder Rolls", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Scapular Shrugs",         "Scapular Shrugs", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Cat Camels",              "Cat Camels", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Overhead Pull Down",      "Overhead Pull Down (band)", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Band Pull Apart",         "Band Pull Apart", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Shoulder Dislocate",      "Shoulder Dislocate", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("GMB Wrist Prep",          "GMB Wrist Prep", "10-30".x(1), restMins: 0.0, main: false),

        // Warmup
        bodyweight("Plank",            "Front Plank",      1, secs: 10, targetSecs: 60),
        bodyweight("Reverse Plank",    "Reverse Plank",    1, secs: 10, targetSecs: 60),
        bodyweight("Hollow Body Hold", "Hollow Body Hold", 1, secs: 10, targetSecs: 60),
        bodyweight("Arch Body Hold",   "Arch Hold",        1, secs: 10, targetSecs: 60),
        bodyweight("Side Plank",       "Side Plank",       2, secs: 10, targetSecs: 60),

        // Strength Work
        bodyweight("Stomach to Wall Handstand",     "Stomach to Wall Handstand", 1, secs: 5*60, targetSecs: 10*60),

        bodyweight("Foot Supported L-sit",         "Foot Supported L-sit", "5-8".x(3), restMins: 1.0, main: true, nextExercise: "One-Leg Foot Supported L-sit"),
        bodyweight("One-Leg Foot Supported L-sit", "One-Leg Foot Supported L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Foot Supported L-sit", nextExercise: "Elevated Tuck L-Sit"),
        bodyweight("Elevated Tuck L-Sit",          "Tuck L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "One-Leg Foot Supported L-sit",  nextExercise: "Tuck L-sit"),
        bodyweight("Tuck L-sit",                   "Tuck L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Elevated Tuck L-Sit", nextExercise: "One-Leg L-sit"),
        bodyweight("One-Leg L-sit",                "One-Leg L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Tuck L-sit",  nextExercise: "L-sit"),
        bodyweight("L-sit",                        "L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "One-Leg L-sit"),

        bodyweight("Dips",                      "Dips", "5-8".x(3), restMins: 1.0, main: true, nextExercise: "Pike Pushup"),
        bodyweight("Pike Pushup",               "Pike Pushup", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Dips", nextExercise: "Elevated Pike Pushup"),
        bodyweight("Elevated Pike Pushup",      "Pike Pushup", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Pike Pushup", nextExercise: "Negative Handstand Pushup"),
        bodyweight("Negative Handstand Pushup", "Negative Handstand Pushup", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Elevated Pike Pushup", nextExercise: "Handstand Pushup"),
        bodyweight("Handstand Pushup",          "Handstand Pushup", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Negative Handstand Pushup"),
        
        bodyweight("Scapular Pulls",    "Scapular Pulls", "5-8".x(3), restMins: 1.5, main: true, nextExercise: "Arch Hangs"),
        bodyweight("Arch Hangs",        "Arch Hangs",     "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Scapular Pulls", nextExercise: "Pull-up Negatives"),
        bodyweight("Pull-up Negatives", "Pullup",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Arch Hangs", nextExercise: "Pullup"),
        bodyweight("Pullup",            "Pullup",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Pull-up Negatives", nextExercise: "Weighted Pull-ups"),
        bodyweight("Weighted Pull-ups", "Pullup",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Pullup"),

        bodyweight("Vertical Pushup",        "Vertical Pushup", "8-12".x(3), restMins: 1.5, main: true, nextExercise: "Incline Pushup"),
        bodyweight("Incline Pushup",         "Incline Pushup",  "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Vertical Pushup", nextExercise: "Pushup"),
        bodyweight("Pushup",                 "Pushup",          "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Incline Pushup",  nextExercise: "Diamond Pushup"),
        bodyweight("Diamond Pushup",         "Diamond Pushup",  "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Pushup", nextExercise: "Pseudo Planche Pushups"),
        bodyweight("Pseudo Planche Pushups", "Pseudo Planche Pushups", "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Diamond Pushup"),
        
        bodyweight("Vertical Rows",         "Vertical Rows",   "8-12".x(3), restMins: 1.5, main: true, nextExercise: "Incline Rows"),
        bodyweight("Incline Rows",          "Incline Rows",    "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Vertical Rows", nextExercise: "Horizontal Rows"),
        bodyweight("Horizontal Rows",       "Horizontal Rows", "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Incline Rows", nextExercise: "Wide Rows"),
        bodyweight("Wide Rows",             "Wide Rows",       "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Horizontal Rows", nextExercise: "Weighted Inverted Row"),
        bodyweight("Weighted Inverted Row", "Inverted Row",    "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Wide Rows"),

        bodyweight("Left Step-ups",  "Deep Step-ups", "5-8".x(3), restMins: 1.5, main: true),
        bodyweight("Right Step-ups", "Deep Step-ups", "5-8".x(3), restMins: 1.5, main: true),

        // Stretching and Mobility
        bodyweight("Child's Pose",   "Child's Pose", 1, secs: 30, targetSecs: 60),
        bodyweight("Child's Pose with Lat Stretch",   "Child's Pose with Lat Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Wall Extensions", "Wall Extensions",   "10".x(1), restMins: 0.5),
        bodyweight("Chest Wall Stretch",   "Chest Wall Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Bent-legged Calf Stretch",   "Bent-legged Calf Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Hamstring Lunge Stretch",   "Hamstring Lunge Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Front Scale Leg Lifts", "Front Scale Leg Lifts",   "10".x(3), restMins: 0.25),
        bodyweight("Ido's Squat Routine",   "Ido's Squat Routine", "1".x(1), restMins: 0.5),
        bodyweight("Hip Flexor Lunge Stretch",   "Hip Flexor Lunge Stretch", 2, secs: 30, targetSecs: 60)
        ]

    
    let workouts = [
        Workout("Warmup", ["Shoulder Rolls", "Kneeling Shoulder Rolls", "Reverse Kneeling Shoulder Rolls", "Scapular Shrugs", "Cat Camels", "Overhead Pull Down", "Band Pull Apart", "Shoulder Dislocate", "GMB Wrist Prep", "Plank", "Reverse Plank", "Hollow Body Hold", "Arch Body Hold", "Side Plank"], scheduled: false, optional: []),

        Workout("Strength", ["Stomach to Wall Handstand", "Foot Supported L-sit", "One-Leg Foot Supported L-sit", "Elevated Tuck L-Sit", "Tuck L-sit", "One-Leg L-sit", "L-sit", "Dips", "Pike Pushup", "Elevated Pike Pushup", "Negative Handstand Pushup", "Handstand Pushup", "Scapular Pulls", "Arch Hangs", "Pull-up Negatives", "Pullup", "Weighted Pull-ups", "Vertical Pushup", "Incline Pushup", "Pushup", "Diamond Pushup", "Pseudo Planche Pushups", "Vertical Rows", "Incline Rows", "Horizontal Rows", "Wide Rows", "Weighted Inverted Row", "Left Step-ups", "Right Step-ups"],
            scheduled: false, optional: ["One-Leg Foot Supported L-sit", "Elevated Tuck L-Sit", "Tuck L-sit", "One-Leg L-sit", "L-sit", "Pike Pushup", "Elevated Pike Pushup", "Negative Handstand Pushup", "Handstand Pushup", "Arch Hangs", "Pull-up Negatives", "Pullup", "Weighted Pull-ups", "Incline Pushup", "Pushup", "Diamond Pushup", "Pseudo Planche Pushups", "Incline Rows", "Horizontal Rows", "Wide Rows", "Weighted Inverted Row"]),
        
        Workout("Stretching and Mobility", ["Child's Pose", "Child's Pose with Lat Stretch", "Wall Extensions", "Chest Wall Stretch", "Bent-legged Calf Stretch", "Hamstring Lunge Stretch", "Front Scale Leg Lifts", "Ido's Squat Routine", "Hip Flexor Lunge Stretch"], scheduled: false, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .strength, .minimal, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is a bodyweight fitness [program](https://www.reddit.com/r/bodyweightfitness/wiki/move) from reddit. It will help build strength but also has an emphasis on mobility and flexibility. It's suitable for beginners and can be run for two years or even longer. It's divided up into five phases. This is the [third phase](https://www.reddit.com/r/bodyweightfitness/wiki/move/phase3) and amps up the strength work:

**Dynamic Stretches**
* Shoulder Rolls 3
* Kneeling Shoulder Rolls 5-10
* Reverse Kneeling Shoulder Rolls 5-10
* Scapular Shrugs 5-10
* Cat Camels 5-10
* Overhead Pull Down 5-10
* Band Pull Apart 5-10
* Shoulder Dislocate 5-10
* GMB Wrist Prep 10-30

**Warmup**
* Plank 10-60s
* Reverse Plank 10-60s
* Hollow Body Hold 10-60s
* Arch Body Hold 10-60s
* Side Plank 10-60s (each side)

**Strength Work**
* Stomach to Wall Handstand 5-10 min
* L-sit progression 3x5-8
* Handstand Pushup progression 3x5-8 (pair 1)
* Pullup progression 3x5-8
* Pushup progression 3x8-12 (pair 2)
* Row progression 3x8-12
* Step up left leg 3x5-8 (pair 3)
* Step up right leg 3x5-8

**Stretching and Mobility**
* Child's Pose 30-60s
* Child's Pose with Lat Stretch 30-60s (each side)
* Wall Extensions 1x10
* Chest Wall Stretch 30-60s (each side)
* Calf Stretch 30-60s (each side)
* Hamstring Lunge 30-60s (each side)
* Leg Lifts 3x10 (alternate sides)
* Ido's Squat Routine
* Hip Flexor Stretch 30-60s

**Notes**
* For the pairs do a set of the first pair, a set of the second pair, rest, and repeat until you've done all the sets.
* The rep ranges for pushups and rows changes from 5-8 to 8-12. It's OK if that means you need to drop back to an easier version of the exercise.
* Move on to phase four after three months.
* Do the above 3x a week.
"""
    return Program("Body Weight Move 3", workouts, exercises, tags, description, maxWorkouts: 3*3*4, nextProgram: "Body Weight Move 4")
}

func Move4() -> Program {
    let exercises: [Exercise] = [
        // Strength Warmup
        bodyweight("Shoulder Rolls",          "Shoulder Rolls", "1".x(3), restMins: 0.0, main: false),
        bodyweight("Kneeling Shoulder Rolls", "Kneeling Shoulder Rolls", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Reverse Kneeling Shoulder Rolls", "Kneeling Shoulder Rolls", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Scapular Shrugs",         "Scapular Shrugs", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Cat Camels",              "Cat Camels", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Overhead Pull Down",      "Overhead Pull Down (band)", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Band Pull Apart",         "Band Pull Apart", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("Shoulder Dislocate",      "Shoulder Dislocate", "5-10".x(1), restMins: 0.0, main: false),
        bodyweight("GMB Wrist Prep",          "GMB Wrist Prep", "10-30".x(1), restMins: 0.0, main: false),

        bodyweight("Wall Extensions",    "Wall Extensions",  "10".x(1), restMins: 0.5),
        bodyweight("Plank",              "Front Plank",      1, secs: 10, targetSecs: 60),
        bodyweight("Reverse Plank",      "Reverse Plank",    1, secs: 10, targetSecs: 60),
        bodyweight("Hollow Body Hold 1", "Hollow Body Hold", 1, secs: 10, targetSecs: 60),
        bodyweight("Arch Body Hold",     "Arch Hold",        1, secs: 10, targetSecs: 60),
        bodyweight("Side Plank",         "Side Plank",       2, secs: 10, targetSecs: 60),
        
        // Strength Work
        bodyweight("Foot Supported L-sit",         "Foot Supported L-sit", "5-8".x(3), restMins: 1.0, main: true, nextExercise: "One-Leg Foot Supported L-sit"),
        bodyweight("One-Leg Foot Supported L-sit", "One-Leg Foot Supported L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Foot Supported L-sit", nextExercise: "Elevated Tuck L-Sit"),
        bodyweight("Elevated Tuck L-Sit",          "Tuck L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "One-Leg Foot Supported L-sit",  nextExercise: "Tuck L-sit"),
        bodyweight("Tuck L-sit",                   "Tuck L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Elevated Tuck L-Sit", nextExercise: "One-Leg L-sit"),
        bodyweight("One-Leg L-sit",                "One-Leg L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Tuck L-sit",  nextExercise: "L-sit"),
        bodyweight("L-sit",                        "L-sit", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "One-Leg L-sit"),
        
        bodyweight("Dips",                      "Dips", "5-8".x(3), restMins: 1.0, main: true, nextExercise: "Pike Pushup"),
        bodyweight("Pike Pushup",               "Pike Pushup", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Dips", nextExercise: "Elevated Pike Pushup"),
        bodyweight("Elevated Pike Pushup",      "Pike Pushup", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Pike Pushup", nextExercise: "Negative Handstand Pushup"),
        bodyweight("Negative Handstand Pushup", "Negative Handstand Pushup", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Elevated Pike Pushup", nextExercise: "Handstand Pushup"),
        bodyweight("Handstand Pushup",          "Handstand Pushup", "5-8".x(3), restMins: 1.0, main: true, prevExercise: "Negative Handstand Pushup"),
        
        bodyweight("Scapular Pulls",    "Scapular Pulls", "5-8".x(3), restMins: 1.5, main: true, nextExercise: "Arch Hangs"),
        bodyweight("Arch Hangs",        "Arch Hangs",     "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Scapular Pulls", nextExercise: "Pull-up Negatives"),
        bodyweight("Pull-up Negatives", "Pullup",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Arch Hangs", nextExercise: "Pullup"),
        bodyweight("Pullup",            "Pullup",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Pull-up Negatives", nextExercise: "Weighted Pull-ups"),
        bodyweight("Weighted Pull-ups", "Pullup",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Pullup"),
        
        bodyweight("Vertical Pushup",        "Vertical Pushup", "8-12".x(3), restMins: 1.5, main: true, nextExercise: "Incline Pushup"),
        bodyweight("Incline Pushup",         "Incline Pushup",  "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Vertical Pushup", nextExercise: "Pushup"),
        bodyweight("Pushup",                 "Pushup",          "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Incline Pushup",  nextExercise: "Diamond Pushup"),
        bodyweight("Diamond Pushup",         "Diamond Pushup",  "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Pushup", nextExercise: "Pseudo Planche Pushups"),
        bodyweight("Pseudo Planche Pushups", "Pseudo Planche Pushups", "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Diamond Pushup"),
        
        bodyweight("Vertical Rows",         "Vertical Rows",   "8-12".x(3), restMins: 1.5, main: true, nextExercise: "Incline Rows"),
        bodyweight("Incline Rows",          "Incline Rows",    "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Vertical Rows", nextExercise: "Horizontal Rows"),
        bodyweight("Horizontal Rows",       "Horizontal Rows", "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Incline Rows", nextExercise: "Wide Rows"),
        bodyweight("Wide Rows",             "Wide Rows",       "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Horizontal Rows", nextExercise: "Weighted Inverted Row"),
        bodyweight("Weighted Inverted Row", "Inverted Row",    "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Wide Rows"),
        
        bodyweight("Left Step-ups",  "Deep Step-ups", "5-8".x(3), restMins: 1.5, main: true),
        bodyweight("Right Step-ups", "Deep Step-ups", "5-8".x(3), restMins: 1.5, main: true),
        
        // Handstand and Mobility
        // Shoulder Rolls through GMB Wrist Prep
        bodyweight("Shoulder Rolls",          "Shoulder Rolls", "1".x(3), restMins: 0.0, main: false),

        bodyweight("Foam Roll Lats",            "Foam Roll Lats", "1".x(1), restMins: 0.5),
        bodyweight("Yuri's Shoulder Band",      "Yuri's Shoulder Band", "1".x(1), restMins: 0.5),
        bodyweight("Rear Delt Band Pull Apart", "Rear Delt Band Pull Apart", "8-15".x(4), restMins: 0.5, main: false),
        bodyweight("Trap-3 Raise",              "Trap-3 Raise", "8-15".x(4), restMins: 0.5, main: false),
        bodyweight("Cuban Rotation",            "Cuban Rotation", "8-15".x(4), restMins: 0.5, main: false),

        bodyweight("Pec Stretch",        "Chest Wall Stretch", 1, secs: 120),
        bodyweight("Lat Stretch",        "Lat Stretch", 1, secs: 120),
        bodyweight("Butcher's Block",    "Butcher's Block", 1, secs: 120),
        bodyweight("Hollow Body Hold 2", "Hollow Body Hold", 3, secs: 10, targetSecs: 60),

        bodyweight("Wall Plank",            "Wall Plank", 1, secs: 5*60, targetSecs: 10*60, nextExercise: "Learn to Bail"),
        bodyweight("Learn to Bail",         "Handstand", 1, secs: 10*60, prevExercise: "Wall Plank", nextExercise: "Stomach to Wall"),
        bodyweight("Stomach to Wall",       "Stomach to Wall Handstand", 1, secs: 20*60, prevExercise: "Learn to Bail", nextExercise: "Wall Scissors"),
        bodyweight("Wall Scissors",         "Wall Scissors", 1, secs: 20*60, prevExercise: "Stomach to Wall", nextExercise: "Heel Pulls"),
        bodyweight("Heel Pulls",            "Heel Pulls", 1, secs: 20*60, prevExercise: "Wall Scissors", nextExercise: "Toe Pulls"),
        bodyweight("Toe Pulls",             "Toe Pulls", 1, secs: 20*60, prevExercise: "Heel Pulls", nextExercise: "Freestanding Practice"),
        bodyweight("Freestanding Practice", "Handstand", 1, secs: 20*60, prevExercise: "Toe Pulls", nextExercise: "Kick Up"),
        bodyweight("Kick Up",               "Handstand", 1, secs: 15*60, prevExercise: "Freestanding Practice"),

        bodyweight("Bent-legged Calf Stretch", "Bent-legged Calf Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Hamstring Lunge Stretch",  "Hamstring Lunge Stretch", 2, secs: 30, targetSecs: 60),
        bodyweight("Front Scale Leg Lifts",    "Front Scale Leg Lifts",   "10".x(3), restMins: 0.25),
        bodyweight("Ido's Squat Routine",      "Ido's Squat Routine", "1".x(1), restMins: 0.5),
        bodyweight("Hip Flexor Lunge Stretch", "Hip Flexor Lunge Stretch", 2, secs: 30, targetSecs: 60)]
    
    let workouts = [
        Workout("Stretching", ["Shoulder Rolls", "Kneeling Shoulder Rolls", "Reverse Kneeling Shoulder Rolls", "Scapular Shrugs", "Cat Camels", "Overhead Pull Down", "Band Pull Apart", "Shoulder Dislocate", "GMB Wrist Prep"], scheduled: false, optional: []),
        
        Workout("Strength Warmup", ["Wall Extensions", "Plank", "Reverse Plank", "Hollow Body Hold", "Arch Body Hold", "Side Plank"], scheduled: false, optional: []),
        
        Workout("Strength Work", ["Foot Supported L-sit", "One-Leg Foot Supported L-sit", "Elevated Tuck L-Sit", "Tuck L-sit", "One-Leg L-sit", "L-sit", "Dips", "Pike Pushup", "Elevated Pike Pushup", "Negative Handstand Pushup", "Handstand Pushup", "Scapular Pulls", "Arch Hangs", "Pull-up Negatives", "Pullup", "Weighted Pull-ups", "Vertical Pushup", "Incline Pushup", "Pushup", "Diamond Pushup", "Pseudo Planche Pushups", "Vertical Rows", "Incline Rows", "Horizontal Rows", "Wide Rows", "Weighted Inverted Row", "Left Step-ups", "Right Step-ups"],
                scheduled: false, optional: ["One-Leg Foot Supported L-sit", "Elevated Tuck L-Sit", "Tuck L-sit", "One-Leg L-sit", "L-sit", "Pike Pushup", "Elevated Pike Pushup", "Negative Handstand Pushup", "Handstand Pushup", "Arch Hangs", "Pull-up Negatives", "Pullup", "Weighted Pull-ups", "Incline Pushup", "Pushup", "Diamond Pushup", "Pseudo Planche Pushups", "Incline Rows", "Horizontal Rows", "Wide Rows", "Weighted Inverted Row"]),
        
        Workout("Handstand and Mobility", ["Foam Roll Lats", "Yuri's Shoulder Band", "Rear Delt Band Pull Apart", "Trap-3 Raise", "Cuban Rotation", "Pec Stretch", "Lat Stretch", "Butcher's Block", "Hollow Body Hold 2", "Wall Plank", "Learn to Bail", "Stomach to Wall", "Wall Scissors", "Heel Pulls", "Toe Pulls", "Freestanding Practice", "Kick Up", "Bent-legged Calf Stretch", "Hamstring Lunge Stretch", "Front Scale Leg Lifts", "Ido's Squat Routine", "Hip Flexor Lunge Stretch"], scheduled: false, optional: ["Learn to Bail", "Stomach to Wall", "Wall Scissors", "Heel Pulls", "Toe Pulls", "Freestanding Practice", "Kick Up"])]
    
    let tags: [Program.Tags] = [.beginner, .strength, .minimal, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is a bodyweight fitness [program](https://www.reddit.com/r/bodyweightfitness/wiki/move) from reddit. It will help build strength but also has an emphasis on mobility and flexibility. It's suitable for beginners and can be run for two years or even longer. It's divided up into five phases. This is the [fourth phase](https://www.reddit.com/r/bodyweightfitness/wiki/move/phase4) and switches to six days a week: do the strength workouts 3x a week and in between do Handstand and Mobility.

**Stretches (do these on both Strength and Handstand days)**
* Shoulder Rolls 3
* Kneeling Shoulder Rolls 5-10
* Reverse Kneeling Shoulder Rolls 5-10
* Scapular Shrugs 5-10
* Cat Camels 5-10
* Overhead Pull Down 5-10
* Band Pull Apart 5-10
* Shoulder Dislocate 5-10
* GMB Wrist Prep 10-30

**Strength Warmup**
* Wall Extensions 10
* Plank 10-60s
* Reverse Plank 10-60s
* Hollow Body Hold 10-60s
* Arch Body Hold 10-60s
* Side Plank 10-60s (each side)

**Strength Work**
* L-sit progression 3x5-8
* Handstand Pushup progression 3x5-8 (pair 1)
* Pullup progression 3x5-8
* Pushup progression 3x8-12 (pair 2)
* Row progression 3x8-12
* Step up left leg 3x5-8 (pair 3)
* Step up right leg 3x5-8

**Handstand and Mobility**
* Foam Roll Lats
* Yuri's Shoulder Band
* Rear Delt Band Pull Apart 4x8-15
* Trap-3 Raise 4x8-15
* Cuban Rotation 4x8-15
* Pec Stretch 120s
* Lat Stretch 120s
* Butcher's Block 120s
* Hollow Body Hold 3
* Handstand Progression 5-20 min
* Calf Stretch 30-60s (each side)
* Hamstring Lunge 30-60s (each side)
* Leg Lifts 3x10 (alternate sides)
* Ido's Squat Routine
* Hip Flexor Stretch 30-60s

**Notes**
* For the pairs do a set of the first pair, a set of the second pair, rest, and repeat until you've done all the sets.
* Move on to [phase five](https://www.reddit.com/r/bodyweightfitness/wiki/move/phase5) after three months. Note that phase 5 is supposed to be customized to suit your needs: you can either create a brand new program or edit this one.
"""
    return Program("Body Weight Move 4", workouts, exercises, tags, description)
}
