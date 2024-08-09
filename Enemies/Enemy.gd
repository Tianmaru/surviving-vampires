class_name Enemy
extends KinematicBody2D

signal defeated

export(float) var MOVE_SPEED = 20
export(float) var MAX_HEALTH = 10
export(float) var DAMAGE = 10
export(float) var TICKS = 0.2

var damage_text_scn = preload("res://DamageText/DamageText.tscn")
var blood_scn = preload("res://Blood/Blood.tscn")
var death_effect_scn = preload("res://Effects/DeathEffect/DeathEffect.tscn")

var target
var health setget set_health

onready var hitbox = $HitBox
onready var hitbox_col = $HitBox/CollisionShape2D
onready var hitbox_timer = $HitBox/Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	hitbox_timer.wait_time = TICKS

func _physics_process(delta):
	var player
	var player_nodes = get_tree().get_nodes_in_group("player")
	if not player_nodes.empty():
		player = player_nodes.pop_front()
		var dir_vec = global_position.direction_to(player.global_position)
		move_and_slide(dir_vec * MOVE_SPEED)

func attack():
	target.take_damage(DAMAGE)

func _on_HitBox_area_entered(area):
	target = area.get_parent()
	attack()
	hitbox_timer.start()

func _on_HitBox_area_exited(area):
	hitbox_timer.stop()

func _on_Timer_timeout():
	attack()
	hitbox_timer.start()

func take_damage(dmg):
	self.health -= dmg
	var dmg_txt = damage_text_scn.instance()
	dmg_txt.text = dmg
	get_parent().add_child(dmg_txt)
	dmg_txt.global_position = global_position

func set_health(value):
	health = max(0, value)
	if health <= 0:
		emit_signal("defeated")
		spawn_loot()
		queue_free()

func spawn_loot():
	var effect = death_effect_scn.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position
	if rand_range(0,1) <= 0.5:
		var blood = blood_scn.instance()
		get_parent().add_child(blood)
		blood.global_position = global_position
