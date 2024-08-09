class_name Player
extends KinematicBody2D

signal xp_gained
signal defeated
signal level_up

export(float) var MOVE_SPEED = 50
export(float) var MAX_HEALTH = 100

var health : float setget set_health
var xp := 0 setget set_xp
var next_level := 5
var level := 1
const MAX_LEVEL = 18
const XP_INCREASE = 2

onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var healthbar = $HealthBar
onready var particles = $CPUParticles2D

onready var bats_scn = preload("res://Weapon/Bats/Bats.tscn")
onready var fangs_scn = preload("res://Weapon/Fangs/Fangs.tscn")
onready var coffins_scn = preload("res://Weapon/Coffins/Coffins.tscn")

onready var weapons = $Weapons
onready var fangs = $Weapons/Fangs
onready var bats
onready var coffins

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	healthbar.max_value = MAX_HEALTH
	healthbar.value = health
	fangs.world = get_parent()

func get_input_vec():
	var input_vec = Vector2()
	if Input.is_action_pressed("move_right"):
		input_vec.x += 1
	if Input.is_action_pressed("move_left"):
		input_vec.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vec.y += 1
	if Input.is_action_pressed("move_up"):
		input_vec.y -= 1
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		input_vec = global_position.direction_to(get_global_mouse_position())
	return input_vec

func _physics_process(delta):
	var input_vec = get_input_vec()
	if input_vec.length() > 0:
		sprite.flip_h = input_vec.x < 0
		if not anim.is_playing():
			anim.play("walk")
		if fangs:
			fangs.rotation = input_vec.normalized().angle()
	else:
		anim.stop()
	move_and_slide(input_vec.normalized() * MOVE_SPEED)

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	healthbar.value = value
	if health <= 0:
		emit_signal("defeated")
		queue_free()

func take_damage(dmg : float):
	self.health -= dmg
	if not particles.emitting:
		particles.restart()

func _on_Attractor_area_entered(area):
	area.queue_free()
	self.xp += 1
	self.health += 1

func set_xp(value):
	xp = min(value, next_level)
	emit_signal("xp_gained")
	if xp == next_level and not level == MAX_LEVEL:
		emit_signal("level_up")

func levelup(weapon):
	level += 1
	self.xp = 0
	next_level += XP_INCREASE
	if weapon == "bats":
		if bats:
			bats.level_up()
		else:
			bats = bats_scn.instance()
			weapons.add_child(bats)
			bats.global_position = weapons.global_position
	elif weapon == "fangs":
		if fangs:
			fangs.level_up()
		else:
			fangs = fangs_scn.instance()
			fangs.world = get_parent()
			weapons.add_child(bats)
			fangs.global_position = weapons.global_position
	elif weapon == "coffins":
		if coffins:
			coffins.level_up()
		else:
			coffins = coffins_scn.instance()
			coffins.world = get_parent()
			weapons.add_child(coffins)
			coffins.global_position = weapons.global_position

func get_weapons():
	return [fangs, bats, coffins]
