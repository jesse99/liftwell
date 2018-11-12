//  Created by Jesse Jones on 11/1/18.
//  Copyright © 2018 MushinApps. All rights reserved.
import Foundation

private func createNote(notes: [String], links: [String: String]) -> String {
    let ammended = notes.map {"* " + $0}
    var text = ammended.joined(separator: "\n")
    text += "\n\n"
    
    for (name, link) in links {
        text += "[\(name)](\(link))\n\n"
    }
    
    return text
}

// It'd be nice to filter this by exercise type and perhaps apparatus so that users don't have
// to wade through a ton of exercises to select the matching one. But it's not always clear how
// to categorize an exercise, e.g. a back extension could equally sensibly be body weight or
// dumbbell. And there are programs that do odd things like turning a cable seated row into a
// timed exercise by having users do as many reps as possible within a time window.
let builtInNotes: [String: String] = [
    "Ab Wheel Rollout": createNote(
        notes: [
            "Hold the ab wheel with both hands and kneel on the floor.",
            "Roll the wheel straight forward as far as you can without touching the floor with your body.",
            "Pause and slowly roll back."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/ab-roller", "Video": "https://www.youtube.com/watch?v=uYBOBBv9GzY"]),
    
    "Adductor Foam Roll": createNote(
        notes: [
            "Lay face down on the floor using upper hands to support your upper body.",
            "Place the inside of your thigh on the foam roller.",
            "Slowly roll up and down and side to side.",
            "Pause on areas that are especially tender until they feel better."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/adductor"]),
    
    "Advanced Shrimp Squat": createNote(
        notes: [
            "Stand straight up with your hands stretched out in front of you.",
            "Raise one leg so that your shin is above parallel to the floor.",
            "Squat down until your elevated leg touches down at the knee, but not at the toes.",
            "Hold onto your elevated knee as you descend."],
        links: ["Video": "https://www.youtube.com/watch?v=TKt0-c83GSc&feature=youtu.be&t=3m9s"]),
    
    "Advanced Tuck Front Lever Row": createNote(
        notes: [
            "Get into a loosely tucked front level position.",
            "Pull your body up as high as possible while remaining horizontal."],
        links: ["Link": "https://www.youtube.com/watch?v=cVdb8oUGKAw", "Body Weight Rows": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/row"]),
    
    "Arch Hangs": createNote(
        notes: [
            "Hang off a pullup bar.",
            "Bring your head and shoulders back and arch your entire body",
            "Try to pinch your shoulder blades together and keep your elbows straight."],
        links: ["Link": "https://www.youtube.com/watch?v=C995b3KLXS4&feature=youtu.be&t=7s"]),
    
    "Arch Hold": createNote(
        notes: [
            "Lay face down.",
            "Place hands behind you off the floor, lift chest up, raise legs off the floor.",
            "Remember to breathe.",
            "Difficulty can be increased by moving hands out in front of you."],
        links: ["Link": "https://www.youtube.com/watch?v=44ScXWFaVBs&feature=youtu.be&t=3m34s"]),
    
    "Arm & Leg Lift Front Plank": createNote(
        notes: [
            "Adopt the normal front plank position.",
            "Raise one leg and the opposite arm so that they are parallel to the floor.",
            "Halfway through switch up your limbs."],
        links: ["Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Arm & Leg Lift Side Plank": createNote(
        notes: [
            "Adopt the normal side plank position.",
            "Extend one arm all the way up and raise separate your legs.",
            "Halfway through flip to the other side."],
        links: ["Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Arnold Press": createNote(
        notes: [
            "Sit on a bench with back support.",
            "Hold two dumbbells in front of you at about shoulder height with palms facing inward.",
            "Raise the dumbbells while rotating them so that your palms face outward.",
            "Lower the dumbbells rotating them back to the original position."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/arnold-dumbbell-press"]),
    
    "Assisted Squat": createNote(
        notes: [
            "Use a chair or something else to support you as you squat.",
            "Reduce the use of the support over time."],
        links: ["Link": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/squat", "Body Weight Squats": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/squat"]),
    
    "Back Extension": createNote(
        notes: [
            "Lie face down on a hyperextension bench.",
            "Keep knees slightly bent, angle feet out.",
            "Bend forward as far as possible while keeping back straight.",
            "Raise upwards again keeping back straight.",
            "Stop once your body forms a straight line.",
            "Difficulty can be increased by clasping your hands behind your head (prisoner position), by bracing yourself with one leg, or by holding a weight to your chest."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/hyperextensions-back-extensions", "Video": "https://bretcontreras.com/back-extensions/"]),
    
    "Band Anti-Rotary Hold": createNote(
        notes: [
            "Attach a resistance band to a support.",
            "Stretch the band out and stand so that you are perpendicular to the band.",
            "Extend your arms straight out.",
            "Hold that position."],
        links: ["Video": "https://www.youtube.com/watch?v=xwoPR2_F6qc"]),
    
    "Band Seated Abduction": createNote(
        notes: [
            "Sit on a box or low chair.",
            "Place a resistance band just below your knees.",
            "Clasp your hands on your chest.",
            "Keep your feet on the floor and extend your knees out and back in."],
        links: ["Video": "https://www.youtube.com/watch?v=uo4_wM5r7zY"]),
    
    "Band Standing Abduction": createNote(
        notes: [
            "Place a resistance band just above your ankles.",
            "Use one hand to brace yourself.",
            "Bring one foot up off the floor and to the side."],
        links: ["Video": "https://www.youtube.com/watch?v=HzUgVEAjixY"]),
    
    "Banded Nordic Curl": createNote(
        notes: [
            "Kneel on the ground.",
            "Secure a band to a support and wrap it around your chest.",
            "Lean forward.",
            "Keep your back straight at all times."],
        links: ["Video": "https://www.youtube.com/watch?v=HUXS3S2xSX4"]),
    
    "Bar Pullover": createNote(
        notes: [
            "Do a pullup and as you come up bring your legs up and spin around the bar.",
            "From the top roll forward, lower your legs, and no a negative pullup."],
        links: ["Link": "https://www.youtube.com/watch?v=saLtuweg8As", "Pullups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pullup"]),
    
    "Barbell Curl": createNote(
        notes: [
            "Use an EZ bar or a regular barbell.",
            "Grip bar at shoulder width with palms facing out,",
            "Pull upwards until forearms are vertical.",
            "Lower until arms are straightened out."],
        links: ["Link": "http://www.exrx.net/WeightExercises/Biceps/BBCurl.html"]),
    
    "Barbell Lunge": createNote(
        notes: [
            "Load up a bar within a squat rack.",
            "Step under the bar and place it just below your neck.",
            "Step away from the rack and squat down with one leg.",
            "Squat with the other leg and repeat.",
            "When pushing up drive through your heels.",
            "Keep your torso upright.",
            "Don't allow your knees to go forward beyond your toes.",
            "Difficulty can be increased by walking as you lunge."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/barbell-lunge"]),
    
    "Barbell Shrug": createNote(
        notes: [
            "Stand straight upright with your feet at shoulder width.",
            "Grip the bar with your palms facing you and hands slightly more that shoulder width apart.",
            "Raise your shoulders as high as they will go.",
            "Slowly lower the bar back down.",
            "Avoid using your biceps."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/barbell-shrug"]),
    
    "Beginner Shrimp Squat": createNote(
        notes: [
            "Stand straight up with your hands stretched out in front of you.",
            "Raise one leg so that your shin is parallel to the floor.",
            "Squat down until your elevated leg touches down at the knee and at the toes.",
            "If you're having trouble balancing you can hold onto a support."],
        links: ["Video": "https://www.youtube.com/watch?v=TKt0-c83GSc&feature=youtu.be&t=3m9s"]),
    
    "Bench Jump": createNote(
        notes: [
            "Begin with a bench or box 1-2 feet in front of you.",
            "Stand with feet about shoulder width apart.",
            "Do a short squat, swing arms back, and jump as high as possible over the bench."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/bench-jump"]),
    
    "Bench Press": createNote(
        notes: [
            "Eyes under the bar.",
            "Grip should be such that forearms are vertical at the bottom. Usually about 1.5-2x shoulder width.",
            "Feet should usually be between knees and hips and out as much as possible.",
            "Lift chest, squeeze shoulder blades together, feet flat on the floor.",
            "Bar should rest on palm, near wrists.",
            "Wrists should stay straight.",
            "Don't watch the bar, instead look at a fixed point on the ceiling.",
            "Arch back but keep your butt on the bench.",
            "At the bottom elbows should be tucked in to about 75 degrees. On the way up flare elbows out to 90 degrees.",
            "Squeeze the bar hard.",
            "Press feet hard into the floor to help maintain tension."],
        links: ["Strength Theory": "http://strengtheory.com/how-to-bench/", "Stronglifts": "http://stronglifts.com/bench-press/", "Thrall Video": "https://www.youtube.com/watch?v=BYKScL2sgCs"]),
    
    "Bend (intro)": createNote(
        notes: [
            "Stand upright with your hands stretched out above your head.",
            "Bend forward, trying to reach your toes.",
            "Straighten back up and bend backwards moderately."],
        links: ["Link": "https://www.fourmilab.ch/hackdiet/e4/"]),
    
    "Bend and Bounce": createNote(
        notes: [
            "Stand upright with your hands stretched out above your head.",
            "Bend forward and touch the floor between your legs.",
            "Bounce up a few inches and touch the floor again.",
            "Straighten back up and bend backwards moderately."],
        links: ["Link": "https://www.fourmilab.ch/hackdiet/e4/"]),
    
    "Bent-knee Iron Cross": createNote(
        notes: [
            "Lie on your back with your legs tucked into your chest and your arms spread outwards.",
            "Keeping legs tucked and shoulders on the floor rotate your legs from side to side."],
        links: ["Video": "https://www.youtube.com/watch?v=2HYWl009bq0"]),
    
    "Bent Over Dumbbell Row": createNote(
        notes: [
            "Grasp dumbbells so that palms are facing inward.",
            "Bend knees slightly and bend forward until torso is almost parallel with the floor.",
            "Keep back straight and head up.",
            "Bring dumbbells to your sides while keeping torso stationary."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/bent-over-two-dumbbell-row"]),
    
    "Bird-dog": createNote(
        notes: [
            "Kneel with your hands and feet shoulder width apart.",
            "Slowly lean forward and place your hands on the mat below your shoulders.",
            "Brace your core and simultaneously raise one arm and the opposite leg until they extend straight outwards."],
        links: ["Link": "https://www.acefitness.org/education-and-resources/lifestyle/exercise-library/14/bird-dog"]),
    
    "Body Saw": createNote(
        notes: [
            "Crouch down in front plank position with your feet resting on something that will allow them to move easily.",
            "Shift your body backward and then forward.",
            "Keep your body in a straight line throughout."],
        links: ["Video": "https://www.youtube.com/watch?v=8hoiwnkFAHE"]),
    
    "Body-weight Box Squat": createNote(
        notes: [
            "Find a bench or chair that is at a height where when your butt touches it your thighs are slightly below parallel with the floor.",
            "Stand with your feet slightly wider than your hips.",
            "Point toes outward 5-20 degrees.",
            "Look straight forward the entire time: pick a point and focus on that.",
            "In one motion begin extending your hips backward and bending your knees.",
            "Push your knees out so that they stay over your feet.",
            "Go down until your butt touches the box and then go back up.",
            "Keep your back straight."],
        links: ["Link": "https://www.nerdfitness.com/blog/2014/03/03/strength-training-101-how-to-squat-properly/", "Barbell Version": "http://www.bodybuilding.com/exercises/detail/view/name/box-squat"]),
    
    "Body-weight Hip Thrust": createNote(
        notes: [
            "Use a low bench to elevate your shoulders.",
            "Move feet about shoulder width apart.",
            "Push your heels into the floor and lift your hips off the floor.",
            "Keep your back straight.",
            "Difficulty can be increased by pausing for 3s at the top."],
        links: ["Shoulders Down Version": "http://www.bodybuilding.com/exercises/detail/view/name/butt-lift-bridge", "Barbell Version": "https://bretcontreras.com/how-to-hip-thrust/"]),
    
    "Body-weight Single Leg Hip Thrust": createNote(
        notes: [
            "Use a low bench to elevate your shoulders.",
            "Move feet about shoulder width apart.",
            "Use one leg to lift your hips off the floor.",
            "Tuck the other leg into your chest.",
            "Difficulty can be increased by pausing for 3s at the top."],
        links: ["Video": "https://www.youtube.com/watch?v=hUboSbJdvvU"]),
    
    "Body-weight Single Leg Deadlift": createNote(
        notes: [
            "Stand straight up.",
            "Extend one leg straight out behind you.",
            "At the same time lower your torso.",
            "Continue until your outstretched leg and torso are parallel to the floor.",
            "Keep your back straight the entire time.",
            "Your hands can be stretched out in front of you or one can be lowered to the floor."],
        links: ["Link": "http://www.alkavadlo.com/body-weight-exercises/the-single-leg-deadlift/", "Contreras": "https://bretcontreras.com/the-single-leg-rdl/"]),
    
    "Body-weight Bulgarian Split Squat": createNote(
        notes: [
            "Stand in front of a low bench.",
            "Bring one leg backward so that your foot rests on the bench.",
            "Keeping your torso upright drop into a squat."],
        links: ["Video": "https://www.youtube.com/watch?v=HeZiiPtlcew"]),
    
    "Body-weight Romanian Deadlift": createNote(
        notes: [
            "Stand up straight with one hand on your chest and another on your belly.",
            "Keeping your back straight and your chest out, bend at the waist,"],
        links: ["Video": "https://gfycat.com/BlueUltimateBaiji"]),
    
    "Body-weight Squat": createNote(
        notes: [
            "Hold your hands up under your chin.",
            "With one leg squat down so that your knee touches the ground.",
            "Keep your back straight and your chest pushed out."],
        links: ["Link": "https://www.getstrong.fit/images/GobletSplitSquat.jpg"]),
    
    "Body-weight Split Squat": createNote(
        notes: [
            "Stand in front of a low bench.",
            "Bring one leg backward so that your foot rests on the bench.",
            "Keeping your torso upright drop into a squat."],
        links: ["Video": "https://www.youtube.com/watch?v=HeZiiPtlcew"]),
    
    "Body-weight Step Up + Reverse Lunge": createNote(
        notes: [
            "Use one leg to step onto a low bench.",
            "Step back down and lower the knee of that leg onto the ground.",
            "Repeat.",
            "Difficulty can be increased by holding a dumbbell."],
        links: ["Video": "https://www.youtube.com/watch?v=F72adrSjfiU"]),
    
    "Body-weight Walking Lunge": createNote(
        notes: [
            "Stand with feet shoulder width apart and your hands on your hips.",
            "Step forward with one leg and descend until one knee nearly touches the ground.",
            "Press using your heel to raise yourself back up.",
            "Repeat with the other leg",
            "Keep your torso upright."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/bodyweight-walking-lunge"]),
    
    "Bottoms Up": createNote(
        notes: [
            "Lay on your back with your legs straight and your arms at your side.",
            "Tuck your knees into your chest.",
            "Extend your legs straight out above you.",
            "Raise your butt off the floor keeping your legs perpendicular to the ground."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/bottoms-up"]),
    
    "Bottoms Up Good Morning": createNote(
        notes: [
            "Adjust the pins within a power rack so that the barbell is at stomach height.",
            "Bend underneath the bar and setup as if for a low bar squat. When the bar is at the correct height you should be parallel to the floor.",
            "Straighten up until you are standing.",
            "Keep back straight and knees slightly bent."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/good-morning-off-pins"]),
    
    "Box Jump": createNote(
        notes: [
            "Squat down, swing your arms behind you, and jump as high as you can onto the box.",
            "Land with your feet flat.",
            "Keep back straight and abs braced.",
            "Eyes and chest should be up when landing.",
            "Pause for a bit after landing.",
            "Step off the box if it’s higher than 20 inches."],
        links: ["Guide": "https://www.bodybuilding.com/exercises/front-box-jump", "More": "https://www.t-nation.com/training/stop-doing-box-jumps-like-a-jackass"]),
    
    "Box Squat": createNote(
        notes: [
            "Find a bench or chair that is at a height where when your butt touches it your thighs are slightly below parallel with the floor.",
            "Stand with your feet slightly wider than your hips.",
            "Point toes outward 5-20 degrees.",
            "Look straight forward the entire time: pick a point and focus on that.",
            "In one motion begin extending your hips backward and bending your knees.",
            "Push your knees out so that they stay over your feet.",
            "Go down until your butt touches the box and then go back up.",
            "Keep your back straight."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/box-squat"]),
    
    "Burpees": createNote(
        notes: [
            "Drop to your hands and knees.",
            "Stretch out your legs so that they are fully extended behind you.",
            "Pull your legs foreward and jump into the air.",
            "Repeat."],
        links: ["Link": "https://www.youtube.com/watch?v=qNLiCX8gYWo"]),
    
    "Cable Crunch": createNote(
        notes: [
            "Kneel below a high pulley with a rope attachment.",
            "Lower the rope until your hands are next to your face.",
            "Allow the weight to hyper-extend your back.",
            "Flex abs and lower your torso.",
            "Elbows should be lowered to mind-thighs."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/cable-crunch"]),
    
    "Cable Hip Abduction": createNote(
        notes: [
            "Use an ankle cuff to attach a leg to a low pulley.",
            "Step away from the pulley and turn so that the leg with the cuff is closest to the pulley.",
            "Take a wide stance and move the leg with the cuff closer to the puller and then back to your starting position."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/cable-hip-adduction"]),
    
    "Cable Hip Rotation": createNote(
        notes: [
            "Use a tower or a high pulley and an attachment that works with your hands clasped together.",
            "Stand sideways to the cable and grab the attachment keeping your arm fully extended.",
            "Rotate your arms and torso closer and further from the pulley.",
            "Keep your arms stretched out the entire time."],
        links: ["Video": "https://www.youtube.com/watch?v=EhXxfGMggB8"]),
    
    "Cable Wood Chop": createNote(
        notes: [
            "Use a tower or a high pulley and an attachment that works with your hands clasped together.",
            "Stand sideways to the cable and grab the attachment keeping your arm fully extended.",
            "Grasp the attachment with your other hand and swing your hands down and to your side.",
            "Rotate your torso keeping back and arms straight."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/standing-cable-wood-chop"]),
    
    "Calf Press": createNote(
        notes: [
            "Adjust the seat so that your legs are only slightly bent at the start position.",
            "Grasp the handles and straighten your legs by extending knees.",
            "Your ankle should be fully flexed with toes pointed up."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/calf-press"]),
    
    "Cat Camels": createNote(
        notes: [
            "Crouch on your hands and knees with arms straight.",
            "For the cat lift head and chest up letting your stomach sink.",
            "For the camel round back and bring head and hips together."],
        links: ["Link": "https://www.youtube.com/watch?v=K9bK0BwKFjs"]),
    
    "Chest Flies (band)": createNote(
        notes: [
            "Start with your arms extending out to your sides stretching a band behind your back.",
            "Rotate your arms so that they point straight in front of you.",
            "Keep your arms straight the entire time.",
            "Bring your arms back behind your back."],
        links: ["Link": "https://www.youtube.com/watch?v=8lDC4Ri9zAQ&feature=youtu.be&t=4m22s"]),
    
    "Chinup": createNote(
        notes: [
            "Hands closer than shoulder width. Palms facing in.",
            "Keep elbows close to body and pull until head is even or above the bar.",
            "Slowly lower back down.",
            "Difficulty can be lessened by doing negatives: jump to raised position and very slowly lower yourself.",
            "Difficulty can be increased by attaching plates to a belt."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/chin-up", "Elbow Pain": "https://breakingmuscle.com/fitness/5-ways-to-end-elbow-pain-during-chin-ups"]),
    
    "Clam": createNote(
        notes: [
            "Lay on your side.",
            "Move your hips back about 45 degrees.",
            "Move your knees foreward so that they form a 90 degree angle.",
            "Push a knee into the air as far as possible pausing at the top.",
            "Keep your feet touching."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/clam"]),
    
    "Close-Grip Bench Press": createNote(
        notes: [
            "Lay on a flat bench.",
            "Hands about shoulder width apart.",
            "Slowly lower the bar to your middle chest.",
            "Keep elbows tucked into torso at all times.",
            "Note that failed lifts tend to occur more suddenly than with wide grip bench presses."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/close-grip-barbell-bench-press"]),
    
    "Close-Grip Lat Pulldown": createNote(
        notes: [
            "Use a grip smaller than shoulder width.",
            "Palms facing forward.",
            "Lean torso back about thirty degrees, stick chest out.",
            "Touch the bar to chest keeping torso still.",
            "Squeeze shoulders together."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/close-grip-front-lat-pulldown"]),
    
    "Cocoons": createNote(
        notes: [
            "Lie down on your back with your arms extended behind your head.",
            "Tuck your knees into your chest.",
            "As you are tucking bring your head up and your hands alongside your knees."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/cocoons"]),
    
    "Concentration Curls": createNote(
        notes: [
            "Sit on a flat bench with a dumbbell between your knees.",
            "Place an elbow on your inner thigh with palm facing away from thigh.",
            "Curl the weight.",
            "Keep upper arm stationary.",
            "At the top your pinky should be higher than your thumb."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/concentration-curls"]),
    
    "Cossack Squat": createNote(
        notes: [
            "Stand with legs stretched out wide and toes out a bit.",
            "Squat down on one leg so that the other leg is stretched straight out away from you.",
            "Stand up and squat down on the other leg.",
            "Heels should remain on the floor though toes can come up.",
            "Back should remain flat.",
            "Difficulty can be lessened by balancing yourself with your hands on the ground.",
            "Difficulty can be increased by holding your hands over your chest."],
        links: ["Video": "https://www.youtube.com/watch?v=tpczTeSkHz0"]),
    
    "Couch Stretch": createNote(
        notes: [
            "Kneel down and back both feet up against a wall.",
            "Slide one leg back so that your knee and calf are against the wall.",
            "Bring the other leg out and post it so that your shin is vertical.",
            "Place both hands on the ground and drive your hips forward so that your back forms a straight line with your legs.",
            "Take your hands off the floor and raise your torso so that it is upright keeping your back straight.",
            "Keep abs tight.",
            "Work towards doing this two minutes a day for each leg."],
        links: ["Link": "http://www.active.com/triathlon/articles/the-stretch-that-could-be-the-key-to-saving-your-knees", "Tips": "http://breakingmuscle.com/mobility-recovery/couch-stretch-small-but-important-ways-youre-doing-it-wrong", "Video": "https://www.youtube.com/watch?v=JawPBvtf7Qs"]),
    
    "Deadbugs": createNote(
        notes: [
            "Lie on your back with arms held straight up and legs forming a 90 degree angle.",
            "Extend one arm behind you and extemnd the opposite leg out.",
            "Keep your core braced."],
        links: ["Link": "http://www.nick-e.com/deadbug/"]),
    
    "Deadlift": createNote(
        notes: [
            "Walk to the bar and place feet so that the bar is over the middle of your feet.",
            "Feet should be pointed out ten to thirty degrees.",
            "Feet should be about as far apart as they would be for a vertical jump (hip width not shoulder width).",
            "Bend over and grab the bar keeping hips as high as possible.",
            "When starting to grip the bar position your hands so that the calluses on your palm are just above the bar and then wrap your fingers and thumb around the bar.",
            "Pull yourself down and into the bar by engaging lats, upper back, and hip flexors.",
            "Stop once the bar touches your shins, knees touching arms.",
            "Back should be straight, hips fairly high, but seated back as much as possible.",
            "Chest out, back straight, big breath, start pulling.",
            "Keep the bar as close as possible to your legs.",
            "Push with your heels.",
            "As the bar approaches your knees drive forward with your hips.",
            "Never bend arms: all the lifting should be done with legs and back.",
            "Don't shrug or lean back too far at the top.",
            "Can help to switch to a mixed grip for the last warmup and work sets.",
            "Can build grip strength by holding the last rep in place."],
        links: ["Stronglifts": "http://stronglifts.com/deadlift/", "Thrall Video": "https://www.youtube.com/watch?v=Y1IGeJEXpF4", "Tips": "https://www.t-nation.com/training/5-tips-to-dominate-the-deadlift", "Grip": "https://stronglifts.com/deadlift/grip/"]),
    
    "Decline Bench Press": createNote(
        notes: [
            "Lay on a bench tilted such that your head is lower than your hips.",
            "Use a medium grip (so that in the middle of the movement your upper and lower arms make a 90 degree angle).",
            "Slowly lower the bar to your lower chest.",
            "A lift off from a spotter will help protect your rotator cuffs."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/decline-barbell-bench-press"]),
    
    "Decline Plank": createNote(
        notes: [
            "Lie prone on a mat keeping elbows below shoulders.",
            "Support your legs using your toes and a bench.",
            "Raise body upwards to create a straight line."],
        links: ["Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Decline & March Plank": createNote(
        notes: [
            "Lie prone on a mat keeping elbows below shoulders.",
            "Support your legs using your toes and a bench.",
            "Raise body upwards to create a straight line.",
            "Alternate between bringing each knee forward."],
        links: ["Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Decline Situp": createNote(
        notes: [
            "Lie on your back on a decline bench.",
            "Place your hands behind your head, but don't lock your fingers together.",
            "Push your lower back into the bench and raise your shoulders about four inches.",
            "At the top contract your abs and hold for a second."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/decline-crunch"]),
    
    "Deep Step-ups": createNote(
        notes: [
            "Place one foot on a high object.",
            "Place all of your weight on that object and step up onto the object.",
            "Use your back leg as little as possible.",
            "Difficulty can be increased by using a higher object or holding a weight."],
        links: ["Link": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/squat", "Body Weight Squats": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/squat"]),
    
    "Deficit Deadlift": createNote(
        notes: [
            "Stand on a platform or a plate or two, typically 1-4 inches off the ground.",
            "Deadlift as usual."],
        links: ["Link": "https://www.t-nation.com/training/in-defense-of-deficit-deadlifts"]),
    
    "Diamond Pushup": createNote(
        notes: [
            "Move your hands together so that the thumbs and index fingers touch (forming a diamond).",
            "Lean forward and perform the pullup.",
            "Difficulty can be decreased by moving your hands further apart.",
            "Keep your body in a straight line.",
            "Lock out arms and push shoulders forward.",
            "Keep elbows in, don't let them flare outwards from your torso."],
        links: ["Link": "https://www.youtube.com/watch?v=_4EGPVJuqfA", "Pushups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pushup"]),
    
    "Dips": createNote(
        notes: [
            "Start in the raised position with elbows nearly locked.",
            "Inhale and slowly lower yourself downward.",
            "Lower until elbow hits ninety degrees.",
            "Exhale and push back up.",
            "To work the chest more than triceps lean forward thirty degrees and go a bit deeper."],
        links: ["Triceps": "http://www.bodybuilding.com/exercises/detail/view/name/dips-triceps-version", "Chest": "http://www.bodybuilding.com/exercises/detail/view/name/dips-chest-version", "Dips": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/dip"]),
    
    "Donkey Calf Raises": createNote(
        notes: [
            "Either use a donkey calf machine or have someone sit low on your back.",
            "Knees should remain straight but not locked.",
            "Raise heels as high as possible."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/donkey-calf-raises"]),
    
    "Doorway Chest Stretch": createNote(
        notes: [
            "Stand in front of a doorway.",
            "Raise hands just above shoudlers with palms facing forward.",
            "Lean into the doorway supporting yourself with your forearms.",
            "Pinch shoulder blades together.",
            "Difficulty can be increased by using one arm at a time.",
            "Work towards doing three sets for 60s each."],
        links: ["Link": "http://breakingmuscle.com/mobility-recovery/why-does-the-front-of-my-shoulder-hurt"]),
    
    "Dragon Flag": createNote(
        notes: [
            "Lay face up on a bench with your hands holding a support behind your head.",
            "Lift your body until it is above your shoulders.",
            "Slowly lower your body back down.",
            "Keep your body as straight as possible the entire time."],
        links: ["Link": "https://www.t-nation.com/training/dragon-flag", "Video": "https://www.youtube.com/watch?v=njKXkuhY7_0", "Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Dumbbell Bench Press": createNote(
        notes: [
            "Lie flat on a bench.",
            "Rotate dumbbells so your palms are facing your feet.",
            "Move arms to sides so upper and lower arms are at ninety degree angle.",
            "Dumbbells should be just outside of chest.",
            "Raise the dumbbells so that they lightly touch one another above your chest.",
            "After completing the set kick your legs up, place the weights on your thighs, and situp.",
            "Once you are sitting up you can place the weights on the floor."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/dumbbell-bench-press", "Positioning": "http://truthofbuildingmuscle.com/barbell-vs-dumbbell-bench-press-which-one-is-better"]),
    
    "Dumbbell Bent Over Row": createNote(
        notes: [
            "Hold a dumbbell in both hands with palms facing your torso,",
            "Bend your knees slightly and bend over until your torso is almost parallel with the floor.",
            "Lift the weights to your side keeping your elbows close to your body.",
            "Keep your back straight and your head up."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/bent-over-two-dumbbell-row"]),
    
    "Dumbbell Deadlift": createNote(
        notes: [
            "Hands shoulder width or a bit narrower.",
            "Grasp dumbbells so that palms face backwards.",
            "Lower dumbbells to top of feet and then straighten back up.",
            "Keep back and knees straight the entire time.",
            "Keep dumbbells close to legs."],
        links: ["Link": "http://exrx.net/WeightExercises/Hamstrings/DBStrBackStrLegDeadlift.html"]),
    
    "Dumbbell Floor Press": createNote(
        notes: [
            "Lay flat on your back with knees raised,",
            "Grasp dumbbells so that palms are facing forward.",
            "Raise dumbbells so that they touch above chest."],
        links: ["Link": "https://www.youtube.com/watch?feature=player_embedded&v=XtEzJpPR2Zg"]),
    
    "Dumbbell Flyes": createNote(
        notes: [
            "Position dumbbells in front of shoulders with palms facing each other.",
            "Raise dumbbells as if you were pressing them but don't lock them out.",
            "With a slight bend in elbows lower dumbbells to sides in a wide arc.",
            "Stop lowering the dumbbells once you feel a stretch in your chest."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/dumbbell-flyes"]),
    
    "Dumbbell Incline Flyes": createNote(
        notes: [
            "Position dumbbells in front of shoulders with palms facing each other.",
            "Raise dumbbells as if you were pressing them but don't lock them out.",
            "With a slight bend in elbows lower dumbbells to sides in a wide arc.",
            "Stop lowering the dumbbells once you feel a stretch in your chest.",
            "Shoulders should point down at the bottom and out at the top."],
        links: ["Link": "https://www.exrx.net/WeightExercises/PectoralClavicular/DBInclineFly"]),
    
    "Dumbbell Incline Press": createNote(
        notes: [
            "Lie on your back on a bench so that your head is higher than your hips.",
            "Use your thighs to help push the weights to your shoulders.",
            "Rotate the weights so that your palms are facing your feet.",
            "Raise the weights over your head."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/incline-dumbbell-press"]),
    
    "Dumbbell Incline Row": createNote(
        notes: [
            "Lie on your front on a bench so that your head is higher than your hips.",
            "Hold dumbbells in both hands with your palms facing your torso.",
            "Start with your arms extended and pull the weights to your sides."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/dumbbell-incline-row"]),
    
    "Dumbbell Lunge": createNote(
        notes: [
            "Grasp dumbbells so that palms are facing body.",
            "Alternately step forward with each leg.",
            "Lower body until rear knee is almost in contact with the floor.",
            "Longer steps work the glutes more, short lunges work quads more."],
        links: ["Link": "http://exrx.net/WeightExercises/Quadriceps/DBLunge.html"]),
    
    "Dumbbell One Arm Bench Press": createNote(
        notes: [
            "Lie on your back on a flat bench.",
            "Use your though to help position the dumbbell in front of you at shoulder width.",
            "Rotate the weight so that your palm is facing your feet.",
            "Lift the weight up and then back down."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/one-arm-dumbbell-bench-press"]),
    
    "Dumbbell One Arm Shoulder Press": createNote(
        notes: [
            "Stand straight up with feet shoulder width apart.",
            "Raise the dumbbell to head height with elbows extended out and palms facing forward.",
            "Raise the weight to above your head.",
            "Don't use your legs or lean backwards."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/dumbbell-one-arm-shoulder-press"]),
    
    "Dumbbell Romanian Deadlift": createNote(
        notes: [
            "Stand straight up with a dumbbell in each hand.",
            "Allow your arms to hang down with palms facing backwards.",
            "Push your butt back as far as possible while slightly bending your knees.",
            "Keep your back straight the entire time."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/romanian-deadlift-with-dumbbells"]),
    
    "Dumbbell Seated Shoulder Press": createNote(
        notes: [
            "Position dumbbells at shoulders with elbows below wrists.",
            "Press dumbbells upward and lightly tap them together.",
            "Can bounce the dumbbells off thighs to help get them into place."],
        links: ["Link": "http://exrx.net/WeightExercises/DeltoidAnterior/DBShoulderPress.html"]),
    
    "Dumbbell Shoulder Press": createNote(
        notes: [
            "Stand straight up with feet shoulder width apart.",
            "Raise the dumbbells to head height with elbows extended out and palms facing forward.",
            "Raise the weights to above your head.",
            "Don't use your legs or lean backwards."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/standing-dumbbell-press-"]),
    
    "Dumbbell Shrug": createNote(
        notes: [
            "Stand straight upright with a dumbbell in each hand.",
            "Palms should face one another.",
            "Light the weights by elevating your shoulders as much as possible.",
            "Avoid using your biceps."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/dumbbell-shrug"]),
    
    "Dumbbell Side Bend": createNote(
        notes: [
            "Stand up straight with a dumbbell held in one hand.",
            "Face the hand with the dumbbell so that it is pointed to your torso.",
            "Place your other hand on your hip.",
            "Bend as far towards the weight as you can.",
            "Then bend in the other direction.",
            "Keep your back straight and your head up.",
            "Do the recommended reps, switch hands, and start again."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/dumbbell-side-bend"]),
    
    "Dumbbell Single Leg Split Squat": createNote(
        notes: [
            "Grasp dumbbells so that palms are facing inward.",
            "Extend leg backwards and re st foot on a bench or chair.",
            "Squat down until rear knee is almost in contact with the floor.",
            "Return to original standing position.",
            "Difficulty can be increased by using a box or plates to prop up your front foot 2-4 inches."],
        links: ["Link": "http://exrx.net/WeightExercises/Quadriceps/DBSingleLegSplitSquat.html", "Tougher": "https://www.t-nation.com/training/tip-make-the-bulgarian-split-squat-even-tougher"]),
    
    "Exercise Ball Back Extension": createNote(
        notes: [
            "Lie on your stomach onto an exercise ball.",
            "Shift your position until the ball is just above your hips.",
            "Cross your arms across your chest.",
            "Raise your torso upwards.",
            "Difficulty can be increased by placing your hands behind your head (like a prisoner)."],
        links: ["Link": "http://www.exrx.net/WeightExercises/ErectorSpinae/BWHyperextensionBallArmsCrossed.html"]),
    
    "Exercise Ball Crunch": createNote(
        notes: [
            "Lie on your lower back on an exercise ball.",
            "Plant your feet firmly on the floor.",
            "Cross your arms across your chest or place them along your sides.",
            "Lower your torso keeping your neck neutral.",
            "Contract your abs to raise your torso.",
            "Difficulty can be increased by placing your hands behind your head (like a prisoner)."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/exercise-ball-crunch"]),
    
    "Exercise Ball Side Crunch": createNote(
        notes: [
            "Lie on your lower back on an exercise ball.",
            "Tilt to one side so that you are lying mostly on that side.",
            "Place your hands behind your head.",
            "Contract your abs to raise your torso."],
        links: ["Link": "http://www.exrx.net/WeightExercises/Obliques/WTSideCrunchOnBall.html"]),
    
    "Face Pull": createNote(
        notes: [
            "Use a high pulley with rope or a dual handle attachment.",
            "Pull the weight directly to your face separating your hands as you go.",
            "Pull until your hands are on either side of your head.",
            "Keep upper arms parallel to the ground."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/face-pull", "Proper Form": "http://seannal.com/articles/training/face-pulls-benefits-proper-form.php"]),
    
    "Farmer's Walk": createNote(
        notes: [
            "Use heavy dumbbells or custom equipment.",
            "Walk, taking short quick steps.",
            "Walk 50-100 feet."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/farmers-walk"]),
    
    "Finger Curls": createNote(
        notes: [
            "Sit on a bench and hold a barbell with your palms facing up.",
            "Your hands should be about shoulder width apart.",
            "Allow the bar to roll forward, catching it at the final joint of your fingers.",
            "Lower the bar as far as possible.",
            "Using your fingers raise the bar as far as possible."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/finger-curls"]),
    
    "Fire Hydrant Hip Circle": createNote(
        notes: [
            "Get on your hands and knees.",
            "Keep arms straight.",
            "Raise one leg, pull knee into your butt, and rotate your knee in a circle.",
            "After circling in one direction do the same in the other direction.",
            "Try and make the biggest circle you can."],
        links: ["Video": "https://www.youtube.com/watch?v=f-GRxDrMC4Y"]),
    
    "Foam Roll Pec Stretch": createNote(
        notes: [
            "Lie down on top of a foam roller with the roller running length wise from your shoulders to your hips.",
            "Extend your hands straight above your chest and then allow them to fall to either side.",
            "Difficulty can be increased by placing the foam roller on a bench so that your arms can be lowered further."],
        links: ["Link": "http://breakingmuscle.com/mobility-recovery/why-does-the-front-of-my-shoulder-hurt"]),
    
    "Foot Elevated Hamstring Stretch": createNote(
        notes: [
            "Stand facing an elevated surface.",
            "Place one foot onto the surface keeping your knee straight.",
            "The foot on the ground should be pointed sraight ahead.",
            "The toes of the elevated foot should be pointed straight upwards (or backwards to also stretch the calf).",
            "Gently lean forward until you feel your hamstrings stretch."],
        links: ["Link": "http://www.floota.com/HamstringStretch.html"]),
    
    "Foot Supported L-sit": createNote(
        notes: [
            "Sit with your legs stretched out before you on the floor.",
            "Use your palms to raise your body off the floor keeping your legs extended out.",
            "Leave your feet on the ground.",
            "Keep arms and legs straight.",
            "Don't shrug your shoulders up."],
        links: ["Link": "https://www.youtube.com/watch?v=IUZJoSP66HI#t=40s", "L-sits": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/l-sit"]),
    
    "Forward Lunge Stretch": createNote(
        notes: [
            "Kneel down with one leg forward and the other stretched behind you so that your weight is supported by your forward foot and back knee.",
            "Forward foot should be directly under your knee.",
            "Back leg should be stretched out straight behind you.",
            "If you're having balance problems you may rest your hands on the ground.",
            "Gently lower your hips down and forward."],
        links: ["Link": "http://www.topendsports.com/medicine/stretches/lunge-forward.htm", "Video": "https://www.doyogawithme.com/content/lunge-psoas-stretch"]),
    
    "Freestanding Handstand": createNote(
        notes: [
            "Lock out your elbows and knees.",
            "Glue your legs together and point the toes."],
        links: ["Link": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/handstand", "Handstands": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/handstand"]),
    
    "Front Plank": createNote(
        notes: [
            "Lie prone on a mat keeping elbows below shoulders.",
            "Raise body upwards to create a straight line.",
            "Use your toes to support yourself.",
            "Difficulty can be lessened by keeping your knees on the ground.",
            "Difficulty can be increased by raising a foot and/or hand off the ground or by elevating feet."],
        links: ["Link": "http://www.exrx.net/WeightExercises/RectusAbdominis/BWFrontPlank.html", "Antranik": "https://www.youtube.com/watch?v=44ScXWFaVBs", "Alternative": "http://i.imgur.com/2D4Nd1R.jpg", "Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Front Squat": createNote(
        notes: [
            "Bring arms up under the bar so that the bar rests on your deltoids (uppermost part of arms).",
            "Elbows should be very high.",
            "May have more control of the bar by crossing forearms.",
            "Unless you are very flexible there is no reason to actually grip the bar,",
            "Feet shoulder width apart with toes slightly pointed out.",
            "Go down slowly until thighs break parallel with the floor.",
            "Go up quickly."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/front-barbell-squat", "25 Tips": "http://breakingmuscle.com/strength-conditioning/when-in-doubt-do-front-squats-25-tips-for-better-front-squats"]),
    
    "Gliding Leg Curl": createNote(
        notes: [
            "Hang from something like a bar on a squat rack.",
            "Prop your feet up on a low stool or chair.",
            "Push your heels into the floor and lift your hips off the floor.",
            "When in position your butt should be off the floor and your torso and legs should form a ninety degree angle.",
            "Flex your hips up as high as possible,",
            "Once you reach the high point swing your entire body forward."],
        links: ["Video": "https://www.youtube.com/watch?v=KlCOhWuPGBU"]),
    
    "Glute Bridge": createNote(
        notes: [
            "Lie on your back with your hands to your sides and your knees bent.",
            "Move feet about shoulder width apart.",
            "Push your heels into the floor and lift your hips off the floor.",
            "Hold at the top for a second.",
            "Keep your back straight."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/butt-lift-bridge"]),
    
    "Glute Ham Raise": createNote(
        notes: [
            "Similar to a back extension except feet are placed between rollers and braced against a plate."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/glute-ham-raise"]),
    
    "Glute March": createNote(
        notes: [
            "Rest your shoulders on top of a low bench.",
            "Elevate your hips so that your body is in a straight line.",
            "Raise one foot high into the air and then the other."],
        links: ["Link": "https://bretcontreras.com/the-glute-march/"]),
    
    "Goblet Squat": createNote(
        notes: [
            "Hold a dumbbell or kettlebell close to your chest.",
            "Squat down until your thighs touch your calves.",
            "Keep your chest up and your back straight.",
            "Keep your knees out (can push them out at the bottom using your elbows)."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/goblet-squat"]),
    
    "GMB Wrist Prep": createNote(
        notes: [
            "Finger Pulses: bounce fingers up and down.",
            "Palm Pulses: palms down, fingers opened, raise wrists up and down.",
            "Side to Side Palm Rotations: palm down, fingers opened, roll palm from side to side.",
            "Front Facing Elbow Rotations: palm down, fingers opened, rotate arm left and right.",
            "Side to Side Wrist Stretch: palms down facing to sides, move whole body side to side.",
            "Rear Facing Wrist Stretch Palms Down: palms facing knees, rock your body forward and backward.",
            "Rear Facing Wrist Stretch Palms Up: palms facing knees, rock your body forward and backward.",
            "Rear Facing Elbow Rotations: palms down facing knees, rotate elbows left and right.",
            "Forward Facing Wrist Stretch: palms down facing forward, rock your body forward and backward."],
        links: ["Video": "https://www.youtube.com/watch?v=mSZWSQSSEjE"]),
    
    "Good Morning": createNote(
        notes: [
            "Begin standing with the bar on your back as if you were doing a low bar squat.",
            "Bend until your torso is parallel to the floor.",
            "Keep back straight and knees slightly bent."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/good-morning"]),
    
    "Hack Squat": createNote(
        notes: [
            "Stand up straight with a barbell held behind you.",
            "Feet at shoulder width.",
            "Squat until thighs are parallel with the floor, keep head up and back straight.",
            "Go back up by pressing heels into the floor using quads."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/barbell-hack-squat"]),
    
    "Half-kneeling Cable Anti-Rotation Press": createNote(
        notes: [
            "Attach a straight bar to a low pulley.",
            "Kneel on one leg facing away from the pulley.",
            "Extend one arm all the way forward.",
            "Bring it back and extend the other arm all the way forward."],
        links: ["Video": "https://www.youtube.com/watch?v=k--dW53UQWs"]),
    
    "Hammer Curls": createNote(
        notes: [
            "Stand straight upright with a dumbbell in each hand.",
            "Keep elbows close to your torso and palms facing inwards.",
            "Using only your forearms curl both dumbbells."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/hammer-curls"]),
    
    "Hammer Strength Chest Press": createNote(
        notes: [
            "Adjust the seat so that the handles are just below shoulder level.",
            "Grip the handles with palms down and with a width that keeps your arms straight.",
            "Don't allow your wrist to bend backwards.",
            "Retract your shoulder blades by pincing them together.",
            "Keep your shoulder blades retracted and extend your arms out."],
        links: ["Link": "https://www.regularityfitness.com/hammer-strength-chest-press/"]),
    
    "Hanging Dragon Flag": createNote(
        notes: [
            "Grab a pole with both hands.",
            "Brace your shoulders against the poll just below your hands.",
            "Extend your body so that it is parallel to the ground."],
        links: ["Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Hanging Leg Raise": createNote(
        notes: [
            "Hang from a bar with a wide or medium grip.",
            "Raise your legs so that your thighs make a 90 degree angle with your torso.",
            "Bend your knees as you raise your legs.",
            "Slowly lower your legs back down.",
            "Difficulty can be increased by holding a dumbbell between your feet."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/hanging-leg-raise"]),
    
    "HIIT": createNote(
        notes: [
            "Do a 3-4 min warmup at low to moderate intensity of whatever exercise you're doing.",
            "Do 6-10 sets of 60/60, 30/60, 30/30, 20/10 seconds of high/low intensity.",
            "Do a 3-4 min cooldown at low intensity."],
        links: ["Guide": "https://www.reddit.com/r/hiit/wiki/beginners_guide", "FAQ": "https://www.reddit.com/r/hiit/wiki/faq"]),
    
    "High bar Squat": createNote(
        notes: [
            "Bar goes at the top of shoulders at the base of the neck.",
            "Brace core and unrack the bar.",
            "Toes slightly pointed outward.",
            "Push hips back slightly, chest forward, and squat down.",
            "Keep bar over the middle of your feet.",
            "High bar depth is typically greater than low bar depth.",
            "If your neck gets sore the bar is in the wrong position."],
        links: ["Link": "https://squatuniversity.com/2016/03/18/how-to-perfect-the-high-bar-back-squat-2/", "Video": "https://www.youtube.com/watch?v=lUGpa_Wz2gs"]),
    
    "Hip Hinge with Dowel": createNote(
        notes: [
            "Place a dowel or rod along the center line of your back.",
            "Support the dowel with one hand on your lower back and another at head height.",
            "Stand up straight and use your hips to bend down.",
            "Keep knees slightly bent.",
            "Keep back straight: dowel should only contact you at hips, shoulders, and head."],
        links: ["Video": "https://www.youtube.com/watch?v=gwN_nXKVXXI"]),
    
    "Hip Thrust": createNote(
        notes: [
            "Load the bar up with either 45 pound plates or bumper plates.",
            "Sit down in front of a low bench.",
            "Roll the barbell over your feet and then your legs until it is at your hips.",
            "Scoot your shoulders back so that they are supported on the bench.",
            "Bring your feet back so that your shins will be vertical when the bar is raised.",
            "Use your hips to raise the bar in a smooth motion.",
            "Keep your head in a neutral position: don't tilt it forward.",
            "Hands can be used to either help support yourself on the bench or to help control the bar."],
        links: ["Link": "https://bretcontreras.com/how-to-hip-thrust/", "Positioning": "https://bretcontreras.com/get-bar-proper-position-hip-thrusts/", "Video": "https://www.youtube.com/watch?v=mvBTGx5zu5I", "Form Video": "https://www.youtube.com/watch?v=LM8XHLYJoYs"]),
    
    "Hip Thrust (constant tension)": createNote(
        notes: [
            "This is exactly like an ordinary hip thrust except that you only go about half-way down."],
        links: ["Link": "https://bretcontreras.com/the-evolution-of-the-hip-thrust/", "Normal Hip Thrust": "https://bretcontreras.com/how-to-hip-thrust/"]),
    
    "Hip Thrust (isohold)": createNote(
        notes: [
            "This is exactly like an ordinary hip thrust except that you hold the top position for an extended period."],
        links: ["Video": "https://www.youtube.com/watch?v=DdmW_MFN_jo", "Normal Hip Thrust": "https://bretcontreras.com/how-to-hip-thrust/"]),
    
    "Hip Thrust (rest pause)": createNote(
        notes: [
            "This is exactly like an ordinary hip thrust except that you pause once or twice in the middle of each set."],
        links: ["Link": "https://bretcontreras.com/random-thoughts-12/", "Normal Hip Thrust": "https://bretcontreras.com/how-to-hip-thrust/"]),
    
    "Hollow Body Hold": createNote(
        notes: [
            "Lie on your back.",
            "Drive legs into floor, arch back, and retract shoulders.",
            "Lower bar to sternum.",
            "Keep elbows slightly in."],
        links: ["Link": "http://gymnasticswod.com/content/hollow-body", "Video": "https://www.youtube.com/watch?v=LlDNef_Ztsc", "Antranik": "https://www.youtube.com/watch?v=44ScXWFaVBs&feature=youtu.be&t=3m34s"]),
    
    "Horizontal Rows": createNote(
        notes: [
            "Setup using something like a pullup bar and optionally a low stool for your feet.",
            "Pull your body into the bar and then allow it to move back down.",
            "Keep your body straight.",
            "Arms should be straight at the bottom.",
            "Don't let your shoulders shrug up."],
        links: ["Link": "https://www.youtube.com/watch?v=dvkIaarnf0g", "Body Weight Rows": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/row"]),
    
    "Incline Cable Flye": createNote(
        notes: [
            "Position a bench between two low pulleys.",
            "Grab the cable attachments and bring your hands above your head.",
            "Lower your hands until you feel a stretch in your chest.",
            "Keep elbows slightly bent."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/incline-cable-flye"]),
    
    "Incline Bench Press": createNote(
        notes: [
            "Use a bench incline such that your head is higher than your hips.",
            "Drive legs into floor, arch back, and retract shoulders.",
            "Lower bar to sternum.",
            "Keep elbows slightly in."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/barbell-incline-bench-press-medium-grip"]),
    
    "Incline Dumbbell Bench Press": createNote(
        notes: [
            "Sit on an incline bench with a dumbbell in each hand.",
            "Start with the dumbbells on your thighs with your palms facing each other.",
            "Use your thighs to help lift the weights to just above your shoulders.",
            "Rotate the dumbbells so that your palms are facing your feet.",
            "Raise the dumbbells out and lock your arms.",
            "Slowly lower the weights and repeat.",
            "After completing a set put the dumbbells onto your thighs and then onto the floor."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/incline-dumbbell-press"]),
    
    "Incline Dumbbell Curl": createNote(
        notes: [
            "Sit on an incline bench with a dumbbell in each hand.",
            "Keep your elbows close to your torso and rotate the dumbbells so that your palms are facing your feet.",
            "Curl the weights keeping your upper arms stationary."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/incline-dumbbell-curl"]),
    
    "Incline Pushup": createNote(
        notes: [
            "Extend your arms and place both hands on a table or some other support.",
            "Walk your feet backward.",
            "Lower yourself until your chest touches the support and and then push yourself away.",
            "Difficulty can be increased by using a lower platform.",
            "Keep your body in a straight line.",
            "Lock out arms and push shoulders forward.",
            "Keep elbows in, don't let them flare outwards from your torso."],
        links: ["Link": "https://www.youtube.com/watch?v=4dF1DOWzf20&feature=youtu.be&t=3m56s", "Pushups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pushup"]),
    
    "Incline Rows": createNote(
        notes: [
            "Grab onto something that will support you and also allow you to be between vertical and horizontal.",
            "Pull your body into the support and then allow it to move back.",
            "Difficulty can be increased by using a support that will allow you to get more horizontal.",
            "Keep your body straight and elbows in.",
            "Arms should be straight at the bottom.",
            "Don't let your shoulders shrug up."],
        links: ["Link": "https://www.youtube.com/watch?v=tDUWmbzs154", "Body Weight Rows": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/row"]),
    
    "Intermediate Shrimp Squat": createNote(
        notes: [
            "Stand straight up with your hands stretched out in front of you.",
            "Raise one leg so that your shin is above parallel to the floor.",
            "Squat down until your elevated leg touches down at the knee, but not at the toes.",
            "If you're having trouble balancing you can hold onto a support."],
        links: ["Video": "https://www.youtube.com/watch?v=TKt0-c83GSc&feature=youtu.be&t=3m9s"]),
    
    "Inverted Row": createNote(
        notes: [
            "Position a bar in a rack about waist height. A smith machine or a pullup bar are also suitable.",
            "Scoot underneath the bar and grip it with hands wider than your shoulders.",
            "Keep your heels on the ground and hang with arms fully extended.",
            "Flex your elbows and pull your chest to the bar.",
            "Difficulty can be lessened by bending your knees or by increasing the angle your torso forms to the ground."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/inverted-row"]),
    
    "IT-Band Foam Roll": createNote(
        notes: [
            "Lie on your side using your arms to support your upper body.",
            "Place the outside of your thigh on the foam roller.",
            "Slowly roll up and down and side to side.",
            "Pause on areas that are especially tender until they feel better."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/iliotibial-tract-smr"]),
    
    "Jump Squat": createNote(
        notes: [
            "Stand with arms by your side and feet shoulder width apart.",
            "Keeping back straight and chest up, squat until thighs are parallel or lower to the floor.",
            "Press with the balls of your feet and jump into the air as high as possible.",
            "Immediately repeat."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/jump-squat"]),
    
    "Kettlebell One-Legged Deadlift": createNote(
        notes: [
            "Hold a kettlebell in one hand.",
            "Move the leg opposite the weight behind you.",
            "Bend at the waist and lower the kettlebell to the ground.",
            "Reverse the motion to raise the kettlebell.",
            "Throughout keep the knee supporting you slightly bent."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/kettlebell-one-legged-deadlift"]),
    
    "Kettlebell Two Arm Swing": createNote(
        notes: [
            "Stand behind a kettlebell with feet slightly more than shoulder width apart.",
            "Bend at the hips and lift the kettlebell with palms facing you.",
            "Drive hips forward and swing the weight up until your arms are parallel to the floor (or a bit past).",
            "Allow the weight to fall back between your legs.",
            "Keep your back straight.",
            "Knees can bend a bit."],
        links: ["Link": "http://www.exrx.net/WeightExercises/Kettlebell/KBTwoArmSwing.html"]),
    
    "Kroc Row": createNote(
        notes: [
            "Bend at the waist and use one arm to grip a support, if using a bench place one knee on the bench.",
            "Using your other arm bring a dumbbell from the floor all the way back.",
            "Keep your shoulders higher than your hips, your back should be at a 15 degree angle to the floor.",
            "Pull the dumbbell in a straight line from directly below your chest to the lower part of your rib cage."],
        links: ["Link": "https://www.t-nation.com/training/kroc-rows-101", "Video": "https://www.youtube.com/watch?v=D7jAIdoORxI"]),
    
    "L-sit": createNote(
        notes: [
            "Sit with your legs stretched out before you on the floor.",
            "Use your palms to raise your entire body off the floor keeping your legs extended out.",
            "Keep arms and legs straight.",
            "Don't shrug your shoulders up."],
        links: ["Link": "https://www.youtube.com/watch?v=ek76IXnE9tE", "L-sits": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/l-sit"]),
    
    "L-sit Pullup": createNote(
        notes: [
            "Hold your legs extended straight outward from your body.",
            "Do a pullup."],
        links: ["Link": "https://www.youtube.com/watch?v=quFBLtkxMRM", "Pullups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pullup"]),
    
    "Landmine 180's": createNote(
        notes: [
            "Position a barbell into a landmine or a corner.",
            "Load plates onto one end.",
            "Raise the bar to shoulder height with both hands extended before you.",
            "Take a wide stance.",
            "Rotate the bar from side to side by rotating your trunk and hips.",
            "Keep your arms extended throughout."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/landmine-180s"]),
    
    "Lat Pulldown": createNote(
        notes: [
            "Use grip wider than shoulder width.",
            "Palms facing forward.",
            "Lean torso back about thirty degrees, stick chest out.",
            "Touch the bar to chest keeping torso still.",
            "Squeeze shoulders together."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/wide-grip-lat-pulldown"]),
    
    "Leg Extensions": createNote(
        notes: [
            "Adjust pads so that they lie on your legs just above your feet.",
            "Legs should be at a 90 degree angle (less is hard on the knees).",
            "Extend legs to the maximum.",
            "Keep body stationary."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/leg-extensions"]),
    
    "Leg Lift (intro)": createNote(
        notes: [
            "Lie down with legs slightly apart and palms under your thighs.",
            "Lift your left leg, bending at the hip and the knee, while also lifting your head from the floor.",
            "Lower leg and repeat with the right leg (one rep includes both legs)."],
        links: ["Link": "https://www.fourmilab.ch/hackdiet/e4/"]),
    
    "Leg Lift Plank": createNote(
        notes: [
            "Adopt the normal front plank position.",
            "Raise one leg so that it is parallel to the floor.",
            "Halfway through switch up your legs."],
        links: ["Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Leg Press": createNote(
        notes: [
            "Feet at shoulder width.",
            "Torso and legs should be ninety degrees apart.",
            "Push until legs are fully extended but **don't lock knees**.",
            "Lower platform until upper and lower legs make a ninety degree angle."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/leg-press"]),
    
    "Leg Swings": createNote(
        notes: [
            "Hold onto a pole or some other support with one hand.",
            "Extend the other arm all the way out from your side.",
            "Cross one leg across the other and then kick it up towards your outstretched arm.",
            "Then move one leg behind you and kick towards your front."],
        links: ["Link": "https://www.youtube.com/watch?v=AkqakLhh1fI&feature=youtu.be"]),
    
    "Low bar Squat": createNote(
        notes: [
            "Hands should be as close together as possible without pain or discomfort",
            "Bar goes as far down as it can go without sliding downwards.",
            "Wrists should be straight and thumbs above the bar.",
            "Elbows should be up.",
            "Feet should be roughly shoulder width apart and pointed out 15-30 degrees.",
            "Knees should remain over feet during the squat.",
            "Head should be in a neutral position or slightly angled down.",
            "Keep core braced during the squat (a belt can help with this).",
            "Go low enough that your thighs break parallel (or even lower if flexible enough).",
            "When starting the ascent drive shoulders back so the bar remains over mid-foot.",
            "Can help to try to screw heels inward."],
        links: ["The Definitive Guide": "http://strengtheory.com/how-to-squat/", "Candito Video": "https://www.youtube.com/watch?v=zoZWgTrZLd8", "Stronglifts": "http://stronglifts.com/squat/", "Catching Squat up to Deadlift": "http://strengtheory.com/help-squat-catch-deadlift/"]),
    
    "Lying Leg Curls": createNote(
        notes: [
            "Lay on your back on a bench with your legs hanging off the end.",
            "Place hands either under your glutes palms down or on the sides holding the bench.",
            "Raise your legs until the make a 90 degree angle with the floor.",
            "Slowly lower your legs so that they are parallel to the floot.",
            "Keep your legs straight at all times, but don't lock your knees."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/lying-leg-curls"]),
    
    "Lying Leg Raise": createNote(
        notes: [
            "Adjust the machine so that the pad is a few inches below your calves.",
            "Grab the handles and point your toes straight.",
            "Curl legs upwards as far as possible without moving upper legs from the pad."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/flat-bench-lying-leg-raise"]),
    
    "Lying Straight Leg Raise": createNote(
        notes: [
            "Lay on your back on a bench or mat.",
            "Place your hands underneath your bottom to help support yourself.",
            "Keep your knees straight and raise your legs to a vertical position.",
            "Use slow and controlled movements.",
            "Can be made easier by bending the knees.",
            "Also can be made easier by using a mat and allowing heels to touch the ground."],
        links: ["Link": "http://www.exrx.net/WeightExercises/HipFlexors/BWStraightLegRaise.html", "Progression": "http://www.startbodyweight.com/p/leg-raises-progression.html"]),
    
    "LYTP": createNote(
        notes: [
            "**L** Raise elbows back and rotate forearms forward and backward.",
            "**Y** Raise arms upward keeping them about 45 degrees from head.",
            "**T** Raise arms upward keeping them 90 degrees from body.",
            "**P** Position arms so that they and your torso form a W. Bring elbows back. Pinkies up.",
            "Keep weights light, typically three pounds or less."],
        links: ["Video": "https://www.youtube.com/watch?v=VyBJQQz3eok"]),
    
    "Machine Bench Press": createNote(
        notes: [
            "Palms down grip.",
            "Lift arms so that upper arms are parallel to the floor.",
            "Push handles out."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/machine-bench-press"]),
    
    "Medicine Ball Slam": createNote(
        notes: [
            "Hold the ball with both hands.",
            "Stand with feet shoulder width apart.",
            "Raise the ball above your head.",
            "Slam it down in front of you as hard as you can."],
        links: ["Link": "https://www.bodybuilding.com/exercises/overhead-slam"]),
    
    "Military Press": createNote(
        notes: [
            "Grip the bar with palms facing out slightly wider than shoulder width.",
            "Place the bar on your collar bone.",
            "Lift it overhead without moving your hips (as you would with an OHP)."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/standing-military-press"]),
    
    "Mountain Climber": createNote(
        notes: [
            "Get into a pushup position with hands a bit closer than normal.",
            "Keep arms straight.",
            "Bring one leg up and plant your foot outside your arm.",
            "Sink back leg down and repeat with other leg."],
        links: ["Video": "https://www.youtube.com/watch?v=flT4TIMYvzI"]),
    
    "Oblique Crunches": createNote(
        notes: [
            "Lie on your back with your feet elevated.",
            "Place one hand behind your head and the other on the floor along your side.",
            "Elevate your body until your raised elbow touches your knee.",
            "Switch hands."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/oblique-crunches"]),
    
    "One-Arm Kettlebell Snatch": createNote(
        notes: [
            "Place a kettlebell between your feet.",
            "Bend your knees and push your butt back.",
            "Look straight ahead and swing the kettlebell backwards.",
            "Immediately reverse direction and use your knees and hips to accelerate the kettlebell.",
            "As the kettlebell reaches your shoulders punch upwards and lock it out overhead."],
        links: ["Link": "https://www.bodybuilding.com/exercises/one-arm-kettlebell-snatch", "technique": "https://www.girlsgonestrong.com/blog/strength-training/how-to-do-a-kettlebell-snatch/"]),
    
    "One-Handed Hang": createNote(
        notes: [
            "With your palm facing away from you grab a chinup bar.",
            "Keep your feet on the ground or on a support so that you're not supporting quite all of your weight.",
            "Hold that position."],
        links: ["Link": "https://www.bodybuilding.com/exercises/one-handed-hang"]),
    
    "One-Legged Cable Kickback": createNote(
        notes: [
            "Hook a cuff to a low cable pulley.",
            "Face the machine from about two feet away.",
            "Hold the machine to stay balanced.",
            "Kick the leg with the cuff backwards as high as it will comfortably go."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/one-legged-cable-kickback"]),
    
    "One-Leg L-sit": createNote(
        notes: [
            "Sit with your legs tucked towards your chest.",
            "Use your palms to raise your entire body off the floor keeping your legs tucked to your chest.",
            "Work on extending your legs outward: either by tucking less or extending one leg straight out.",
            "Keep arms straight.",
            "Don't shrug your shoulders up."],
        links: ["Link": "https://www.youtube.com/watch?v=IUZJoSP66HI#t=40s", "L-sits": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/l-sit"]),
    
    "One-Leg Foot Supported L-sit": createNote(
        notes: [
            "Sit with your legs stretched out before you on the floor.",
            "Use your palms to raise your body off the floor keeping your legs extended out.",
            "Keep one foot on the ground.",
            "It's OK to alternate which foot is on the ground.",
            "Keep arms and legs straight.",
            "Don't shrug your shoulders up."],
        links: ["Link": "https://www.youtube.com/watch?v=IUZJoSP66HI#t=40s", "L-sits": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/l-sit"]),
    
    "Overhead Press": createNote(
        notes: [
            "Grip should be narrow enough that forearms are vertical at the bottom.",
            "Bar should be on the base of the palms, close to wrist.",
            "Keep wrists straight.",
            "Elbows should start under the bar and touching your lats,",
            "Feet about shoulder width apart, pointed slightly out.",
            "Legs should be locked at all times.",
            "Lift chest by arching upper back.",
            "Lean backward a bit to allow the bar to clear your head and then forward once it is past your head.",
            "Stay tight by bracing your abs and squeezing your glutes together.",
            "Shrug shoulders upward at the top (this is important to prevent impingement)."],
        links: ["Stronglifts": "http://stronglifts.com/overhead-press/", "Rippetoe Video": "https://www.youtube.com/watch?v=tMAiNQJ6FPc"]),
    
    "Overhead Pull Down (band)": createNote(
        notes: [
            "Hold the band overhead and make it taut.",
            "Rotate your arms down to your side so that the band stretches outwards.",
            "The band should come down behind your back.",
            "Keep your arms straight the entire time."],
        links: ["Link": "https://www.youtube.com/watch?v=8lDC4Ri9zAQ&feature=youtu.be&t=4m22s"]),
    
    "Pallof Press": createNote(
        notes: [
            "Attach a band to a support.",
            "Grab the band with both hands and turn your body to the side.",
            "Thrust the band outwards and then back in.",
            "Keep core braced and back straight",
            "Chin tucked and knees slightly bent.",
            "Arms stay tight beside ribs."],
        links: ["Video": "https://www.youtube.com/watch?v=AH_QZLm_0-s"]),
    
    "Parallel Bar Support": createNote(
        notes: [
            "Arms straight.",
            "Body straight or slightly hollow",
            "Depress the shoulders."],
        links: ["Link": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/support", "Supports": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/support"]),
    
    "Pause Bench": createNote(
        notes: [
            "Bench normally.",
            "Pause for a full two seconds at whatever depth you are weakest at.",
            "Most people should pause just below the mid-point but you can also pause an inch or two above your chest."],
        links: ["Pausing": "https://www.t-nation.com/training/2-second-pause-for-big-gains"]),
    
    "Pause Squat": createNote(
        notes: [
            "Squat normally.",
            "Once you hit below parallell pause for a full two seconds.",
            "Resume the squat."],
        links: ["Link": "http://bruteforcestrength.com/techniques/leg-training-pause-squats/", "Pausing": "https://www.t-nation.com/training/2-second-pause-for-big-gains"]),
    
    "Pendlay Row": createNote(
        notes: [
            "Bar above middle of feet. Feet about shoulder width apart.",
            "Toes out about thirty degrees.",
            "Keep knees slightly bent.",
            "Hands just outside shoulder width. Palms in. Grip close to fingers.",
            "Squeeze the bar hard.",
            "Back should remain straight the entire time.",
            "Explode the barbell up so that it touches your chest.",
            "Lower to floor slowly.",
            "Torso remain parallel to the floor and have minimal movement."],
        links: ["Stronglifts": "http://stronglifts.com/barbell-row/", "Video": "https://www.youtube.com/watch?v=Weu9HMHdiDA"]),
    
    "Pike Pushup": createNote(
        notes: [
            "Lay face down on the floor.",
            "Scoot your hips way up into the air.",
            "Keep your chin tucked.",
            "Lower your torso until your forehead touches the ground.",
            "Use your arms to raise your torso.",
            "Difficulty can be lessened by moving your feet backwards.",
            "Difficulty can be increased by resting your feet on a low bench or stool."],
        links: ["Video": "https://www.youtube.com/watch?v=EA8g7q9jauM", "Feet Elevated Video": "https://www.youtube.com/watch?v=Oy3zxr6W-vI"]),
    
    "Pin Squat": createNote(
        notes: [
            "Adjust the pins within a power cage to the desired depth.",
            "Squat normally and allow the bar to rest on the pins.",
            "Don't try to anticipate the pins: drop using your normal technique.",
            "Come to a full stop and then resume the squat."],
        links: ["Link": "http://bruteforcestrength.com/techniques/leg-training-pin-squats/"]),
    
    "Pistol Squat": createNote(
        notes: [
            "Keep your hands straight out.",
            "Stand on one leg and extend the other leg outward.",
            "Drop into a full squat with the leg you are standing on.",
            "Stand and switch legs."],
        links: ["Link1": "http://ashotofadrenaline.net/pistol-squat/", "Link2": "http://breakingmuscle.com/strength-conditioning/whats-preventing-you-from-doing-pistol-squats-how-to-progress-pistols", "Video": "https://www.youtube.com/watch?v=It3yvU0fomI"]),
    
    "Power Clean": createNote(
        notes: [
            "This is a complex technical lift that is difficult to summarize in a short list.",
            "It's best to learn the lift from a coach or a good guide and then add a note here for those bits that give you trouble."],
        links: ["Link": "https://experiencelife.com/article/learn-to-power-clean/", "Video": "https://www.youtube.com/watch?v=_LpPUmrKEg8"]),
    
    "Power Snatch": createNote(
        notes: [
            "This is a complex technical lift that is difficult to summarize in a short list.",
            "It's best to learn the lift from a coach or a good guide and then add a note here for those bits that give you trouble."],
        links: ["Link": "http://www.exrx.net/WeightExercises/OlympicLifts/PowerSnatch.html"]),
    
    "Preacher Curl": createNote(
        notes: [
            "Sit at the preacher bench and grab an EZ bar along the inner camber.",
            "Rest elbows on the bench.",
            "Curl the bar."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/preacher-curl"]),
    
    "Prone Lift": createNote(
        notes: [
            "Lie down with legs slightly apart and palms under your thighs.",
            "Lift both legs, bending at the hip, high enough that your thighs leave your hands.",
            "At the same time lift your head and shoulders from the floor."],
        links: ["Link": "https://www.fourmilab.ch/hackdiet/e4/"]),
    
    "Pseudo Planche Pushups": createNote(
        notes: [
            "Pushup but with your body scooted forward."],
        links: ["Video": "https://www.youtube.com/watch?v=Cdmg0CfMZeo"]),
    
    "Pull Through": createNote(
        notes: [
            "Attach a rope handle to a low pulley.",
            "Face away from the pulley straddling the cable.",
            "Bend at the hips so that the handle moves behind your butt.",
            "Using mostly your hips bring the handle in front of your hips.",
            "Keep your arms straight.",
            "Bend your knees slightly."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/pull-through"]),
    
    "Pullup": createNote(
        notes: [
            "Hands can be wider, the same, or narrower than shoulder width.",
            "Palms face out.",
            "Bring torso back about thirty degrees and push chest out.",
            "Pull until chest touches the bar.",
            "Slowly lower back down.",
            "Difficulty can be lessened by doing negatives: jump to raised position and very slowly lower yourself.",
            "Difficulty can be increased by attaching plates to a belt."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/pullups", "Pullups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pullup", "Elbow Pain": "https://breakingmuscle.com/fitness/5-ways-to-end-elbow-pain-during-chin-ups"]),
    
    "Pullup Negative": createNote(
        notes: [
            "Jump to the top and slowly lower yourself.",
            "Work towards taking 10s to lower yourself."],
        links: ["Link": "https://vimeo.com/76666801", "Pullups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pullup", "Elbow Pain": "https://breakingmuscle.com/fitness/5-ways-to-end-elbow-pain-during-chin-ups"]),
    
    "Push Press": createNote(
        notes: [
            "Clean the bar to your shoulders.",
            "Slightly flex hips and ankles, keeping your torso erect.",
            "Use your legs to push upwards in an explosive movement.",
            "Lock the bar overhead with shoulders shrugged up."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/push-press"]),
    
    "Pushup (intro)": createNote(
        notes: [
            "Lie face down with palms just outside your shoulder and arms bent.",
            "Push up until your arms are straight.",
            "Keep your knees on the floor and your upper body straight."],
        links: ["Link": "https://www.fourmilab.ch/hackdiet/e4/", "Negatives": "https://www.youtube.com/watch?v=S7pHvvD7oqA", "Pushups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pushup"]),
    
    "Pushup": createNote(
        notes: [
            "Hands slightly wider than shoulder width.",
            "Spread fingers and angle your hands outward slightly.",
            "Keep body straight.",
            "Difficulty can be lessened by keeping knees on the floor or by placing hands on a support.",
            "Difficulty can be increased by placing feet on a bench."],
        links: ["Link": "http://www.exrx.net/WeightExercises/PectoralSternal/BWPushup.html", "Antranik": "https://www.youtube.com/watch?v=4dF1DOWzf20&feature=youtu.be", "Pushups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pushup", "Inclined": "http://www.bodybuilding.com/exercises/detail/view/name/incline-push-up"]),
    
    "Pushup Plus": createNote(
        notes: [
            "Get into the upper portion of a pushup.",
            "While keeping your arms straight depress your chest and allow your shoulder blades to come together.",
            "Then raise your chest upwards moving your shoulder blades apart."],
        links: ["Video": "http://www.cornell.edu/video/push-up-plus"]),
    
    "Quadruped Double Traverse Abduction": createNote(
        notes: [
            "Crouch down on all fours.",
            "Tilt your hips to one side.",
            "Raise your opposite leg into the air as high as you can."],
        links: ["Video": "https://www.youtube.com/watch?v=1HrzisfjpBw"]),
    
    "Quadruped Thoracic Extension": createNote(
        notes: [
            "Crouch down on all fours.",
            "Place one hand behind your head.",
            "Rotate that arm inwards so that the elbow is pointed to the oppsite knee",
            "Pause and then rotate the arm up as far as possible.",
            "Keep your lower back straight."],
        links: ["Link": "https://www.exercise.com/exercises/quadruped-extension-and-rotation"]),
    
    "Rack Chinup": createNote(
        notes: [
            "Use a smith machine or squat rack.",
            "Prop feet on a bench or chair.",
            "Using a wide grip do chinups.",
            "Difficulty can be increased by resting a dumbbell on hips."],
        links: ["Link": "http://www.intensemuscle.com/archive/index.php/t-1463.html", "Video": "http://straighttothebar.com/articles/2008/11/rack_chins/"]),
    
    "Rack Pulls": createNote(
        notes: [
            "Setup inside a power rack with the pins either just below knees, at knees, or just above knees.",
            "Lift the bar off the pins just as if you were doing a deadlift.",
            "Weight should be even heavier than a deadlift so a mixed grip or straps are helpful."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/rack-pulls"]),
    
    "Rear-foot-elevated Hip Flexor Stretch": createNote(
        notes: [
            "Get on your knees.",
            "Prop one foot on a low support.",
            "Extend the other foot out in front of you.",
            "Keep your back straight and lean back slightly.",
            "Difficulty can be increased by placing your rear knee against a wall (couch stretch)."],
        links: ["Video": "https://www.youtube.com/watch?v=5rLRCSLbwjQ"]),
    
    "Renegade Row": createNote(
        notes: [
            "Place two kettlebells or dumbbells on the floor about shoulder width apart.",
            "Position yourself on your toes and hands with back and legs straight.",
            "Use the handles of the kettlebells to support your upper body.",
            "Feet can be spread outward.",
            "Push one kettlebell into the floor and row the other to your side.",
            "Lower the kettlebell and row the other one."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/alternating-renegade-row"]),
    
    "Reverse Flyes": createNote(
        notes: [
            "Lie face down on an incline bench.",
            "Grab two dumbbells and angle your hands so that your palms face each other.",
            "Keeping a slight bend to your elbows bring the dumbbells from in front of you to behind your back."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/reverse-flyes"]),
    
    "Reverse Hyperextension": createNote(
        notes: [
            "Lie on on your stomach on a high bench.",
            "Grab either handles or the sides of the bench.",
            "Keeping your legs straight raise them to parallel or a bit higher."],
        links: ["Link": "http://www.exrx.net/WeightExercises/GluteusMaximus/BWReverseHyperextension.html", "Video": "https://www.youtube.com/watch?v=ZeRsNzFcQLQ&"]),
    
    "Reverse Plank": createNote(
        notes: [
            "Lie on your back and raise your body up so that you are supported by just your palms and your feet.",
            "Straighten each leg out in turn.",
            "Pinch shoulder blades together.",
            "Bring the hips up."],
        links: ["Link": "https://www.youtube.com/watch?v=44ScXWFaVBs&feature=youtu.be&t=3m34s"]),
    
    "Reverse Wrist Curl": createNote(
        notes: [
            "Using a light dumbbell sit on a bench with your elbow on your leg so that your arm is bent at ninety degrees.",
            "With your palm facing the floor slowly lower and raise the weight.",
            "For Tennis Elbow (pain outside the elbow) it's recommended to repeat this with the arm held straight out."],
        links: ["Link": "http://www.exrx.net/WeightExercises/WristExtensors/DBReverseWristCurl.html", "Tennis Elbow": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2515258/table/t1-0541115/"]),
    
    "Ring Dips": createNote(
        notes: [
            "Hold the rings with your palms (mostly) facing forward.",
            "Go as far down as you can.",
            "Keep elbows in, don't bend at the hips."],
        links: ["Link": "https://www.youtube.com/watch?v=2Vymm8nH4wM", "Dips": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/dip"]),
    
    "Ring Support Hold": createNote(
        notes: [
            "Arms straight.",
            "Body straight or slightly hollow",
            "Depress the shoulders."],
        links: ["Link": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/support", "Supports": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/support"]),
    
    "Rings L-sit Dips": createNote(
        notes: [
            "Do a ring dip with your legs extended straight outward.",
            "Difficulty can be lessened by tucking your legs."],
        links: ["Link": "https://www.youtube.com/watch?v=2Vymm8nH4wM", "Dips": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/dip"]),
    
    "Rings Pushup": createNote(
        notes: [
            "Start from a plank position on the rings.",
            "Perform the pushup.",
            "Turn out the rings at the top (rotate so that your thumbs are pointed out).",
            "Keep your body in a straight line.",
            "Lock out arms and push shoulders forward.",
            "Keep elbows in, don't let them flare outwards from your torso."],
        links: ["Link": "https://www.youtube.com/watch?v=vBviFvN3rHw", "Pushups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pushup"]),
    
    "Rings Wide Pushup": createNote(
        notes: [
            "Start from a plank position on the rings.",
            "Lower your body while allowing the elbows to come out to your sides.",
            "Go down until your lower and upper arms form a ninety degree angle.",
            "Turn out the rings at the top (rotate so that your thumbs are pointed out).",
            "Keep your body in a straight line.",
            "Lock out arms and push shoulders forward."],
        links: ["Link": "https://www.youtube.com/watch?v=vBviFvN3rHw", "Pushups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pushup"]),
    
    "RKC Plank": createNote(
        notes: [
            "This is similar to a regular front plank except that:",
            "Elbows go further forward (place them under your head).",
            "Elbows are kept close together.",
            "Quads are contracted to lock out the knees.",
            "Glutes are contracted as hard as possible."],
        links: ["Link": "https://bretcontreras.com/the-rkc-plank/"]),
    
    "Rocking Frog Stretch": createNote(
        notes: [
            "Get on your hands and knees.",
            "Raise your knees an inch off the ground.",
            "Rock your body forward and backward.",
            "Keep your back flat and your knees the same distance from the ground."],
        links: ["Video": "https://www.youtube.com/watch?v=RirF9aNKtQU"]),
    
    "Roll-over into V-sit": createNote(
        notes: [
            "Sit on the floor with your legs stretched out in front of you.",
            "Roll backwards onto your shoulders.",
            "Try to have your toes touch the ground behind your head.",
            "Roll forward extending your legs into a V.",
            "Bring your arms forward so that your palms rest on the ground between your legs.",
            "Try to increase the range of motion with each rep.",
            "Difficulty can be reduced by pulling on your ankles as you roll back."],
        links: ["Video": "https://www.youtube.com/watch?v=NcBo0wRDCCE"]),
    
    "Romanian Deadlift": createNote(
        notes: [
            "Stand upright holding the bar with palms facing inward, back arched, and knees slightly bent.",
            "Lower the bar by moving your butt backwards as far as possible.",
            "Keep bar close to body, head looking forward, and shoulders back.",
            "Don't lower bar past knees,"],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/romanian-deadlift"]),
    
    "Rope Horizontal Chop": createNote(
        notes: [
            "Attach a straight bar attachment to a medium or low pulley.",
            "Alternate between extending one arm straight outward."],
        links: ["Video": "https://www.youtube.com/watch?v=_ZwskpDtXi0"]),
    
    "Rope Jumping": createNote(
        notes: [
            "Hold the rope in both hands and position it behind you on the ground.",
            "Swing the rope up and around.",
            "As it hits the floor jump over it."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/rope-jumping"]),
    
    "Rotational Lunge": createNote(
        notes: [
            "Stand up with one foot behind you and the other forward.",
            "Angle your back foot so that it is pointing to the side.",
            "Clasp your hands together, stretch them out forward, and crouch onto your back leg.",
            "It's OK if your front toes come off the ground."],
        links: ["Video": "https://www.youtube.com/watch?v=iH8erCfR7lQ"]),
    
    "Rowing Machine": createNote(
        notes: [
            "Primarily use your leg and hips.",
            "Bring the handle to your torso after straightening your legs.",
            "Keep your core tight throughout."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/rowing-stationary"]),
    
    "RTO Pushup": createNote(
        notes: [
            "Start from a plank position on the rings with the rings turned out.",
            "Perform the pushup.",
            "Keep the rings turned out the entire time.",
            "Keep your body in a straight line.",
            "Lock out arms and push shoulders forward.",
            "Keep elbows in, don't let them flare outwards from your torso."],
        links: ["Link": "https://www.youtube.com/watch?v=MrlyEIpe0LI&t=2m55s", "Pushups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pushup"]),
    
    "RTO PPPU": createNote(
        notes: [
            "Start from a plank position on the rings with the rings turned out.",
            "Lean forward until your shoulders are in front of your hands.",
            "Perform the pushup while maintaining the lean.",
            "Difficulty can be increased by leaning forward more.",
            "Keep your body in a straight line.",
            "Lock out arms and push shoulders forward.",
            "Keep elbows in, don't let them flare outwards from your torso."],
        links: ["Link": "https://www.youtube.com/watch?v=-kwe1EOiWMY", "Pushups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pushup"]),
    
    "RTO Support Hold": createNote(
        notes: [
            "Arms straight.",
            "Body straight or slightly hollow",
            "Depress the shoulders."],
        links: ["Link": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/support", "Supports": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/support"]),
    
    "Run and Jump (intro)": createNote(
        notes: [
            "Run in place at a brisk pace lifting your feet 4-6 inches from the floor with each step.",
            "Every 75th time your left foot touches the ground stop and do 7 introductory jumping jacks.",
            "For the jumping jacks stand with legs together, arms at your sides, and jump into the air extending your legs to the side and arms level with your shoulders."],
        links: ["Link": "https://www.fourmilab.ch/hackdiet/e4/"]),
    
    "Run and Jump": createNote(
        notes: [
            "Run in place at a brisk pace lifting your feet 4-6 inches from the floor with each step.",
            "Every 75th time your left foot touches the ground stop and do 10 jumping jacks.",
            "For the jumping jacks stand with legs together, arms at your sides, and jump into the air extending your legs to the side and arms as high as you can."],
        links: ["Link": "https://www.fourmilab.ch/hackdiet/e4/"]),
    
    "Russian Leg Curl": createNote(
        notes: [
            "Lie down on your stomach.",
            "Secure your feet.",
            "Cross your hands over your chest.",
            "Bring your torso up as high as possible.",
            "Keep your back straight at all times."],
        links: ["Link": "https://bretcontreras.com/nordic-ham-curl-staple-exercise-athletes/", "Video": "https://www.youtube.com/watch?v=d8AAPcYxPo8"]),
    
    "Scapular Pulls": createNote(
        notes: [
            "Hang down from a pullup bar.",
            "Use your arms to lift your shoulders upwards.",
            "Keep your elbows straight.",
            "At the top squeeze your shoulder blades together for 3-5s and slowly lower your body back down."],
        links: ["Video": "https://www.youtube.com/watch?v=FgYoc4O-cio&feature=youtu.be&t=1m21s"]),
    
    "Scapular Shrugs": createNote(
        notes: [
            "Crouch on your hands and knees with arms straight.",
            "Push your shoulder blades back as much as possible.",
            "Push your shoulder blades forward as much as possible.",
            "Difficulty can be increased by doing this in a pushup position or by using a band."],
        links: ["Link": "https://www.youtube.com/watch?v=akgQbxhrhOc"]),
    
    "Seated Cable Row": createNote(
        notes: [
            "Use a V-bar (which allows palms to face each other).",
            "Pull back until torso is at 90-degree angle from legs with chest out.",
            "Keep torso stationary and pull hands back to torso."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/seated-cable-rows"]),
    
    "Seated Calf Raises": createNote(
        notes: [
            "Sit on the machine, place toes on the lower portion of the platform with heels extending off.",
            "Place thighs under lever pad.",
            "Raise and lower heels."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/seated-calf-raise"]),
    
    "Seated Hip Abduction": createNote(
        notes: [
            "Sit on the machine (it's the one where your legs go inside the padded levers).",
            "Move legs as far apart as possible."],
        links: ["Link": "http://www.exrx.net/WeightExercises/HipAbductor/LVSeatedHipAbduction.html"]),
    
    "Seated Hip Adduction": createNote(
        notes: [
            "Sit on the machine (it's the one where your legs go outside the padded levers).",
            "Move legs together."],
        links: ["Link": "http://www.exrx.net/WeightExercises/HipAdductors/LVSeatedHipAdduction.html"]),
    
    "Seated Leg Curl": createNote(
        notes: [
            "Adjust the machine so that the lower pad is a few inches below your calves.",
            "Adjust the machine so that the upper pad is just above the knees.",
            "Grab the handles and point your toes straight.",
            "Curl legs upwards as far as possible without moving your torso."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/seated-leg-curl"]),
    
    "Seated Piriformis Stretch": createNote(
        notes: [
            "Sit down on a chair and cross your legs.",
            "Pull your knee up and lean your chest forward slightly.",
            "Back should remain straight."],
        links: ["Video": "https://www.youtube.com/watch?v=DE-GGsRtb6k"]),
    
    "Seated Triceps Press": createNote(
        notes: [
            "Sit on a bench with back support.",
            "Hold a dumbbell overhead with palms facing inwards.",
            "Lower the weight behind your head until your forearms touch your biceps.",
            "Keep elbows in and upper arms stationary."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/seated-triceps-press"]),
    
    "Shoulder Dislocate": createNote(
        notes: [
            "Use a dowel or a broom or a belt or a towel.",
            "Take a wide grip and slowly raise your arms up as far behind your head as possible.",
            "Keep your arms straight the entire time.",
            "Difficulty can be lessened by taking a wider grip.",
            "Difficulty can be increased by adding **small** weights.",
            "Do 1-3 sets of 15 reps."],
        links: ["Link": "https://www.reddit.com/r/bodyweightfitness/comments/2v5smy/the_shoulder_dislocate_a_must_read_for_all/", "Video": "https://www.youtube.com/watch?v=02HdChcpyBs"]),
    
    "Shoulder Dislocate (band)": createNote(
        notes: [
            "Start with your arms extending straight out.",
            "Rotate your arms behind your back as far as they will go.",
            "Elevate your shoulders as your arms pass over your head.",
            "Keep your arms straight the entire time."],
        links: ["Link": "https://www.youtube.com/watch?v=8lDC4Ri9zAQ&feature=youtu.be&t=4m22s"]),
    
    "Shoulder Rolls": createNote(
        notes: [
            "Stand upright with your arms at your side.",
            "Roll shoulders forward, up to ears, back, and down.",
            "Difficulty can be increased by:\n1. Holding your hands straight out in front of you.\n2. Holding your hands straight up above your head.\n3. Crouching on your hands and knees with elbows locked.\n4. Sticking your butt in the air so that your torso and legs form a ninety degree angle."],
        links: ["Link": "https://www.youtube.com/watch?v=H01oGIS1C_g"]),
    
    "Side Bend (45 degree)": createNote(
        notes: [
            "Lie on your side on an inclined support leaving your torso unsupported.",
            "Clasp your hands behind your head.",
            "Bend your torso towards the floor so that it forms a 45 degree angle to your hips."],
        links: ["Video": "https://www.youtube.com/watch?v=a3ToFRkvVNA"]),
    
    "Side Lateral Raise": createNote(
        notes: [
            "Hold two dumbbells along your sides with palms facing inwards.",
            "Raise arms until they are parallel to the floor.",
            "Keep elbows slightly bent."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/side-lateral-raise"]),
    
    "Side Lying Abduction": createNote(
        notes: [
            "Lay down on your side with your bottom leg bent in front of you and your top leg straight.",
            "Use one hand to support your head and place the other hand on the floor next to your bottom leg.",
            "Brace your core and lift your upper leg slightly.",
            "Keep your upper leg straight.",
            "Don't let your toes turn outwards or rotate towards the ground.",
            "Hold for 3s and slowly lower your leg."],
        links: ["Link": "https://squatuniversity.com/2017/05/30/how-to-fix-it-band-pain/"]),
    
    "Side Lying Hip Raise": createNote(
        notes: [
            "Lay down on your side so that your body is supported by a forearm and knee.",
            "Bring your feet back so that your lower and upper legs form a ninety degree angle.",
            "Place your other hand on your hip.",
            "Raise the leg that isn't supporting you into the air."],
        links: ["Video": "https://www.youtube.com/watch?v=xLbZJaR3il0"]),
    
    "Side Plank": createNote(
        notes: [
            "Lie on side on a mat keeping elbow below shoulder and legs together.",
            "Raise body upwards to create a straight line.",
            "Difficulty can be reduced by keeping your knees on the floor.",
            "Difficulty can be increased by keeping legs apart.",
            "Difficulty can also be increased by raising one leg into the air (abduction)."],
        links: ["Link": "http://www.exrx.net/WeightExercises/Obliques/BWSidePlank.html", "Antranik": "https://www.youtube.com/watch?v=44ScXWFaVBs&feature=youtu.be&t=1m19s", "Alternative": "http://i.imgur.com/6NM22BF.jpg", "Abduction Video": "https://www.youtube.com/watch?v=x6eHE2ox_Oo", "Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Single Leg Glute Bridge": createNote(
        notes: [
            "Lie on your back with your hands to your sides and your knees bent.",
            "Raise one leg, pulling your knee into your chest.",
            "Push your heels into the floor and lift your hips off the floor.",
            "Hold at the top for a second.",
            "Keep your back straight.",
            "Difficulty can be increased by elevating your body by placing one foot on a chair or bench."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/single-leg-glute-bridge-", "Elevated Video": "https://www.youtube.com/watch?v=juyqMVIzDkQ"]),
    
    "Single Leg Romanian Deadlift": createNote(
        notes: [
            "Start in a standing position with your arms hanging down holding a barbell.",
            "Lower the barbell towards the ground while at the same time raising one leg behind you.",
            "Keep your back straight and try to make your raised leg form a a straight line with your back.",
            "Tuck your chin.",
            "Slightly bend the knee your weight is resting on."],
        links: ["Link": "http://tonygentilcore.com/2009/06/exercises-you-should-be-doing-1-legged-barbell-rdl/"]),
    
    "Situp (intro)": createNote(
        notes: [
            "Lie down with feet slightly apart and hands at your sides.",
            "Lift your head and shoulders high enough that you can see your heels.",
            "Lower your head back to the floor and repeat."],
        links: ["Link": "https://www.fourmilab.ch/hackdiet/e4/"]),
    
    "Situp": createNote(
        notes: [
            "Lie down with feet held by a partner or under something that will not move.",
            "Knees should be off the floor",
            "Lock your hands behind your head.",
            "Raise your torso upwards.",
            "Difficulty can be increased by crossing your arms in front while holding a plate."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/sit-up", "Weighted": "http://www.exrx.net/WeightExercises/RectusAbdominis/WtSitUp.html"]),
    
    "Skater Squat": createNote(
        notes: [
            "Stand on one leg.",
            "Lean forward and squat down.",
            "Stand back up and repeat."],
        links: ["Video": "https://www.youtube.com/watch?v=qIi5bsSjdw4", "Details": "https://www.girlsgonestrong.com/blog/strength-training/exercise-spotlight-skater-squat/"]),
    
    "Skull Crushers": createNote(
        notes: [
            "Lie on back on a flat bench.",
            "Grip an EZ bar using a close grip with elbows in and bar behind head.",
            "Bring bar to a position above forehead.",
            "Keep upper arms stationary."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/ez-bar-skullcrusher"]),
    
    "Sliding Leg Curl": createNote(
        notes: [
            "Lay down on your back.",
            "Place valslides under your feet (or a towel if you have a smooth floor).",
            "Bring your feet in and raise your hips off the ground.",
            "Slide your feet all the way forward.",
            "Bring your feet back in until your shins are vertical.",
            "Keep your hips up at all times."],
        links: ["Video": "https://www.youtube.com/watch?v=RmsTFCQ3Qig"]),
    
    "Smith Machine Shrug": createNote(
        notes: [
            "Set the bar height to be about the middle of your thighs.",
            "Grab the bar with your palms facing you.",
            "Lift the bar up keeping your arms fully extended.",
            "Raise your shoulders until they come close to touching your ears.",
            "Lower your shoulders."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/smith-machine-shrug"]),
    
    "SMR Glutes with Ball": createNote(
        notes: [
            "Use a lacrosse or hockey ball.",
            "Sit on the ball and roll it back and forth on your glutes.",
            "Difficulty can be lessened by using a foam roller.",
            "Pause on areas that are especially tender until they feel better."],
        links: ["Video": "https://www.youtube.com/watch?v=M9Ix8OIPF-U"]),
    
    "Spell Caster": createNote(
        notes: [
            "Grab a pair of dumbbells with your palms facing backwards.",
            "Shift the weights to one side of your hips, rotating your torso as you go.",
            "Keeping your arms straight rotate your torso the other way so that the weights move to your other side.",
            "As you move the weights to the other side raise them to chest height."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/spell-caster"]),
    
    "Spider Curls": createNote(
        notes: [
            "Sit at the preacher bench and scoot forward so that your stomach is on the bench and your upper arms are against the sides of the bench.",
            "Grab an EZ bar at about shoulder width.",
            "Curl the bar."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/spider-curl"]),
    
    "Squat Jumps": createNote(
        notes: [
            "Stand straight up.",
            "Drop down into a squat.",
            "Jump into the air as high as possible."],
        links: ["Link": "https://www.youtube.com/watch?v=CVaEhXotL7M"]),
    
    "Squat Sky Reaches": createNote(
        notes: [
            "Squat down with your arms on your knees.",
            "Grab an ankle with one hand, clench the other arm and bring that elbow straight overhead.",
            "Once the elbow is overhead extend the arm straight up."],
        links: ["Video": "https://www.youtube.com/watch?v=lbozu0DPcYI&feature=youtu.be&t=42s"]),
    
    "Squat to Stand": createNote(
        notes: [
            "Stand with feet shoulder width apart.",
            "Keeping legs as straight as possible, bend over and grab your toes.",
            "Lower your hips into a squat while pushing shoulders and chest up.",
            "Raise your hips back to the starting position keeping your hands on your toes."],
        links: ["Link": "https://www.exercise.com/exercises/sumo-squat-to-stand"]),
    
    "Standing Calf Raises": createNote(
        notes: [
            "Use a a Smith machine or free weights.",
            "Keep knees slightly bent at all times.",
            "Keep your back straight.",
            "Don't allow your knees to move around."],
        links: ["Link": "https://www.bodybuilding.com/exercises/standing-calf-raises"]),
    
    "Standing Double Abduction": createNote(
        notes: [
            "Stand on one leg with your hands on your hips.",
            "Bring your other foot a foot or so off the ground.",
            "While sinking into a quarter squat curl your body towards the leg that is supporting you.",
            "Bring your raised knee up as high as you can keeping the foot behind you."],
        links: ["Video": "https://www.youtube.com/watch?v=syUYsbFtqSE"]),
    
    "Standing Dumbbell Calf Raises": createNote(
        notes: [
            "Stand upright while holding two dumbbells.",
            "Place the balls of your feet on a board 2-3\" high.",
            "Raise your heels as high as possible.",
            "Lower your heels to the floor.",
            "To hit all the muscles equally keep your toes pointed straight out."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/standing-dumbbell-calf-raise"]),
    
    "Standing One Arm Cable Row": createNote(
        notes: [
            "Use a low or medium height pulley.",
            "Drive elbow back as far as possible.",
            "Keep torso upright and don't twist."],
        links: ["Link": "http://www.trainbetterfitness.com/standing-1-arm-cable-row/"]),
    
    "Standing Quad Stretch": createNote(
        notes: [
            "Stand next to a wall or some other support.",
            "Place one hand on the support.",
            "With the other hand grab your ankle and pull your foot back to your butt."],
        links: ["Link": "http://www.exrx.net/Stretches/Quadriceps/Standing.html"]),
    
    "Standing Wide Leg Straddle": createNote(
        notes: [
            "Stand with your legs spread wide apart and feet pointer straight out.",
            "Straighten your legs.",
            "Place your fingertips (or palms) on the ground below your shoulders.",
            "You may also grab your big toes.",
            "Keep your eyes forward and your back concave."],
        links: ["Link": "http://yahwehyoga.com/pose-descriptions/cool-down/standing-wide-leg-straddle/"]),
    
    "Static Hold": createNote(
        notes: [
            "Use chalk.",
            "Setup inside a power rack with the pins set above your knees.",
            "When starting to grip the bar position your hands so that the calluses on your palm are just above the bar and then wrap your fingers and thumb around the bar.",
            "Grip the bar tightly.",
            "Lift the bar off the pins just as if you were doing a deadlift."],
        links: ["Link": "http://jasonferruggia.com/mythbusting-improve-grip-strength-deadlifting/", "Grip": "https://stronglifts.com/deadlift/grip/"]),
    
    "Step-ups": createNote(
        notes: [
            "Place one foot on a high object.",
            "Place all of your weight on that object and step up onto the object.",
            "Minimize pushing with your back leg.",
            "Difficulty can be increased by using a higher step or by holding dumbbells."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/dumbbell-step-ups"]),
    
    "Stiff-Legged Deadlift": createNote(
        notes: [
            "Like a normal deadlift except that the knees are only slightly bent and remain stationary."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/stiff-legged-barbell-deadlift"]),
    
    "Straight Leg Situp": createNote(
        notes: [
            "Lie on your back, optionally with your feet held in place.",
            "Cross your hands over your chest.",
            "Keep your legs extended straight outwards.",
            "Raise your torso up.",
            "As you come up extend your hands and touch your toes."],
        links: ["Video": "https://www.youtube.com/watch?v=AT6zWvOI6_o"]),
    
    "Sumo Deadlift": createNote(
        notes: [
            "Take a wide stance with knees pushed out.",
            "Place bar below middle of feet with toes pointed out slightly.",
            "Grab the bar by bending over at the hips instead of squatting down.",
            "Your arms should be hanging from the shoulders and between your legs.",
            "Drop low by driving knees out hard, keep lower back arched and hamstrings stretched.",
            "Wedge hips into bar and raise chest.",
            "Try to use feet to spread the floor apart and explode up.",
            "At the midpoint push hips into the bar."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/sumo-deadlift", "7-Steps": "https://www.elitefts.com/education/7-step-guide-to-learning-the-sumo-deadlift/", "Mastering": "https://www.t-nation.com/training/6-tips-to-master-the-sumo-deadlift"]),
    
    "Swiss Ball Hip Internal Rotation": createNote(
        notes: [
            "Lie on your back on a swiss ball.",
            "Cross your hands over your chest.",
            "Raise your hips up slightly and slowly rock forward and backward.",
            "As you're rocking bring your knees inward a bit."],
        links: ["Video": "https://www.youtube.com/watch?v=aVRidEHlbMA"]),
    
    "Third World Squat": createNote(
        notes: [
            "Look straight ahead and hold hands straight out.",
            "Feet about shoulder width apart, feet slightly angled out.",
            "Drop hips and knees together.",
            "Knees out.",
            "Difficulty can be lessened by using a wider stance and by angling feet outward more.",
            "Work towards holding the squat for one minute for multiple reps."],
        links: ["Link": "http://thirdworldsquats.com/", "Video": "https://vimeo.com/116283733"]),
    
    "Tiger Tail Roller": createNote(
        notes: [
            "Apply about ten pounds of force.",
            "Try to relax your muscles.",
            "Discomfort is OK, major pain is not.",
            "Spend 10-20 seconds on each muscle group."],
        links: ["Link": "https://www.tigertailusa.com/pages/how-to-roll"]),
    
    "Trap Bar Deadlift": createNote(
        notes: [
            "Load up a hex bar, stand in the middle, and grap both handles.",
            "Lower your hips, look foreward, and keep chest up.",
            "Drive through your heels keeping back straight."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/trap-bar-deadlift"]),
    
    "Triceps Pushdown (rope)": createNote(
        notes: [
            "Attach a rope attachment to a high pulley.",
            "Grab the attachment with palms facing each other.",
            "Stand straight up with a slight forward lean.",
            "Bring upper arms close to your torso and perpendicular to the ground.",
            "Start with forarms parallel to the ground.",
            "Using only your forearms bring the attachment down to your thighs.",
            "At the end your arms should be fully extended."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/triceps-pushdown-rope-attachment"]),
    
    "Tuck Front Lever": createNote(
        notes: [
            "Use a shoulder width grip on a pullup bar.",
            "Tuck legs and bring them up to your chest.",
            "Keep hips at the same height as your head.",
            "Difficulty can be increased by tucking less.",
            "Hold that position."],
        links: ["Link": "https://www.youtube.com/watch?v=tiST0765Sfo", "Body Weight Rows": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/row"]),
    
    "Tuck Front Lever Row": createNote(
        notes: [
            "Get into a tuck front level position.",
            "Pull your body up as high as possible while remaining horizontal."],
        links: ["Link": "https://www.youtube.com/watch?v=F-xEL0Ot0HA", "Body Weight Rows": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/row"]),
    
    "Tuck Ice Cream Maker": createNote(
        notes: [
            "From the top point of a pullup on rings tuck your legs.",
            "Then lean back while keeping body horizontal.",
            "Lock out arms and pause for a second in tuck front level position."],
        links: ["Untucked Video": "https://www.youtube.com/watch?v=AszLwoAvLKg", "Body Weight Rows": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/row"]),
    
    "Tuck L-sit": createNote(
        notes: [
            "Sit with your legs tucked towards your chest.",
            "Use your palms to raise your entire body off the floor keeping your legs tucked to your chest.",
            "Keep arms straight.",
            "Don't shrug your shoulders up."],
        links: ["Link": "https://www.youtube.com/watch?v=IUZJoSP66HI#t=40s", "L-sits": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/l-sit"]),
    
    "Turkish Get-Up": createNote(
        notes: [
            "Cradle and grip the kettlebell.",
            "Press the kettlebell overhead (using both hands is OK).",
            "Roll up onto your far elbow and then your hand.",
            "Lift your hips off the floor.",
            "Sweep the leg and find a lunge.",
            "Stand up from the lunge.",
            "Descend from the lunge.",
            "Keep your wrist straight and elbow locked the entire time.",
            "Instead of shrugging your shoulder up pull your shoulder blades down."],
        links: ["Link": "http://www.bodybuilding.com/fun/the-ultimate-guide-to-the-turkish-get-up.html", "Video": "https://www.youtube.com/watch?v=0bWRPC49-KI"]),
    
    "Underhand Cable Pulldowns": createNote(
        notes: [
            "Sit at a lat pulldown machine with a wide bar attached to the pulley.",
            "Grab the bar with your palms facing you at closer than shoulder width,",
            "Stick your chest out and lean back about thirty degrees.",
            "Pull the bar to your upper chest keeping albows in tight."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/underhand-cable-pulldowns"]),
    
    "Upright Row": createNote(
        notes: [
            "Grasp a barbell with palms facing inward slighty less than shoulder width.",
            "Rest the bar on thighs with elbows slightly bent,",
            "Keep back straight.",
            "Raise bar to chin keeping elbows higher than forearms.",
            "Lower bar back to thighs.",
            "Note that many people discourage peforming this exercise because it can cause shoulder impingement."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/upright-barbell-row", "Dangers": "https://www.t-nation.com/training/five-exercises-you-should-stop-doing-forever"]),
    
    "Vertical Pushup": createNote(
        notes: [
            "Stand upright facing a wall.",
            "Extend your arms and place both hands on the wall.",
            "Take a small step back and lift up onto your toes.",
            "Lower yourself into the wall and then push yourself away.",
            "Keep your body in a straight line.",
            "Lock out arms and push shoulders forward.",
            "Keep elbows in, don't let them flare outwards from your torso."],
        links: ["Link": "https://www.youtube.com/watch?v=a6YHbXD2XlU", "Pushups": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/pushup"]),
    
    "Vertical Rows": createNote(
        notes: [
            "Grab a door frame and pull your body into the frame and then allow it to move back.",
            "Keep your body straight and elbows in.",
            "Arms should be straight at the bottom.",
            "Don't let your shoulders shrug up."],
        links: ["Link": "https://www.youtube.com/watch?v=e5fdh9_kH_Y", "Body Weight Rows": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/row"]),
    
    "Walking Knee Hugs": createNote(
        notes: [
            "Stand up straight with your arms ar your sides.",
            "Bring one knee up, grab it with both hands, and gently pull it higher and in."],
        links: ["Link": "https://www.msn.com/en-us/health/exercise/strength/walking-knee-hugs/ss-BBtOl5z"]),
    
    "Wall Ankle Mobility": createNote(
        notes: [
            "Place one foot 3-4 inches away from a wall.",
            "Place the other foot well behind you.",
            "While keeping your front heel on the floor, drive your knees forward.",
            "Your rear heel should be off the floor."],
        links: ["Video": "https://www.youtube.com/watch?v=eGjJkurZlGw"]),
    
    "Wall Extensions": createNote(
        notes: [
            "Sit with your back straight up against a wall.",
            "Raise your arms as if you are surrendering pressing your upper arms against the wall,",
            "Start with your lower and upper arms forming a 90 degree angle.",
            "Once your upper arms are in place move your forearms against the wall.",
            "Keeping forearms completely vertical and your body against the wall slide your hands as high as they will go.",
            "Difficulty can be lessened by starting with elbows further down.",
            "Work towards 8-10 reps."],
        links: ["Link": "https://www.gymnasticbodies.com/forum/topic/846-wall-extensions/"]),
    
    "Wall Handstand": createNote(
        notes: [
            "Perform a handstand with your belly facing a wall and your feet braced against the wall.",
            "Once you can hold the position for more than 30s start take a foot from the wall and then both feet."],
        links: ["Link": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/handstand", "Handstands": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/handstand"]),
    
    "Wall Plank": createNote(
        notes: [
            "Put your feet up against a wall and do a plank hold.",
            "Don't allow your hips to sag: dig your soles hard into the wall.",
            "Work on getting your feet higher and higher."],
        links: ["Link": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/handstand", "Handstands": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/handstand", "Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Wall March Plank": createNote(
        notes: [
            "Put your feet up against a wall and do a plank hold.",
            "Don't allow your hips to sag: dig your soles hard into the wall.",
            "Work on getting your feet higher and higher.",
            "Alternate between bringing each knee forward."],
        links: ["Progression": "http://www.instructables.com/id/How-to-achieve-the-hanging-dragon-flag/"]),
    
    "Wide Rows": createNote(
        notes: [
            "Setup a pullup bar, a barbell, or rings. Use a grip at 1.5x shoulder width.",
            "Pull your body into the bar and then allow it to move back down.",
            "Keep your body straight and elbows in.",
            "Arms should be straight at the bottom.",
            "Don't let your shoulders shrug up."],
        links: ["Link": "https://www.youtube.com/watch?v=1yMRvsuk9Xg", "Body Weight Rows": "https://www.reddit.com/r/bodyweightfitness/wiki/exercises/row"]),
    
    "Wrist Mobility": createNote(
        notes: [
            "Crouch on your hands and knees with arms straight.",
            "1 Keep your fingers on the ground while raising and lowering your palms.",
            "2 Rotate palm left and right.",
            "3 Place hands sideways and rock side to side.",
            "4 Place hands palm up and rock backwards and forwards.",
            "5 Do the Star Trek salute and stick your hands, palm up again, around your knees. Rotate your elbows back and forth.",
            "6 Place palms on the ground in front of you and rotate your elbows back and forth.",
            "7 Place your hands backwards with the palms down, bring knees forward, and sit back on your heels and come back up.",
            "8 Place your hands with palms down and facing forward. Lean foward and then back.",
            "Difficulty can be increased by doing these in a plank position."],
        links: ["Link": "https://www.youtube.com/watch?v=8lDC4Ri9zAQ&feature=youtu.be&t=4m22s"]),
    
    "Yuri's Shoulder Band": createNote(
        notes: [
            "Attach a band to a support at about shoulder height.",
            "Extend an arm straight backwards and move forward until there is tension on the band.",
            "Bring your arm in to your back so that the forearm is against your lower back.",
            "Extend the arm straight back again.",
            "Bring your forearm to the back of your head and then circle it around your far shoulder and then to your far elbow.",
            "Reverse the movement so that your arm is again straight behind you.",
            "Repeat."],
        links: ["Video": "https://www.youtube.com/watch?v=Vwn5hSf3WEg"]),
    
    "X-Band Walk": createNote(
        notes: [
            "Put a resistance band beneath your feet, twist it so that it forms an X, and raise it to your chest.",
            "Walk sideways several steps.",
            "Walk back to your starting position."],
        links: ["Link": "https://www.exercise.com/exercises/x-resistance-band-walk"]),
    
    "Zercher Squat": createNote(
        notes: [
            "Load a bar on a squat rack where the bar is above your waist but below your chest.",
            "Lock your hands together and pick the bar up with it resting on your forearms just below the elbow.",
            "Step away from the rack and take a shoulder width stance.",
            "Point toes out slightly.",
            "Squat down until your thighs just break parallel with the ground.",
            "At the bottom your knees should be over your toes.",
            "Keep your head up at all times."],
        links: ["Link": "http://www.bodybuilding.com/exercises/detail/view/name/zercher-squats", "Details": "https://www.t-nation.com/training/complete-guide-to-zerchers"]),
]



