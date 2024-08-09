extends Projectile

var distance = 200
var g = 90
var velocity = 0

onready var col = $CollisionShape2D
onready var coffin_sprite = $Sprite
onready var shadow_sprite = $ShadowSprite
onready var particles = $CPUParticles2D
onready var timer = $Timer

func _ready():
	coffin_sprite.global_position.y -= distance

func _process(delta):
	coffin_sprite.global_position.y += velocity * delta
	velocity += g * delta
	coffin_sprite.position.y = min(0, coffin_sprite.position.y)
	if coffin_sprite.position.y >= 0:
		coffin_sprite.visible = false
		shadow_sprite.visible = false
		col.set_deferred("disabled", false)
		particles.restart()
		set_process(false)
		timer.start()

func _on_Timer_timeout():
	queue_free()
