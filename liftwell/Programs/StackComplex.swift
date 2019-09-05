//  Created by Jesse Jones on 8/17/19.
//  Copyright © 2019 MushinApps. All rights reserved.
import Foundation

func StackComplex() -> Program {
    let exercises = [
        dumbbell2("Complex", "Stack Complex", "", "8".x(8), restMins: 0.75, fixedSubTitle: "Press, Squat, Deadlift, Row, Pushup, Sprint")]
    
    let workouts = [
        Workout("Complex", ["Complex"], scheduled: false, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .conditioning, .dumbbell, .unisex, .threeDays] + anyAge
    
    let description = """
This is a program from [Stack](https://www.stack.com/a/a-dumbbell-complex-workout-to-build-muscle-and-quickly-shed-fat). It's a complex which means each exercise is done with the same set of weights, the weights should not leave your hands until a set is done, and you should aim for not resting until a set is finished.

**Workout**
* DB Push Press 8 reps
* DB Front Squat 8 reps
* DB Romanian Deadlifts 8 reps
* DB Bent-over Row 8 reps
* DB Elevated Pushups 8 reps
* Max effort bike sprint 30s

**Notes**
* Aim for 6-8 sets.
* You can elect to take a 2-4 min break half-way through.
"""
    return Program("Stack DB Complex", workouts, exercises, tags, description)
}

func PerryComplex() -> Program {
    let exercises = [
        dumbbell2("Complex", "Perry Complex", "", "6".x(5), restMins: 0.75, fixedSubTitle: "Squat, Lunge, Row, Curl&Press")]
    
    let workouts = [
        Workout("Complex", ["Complex"], scheduled: false, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .conditioning, .dumbbell, .unisex, .threeDays, .fourDays, .fiveDays, .sixDays] + anyAge
    
    let description = """
This is a program from [Marc Perry](https://www.builtlean.com/2012/04/10/dumbbell-complex/). It's a complex which means each exercise is done with the same set of weights, the weights should not leave your hands until a set is done, and you should aim for not resting until a set is finished.

**Workout**
* DB Front Squat 6 reps
* DB Forward Lunges 6 reps
* DB Bent-over Row 6 reps
* DB Curl & Press 6 reps

**Notes**
* Start with a weight that you can do for 10-15 reps for the hardest exercise.
* If your grip becomes a problem you can use straps.
"""
    return Program("Perry DB Complex", workouts, exercises, tags, description)
}

