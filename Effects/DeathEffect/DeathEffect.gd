extends Node2D

onready var particles = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	particles.one_shot = true
	particles.restart()

func _process(delta):
	if not particles.emitting:
		queue_free()
