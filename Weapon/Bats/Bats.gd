class_name Bats
extends Weapon

onready var projectiles_node = $Projectiles

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_projectiles():
	.update_projectiles()
	if not projectiles_node:
		yield(self, "ready")
	while projectiles_node.get_child_count() < n_projectiles:
		var bat = projectile_scn.instance()
		projectiles_node.add_child(bat)
	for bat in projectiles_node.get_children():
		update_projectile(bat)
