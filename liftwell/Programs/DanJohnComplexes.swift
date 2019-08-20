//  Created by Jesse Jones on 8/17/19.
//  Copyright © 2019 MushinApps. All rights reserved.
import Foundation

func DanJohnA8() -> Program {
    let exercises = [
        barbell("Complex", "A8", "", "8".x(5), restMins: 0.0, fixedSubTitle: "Row, Clean, F Squat, Press, Squat, Morn"),
    ]
    
    let workouts = [
        Workout("Complex", ["Complex"], scheduled: false, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .conditioning, .barbell, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is a program by [Dan John](https://www.t-nation.com/training/rebuild-yourself-with-complexes). It's a complex which means each exercise is done with the same set of weights, the weights should not leave your hands until a set is done, and you should aim for not resting until a set is finished.

**Workout**
* Row 8 reps
* Power Clean 8 reps
* Front Squat 8 reps
* Military Press 8 reps
* Back Squats 8 reps
* Good Morning 8 reps

**Notes**
* You can do less than five sets.
"""
    return Program("Dan John A8", workouts, exercises, tags, description)
}

