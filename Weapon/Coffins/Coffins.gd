extends Weapon

var world

# Called when the node enters the scene tree for the first time.
func _ready():
	print("coffins")

func fire():
	.fire()
	print("coffin")
	for i in range(n_projectiles):
		var coffin = projectile_scn.instance()
		update_projectile(coffin)
		var offset = Vector2(rand_range(-140, 140), rand_range(-70,70))
		coffin.global_position = global_position + offset
		world.add_child(coffin)
