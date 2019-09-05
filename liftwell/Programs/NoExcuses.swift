//  Created by Jesse Jones on 8/15/19.
//  Copyright © 2019 MushinApps. All rights reserved.

func NoExcuses() -> Program {
    let exercises = [
        bodyweight("Burpees 1", "Burpees",           1, secs: 60),
        bodyweight("Pullups 1", "Pullup",            1, secs: 60),
        bodyweight("Squats 1",  "Body-weight Squat", 1, secs: 60),
        bodyweight("Pushups 1", "Pushup",            1, secs: 60),

        bodyweight("Burpees 2", "Burpees",           1, secs: 45),
        bodyweight("Pullups 2", "Pullup",            1, secs: 45),
        bodyweight("Squats 2",  "Body-weight Squat", 1, secs: 45),
        bodyweight("Pushups 2", "Pushup",            1, secs: 45),

        bodyweight("Burpees 3", "Burpees",           1, secs: 30),
        bodyweight("Pullups 3", "Pullup",            1, secs: 30),
        bodyweight("Squats 3",  "Body-weight Squat", 1, secs: 30),
        bodyweight("Pushups 3", "Pushup",            1, secs: 30),

        bodyweight("Burpees 4", "Burpees",           1, secs: 15),
        bodyweight("Pullups 4", "Pullup",            1, secs: 15),
        bodyweight("Squats 4",  "Body-weight Squat", 1, secs: 15),
        bodyweight("Pushups 4", "Pushup",            1, secs: 15)]
    
    let workouts = [
        Workout("Workout", ["Burpees 1", "Pullups 1", "Squats 1", "Pushups 1", "Burpees 2", "Pullups 2", "Squats 2", "Pushups 2", "Burpees 3","Pullups 3", "Squats 3", "Pushups 3", "Burpees 4", "Pullups 4", "Squats 4", "Pushups 4"], scheduled: true, optional: [])]
    
    let tags: [Program.Tags] = [.beginner, .conditioning, .minimal, .unisex] + anyAge + anyDays
    
    let description = """
This is a body-weight program by [Ross Enamait](http://rosstraining.com/blog/no-excuses/). It can be performed from one to three times a week:

**Workout**
* Burpees for 60s    round 1
* Pullups for 60s
* Squats for 60s
* Pushups for 60s

* Burpees for 45s    round 2
* Pullups for 45s
* Squats for 45s
* Pushups for 45s

* Burpees for 30s    round 3
* Pullups for 30s
* Squats for 30s
* Pushups for 30s

* Burpees for 15s    round 4
* Pullups for 15s
* Squats for 15s
* Pushups for 15s

**Notes**
* Try to do each exercise and each round with no resting.
"""
    return Program("No Excuses", workouts, exercises, tags, description)
}
