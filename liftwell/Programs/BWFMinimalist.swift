//  Created by Jesse Jones on 8/11/19.
//  Copyright © 2019 MushinApps. All rights reserved.

func BWFMinimalist() -> Program {
    let exercises = [
        bodyweight("Walking Lunge",   "Body-weight Walking Lunge", "5-10".x(1), restMins: 0.0, main: true),
        
        bodyweight("Vertical Pushup", "Vertical Pushup",  "5-10".x(1), restMins: 0.0, main: true, nextExercise: "Incline Pushup"),
        bodyweight("Incline Pushup",  "Incline Pushup",   "5-10".x(1), restMins: 0.0, main: true, prevExercise: "Vertical Pushup", nextExercise: "Full Pushup"),
        bodyweight("Full Pushup",     "Pushup",           "5-10".x(1), restMins: 0.0, main: true, prevExercise: "Incline Pushup", nextExercise: "Diamond Pushup"),
        bodyweight("Diamond Pushup",  "Diamond Pushup",   "5-10".x(1), restMins: 0.0, main: true, prevExercise: "Full Pushup", nextExercise: "Pseudo Planche"),
        bodyweight("Pseudo Planche",  "Pseudo Planche Pushups", "5-10".x(1), restMins: 0.0, main: true, prevExercise: "Diamond Pushup"),

        bodyweight("Vertical Rows",   "Vertical Rows",     "5-10".x(1), restMins: 0.0, main: true, nextExercise: "Incline Rows"),
        bodyweight("Incline Rows",    "Incline Rows",      "5-10".x(1), restMins: 0.0, main: true, prevExercise: "Vertical Rows", nextExercise: "Horz Rows"),
        bodyweight("Horz Rows",       "Horizontal Rows",   "5-10".x(1), restMins: 0.0, main: true, prevExercise: "Incline Rows", nextExercise: "Wide Rows"),
        bodyweight("Wide Rows",       "Wide Rows",         "5-10".x(1), restMins: 0.0, main: true, prevExercise: "Horz Rows", nextExercise: "Weighted Inverted Rows"),
        bodyweight("Weighted Inverted Rows", "Weighted Inverted Row", "5-10".x(1), restMins: 0.0, main: true, prevExercise: "Wide Rows"),

        bodyweight("Shoulder Taps",   "Plank Shoulder Taps", "5-10".x(1), restMins: 0.0),
    
        // omitted Superman in favor of Bird-dog per https://www.duncansportspt.com/2015/07/superman-exercise
        bodyweight("Bird-dog",        "Bird-dog",            "5-10".x(1), restMins: 0.0),
        bodyweight("Deadbugs",        "Deadbugs",             1, secs: 30),

        bodyweight("Romanian Deadlift",            "Body-weight Romanian Deadlift",   "5-10".x(1), restMins: 0.0, main: false, nextExercise: "Single Legged Deadlift"),
        bodyweight("Single Legged Deadlift",       "Body-weight Single Leg Deadlift", "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Romanian Deadlift", nextExercise: "Banded Nordic Curl Negatives"),
        bodyweight("Banded Nordic Curl Negatives", "Banded Nordic Curl",              "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Single Legged Deadlift", nextExercise: "Banded Nordic Curl"),
        bodyweight("Banded Nordic Curl",           "Banded Nordic Curl",              "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Banded Nordic Curl Negatives", nextExercise: "Nordic Curls"),
        bodyweight("Nordic Curls",                 "Banded Nordic Curl",              "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Banded Nordic Curl"),

        bodyweight("Assisted Squat",            "Assisted Squat",            "5-10".x(1), restMins: 0.0, main: false, nextExercise: "Squat"),
        bodyweight("Squat",                     "Body-weight Squat",         "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Assisted Squat", nextExercise: "Split Squat"),
        bodyweight("Split Squat",               "Body-weight Split Squat",   "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Squat", nextExercise: "Bulgarian Split Squat"),
        bodyweight("Bulgarian Split Squat",     "Body-weight Bulgarian Split Squat",     "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Split Squat", nextExercise: "Beginner Shrimp Squat"),
        bodyweight("Beginner Shrimp Squat",     "Beginner Shrimp Squat",     "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Bulgarian Split Squat", nextExercise: "Intermediate Shrimp Squat"),
        bodyweight("Intermediate Shrimp Squat", "Intermediate Shrimp Squat", "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Beginner Shrimp Squat", nextExercise: "Advanced Shrimp Squat"),
        bodyweight("Advanced Shrimp Squat",     "Advanced Shrimp Squat",     "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Intermediate Shrimp Squat", nextExercise: "Weighted Shrimp Squat"),
        bodyweight("Weighted Shrimp Squat",     "Advanced Shrimp Squat",     "5-10".x(1), restMins: 0.0, main: false, prevExercise: "Advanced Shrimp Squat")]
    
    let workouts = [
        Workout("Workout", ["Walking Lunge", "Vertical Pushup", "Incline Pushup", "Full Pushup", "Diamond Pushup", "Pseudo Planche", "Vertical Rows", "Incline Rows", "Horz Rows", "Wide Rows", "Weighted Inverted Rows", "Shoulder Taps", "Bird-dog", "Deadbugs", "Romanian Deadlift", "Single Legged Deadlift", "Banded Nordic Curl Negatives", "Banded Nordic Curl", "Nordic Curls", "Assisted Squat", "Squat", "Split Squat", "Bulgarian Split Squat", "Beginner Shrimp Squat", "Intermediate Shrimp Squat", "Advanced Shrimp Squat", "Weighted Shrimp Squat"], scheduled: false, optional: ["Incline Pushup", "Full Pushup", "Diamond Pushup", "Pseudo Planche", "Incline Rows", "Horz Rows", "Wide Rows", "Weighted Inverted Rows", "Bird-dog", "Deadbugs", "Romanian Deadlift", "Single Legged Deadlift", "Banded Nordic Curl Negatives", "Banded Nordic Curl", "Nordic Curls", "Assisted Squat", "Squat", "Split Squat", "Bulgarian Split Squat", "Beginner Shrimp Squat", "Intermediate Shrimp Squat", "Advanced Shrimp Squat", "Weighted Shrimp Squat"])]
    
    let tags: [Program.Tags] = [.beginner, .strength, .minimal, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is a bare bones program from the [bodyweight fitness](https://old.reddit.com/r/bodyweightfitness/wiki/minroutine) reddit. You can do this program every day, but if you want to gain strength it's best to do it three times a week with a day of rest between each workout. Do 2-6 circuits of the following exercises:

**Workout**
* Walking Lunges 1x5-10
* [Pushup Progression](https://old.reddit.com/r/bodyweightfitness/wiki/exercises/pushup) 1x5-10
* [Row Progression](https://old.reddit.com/r/bodyweightfitness/wiki/exercises/row) 1x5-10
* Plank Shoulder Taps 1x5-10

**Notes**
* Once you can do three circuits of push ups or rows at 8-10 reps you can move on to a harder version.
* Take little or no rest.
* Additional exercises can be enabled via the Workout options screen.
"""
    return Program("BWF Minimalist", workouts, exercises, tags, description)
}
