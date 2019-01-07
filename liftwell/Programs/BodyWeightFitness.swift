//  Created by Jesse Jones on 1/3/19.
//  Copyright © 2019 MushinApps. All rights reserved.

func BodyWeight() -> Program {
    let exercises = [
        // Stretch
        bodyweight("Yuri's Shoulder Band", "Yuri's Shoulder Band", "5-10".x(1), restMins: 0.0),
        bodyweight("Squat Sky Reaches",    "Squat Sky Reaches",    "5-10".x(1), restMins: 0.0),
        bodyweight("GMB Wrist Prep",       "GMB Wrist Prep",       "10+".x(1), restMins: 0.0),
        bodyweight("Deadbugs",             "Deadbugs",             1, secs: 30),
        bodyweight("Arch Hang Warmup",     "Arch Hangs",           "10".x(1), restMins: 0.0),
        bodyweight("Support Hold Warmup",  "Support Hold",         1, secs: 30),

        bodyweight("Assisted Squat Warmup",            "Assisted Squat",            "10".x(1), restMins: 0.0, nextExercise: "Squat Warmup"),
        bodyweight("Squat Warmup",                     "Body-weight Squat",         "10".x(1), restMins: 0.0, prevExercise: "Assisted Squat Warmup", nextExercise: "Split Squat Warmup"),
        bodyweight("Split Squat Warmup",               "Body-weight Split Squat",   "10".x(1), restMins: 0.0, prevExercise: "Squat Warmup", nextExercise: "Bulgarian Split Squat Warmup"),
        bodyweight("Bulgarian Split Squat Warmup",     "Body-weight Bulgarian Split Squat",     "10".x(1), restMins: 0.0, prevExercise: "Split Squat Warmup", nextExercise: "Beginner Shrimp Squat Warmup"),
        bodyweight("Beginner Shrimp Squat Warmup",     "Beginner Shrimp Squat",     "10".x(1), restMins: 0.0, prevExercise: "Bulgarian Split Squat Warmup", nextExercise: "Intermediate Shrimp Squat Warmup"),
        bodyweight("Intermediate Shrimp Squat Warmup", "Intermediate Shrimp Squat", "10".x(1), restMins: 0.0, prevExercise: "Beginner Shrimp Squat Warmup", nextExercise: "Advanced Shrimp Squat Warmup"),
        bodyweight("Advanced Shrimp Squat Warmup",     "Advanced Shrimp Squat",     "10".x(1), restMins: 0.0, prevExercise: "Intermediate Shrimp Squat Warmup"),

        bodyweight("Romanian Deadlift Warmup",            "Body-weight Romanian Deadlift",   "10".x(1), restMins: 0.0, nextExercise: "Single Legged Deadlift Warmup"),
        bodyweight("Single Legged Deadlift Warmup",       "Body-weight Single Leg Deadlift", "10".x(1), restMins: 0.0, prevExercise: "Romanian Deadlift Warmup", nextExercise: "Banded Nordic Curl Negatives Warmup"),
        bodyweight("Banded Nordic Curl Negatives Warmup", "Banded Nordic Curl",              "10".x(1), restMins: 0.0, prevExercise: "Single Legged Deadlift Warmup", nextExercise: "Banded Nordic Curl Warmup"),
        bodyweight("Banded Nordic Curl Warmup",           "Banded Nordic Curl",              "10".x(1), restMins: 0.0, prevExercise: "Banded Nordic Curl Negatives Warmup"),

        // Strength
        bodyweight("Scapular Pulls",   "Shoulder Dislocate", "5-8".x(3), restMins: 1.5, main: true, nextExercise: "Arch Hangs"),
        bodyweight("Arch Hangs",       "Arch Hangs",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Scapular Pulls", nextExercise: "Negative Pullups"),
        bodyweight("Negative Pullups", "Pullup Negative",    "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Arch Hangs", nextExercise: "Pullups"),
        bodyweight("Pullups",          "Pullup",             "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Negative Pullups", nextExercise: "Weighted Pullups"),
        bodyweight("Weighted Pullups", "Pullup",             "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Pullups"),

        bodyweight("Assisted Squat",            "Assisted Squat",            "5-8".x(3), restMins: 1.5, main: true, nextExercise: "Squat"),
        bodyweight("Squat",                     "Body-weight Squat",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Assisted Squat", nextExercise: "Split Squat"),
        bodyweight("Split Squat",               "Body-weight Split Squat",   "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Squat", nextExercise: "Bulgarian Split Squat"),
        bodyweight("Bulgarian Split Squat",     "Body-weight Bulgarian Split Squat",     "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Split Squat", nextExercise: "Beginner Shrimp Squat"),
        bodyweight("Beginner Shrimp Squat",     "Beginner Shrimp Squat",     "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Bulgarian Split Squat", nextExercise: "Intermediate Shrimp Squat"),
        bodyweight("Intermediate Shrimp Squat", "Intermediate Shrimp Squat", "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Beginner Shrimp Squat", nextExercise: "Advanced Shrimp Squat"),
        bodyweight("Advanced Shrimp Squat",     "Advanced Shrimp Squat",     "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Intermediate Shrimp Squat", nextExercise: "Weighted Shrimp Squat"),
        bodyweight("Weighted Shrimp Squat",     "Advanced Shrimp Squat",     "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Advanced Shrimp Squat"),

        bodyweight("Parallel Bar",  "Parallel Bar Support", "5-8".x(3), restMins: 1.5, main: true, nextExercise: "Support Hold"),
        bodyweight("Support Hold",  "Support Hold",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Parallel Bar", nextExercise: "Negative Dips"),
        bodyweight("Negative Dips", "Dips",                 "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Support Hold", nextExercise: "Dips"),
        bodyweight("Dips",          "Dips",                 "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Negative Dips", nextExercise: "Weighted Dips"),
        bodyweight("Weighted Dips", "Dips",                 "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Dips"),

        bodyweight("Romanian Deadlift",            "Body-weight Romanian Deadlift",   "5-8".x(3), restMins: 1.5, main: true, nextExercise: "Single Legged Deadlift"),
        bodyweight("Single Legged Deadlift",       "Body-weight Single Leg Deadlift", "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Romanian Deadlift", nextExercise: "Banded Nordic Curl Negatives"),
        bodyweight("Banded Nordic Curl Negatives", "Banded Nordic Curl",              "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Single Legged Deadlift", nextExercise: "Banded Nordic Curl"),
        bodyweight("Banded Nordic Curl",           "Banded Nordic Curl",              "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Banded Nordic Curl Negatives", nextExercise: "Nordic Curls"),
        bodyweight("Nordic Curls",                 "Banded Nordic Curl",              "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Banded Nordic Curl"),

        bodyweight("Vertical Rows",          "Vertical Rows",         "5-8".x(3), restMins: 1.5, main: true, nextExercise: "Incline Rows"),
        bodyweight("Incline Rows",           "Incline Rows",          "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Vertical Rows", nextExercise: "Horz Rows"),
        bodyweight("Horz Rows",              "Horizontal Rows",       "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Incline Rows", nextExercise: "Wide Rows"),
        bodyweight("Wide Rows",              "Wide Rows",             "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Horz Rows", nextExercise: "Weighted Inverted Rows"),
        bodyweight("Weighted Inverted Rows", "Weighted Inverted Row", "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Wide Rows"),

        bodyweight("Vertical Pushup",        "Vertical Pushup",        "5-8".x(3), restMins: 1.5, main: true, nextExercise: "Incline Pushup"),
        bodyweight("Incline Pushup",         "Incline Pushup",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Vertical Pushup", nextExercise: "Full Pushup"),
        bodyweight("Full Pushup",            "Pushup",                 "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Incline Pushup", nextExercise: "Diamond Pushup"),
        bodyweight("Diamond Pushup",         "Diamond Pushup",         "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Full Pushup", nextExercise: "Pseudo Planche"),
        bodyweight("Pseudo Planche",         "Pseudo Planche Pushups", "5-8".x(3), restMins: 1.5, main: true, prevExercise: "Diamond Pushup"),

        bodyweight("Plank",            "Front Plank",         "8-12".x(3), restMins: 1.5, main: true, nextExercise: "Ring Ab Rollouts"),
        bodyweight("Ring Ab Rollouts", "Ring Ab Rollouts",    "8-12".x(3), restMins: 1.5, main: true, prevExercise: "Plank"),

        bodyweight("Banded Pallof Press",    "Pallof Press",           "8-12".x(3), restMins: 1.5, main: true),

        bodyweight("Reverse Hyperextension", "Reverse Hyperextension", "8-12".x(3), restMins: 1.5, main: true)]
    
    let workouts = [
        Workout("Stretch", ["Yuri's Shoulder Band", "Squat Sky Reaches", "GMB Wrist Prep", "Deadbugs",
            "Arch Hang Warmup", "Support Hold Warmup", "Assisted Squat Warmup", "Squat Warmup", "Split Squat Warmup", "Bulgarian Split Squat Warmup", "Beginner Shrimp Squat Warmup", "Intermediate Shrimp Squat Warmup", "Advanced Shrimp Squat Warmup",
            "Romanian Deadlift Warmup", "Single Legged Deadlift Warmup", "Banded Nordic Curl Negatives Warmup", "Banded Nordic Curl Warmup"], scheduled: false, optional: ["Arch Hang Warmup", "Support Hold Warmup", "Assisted Squat Warmup", "Squat Warmup", "Split Squat Warmup", "Bulgarian Split Squat Warmup", "Beginner Shrimp Squat Warmup", "Intermediate Shrimp Squat Warmup", "Advanced Shrimp Squat Warmup", "Romanian Deadlift Warmup", "Single Legged Deadlift Warmup", "Banded Nordic Curl Negatives Warmup", "Banded Nordic Curl Warmup"]),
        
        Workout("Strength", ["Scapular Pulls", "Arch Hangs", "Negative Pullups", "Pullups", "Weighted Pullups",
            "Assisted Squat", "Squat", "Split Squat", "Bulgarian Split Squat", "Beginner Shrimp Squat", "Intermediate Shrimp Squat", "Advanced Shrimp Squat", "Weighted Shrimp Squat",
            "Parallel Bar", "Support Hold", "Negative Dips", "Dips", "Weighted Dips",
            "Romanian Deadlift", "Single Legged Deadlift", "Banded Nordic Curl Negatives", "Banded Nordic Curl", "Nordic Curls",
            "Vertical Rows", "Incline Rows", "Horz Rows", "Wide Rows", "Weighted Inverted Rows",
            "Vertical Pushup", "Incline Pushup", "Full Pushup", "Diamond Pushup", "Pseudo Planche",
            "Plank", "Ring Ab Rollouts",
            "Banded Pallof Press", "Reverse Hyperextension"], scheduled: false, optional: ["Arch Hangs", "Negative Pullups", "Pullups", "Weighted Pullups", "Squat", "Split Squat", "Bulgarian Split Squat", "Beginner Shrimp Squat", "Intermediate Shrimp Squat", "Advanced Shrimp Squat", "Weighted Shrimp Squat", "Support Hold", "Negative Dips", "Dips", "Weighted Dips", "Romanian Deadlift", "Single Legged Deadlift", "Banded Nordic Curl Negatives", "Banded Nordic Curl", "Nordic Curls", "Incline Rows", "Horz Rows", "Wide Rows", "Weighted Inverted Rows", "Incline Pushup", "Full Pushup", "Diamond Pushup", "Pseudo Planche", "Ring Ab Rollouts"])]
    
    let tags: [Program.Tags] = [.beginner, .strength, .minimal, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is the recommended program from the [bodyweight fitness](https://old.reddit.com/r/bodyweightfitness/wiki/kb/recommended_routine) reddit. Do both the strech and strength workouts three times a week::

**Stretch**
* Yuri's Shoulder Band 5-10
* Squat Sky Reaches 5-10
* GMB Wrist Prep 10+
* Deadbugs 30s
* Arch Hangs 10 (add these after you can do Negative Pullups)
* Support Hold 30s (add these after you can do Negative Dips)
* Easier Squat (add an earlier Squat once you can do Bugarian Split Squats)
* Easier Hinge (add an earlier Hinge once you can do Banded Nordic Curls)

**Strength**
* Pullup Progression 3x5-8
* Squat Progression 3x5-8

* Dip Progression 3x5-8
* Hinge Progression 3x5-8

* Row Progression 3x5-8
* Pushup Progression 3x5-8

* Anti-extension Progression 3x8-12
* Anti-rotation Progression 3x8-12
* Extension Progression 3x8-12

**Notes**
* The Strength exercises come in pairs and triplets. To save time you can do one set of the first pair, wait 90s. do a set of the next pair, and repeat until you've done all the sets.
* In each workout try to do better then your last workout.
* Once you can do eight reps (or 30s) of a strength exercise use the Options screen in the workout to progress to a harder version of the exercise.
* Similarly once you progress on the Strength exercises use the Options screen in the Stretch workout to activate harder stretches.
"""
    return Program("Body Weight Fitness", workouts, exercises, tags, description)
}
