//  Created by Jesse Jones on 11/14/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

func FiveThreeOneBeginner() -> Program {
    let warmup    = "5@40% 5@50% 3@60%"

    let worksets1 = "5@65% R 5@75% R 5+@85% R"
    let backoff1  = "5@65%".x(4, rest: .none)
    let sets1     = (warmup, worksets1, backoff1)

    let worksets2 = "3@70% R 3@80% R 3+@90% R"
    let backoff2  = "5@70%".x(4, rest: .none)
    let sets2     = (warmup, worksets2, backoff2)

    let worksets3 = "5@75% R 3@85% R 1+@95% R"
    let backoff3  = "5@75%".x(4, rest: .none)
    let sets3     = (warmup, worksets3, backoff3)
    
    let sets = [sets1, sets2, sets3]

    let assistence  = "8-12 R 8-12 R 8-12 R 8-12"

    let exercises: [Exercise] = [
        barbell("Squat",       "Low bar Squat", sets, restMins: 2.0, trainingMaxPercent: 0.9, main: true),
        barbell("Bench Press", "Bench Press", sets, restMins: 2.0, trainingMaxPercent: 0.9, main: true),
        barbell("Deadlift",    "Deadlift", sets, restMins: 2.0, bumpers: defaultBumpers(), trainingMaxPercent: 0.9, main: true),
        barbell("OHP",         "Overhead Press", sets, restMins: 2.0, trainingMaxPercent: 0.9, main: true),

        // Push
        bodyweight("Dips",          "Dips",                        4, by: 12, restMins: 1.5),
        dumbbell2("Dumbbell Bench", "Dumbbell Bench Press",    "", assistence, restMins: 1.5),
        dumbbell2("Dumbbell OHP",   "Dumbbell Shoulder Press", "", assistence, restMins: 1.5),
        bodyweight("Pushup",        "Pushup",                      4, by: 12, restMins: 1.5),
        cable("Triceps Pushdown",   "Triceps Pushdown (rope)", "", assistence, restMins: 1.5),

        // Pull
        bodyweight("Band Pull Apart", "Band Pull Apart",      4, by: 12),
        bodyweight("Chinups",         "Chinup",               numSets: 4, goalReps: 50, restMins: 2.0, restAtEnd: false),
        cable("Face Pull",            "Face Pull", "",        assistence, restMins: 1.5),
        bodyweight("Inverted Row",    "Inverted Row",         4, by: 12, restMins: 1.5),
        cable("Lat Pulldown",         "Lat Pulldown", "",     assistence, restMins: 1.5),
        barbell("Preacher Curl",      "Preacher Curl", "",    assistence, restMins: 1.5),
        cable("Seated Cable Row",     "Seated Cable Row", "", assistence, restMins: 1.5),

        // Single Leg/Core
        bodyweight("Ab Wheel Rollout",  "Ab Wheel Rollout",                    4, by: 12, restMins: 1.5),
        dumbbell1("Back Extensions",    "Back Extensions",                 "", assistence, restMins: 1.5),
        cable("Cable Crunch",           "Cable Crunch", "",                    assistence, restMins: 1.5),
        dumbbell2("Dumbbell Lunge",     "Dumbbell Lunge", "",                  assistence, restMins: 1.5),
        bodyweight("Kettlebell Snatch", "One-Arm Kettlebell Snatch",           4, by: 12, restMins: 1.5),
        bodyweight("Kettlebell Swing",  "Kettlebell Two Arm Swing",            4, by: 12, restMins: 1.5),
        bodyweight("Reverse Hyper",     "Reverse Hyperextension",              4, by: 12, restMins: 1.5),
        dumbbell2("Spell Caster",       "Spell Caster", "",                    assistence, restMins: 1.5),
        dumbbell2("Split Squat",        "Dumbbell Single Leg Split Squat", "", assistence, restMins: 1.5),
        dumbbell2("Step-ups",           "Step-ups",                        "", assistence, restMins: 1.5),
        ]
    
    let workouts = [
        Workout("A", ["Squat", "Bench Press", "Dips", "Dumbbell Bench",    "Ab Wheel Rollout", "Back Extensions", "Cable Crunch", "Dumbbell Lunge", "Dumbbell OHP", "Kettlebell Snatch", "Kettlebell Swing", "Pushup", "Reverse Hyper", "Spell Caster", "Split Squat", "Step-ups", "Triceps Pushdown"], scheduled: true, optional: ["Ab Wheel Rollout", "Back Extensions", "Cable Crunch", "Dumbbell Lunge", "Dumbbell OHP", "Kettlebell Snatch", "Kettlebell Swing", "Pushup", "Reverse Hyper", "Spell Caster", "Split Squat", "Triceps Pushdown"]),
        
        Workout("B", ["Deadlift", "OHP", "Back Extensions", "Preacher Curl",    "Ab Wheel Rollout", "Band Pull Apart", "Cable Crunch", "Chinups", "Dumbbell Lunge", "Face Pull", "Inverted Row", "Kettlebell Snatch", "Kettlebell Swing", "Lat Pulldown", "Reverse Hyper", "Spell Caster", "Split Squat", "Seated Cable Row", "Step-ups"], scheduled: true, optional: ["Ab Wheel Rollout", "Band Pull Apart", "Cable Crunch", "Face Pull", "Chinups", "Dumbbell Lunge", "Inverted Row", "Kettlebell Snatch", "Kettlebell Swing", "Lat Pulldown", "Reverse Hyper", "Spell Caster", "Split Squat", "Seated Cable Row", "Step-ups"]),
        
        Workout("C", ["Bench Press", "Squat", "Dumbbell OHP", "Split Squat",    "Ab Wheel Rollout", "Back Extensions", "Cable Crunch", "Dips", "Dumbbell Bench", "Dumbbell Lunge", "Kettlebell Snatch", "Kettlebell Swing", "Pushup", "Reverse Hyper", "Spell Caster", "Step-ups", "Triceps Pushdown"], scheduled: true, optional: ["Ab Wheel Rollout", "Back Extensions", "Cable Crunch", "Dips", "Dumbbell Bench", "Dumbbell Lunge", "Kettlebell Snatch", "Kettlebell Swing", "Pushup", "Reverse Hyper", "Spell Caster", "Step-ups", "Triceps Pushdown"])]
    
    let tags: [Program.Tags] = [.beginner, .strength, .barbell, .unisex, .threeDays, .ageUnder40, .age40s]
    
    // TODO: this did call for re-checking the training max after every third cycle. If we do this we should ask the user if he really wants
    // to do that and we'll need to make sure that this can be edited.
    let description = """
[This program](https://old.reddit.com/r/Fitness/wiki/531-beginners) and [GZCLP](https://www.reddit.com/r/Fitness/wiki/gzclp) are the two programs recommended by reddit/fitness if you're familiar with the barbell lifts or if you have run [Phrak's Greyskull](https://old.reddit.com/r/Fitness/wiki/phraks-gslp) program for a few months. This program is based on three week cycles where each week the volume goes down but percentages go up. After the third week the weight should normally go up. It's a three days a week program.

Before each workout do 10-15 reps over 3 sets of Box Jumps, Broad Jumps, or Medicine Ball Throws.

Worksets for the main lifts are done using up to five reps. After finishing a workset five backoff sets are done using the percentage from the first workset.

Week one looks like this:
* **Warmup:** 5@40% 5@50% 3@60%
* **Workset:** 5@65% 5@75% 5+@85% (the plus means to do As Many Reps As Possible)
* **Backoff:** 5@65% 5@65% 5@65% 5@65% 5@65%

Week two is like this:
* **Warmup:** 5@40% 5@50% 3@60%
* **Workset:** 3@70% 3@80% 3+@90%
* **Backoff:** 5@70% 5@70% 5@70% 5@70% 5@70%

And week three:
* **Warmup:** 5@40% 5@50% 3@60%
* **Workset:** 5@75% 3@85% 1+@95%
* **Backoff:** 5@75% 5@75% 5@75% 5@75% 5@75%

You'll be asked if you want to increase weights after week three.

The workouts are:
**A**
* Squat
* Bench Press
* Assistence

**B**
* Deadlift
* Overhead Press
* Assistence

**C**
* Bench Press
* Squat
* Assistence

There are a lot of options for assistence work (you can switch them up using the Options button in the Workout screen). Do 50-100 total reps spread over one or two exercises.

**Notes**
* 5/3/1 is designed around driving progress by using lots of reps well under the max weight you can lift.
* When starting the program you need to find your Training Max for each of the main lifts. The program will do this for you: when you start an exercise it will guide you to find the five rep max for that exercise, then it will estimate your one rep max, and use 90% of the 1RM for your training max.
* The weights may feel light, especially at first, but it's much better to use a training max that is a bit too small than one that is too large.
* Don't do the AMRAP sets to failure: try and leave one or two reps in the tank, e.g. stop if the bar speed slows significantly.
* At the end of the three week cycle you'll be prompted to add weight. Normally you should add 5 pounds to upper body lifts and 10 pounts to lower body lifts. **Don't** adjust weight based on how well you did on the AMRAP sets.
* If you're consistently missing reps or they are not clean, fast reps then you can lower the training max by 3x the amount you used for incrementing.
* It is recommended to include cardio work but not to the point where you start feeling tired on lift days.
"""
    return Program("5/3/1 Beginner", workouts, exercises, tags, description)
}

