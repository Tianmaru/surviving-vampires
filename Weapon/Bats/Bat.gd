extends Projectile

# Called when the node enters the scene tree for the first time.
func _ready():
	move_dir = rand_dir()

func _physics_process(delta):
	position += move_dir * delta * speed
	position.x = clamp(position.x, -160, 160)
	position.y = clamp(position.y, -90, 90)
	if position.x == -160 or position.x == 160:
		move_dir.x *= -1
		move_dir.y = rand_range(-1,1)
		move_dir = move_dir.normalized()
	elif position.y == -90 or position.y == 90:
		move_dir.x = rand_range(-1,1)
		move_dir.y *= -1
		move_dir = move_dir.normalized()
