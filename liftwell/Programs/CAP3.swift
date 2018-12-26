//  Created by Jesse Jones on 12/24/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func CAP3() -> Program {
    func benchSets() -> [String] {
        let week1a = "4@70% 4@70% 4@70% 4@70% 4@80% R 4@80% R 4+@85%"          // TODO: AMRAP is optional
        let week1b = "6@65% 6@65% 6@65% 6@65% 6@65% 5@80% R 5@80% R 5+@85%"  // TODO: AMRAP is optional
        
        let week2a = "3@75% 3@75% 3@75% 3@75% 3@80% R 3@85% R 3@85% R 3+@90%"  // TODO: AMRAP is optional
        let week2b = "5@70% 5@70% 5@70% 5@70% 4@80% R 4@80% R 4@80% R 4@80% R 4+@90%"  // TODO: AMRAP is optional
        
        let week3a = "4+@85%"
        let week3b = "8@60% 8@60% 8@60% 8@60% 6@70% 6@70% R 6+@75%"  // TODO: AMRAP is optional
        
        return [week1a, week1b, week2a, week2b, week3a, week3b]
    }
    
    func dbBenchSets() -> [String] {
        let week1a = "10+@75% R 8+@65% R 5+@65%"
        let week1b = "8+@80% R 6+@70% R 4+@70%"

        let week2a = "9+@80% R 6+@70% R 4+@70%"
        let week2b = "5-8@80% R 6@75% R 6@75% R 6@75%"
        
        let week3a = "12+@70% R 10+@60% R 6+@60%"
        let week3b = "12+@75% R 10+@65% R 5+@65%"

        return [week1a, week1b, week2a, week2b, week3a, week3b]
    }
    
    let exercises: [Exercise] = [
        barbell("Flat Bench",    "Bench Press",           amrap1rm: benchSets(), restMins: 3.0, main: true),
        dumbbell2("DB Bench",    "Dumbbell Bench Press",  emom: dbBenchSets(), restMins: 1.0),
    ]
    
    let workouts = [
        Workout("Chest & Biceps 1", ["Flat Bench", "DB Bench"], scheduled: true, optional: []),
        Workout("Chest & Biceps 2", ["Flat Bench", "DB Bench"], scheduled: true, optional: []),
        ]
    
    let tags: [Program.Tags] = [.advanced, .strength, .barbell, .unisex, .fourDays, .fiveDays, .sixDays, .ageUnder40]
    
    let description = """
This is a [program](http://archive.is/2017.01.27-015129/https://www.reddit.com/r/Fitness/comments/5icyza/2_suns531lp_tdee_calculator_and_other_items_all/#selection-2147.0-2147.13) from [reddit](https://www.reddit.com/r/nSuns/) with weekly progression. Each day has a main lift, an associated secondary lift, and assistence lifts. The main lift weights go up every three weeks if you're able to complete all the required reps. Secondary lifts are similar but go up each time your estimated 1RM increases or after three weeks if you were able to complete all the requried reps.

This program can be run from four to six days a week:
**Chest & Biceps 1**
* 200 Band Pull-Aparts
* 100 Banded Shoulder Dislocates
* 4 sets of AMRAP Chinups
* Flat Bench
* DB Bench

**Back, Abs, & Triceps 1**
* 200 Band Pull-Aparts
* 100 Banded Shoulder Dislocates
* 30 Weighted Chinups
* Sumo Deadlift
* DB Row

**Shoulders & Legs 1**
* 200 Band Pull-Aparts
* 100 Banded Shoulder Dislocates
* Mobility
* Squat
* DB OHP

**Chest & Biceps 2**
* 200 Band Pull-Aparts
* 100 Banded Shoulder Dislocates
* 4 sets of AMRAP Chinups
* Flat Bench
* DB Bench

**Back, Abs, & Triceps 2**
* 200 Band Pull-Aparts
* 100 Banded Shoulder Dislocates
* 15 Weighted Chinups
* Deadlift
* Barbell Row

**Shoulders & Legs 2**
* 200 Band Pull-Aparts
* 100 Banded Shoulder Dislocates
* Mobility
* DB Split Squat
* OHP

Main lifts are done for eight worksets with varying perentages and reps. Secondary lifts are done for 3+ sets (with a fixed one minute rest between the variable sets).

Varaitions of the lifts can be switched in using the Options button in the Workout screen.

**Notes**
* When starting the program you need to find your Training Max for each of the main lifts. The program will do this for you: when you start an exercise it will guide you to find the five rep max for that exercise, then it will estimate your one rep max, and use 90% of the 1RM for your training max.
* This program uses a lot of sets at a relatively low intensity so be conservative with your initial weights.
* It's a good idea to do a few warmup sets before the main lifts.
* Some of the AMRAP sets have a question mark, e.g. 3+?. In that case do extra reps only if you feel like you have enough energy.
* Don't do the AMRAP sets to failure: try and leave one or two reps in the tank, e.g. stop if the bar speed slows significantly.
* You can do up to four assistence lifts per workout.
* The assistence lifts should be tailored to address your weak areas.
* A deload week is optional after finishing the cycles.
"""
    return Program("CAP3 (nSuns)", workouts, exercises, tags, description)
}
