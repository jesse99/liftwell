//  Created by Jesse Jones on 12/16/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

fileprivate let warmup = "5@40% 5@50% 3@60%"

fileprivate let worksets1 = "5@65% R 5@75% R 5+@85%"
fileprivate let worksets2 = "3@70% R 3@80% R 3+@90%"
fileprivate let worksets3 = "5@75% R 3@85% R 1+@95%"
fileprivate let worksets4 = "5@40% 5@50% 5@60%"

func JackShit() -> Program {
    let sets1 = (warmup, worksets1, "")
    let sets2 = (warmup, worksets2, "")
    let sets3 = (warmup, worksets3, "")
    let sets4 = ("", worksets4, "")
    let sets = [sets1, sets2, sets3, sets4]
    
    let exercises: [Exercise] = [
        barbell("OHP",         "Overhead Press", sets, restMins: 3.0, advance: .onCycle(2), trainingMaxPercent: 0.9, main: true),
        barbell("Deadlift",    "Deadlift", sets, restMins: 3.0, bumpers: defaultBumpers(), advance: .onCycle(2), trainingMaxPercent: 0.9, main: true),
        barbell("Bench Press", "Bench Press", sets, restMins: 3.0, advance: .onCycle(2), trainingMaxPercent: 0.9, main: true),
        barbell("Squat",       "Low bar Squat", sets, restMins: 3.0, advance: .onCycle(2), trainingMaxPercent: 0.9, main: true)]
    
    let workouts = [
        Workout("OHP",      ["OHP"], scheduled: true, optional: []),
        Workout("Deadlift", ["Deadlift"], scheduled: true, optional: []),
        Workout("Bench",    ["Bench Press"], scheduled: true, optional: []),
        Workout("Squat",    ["Squat"], scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.intermediate, .strength, .barbell, .threeDays, .fourDays, .ageUnder40, .age40s] + anySex
    
    let description = """
This is a program from [5/3/1: The Simplest and Most Effective Training System for Raw Strength](https://www.amazon.com/Simplest-Effective-Training-System-Strength-ebook/dp/B00AJ8CIQM/ref=sr_1_1?ie=UTF8&qid=1544983677&sr=8-1&keywords=5%2F3%2F1) by Jim Wendler. There are many variations of 5/3/1 (especially in his later books) but this is a good one if you are very time constrained. It can be run as a three day or four day a week program.

In this version of 5/3/1 you only do one lift per workout. This is not ideal because you may develop imbalances and you risk stalling out more often because you're not addressing weak points with assistence exercises. But it is much better than not working out at all.

The workouts cycle reps and weight. If you're running the 4 day/week variation then the weeks are as below. (If you're working out three days a week then one of the workouts will roll-over into the next week and the full cycle will extend to more than four weeks).

Week one looks like this:
* **Warmup:** 5@40% 5@50% 3@60%
* **Workset:** 5@65% 5@75% 5+@85% (the plus means to do As Many Reps As Possible)

Week two is like this:
* **Warmup:** 5@40% 5@50% 3@60%
* **Workset:** 3@70% 3@80% 3+@90%

Week three:
* **Warmup:** 5@40% 5@50% 3@60%
* **Workset:** 5@75% 3@85% 1+@95%

Week four (deload):
* **Workset:** 5@40% 5@50% 5@60%

You'll be asked if you want to increase weights after week four. The lifts are Overhead Press, Deadlift, Bench Press, and Squat.

**Notes**
* When starting the program you need to find your Training Max for each of the main lifts. The program will do this for you: when you start an exercise it will guide you to find the five rep max for that exercise, then it will estimate your one rep max, and use 90% of the 1RM for your training max.
* The weights may feel light, especially at first, but it's much better to use a training max that is a bit too small than one that is too large.
* Don't do the AMRAP sets to failure: try and leave one or two reps in the tank, e.g. stop if the bar speed slows significantly.
* Don't increase weights by more than 10 pounds for lower body lifts and 5 pounds for upper body lifts.
* If you're not able to perform all the reps for an exercise, and it's not just one bad day, then use the options screen to deload that lift by 10% and start over at cycle 0.
* If you're having problems with multiple lifts then use the options screen to set the cycle index to 3 to do a deload week and after the deload week use options to set the weight to 0 so that the app will help you compute new training maxes for the main lifts.
"""
    return Program("I'm not doing jack (531)", workouts, exercises, tags, description)
}

func BoringButBig() -> Program {
    let backoff = "10@35%".x(5, rest: .none)
    
    let sets1 = (warmup, worksets1 + " R", backoff)
    let sets2 = (warmup, worksets2 + " R", backoff)
    let sets3 = (warmup, worksets3 + " R", backoff)
    let sets4 = ("", worksets4, "")
    let sets = [sets1, sets2, sets3, sets4]
    
    let exercises: [Exercise] = [
        barbell("OHP",         "Overhead Press", sets, restMins: 3.0, advance: .onCycle(2), trainingMaxPercent: 0.9, main: true),
        barbell("Deadlift",    "Deadlift", sets, restMins: 3.0, bumpers: defaultBumpers(), advance: .onCycle(2), trainingMaxPercent: 0.9, main: true),
        barbell("Bench Press", "Bench Press", sets, restMins: 3.0, advance: .onCycle(2), trainingMaxPercent: 0.9, main: true),
        barbell("Squat",       "Low bar Squat", sets, restMins: 3.0, advance: .onCycle(2), trainingMaxPercent: 0.9, main: true),
    
        bodyweight("Ab Wheel",       "Ab Wheel Rollout", "10".x(5), restMins: 2.5),
        dumbbell1("Back Extensions", "Back Extensions", "10@50%", "5-10".x(5), restMins: 2.5),
        barbell("Barbell Shrug",     "Barbell Shrug", "10@50%", "8".x(5), restMins: 2.5),
        bodyweight("Chinups",        "Chinup", numSets: 5, startReps: 10, goalReps: 50, restMins: 2.5),
        bodyweight("Dips",           "Dips", numSets: 5, startReps: 10, goalReps: 50, restMins: 2.5),
        dumbbell2("Dumbbell Bench",  "Dumbbell Bench Press", "", "5-10".x(5), restMins: 2.5),
        dumbbell2("Dumbbell OHP",    "Dumbbell Shoulder Press", "", "5-10".x(5), restMins: 2.5),
        barbell("Incline Bench",     "Incline Bench Press", "", "8".x(5), restMins: 2.5),
        dumbbell1("Kroc Row",        "Kroc Row", "10@50%", "5-10".x(5), restMins: 2.5),
        machine("Leg Curl",          "Seated Leg Curl", "10@50%", "10".x(5), restMins: 2.5),
        bodyweight("Leg Raise",      "Hanging Leg Raise", "15".x(3), restMins: 2.5)]

    let workouts = [
        Workout("OHP",      ["OHP", "Chinups", "Kroc Row", "Dips", "Dumbbell OHP", ], scheduled: true, optional: ["Dips", "Dumbbell OHP", "Kroc Row"]),
        Workout("Deadlift", ["Deadlift", "Leg Raise", "Ab Wheel", "Back Extensions", "Barbell Shrug"], scheduled: true, optional: ["Ab Wheel", "Back Extensions", "Barbell Shrug"]),
        Workout("Bench",    ["Bench Press", "Kroc Row", "Chinups", "Dips", "Dumbbell Bench", "Incline Bench"], scheduled: true, optional: ["Chinups", "Dips", "Dumbbell Bench", "Incline Bench"]),
        Workout("Squat",    ["Squat", "Leg Curl", "Ab Wheel", "Back Extensions", "Barbell Shrug", "Chinups"], scheduled: true, optional: ["Ab Wheel", "Back Extensions", "Barbell Shrug", "Chinups"])]
    
    let tags: [Program.Tags] = [.intermediate, .strength, .barbell, .threeDays, .fourDays, .ageUnder40, .age40s] + anySex
    
    let description = """
This is a program from [5/3/1: The Simplest and Most Effective Training System for Raw Strength](https://www.amazon.com/Simplest-Effective-Training-System-Strength-ebook/dp/B00AJ8CIQM/ref=sr_1_1?ie=UTF8&qid=1544983677&sr=8-1&keywords=5%2F3%2F1) by Jim Wendler. There are many variations of 5/3/1 (especially in his later books) but this is one of the more popular ones. It can be run as a three day or four day a week program.

The workouts cycle reps and weight. If you're running the 4 day/week variation then the weeks are as below. (If you're working out three days a week then one of the workouts will roll-over into the next week and the full cycle will extend to more than four weeks).

Week one looks like this:
* **Warmup:** 5@40% 5@50% 3@60%
* **Workset:** 5@65% 5@75% 5+@85% (the plus means to do As Many Reps As Possible)
* **Backoff:** 5@35% 5@35% 5@35% 5@35% 5@35% (you can work up to 50-60% here, also can reduce percents on each set)

Week two is like this:
* **Warmup:** 5@40% 5@50% 3@60%
* **Workset:** 3@70% 3@80% 3+@90%
* **Backoff:** 5@35% 5@35% 5@35% 5@35% 5@35%

Week three:
* **Warmup:** 5@40% 5@50% 3@60%
* **Workset:** 5@75% 3@85% 1+@95%
* **Backoff:** 5@35% 5@35% 5@35% 5@35% 5@35%

Week four (deload):
* **Workset:** 5@40% 5@50% 5@60%

The default workouts look like the above though there are a lot of optional accessory exericses you can swap in using the options screen for a workout:

**OHP**
* Overhead Press 5/3/1
* Chinups 5 sets of as many reps as possible, add weight if you can do 50 total reps

**Deadlift**
* Deadlift 5/3/1
* Leg Raise 3x15

**Bench**
* Bench Press 5/3/1
* Kroc Row 5x5-10

**Squat**
* Squat 5/3/1
* Leg Curl 5x10

**Notes**
* When starting the program you need to find your Training Max for each of the main lifts. The program will do this for you: when you start an exercise it will guide you to find the five rep max for that exercise, then it will estimate your one rep max, and use 90% of the 1RM for your training max.
* The weights may feel light, especially at first, but it's much better to use a training max that is a bit too small than one that is too large.
* Don't do the AMRAP sets to failure: try and leave one or two reps in the tank, e.g. stop if the bar speed slows significantly.
* Don't increase weights by more than 10 pounds for lower body lifts and 5 pounds for upper body lifts.
* Avoid adding too many accessory exericses.
* If you're not able to perform all the reps for an exercise, and it's not just one bad day, then use the options screen to deload that lift by 10% and start over at cycle 0.
* If you're having problems with multiple lifts then use the options screen to set the cycle index to 3 to do a deload week and after the deload week use options to set the weight to 0 so that the app will help you compute new training maxes for the main lifts.
"""
    return Program("Boring but Big (531)", workouts, exercises, tags, description)
}
