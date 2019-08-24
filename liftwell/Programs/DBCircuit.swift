//  Created by Jesse Jones on 8/23/19.
//  Copyright © 2019 MushinApps. All rights reserved.
import Foundation

func DBCircuit() -> Program {
    let exercises = [
        dumbbell2("Complex 1", "Circuit1", "", "10".x(1, rest: .atEnd), restMins: 1.0, fixedSubTitle: "Deadlift, Row, Clean"),
        dumbbell2("Complex 2", "Circuit2", "", "10".x(1, rest: .atEnd), restMins: 1.0, fixedSubTitle: "Front Squat, Curl, OHP"),
        dumbbell2("Complex 3", "Circuit3", "", "12".x(1, rest: .atEnd), restMins: 1.0, fixedSubTitle: "Crunch, Twist, Bridge")]
    
    let workouts = [
        Workout("Circuit", ["Complex 1", "Complex 2", "Complex 3"], scheduled: false, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .conditioning, .dumbbell, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is a program is [from](https://experiencelife.com/article/the-dumbbell-complex-workout/). It's a series of complexes where the exercises in each complex are done with the same set of weights, the weights should not leave your hands until the complex is done, and you should aim for not resting until the complex is finished. Aim for repeating the complex circuit 3-4x.

**Complex 1**
* Romanian Deadlift 10 reps
* Bent-over Row 10 reps
* Clean 10 reps

**Complex 2**
* Front Squat 10 reps
* Curl 10 reps
* Overhead Press 10 reps

**Complex 3**
* Weighted Crunch 12 reps
* Russian Twist 12 reps
* Weighted Glute Bridge 12 reps

**Notes**
* For each complex pick a weight where you can do 3-4 sets of 10-12 reps for the hardest exercise.
"""
    return Program("DB Circuit", workouts, exercises, tags, description)
}
