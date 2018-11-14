//  Created by Jesse Jones on 11/12/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func PhraksGreyskull() -> Program {
    let exercises = [
        bodyweight("Chinups",     "Chinup", "5@100% R 5@100% R 5+@100%", restMins: 2.5, main: false),
        barbell("OHP",         "Overhead Press", "10@0% 5@50% 3@75% 1@90% 5@100% R 5@100% R 5+@100%", restMins: 2.5, main: true),
        barbell("Squat",       "Low bar Squat", "10@0% 5@50% 3@75% 1@90% 5@100% R 5@100% R 5+@100%", restMins: 2.5, main: true),
        barbell("Rows",        "Pendlay Row", "10@50% 5@100% R 5@100% R 5+@100%", restMins: 2.5, main: true),
        barbell("Deadlift",    "Deadlift", "5@0% 5@50% 3@75% 1@90% 5+@100%", restMins: 2.5, bumpers: defaultBumpers(), main: true),
        barbell("Bench Press", "Bench Press", "10@0% 5@50% 3@75% 1@90% 5@100% R 5@100% R 5+@100%", restMins: 2.5, main: true)]
    
    let workouts = [
        Workout("1A", ["Chinups", "OHP", "Squat"], scheduled: true, optional: []),
        Workout("1B", ["Rows", "Bench Press", "Deadlift"], scheduled: true, optional: []),
        Workout("1C", ["Chinups", "OHP", "Squat"], scheduled: true),
        
        Workout("2A", ["Rows", "Bench Press", "Squat"], scheduled: true, optional: []),
        Workout("2B", ["Chinups", "OHP", "Deadlift"], scheduled: true, optional: []),
        Workout("2C", ["Rows", "Bench Press", "Squat"], scheduled: true)]
    
    let tags: [Program.Tags] = [.beginner, .strength, .barbell, .unisex, .threeDays, .ageUnder40, .age40s]
    
    let description = """
This is the [beginner program](https://old.reddit.com/r/Fitness/wiki/phraks-gslp) recommended by reddit/fitness. After three months (or if you are already familiar with bench press, overhead
press, squat, and deadlift) then switch to either [5/3/1 for Beginners](https://old.reddit.com/r/Fitness/wiki/531-beginners) or [GZCLP](https://www.reddit.com/r/Fitness/wiki/gzclp). This is a three day a week program:

**1A**
* Chin Ups 3x5+
* OHP 3x5+
* Squat 3x5+

**1B**
* Rows 3x5+
* Bench Press 3x5+
* Deadlift 1x5+

**1C**
* Chin Ups 3x5+
* OHP 3x5+
* Squat 3x5+

**2A**
* Rows 3x5+
* Bench Press 3x5+
* Squat 3x5+

**2B**
* Chin Ups 3x5+
* OHP 3x5+
* Deadlift 1x5+

**2C**
* Rows 3x5+
* Bench Press 3x5+
* Squat 3x5+

**Notes**
* The + means that the last set is As Many Reps as Possible (AMRAP). But don't do these to failure: try and leave one or two reps in the tank, e.g. stop if the bar speed slows significantly.
* Add 2.5 pounds to upper body lifts (you may need micro-plates or magnets). Add five pounds to lower body lifts.
* If you're able to do more than 10 reps on the AMRAP set then you can add twice as much weight.
* If you fail to do at least fifteen reps then deload that lift by 10%.
* If you can't do chin ups then do negatives (slowly lower yourself).
* It is recommended to include cardio work.
* Avoid making other changes to the program.
"""
    return Program("Phrak's Greyskull", workouts, exercises, tags, description, maxWorkouts: 3*12, nextProgram: nil)
}

