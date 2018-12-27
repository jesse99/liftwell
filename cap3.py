percents = [100, 95, 93, 90, 87, 85, 83, 80, 77, 75, 72, 67, 66, 66, 65]

for max in [100, 150, 200, 250, 300]:
	tm = 0.9*max
	weight = 0.8*tm
	print "max: %.0f tm: %.0f weight: %.0f" % (max, tm, weight)

	for reps in range(1, 20):
		if reps < len(percents):
			lookup = weight*(2 - percents[reps-1]/100.0)
			formula = weight*((0.03333*reps) + 1)
			if lookup >= max or formula >= max:
				print "%d: %.1f   %.1f   %.2f" % (reps, lookup, formula, formula/lookup)
		else:
			formula = weight*((0.03333*reps) + 1)
			if formula >= max:
				print "%d:         %.1f" % (reps, formula)
	print "" 
	
