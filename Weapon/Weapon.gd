class_name Weapon
extends Node2D

const MAX_LEVEL = 5

export(Array, float) var COOLDOWN_LEVEL = [-1.0, -1.0, -1.0, -1.0, -1.0, -1.0]
export(Array, float) var N_PROJECTILES_LEVEL = [1, 1, 1, 2, 2, 3]
export(Array, float) var PROJECTILE_DAMAGE_LEVEL = [1, 2, 3, 4, 5, 6]
export(Array, float) var PROJECTILE_SPEED_LEVEL = [10, 20, 30, 40, 50, 60]
export(Array, float) var PROJECTILE_SIZE_LEVEL = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
export(Array, float) var PROJECTILE_TICKS_LEVEL = [0.2, 0.2, 0.2, 0.2, 0.2, 0.2]

export(PackedScene) var projectile_scn

var level = 0

var n_projectiles = 1
var projectile_damage = 1
var projectile_speed = 10
var projectile_size = 1
var projectile_ticks = 0.2
var cooldown = -1

onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	update_stats()
	if timer:
		timer.connect("timeout", self, "_on_Timer_timeout")
		timer.start()

func update_stats():
	cooldown = COOLDOWN_LEVEL[level]
	projectile_damage = PROJECTILE_DAMAGE_LEVEL[level]
	projectile_ticks = PROJECTILE_TICKS_LEVEL[level]
	n_projectiles = N_PROJECTILES_LEVEL[level]
	projectile_speed = PROJECTILE_SPEED_LEVEL[level]
	projectile_size = PROJECTILE_SIZE_LEVEL[level]
	if cooldown > 0 and timer:
		timer.wait_time = cooldown
	else:
		update_projectiles()

func level_up():
	level += 1
	level = clamp(level, 0, MAX_LEVEL)
	update_stats()

func update_projectile(projectile):
	projectile.scale = Vector2(projectile_size, projectile_size)
	projectile.speed = projectile_speed
	projectile.damage = projectile_damage
	projectile.ticks = projectile_ticks

func update_projectiles():
	pass

func _on_Timer_timeout():
	fire()

func fire():
	pass
