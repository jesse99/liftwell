//  Created by Jesse Jones on 12/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

fileprivate let notes = """
* Attempt to increase weights by 5-10 pounds each week.
* Focus on activating the glutes with each exercise.
* When performing a single leg/arm exercise begin with the weaker limb and then do the same number of reps with the stronger limb.
* If you're having an off day don't continue a set if your form begins to break down.
* Unlike the other Strong Curves workouts this one is not set up for super-setting.
* Once you've done all the indicated workouts the app will prompt you to move onto the next program.
"""

// Weeks 1-4 for 3 days/week version of Gorgeous Glutes.
func GorgeousGlutes1() -> Program {
    let exercises = [
        // A
        bodyweight("Hip Thrust",      "Hip Thrust",         "20".x(3), restMins: 1.5, main: true),
        bodyweight("Squat",           "Body-weight Squat",  "20".x(3), restMins: 1.5, main: true),
        bodyweight("Back Extension",  "Back Extension",     "20".x(3), restMins: 1.0),
        bodyweight("Side Lying Clam", "Clam",               "30", restMins: 0.5),
        
        // B
        bodyweight("Single-leg Glute Bridge", "Single Leg Glute Bridge",   "20".x(3), restMins: 1.5, main: true),
        bodyweight("Walking Lunge",           "Body-weight Walking Lunge", "10-20".x(3), restMins: 1.0, main: true),
        bodyweight("Reverse Hyperextension",  "Reverse Hyperextension",    "20".x(3), restMins: 1.0),
        bodyweight("Side Lying Abduction",    "Side Lying Abduction",      "30", restMins: 1.0),
        
        // C
        barbell("Glute Bridge",       "Glute Bridge",               "", "10".x(3), restMins: 2.0, main: true),
        dumbbell1("Goblet Squat",      "Goblet Squat",               "", "10".x(3), restMins: 2.0, main: true),
        dumbbell2("Romanian Deadlift", "Dumbbell Romanian Deadlift", "", "10".x(3), restMins: 2.0, main: true),
        cable("Cable Hip Rotation", "Cable Hip Rotation",         "", "10", restMins: 1.0)]
    
    let aExercises = ["Hip Thrust", "Squat", "Back Extension", "Side Lying Clam"]
    let bExercises = ["Single-leg Glute Bridge", "Walking Lunge", "Reverse Hyperextension", "Side Lying Abduction"]
    let cExercises = ["Glute Bridge", "Goblet Squat", "Romanian Deadlift", "Cable Hip Rotation"]
    
    let workouts = [
        Workout("A", aExercises, scheduled: true, optional: []),
        Workout("B", bExercises, scheduled: true, optional: []),
        Workout("C", cExercises, scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .gym, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is weeks 1-4 of the stripped down beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves) by Bret Contreras. The program is as follows:

**Workout A**
* Bodyweight Hip Thrust 3x20
* Bodyweight Full Squat 3x20
* Bodyweight Back Extension 3x20
* Side Lying Clam 1x30 (per side)

**Cardio**

**Workout B**
* Bodyweight Single-leg Glute Bridge 3x20 (per side)
* Bodyweight Walking Lunge 3x10-20 (per side)
* Bodyweight Reverse Hyperextension 3x20
* Side Lying Abduction 1x30 (per side)

**Cardio**

**Workout C**
* Barbell Glute Bridge 3x10
* Goblet Squat 3x10
* Dumbbell Romanian Deadlift 3x10
* Cable Hip Rotation 1x10 (per side)

**Cardio**

**Rest**

**Notes**
\(notes)
"""
    return Program("Gorgeous Glutes 1-4", workouts, exercises, tags, description, maxWorkouts: 3*4, nextProgram: "Gorgeous Glutes 5-8")
}

// Weeks 5-8 for 3 days/week version of Gorgeous Glutes.
func GorgeousGlutes2() -> Program {
    let exercises = [
        // A
        barbell("Hip Thrust",               "Hip Thrust",            "", "8-12".x(3), restMins: 2.0, main: true),
        barbell("Front Squat",              "Front Squat",           "", "8-12".x(3), restMins: 2.0, main: true),
        barbell("Romanian Deadlift",        "Romanian Deadlift",     "", "8-12".x(3), restMins: 2.0, main: true),
        bodyweight("Band Seated Abduction", "Band Seated Abduction", "30", restMins: 1.0),
        
        // B
        bodyweight("Single-leg Hip Thrust",      "Body-weight Single Leg Hip Thrust",  "8-12".x(3), restMins: 1.5, main: true),
        bodyweight("Skater Squat",               "Skater Squat",                       "8-12".x(3), restMins: 1.5, main: true),
        dumbbell2("Single-leg Romanian Deadlift", "Single Leg Romanian Deadlift",       "", "8-12".x(3), restMins: 1.5, main: true),
        cable("Cable Hip Abduction",           "Cable Hip Abduction",                "", "30", restMins: 0.5),
        
        // C
        barbell("Glute Bridge",            "Glute Bridge",         "", "10".x(3), restMins: 1.5, main: true),
        barbell("Zercher Squat",           "Zercher Squat",        "", "10".x(3), restMins: 1.5, main: true),
        dumbbell1("Back Extension",         "Back Extension",       "", "10".x(3), restMins: 1.0),
        bodyweight("Side Lying Hip Raise", "Side Lying Hip Raise", "12", restMins: 1.0)]
    
    let aExercises = ["Hip Thrust", "Front Squat", "Romanian Deadlift", "Band Seated Abduction"]
    let bExercises = ["Single-leg Hip Thrust", "Skater Squat", "Single-leg Romanian Deadlift", "Cable Hip Abduction"]
    let cExercises = ["Glute Bridge", "Zercher Squat", "Back Extension", "Side Lying Hip Raise"]
    
    let workouts = [
        Workout("A", aExercises, scheduled: true, optional: []),
        Workout("B", bExercises, scheduled: true, optional: []),
        Workout("C", cExercises, scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .gym, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is weeks 5-8 of the stripped down beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves) by Bret Contreras. The program is as follows:

**Workout A**
* Barbell Hip Thrust 3x8-12
* Barbell Front Squat 3x8-12
* Barbell Romanian Deadlift 3x8-12
* Band Seated Abduction 1x30

**Cardio**

**Workout B**
* Bodyweight Single-leg Hip Thrust 3x8-12 (per side)
* Bodyweight Skater Squat 3x8-12 (per side)
* Dumbbell Single-leg Romanian Deadlift 3x8-12 (per side)
* Cable Standing Abduction 1x30 (per side)

**Cardio**

**Workout C**
* Barbell Glute Bridge 3x10
* Barbell Zercher Squat 3x10
* Dumbbell Back Extension 3x10
* Side-lying Hip Raise 1x12

**Cardio**

**Rest**

**Notes**
\(notes)
"""
    return Program("Gorgeous Glutes 5-8", workouts, exercises, tags, description, maxWorkouts: 3*4, nextProgram: "Gorgeous Glutes 9-12")
}

// Weeks 9-12 for 3 days/week version of Gorgeous Glutes.
func GorgeousGlutes3() -> Program {
    let exercises = [
        // A
        barbell("Hip Thrust (constant tension)",  "Hip Thrust (constant tension)",           "", "20".x(3), restMins: 2.0, main: true),
        dumbbell2("Deficit Bulgarian Split Squat", "Dumbbell Single Leg Split Squat",         "", "12".x(3), restMins: 2.0, main: true),
        barbell("Deadlift",                       "Deadlift",                                "", "8".x(3), restMins: 2.0, main: true),
        cable("Anti-Rotation Press",            "Half-kneeling Cable Anti-Rotation Press", "", "15", restMins: 1.0),
        
        // B
        bodyweight("Elevated Single-leg Hip Thrust (pause rep)", "Body-weight Single Leg Hip Thrust", "6".x(3), restMins: 1.5, main: true),
        barbell("Box Squat",                    "Box Squat",           "", "6".x(3), restMins: 1.5, main: true),
        bodyweight("Single-leg Back Extension", "Back Extension",      "12".x(3), restMins: 1.0),
        cable("Cable Hip Abduction",          "Cable Hip Abduction", "", "15", restMins: 0.5),
        
        // C
        barbell("Hip Thrust (rest pause)", "Hip Thrust (rest pause)",  "", "10".x(3), restMins: 2.0, main: true),
        dumbbell2("Step Ups",              "Step-ups",                 "", "8".x(3), restMins: 1.5, main: true),
        bodyweight("Kettlebell Swing",     "Kettlebell Two Arm Swing", "20".x(3), restMins: 1.5),
        bodyweight("Side Lying Hip Raise", "Side Lying Hip Raise",     "15", restMins: 1.0)]
    
    let aExercises = ["Elevated Single-leg Hip Thrust (pause rep)", "Box Squat", "Single-leg Back Extension", "Cable Hip Abduction"]
    let bExercises = ["Elevated Single-leg Hip Thrust (pause rep)", "Box Squat", "Single-leg Back Extension", "Cable Hip Abduction"]
    let cExercises = ["Hip Thrust (rest pause)", "Step Ups", "Kettlebell Swing", "Side Lying Hip Raise"]
    
    let workouts = [
        Workout("A", aExercises, scheduled: true, optional: []),
        Workout("B", bExercises, scheduled: true, optional: []),
        Workout("C", cExercises, scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .hypertrophy, .gym, .threeDays, .female, .ageUnder40, .age40s, .age50s]
    let description = """
This is weeks 9-12 of the stripped down beginner program from [Strong Curves: A Woman's Guide to Building a Better Butt and Body](https://www.amazon.com/Strong-Curves-Womans-Building-Better-ebook/dp/B00C4XI0QM/ref=sr_1_1?ie=UTF8&qid=1516764374&sr=8-1&keywords=strong+curves) by Bret Contreras. The program is as follows:

**Workout A**
* Barbell Hip Thrust (constant tension) 3x20
* Dumbbell Deficit Bulgarian Split Squat 3x12 (per side)
* Barbell Deadlift 3x8
* Half-kneeling Cable Anti-Rotation Press 1x15 (per side)

**Cardio**

**Workout B**
* Bodyweight Shoulder/foot Elevated Single-leg Hip Thrust (pause rep) 3x6
* Barbell High Box Squat 3x6
* Single-leg Back Extension 3x12 (per side)
* Cable Hip Rotation 1x15

**Cardio**

**Workout C**
* Barbell Hip Thrust (rest pause) 3x10
* Dumbbell High Steup 3x8 (per side)
* Russian Kettlebell Swing 3x20
* Side Lying Hip Raise 1x15 (per side)

**Cardio**

**Rest**

**Notes**
\(notes)
* After finishing the four weeks Brett recommends that you do a deload week, e.g. by reducing weights 20-50%.
"""
    return Program("Gorgeous Glutes 9-12", workouts, exercises, tags, description)
}



