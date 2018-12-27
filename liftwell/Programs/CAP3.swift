//  Created by Jesse Jones on 12/24/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func CAP3() -> Program {
    func primaryBench() -> [String] {
        let week1a = "4@70% 4@70% 4@70% 4@70% 4@80% R 4@80% R 4+?@85%"
        let week1b = "6@65% 6@65% 6@65% 6@65% 6@65% 5@80% R 5@80% R 5+?@85%"
        
        let week2a = "3@75% R 3@75% R 3@75% R 3@75% R 3@80% R 3@85% R 3@85% R 3+?@90%"
        let week2b = "5@70% 5@70% 5@70% 5@70% 4@80% R 4@80% R 4@80% R 4@80% R 4?@90%"
        
        let week3a = "4+@85%"
        let week3b = "8@60% 8@60% 8@60% 8@60% 6@70% 6@70% R 6+?@75%"
        
        return [week1a, week1b, week2a, week2b, week3a, week3b]
    }
    
    func primaryDead() -> [String] {
        let week1 = "4+@85%"
        let week2 = "4@80% R 4@80% R 4@80% R 4@80% R 4@85% R 4@85% R 4+?@95%"
        let week3 = "3@85% R 3@85% R 3@85% R 3@85% R 3@95% R 3@95% R 3@95% R 3+?@105%"
        
        return [week1, week2, week3, week1, week2, week3]
    }
    
    func primarySquat() -> [String] {
        let week1 = "3@80% R 3@80% R 3@80% R 3@80% R 3@95% R 3@95% R 3?@95% R 3@105%"
        let week2 = "4+@85%"
        let week3 = "4@80% R 4@80% R 4@80% R 4@90% R 4@90% R 4@90% R 4+?@100%"
        
        return [week1, week2, week3, week1, week2, week3]
    }
    
    func secondaryBench() -> [String] {
        let week1a = "10+?@75% R 8+?@65% R 5+?@65%"
        let week1b = "8+?@80% R 6+?@70% R 4+?@70%"

        let week2a = "8+?@80% R 6+?@70% R 4+?@70%"
        let week2b = "5-8@80% R 6@75% R 6@75% R 6@75%"
        
        let week3a = "12+?@70% R 10+?@60% R 6+?@60%"
        let week3b = "10+?@75% R 10+?@65% R 5+?@65%"

        return [week1a, week1b, week2a, week2b, week3a, week3b]
    }
    
    func secondaryDead() -> [String] {
        let week1 = "5@70% 5@70% 5@70% 5@70% 4@80% R 4@80% R 4@80% R 4@80% R 4?@90%"
        let week2 = "8@60% 8@60% 8@60% 8@60% 6@70% 6@70% 6?@75%"
        let week3 = "6@65% 6@65% 6@65% 6@65% 6@65% 5@75% R 5@75% R 5+?@80%"
        
        return [week1, week2, week3, week1, week2, week3]
    }
    
    func secondaryOHP1() -> [String] {
        let week1 = "8+?@80% R 6+?@70% R 4+?@70%"
        let week2 = "12+?@70% R 10+?@60% R 6+?@60%"
        let week3 = "10+?@75% R 8+?@65% R 5+?@65%"
        
        return [week1, week2, week3, week1, week2, week3]
    }

    func secondaryOHP2() -> [String] {
        let week1 = "6+?@80% R 5+?@75% R 3+?@75%"
        let week2 = "6-10@80% R 5?@70% R 5?@70% R 5?@70%"
        let week3 = "10+?@75% R 8+?@65% R 5+?@65%"
        
        return [week1, week2, week3, week1, week2, week3]
    }
    
    func secondaryRow1() -> [String] {
        let week1 = "6+?@80% R 4+?@75% R 3+?@75%"
        let week2 = "10+?@75% R 6+?@65% R 5+?@65%"
        let week3 = "8+?@80% R 5+?@70% R 4+?@70%"
        
        return [week1, week2, week3, week1, week2, week3]
    }
    
    func secondaryRow2() -> [String] {
        let week1 = "8-12@70% R 10@60% R 10@60% R 10@60%"
        let week2 = "10+?@80% R 8+?@70% R 5+?@70%"
        let week3 = "8+?@75% R 6+?@65% R 4+?@65%"
        
        return [week1, week2, week3, week1, week2, week3]
    }
    
    func secondarySquat() -> [String] {
        let week1 = "5@70% 5@70% 5@70% 5@70% 4@75% R 4@75% R 4@75% R 4@75% R 4?@90%"
        let week2 = "8@60% 8@60% 8@60% 8@60% 6@70% 6@70% 6+?@75%"
        let week3 = "6@65% 6@65% 6@65% 6@65% 6@65% 5@75% R 5@75% R 5+?@80%"
        
        return [week1, week2, week3, week1, week2, week3]
    }

    let exercises: [Exercise] = [
        bodyweight("Band Pull Apart",     "Band Pull Apart",    1, by: 200),
        bodyweight("Shoulder Dislocates", "Shoulder Dislocate", 1, by: 100),
        bodyweight("Chinups",             "Chinup",             numSets: 4, startReps: 12, goalReps: 0, restMins: 2.0),
        bodyweight("Weighted Chinups",    "Chinup",             numSets: 3, startReps: 6, goalReps: 30, restMins: 2.0),

        bodyweight("Foam Rolling",            "IT-Band Foam Roll",         1, by: 15),
        bodyweight("Bent-knee Iron Cross",    "Bent-knee Iron Cross",      1, by: 10),
        bodyweight("Roll-over into V-sit",    "Roll-over into V-sit",      1, by: 15),
        bodyweight("Rocking Frog Stretch",    "Rocking Frog Stretch",      1, by: 10),
        bodyweight("Fire Hydrant Hip Circle", "Fire Hydrant Hip Circle",   1, by: 10),
        bodyweight("Mountain Climber",        "Mountain Climber",          1, by: 10),
        bodyweight("Cossack Squat",           "Cossack Squat",             1, by: 10),
        bodyweight("Piriformis Stretch",      "Seated Piriformis Stretch", 2, secs: 30),

        barbell("Flat Bench",       "Bench Press",            amrap1rm: primaryBench(), restMins: 3.0, main: true),
        dumbbell2("DB Bench",       "Dumbbell Bench Press",   emom: secondaryBench(), restMins: 1.0),
        barbell("Paused Bench",     "Bench Press",            emom: secondaryBench(), restMins: 1.0),
        barbell("CG Bench",         "Close-Grip Bench Press", emom: secondaryBench(), restMins: 1.0),
        barbell("Incline Bench",    "Incline Bench Press",    emom: secondaryBench(), restMins: 1.0),
        barbell("DB Incline Bench", "Dumbbell Incline Press", emom: secondaryBench(), restMins: 1.0),

        barbell("Sumo Deadlift",     "Sumo Deadlift",     emom: secondaryDead(), restMins: 3.0, main: true),
        barbell("Romanian Deadlift", "Romanian Deadlift", emom: secondaryDead(), restMins: 1.0),
        barbell("Paused Sumo",       "Sumo Deadlift",     emom: secondaryDead(), restMins: 1.0),
        barbell("Rack Pull",         "Rack Pulls",        emom: secondaryDead(), restMins: 1.0),
        dumbbell1("Kroc Row",        "Kroc Row",          emom: secondaryRow1(), restMins: 1.0),
        singlePlates("T-Bar Row",    "T-Bar Row",         emom: secondaryRow1(), restMins: 1.0),

        barbell("Squat",          "Low bar Squat",           amrap1rm: primarySquat(), restMins: 3.0, main: true),
        barbell("High Bar Squat", "High bar Squat",          amrap1rm: primarySquat(), restMins: 3.0, main: true),
        dumbbell2("DB OHP",       "Dumbbell Shoulder Press", emom: secondaryOHP1(), restMins: 1.0),
        dumbbell2("DB Lunge",     "Dumbbell Lunge",          emom: secondaryOHP1(), restMins: 1.0),
        barbell("Front Squat",    "Front Squat",             emom: secondaryOHP1(), restMins: 1.0),
        barbell("Paused Squat",   "Low bar Squat",           emom: secondaryOHP1(), restMins: 1.0),

        barbell("Deadlift",         "Deadlift",         amrap1rm: primaryDead(), restMins: 3.0, main: true),
        barbell("Pendlay Row",      "Pendlay Row",      emom: secondaryRow2(), restMins: 1.0),
        barbell("Deficit Deadlift", "Deficit Deadlift", emom: secondaryRow2(), restMins: 1.0),
        barbell("Paused Deadlift",  "Deadlift",         emom: secondaryRow2(), restMins: 1.0),
        cable("Seated Cable Row",   "Seated Cable Row", emom: secondaryRow2(), restMins: 1.0),

        dumbbell2("Split Squat",   "Dumbbell Single Leg Split Squat", emom: secondarySquat(), restMins: 1.0),
        barbell("OHP",             "Overhead Press",                  emom: secondaryOHP2(), restMins: 1.0),
        dumbbell2("DB Seated OHP", "Dumbbell Seated Shoulder Press",  emom: secondaryOHP2(), restMins: 1.0),
        dumbbell1("DB 1-Arm OHP",  "Dumbbell One Arm Shoulder Press", emom: secondaryOHP2(), restMins: 1.0),
        barbell("Z Press",         "Z Press",                         emom: secondaryOHP2(), restMins: 1.0)]
    
    let workouts = [
        Workout("Chest & Biceps 1",       ["Band Pull Apart", "Shoulder Dislocates", "Chinups", "Flat Bench", "DB Bench",  "Paused Bench", "CG Bench"], scheduled: true, optional: ["Paused Bench", "CG Bench"]),
        Workout("Back, Abs, & Triceps 1", ["Band Pull Apart", "Shoulder Dislocates", "Weighted Chinups", "Sumo Deadlift", "Kroc Row", "Romanian Deadlift", "Paused Sumo", "Rack Pull", "T-Bar Row"], scheduled: true, optional: ["Romanian Deadlift", "Paused Sumo", "Rack Pull", "T-Bar Row"]),
        Workout("Shoulders & Legs 1",     ["Band Pull Apart", "Shoulder Dislocates", "Foam Rolling", "Bent-knee Iron Cross", "Roll-over into V-sit", "Rocking Frog Stretch", "Fire Hydrant Hip Circle", "Mountain Climber", "Cossack Squat", "Piriformis Stretch", "Squat", "High Bar Squat", "DB OHP", "DB Lunge", "Front Squat", "Paused Squat"], scheduled: true, optional: ["High Bar Squat", "DB Lunge", "Front Squat", "Paused Squat"]),

        Workout("Chest & Biceps 2",       ["Band Pull Apart", "Shoulder Dislocates", "Flat Bench", "DB Bench",  "Incline Bench", "DB Incline Bench"], scheduled: true, optional: ["Incline Bench", "DB Incline Bench"]),
        Workout("Back, Abs, & Triceps 2", ["Band Pull Apart", "Shoulder Dislocates", "Deadlift", "Pendlay Row", "Deficit Deadlift", "Paused Deadlift", "Seated Cable Row"], scheduled: true, optional: ["Deficit Deadlift", "Paused Deadlift", "Seated Cable Row"]),
        Workout("Shoulders & Legs 2",     ["Band Pull Apart", "Shoulder Dislocates", "Foam Rolling", "Bent-knee Iron Cross", "Roll-over into V-sit", "Rocking Frog Stretch", "Fire Hydrant Hip Circle", "Mountain Climber", "Cossack Squat", "Piriformis Stretch", "Split Squat", "OHP", "DB Seated OHP", "DB 1-Arm OHP", "Z Press"], scheduled: true, optional: ["DB Seated OHP", "DB 1-Arm OHP", "Z Press"])]
    
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
* The secondary sets are Max Rep Sets (MRS): the app will continue to ask you to perform sets until you can't do all the requested reps.
* Don't rest longer than one minute between the max rep sets.
* Some of the AMRAP sets have a question mark, e.g. 3+?. In that case do extra reps only if you feel like you have enough energy.
* A few sets are optional (do them only if you're feeling good), these look like: 5?.
* Don't do the AMRAP sets to failure: try and leave one or two reps in the tank, e.g. stop if the bar speed slows significantly.
* You can do up to four assistence lifts per workout.
* The assistence lifts should be tailored to address your weak areas.
* A deload week is optional after finishing the cycles.
"""
    return Program("CAP3 (nSuns)", workouts, exercises, tags, description)
}
