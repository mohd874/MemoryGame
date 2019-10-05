extends Node2D

onready var star_image = preload("res://sprites/ui/star.png")
onready var empty_star_image = preload("res://sprites/ui/star-outline.png")

func reset():
    self.hide()
    for s in $Canvas/Stars.get_children():
        s.hide()

func display_score(num_of_pairs, num_of_tries):
    var score = round(num_of_pairs*4/num_of_tries)
    print("results:")
    print("pairs: "+str(num_of_pairs))
    print("tries: "+str(num_of_tries))
    print("score: "+str(score))
    
    self.show()
    for s in $Canvas/Stars.get_children():
        s.show()
        if score > 0:
            s.texture = star_image
            score -= 1
        else:
            s.texture = empty_star_image