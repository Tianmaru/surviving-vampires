extends Projectile

onready var anim = $AnimationPlayer
onready var col = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	global_position += get_transform().x.normalized() * speed * delta

func _on_area_entered(area):
	._on_area_entered(area)
	set_process(false)
	col.set_deferred("disabled", true)
	anim.play("bite")
	yield(anim, "animation_finished")
	queue_free()
