//  Created by Jesse Jones on 12/19/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func Monolith() -> Program {
    let warmup = "5@40% 5@50% 3@60%"
    
    func squatSets() -> [(String, String, String)] {
        let worksets1a = "5@70% R 5@80% R 5@90% R 5@90% R 5@90% R 5@90% R 5@90%"
        let sets1a     = (warmup, worksets1a, "")
        
        let worksets1b = "5@70% R 5@80% R 5@90% R 20@45%"
        let sets1b     = (warmup, worksets1b, "")
        
        let worksets2a = "5@65% R 5@75% R 5@85% R 5@85% R 5@85% R 5@85% R 5@85%"
        let sets2a     = (warmup, worksets2a, "")
        
        let worksets2b = "5@65% R 5@75% R 5@85% R 20@55%"
        let sets2b     = (warmup, worksets2b, "")
        
        let worksets3a = "5@75% R 5@85% R 5@95% R 5@95% R 5@95% R 5@95% R 5@95%"
        let sets3a     = (warmup, worksets3a, "")
        
        let worksets3b = "5@75% R 5@85% R 5@95% R 20@55%"
        let sets3b     = (warmup, worksets3b, "")
        
        let worksets4b = "5@70% R 5@80% R 5@90% R 20@50%"
        let sets4b     = (warmup, worksets4b, "")
        
        let worksets5b = "5@65% R 5@75% R 5@85% R 20@65%"
        let sets5b     = (warmup, worksets5b, "")
        
        let worksets6b = "5@75% R 5@85% R 5@95% R 20@70%"
        let sets6b     = (warmup, worksets6b, "")

        return [sets1a, sets1b, sets2a, sets2b, sets3a, sets3b,
                sets1a, sets4b, sets2a, sets5b, sets3a, sets6b]
    }
    
    func benchSets() -> [(String, String, String)] {
        let worksets1 = "5@70% R 5@80% R 5@90% R 5@90% R 5@90% R 5@90% R 5@90%"
        let sets1     = (warmup, worksets1, "")
        
        let worksets2 = "5@65% R 5@75% R 5@85% R 5@85% R 5@85% R 5@85% R 5@85%"
        let sets2     = (warmup, worksets2, "")
        
        let worksets3 = "5@75% R 5@85% R 5@95% R 5@95% R 5@95% R 5@95% R 5@95%"
        let sets3     = (warmup, worksets3, "")
        
        return [sets1, sets2, sets3, sets1, sets2, sets3]
    }
    
    func ohpSets() -> [(String, String, String)] {
        let worksets1a = "5@70% R 5@80% R 5@90% R 1+@70%"
        let sets1a     = (warmup, worksets1a, "")
        
        let worksets1b = "5@70%".x(10)    // these Friday week 1-3 percents are weird but they are what both Wendler's web page and the online spreadsheet use
        let sets1b     = (warmup, worksets1b, "")
        
        let worksets2a = "5@65% R 5@75% R 5@85% R 1+@65%"
        let sets2a     = (warmup, worksets2a, "")
        
        let worksets2b = "5@50%".x(10)
        let sets2b     = (warmup, worksets2b, "")
        
        let worksets3a = "5@75% R 5@85% R 5@95% R 1+@75%"
        let sets3a     = (warmup, worksets3a, "")
        
        let worksets3b = "5@75%".x(10)
        let sets3b     = (warmup, worksets3b, "")
        
        let worksets4b = "5@60%".x(12)
        let sets4b     = (warmup, worksets4b, "")
        
        let worksets5b = "5@65%".x(15)
        let sets5b     = (warmup, worksets5b, "")

        let worksets6b = "5@75%".x(12)
        let sets6b     = (warmup, worksets6b, "")
        
        return [sets1a, sets1b, sets2a, sets2b, sets3a, sets3b,
                sets1a, sets4b, sets2a, sets5b, sets3a, sets6b]
    }
    
    func deadSets() -> [(String, String, String)] {
        let worksets1 = "5@70% R 5@80% R 5@90% R 5@90% R 5@90%"
        let sets1     = (warmup, worksets1, "")
        
        let worksets2 = "5@65% R 5@75% R 5@85% R 5@85% R 5@85%"
        let sets2     = (warmup, worksets2, "")
        
        let worksets3 = "5@75% R 5@85% R 5@95% R 5@95% R 5@95%"
        let sets3     = (warmup, worksets3, "")
        
        return [sets1, sets2, sets3, sets1, sets2, sets3]
    }
        
    let exercises: [Exercise] = [
        barbell("Squat",       "Low bar Squat", squatSets(), restMins: 3.0, trainingMaxPercent: 0.85, promptIndex: -1, resetIndex: [0, 6], main: true),
        barbell("OHP",         "Overhead Press", ohpSets(), restMins: 3.0, trainingMaxPercent: 0.85, promptIndex: -1, resetIndex: [0, 6], main: true),
        barbell("Deadlift",    "Deadlift", deadSets(), restMins: 3.0, bumpers: defaultBumpers(), trainingMaxPercent: 0.85, promptIndex: -1, resetIndex: [0, 3], main: true),
        barbell("Bench Press", "Bench Press", benchSets(), restMins: 3.0, trainingMaxPercent: 0.85, promptIndex: -1, resetIndex: [0, 3], main: true),
        
        bodyweight("Chins",          "Chinup",        numSets: 10, goalReps: 100, restMins: 2.5),
        cable("Face Pull",           "Face Pull", "", "10-20".x(5), restMins: 2.0),
        bodyweight("Dips",           "Dips",          numSets: 10, goalReps: 200, restMins: 2.5),
        dumbbell1("Kroc Row",        "Kroc Row",      "10@50%", "10-20".x(5), restMins: 3.0),
        barbell("Preacher Curl",     "Preacher Curl", "", "10-20".x(5), restMins: 2.0),
        bodyweight("Weighted Chins", "Chinup",        numSets: 5, goalReps: 25, restMins: 2.5),
        barbell("Barbell Shrug",     "Barbell Shrug", "10@50%", "20".x(5), restMins: 2.5)]
    
    let workouts = [
        Workout("Heavy",    ["Squat", "OHP", "Chins", "Face Pull", "Dips"], scheduled: true, optional: []),
        Workout("Deadlift", ["Deadlift", "Bench Press", "Kroc Row", "Preacher Curl"], scheduled: true, optional: []),
        Workout("Volume",   ["Squat", "OHP", "Weighted Chins", "Face Pull", "Barbell Shrug"], scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.advanced, .hypertrophy, .barbell, .unisex, .threeDays, .ageUnder40]
    
    let description = """
This is a [program](https://jimwendler.com/blogs/jimwendler-com/101078918-building-the-monolith-5-3-1-for-size) by Jim Wendler focused on getting bigger. It's normally run for only six weeks because it is very demanding. If you run this program you should also do cardio 3-4 times a week. You'll also need to eat a **lot**, see the link for details. In addition recovery needs to be on point: don't run this program if you're not able to get adequate rest, make sure you stretch, and also massages are recommended.

The rep ranges and percentages of the main lifts change from week to week but each week is similar to:

**Heavy**
* Squat 5 sets of 5
* Overhead Press 1 set of 5 & a lighter AMRAP set
* Chins 100 total reps
* Face Pulls 100 total reps
* Dips 100-200 reps

**Deadlift**
* Deadlift 3 sets of 5
* Bench Press 5 sets of 5
* Kroc Rows 5x10-20
* Curls 100 total reps

**Volume**
* Squat 1 set of 5 & 20 reps at a light weight
* Overhead Press 10-15 sets of 5 at a medium weight
* Weighted Chins 5x5
* Face Pulls 100 total reps
* Shrugs 100 total reps

**Notes**
* When starting the program you need to find your Training Max for each of the main lifts. The program will do this for you: when you start an exercise it will guide you to find the five rep max for that exercise, then it will estimate your one rep max, and use 90% of the 1RM for your training max.
* Note that the app will automatically reset the traiming max at the end of week three so that you can find a new max.
* The only exercises that are required are squat, OHP, and deadlift. Feel free to swap in different exercises for the others or even disable some of them.
"""
    return Program("Building the Monolith (5/3/1)", workouts, exercises, tags, description)
}

