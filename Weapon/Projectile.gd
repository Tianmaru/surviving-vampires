class_name Projectile
extends Area2D

var speed = 100
var damage = 1
var ticks = 0.2

var move_dir := Vector2()
var targets = Dictionary()

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func rand_dir():
	var rand_dir = Vector2()
	rand_dir.x = rand_range(-1, 1)
	rand_dir.y = rand_range(-1, 1)
	return rand_dir.normalized()

func _on_area_entered(area):
	var target = area.get_parent()
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = ticks
	targets[target] = timer
	target.take_damage(damage)
	timer.connect("timeout", self, "_on_tick", [timer, target])
	timer.start()

func _on_area_exited(area):
	var target = area.get_parent()
	if target in targets:
		targets[target].queue_free()
		targets.erase(target)

func _on_tick(timer, target):
	if target:
		target.take_damage(damage)
		timer.start()

