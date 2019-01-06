//  Created by Jesse Jones on 1/3/19.
//  Copyright © 2019 MushinApps. All rights reserved.

func BodyWeight() -> Program {
    let exercises = [
        
        // Stretch
        bodyweight("Yuri's Shoulder Band", "Yuri's Shoulder Band", "5-10".x(1), restMins: 0.0),
        
        bodyweight("Scapular Pulls",     "Shoulder Dislocate", "5-8".x(3), restMins: 1.5, main: true),
        bodyweight("Arch Hangs",         "Arch Hangs",         "5-8".x(3), restMins: 1.5, main: true),
        //bodyweight("Chinup Progression", ["Scapular Pulls", "Arch Hangs"]),
    ]
    
    let workouts = [
        Workout("Stretch", ["Yuri's Shoulder Band"], scheduled: true, optional: []),
        Workout("Strength", ["Chinup Progression"], scheduled: true)]
    
    let tags: [Program.Tags] = [.beginner, .strength, .minimal, .unisex, .threeDays, .ageUnder40, .age40s, .age50s]
    
    let description = """
This is the recommended program from reddit's [bodyweight fitness](https://old.reddit.com/r/bodyweightfitness/wiki/kb/recommended_routine):

**Stretch**
* TODO 3x6-12

**Strength**
* TODO 3x6-12
"""
    return Program("Body Weight Fitness", workouts, exercises, tags, description)
}
