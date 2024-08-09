extends Weapon

var world

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire():
	.fire()
	var fang = projectile_scn.instance()
	fang.global_position = global_position
	fang.rotation = rotation
	update_projectile(fang)
	world.add_child(fang)
