extends Node

var hooman_scn = preload("res://Enemies/Hooman/Hooman.tscn")
var bishop_scn = preload("res://Enemies/Bishop/Bishop.tscn")
var enemy_scn = hooman_scn

onready var xpbar = $CanvasLayer/XPBar
onready var timer_label = $CanvasLayer/TimerLabel
onready var player = $Player
onready var gameoverlay = $CanvasLayer2/GameOver
onready var youwin = $CanvasLayer2/YouWin
onready var spawn_timer = $SpawnTimer
onready var level_up_menu = $CanvasLayer/LevelUpMenu

onready var upgrade_buttons = [
	$CanvasLayer/LevelUpMenu/Background/Upgrades/FangsButton,
	$CanvasLayer/LevelUpMenu/Background/Upgrades/BatsButton,
	$CanvasLayer/LevelUpMenu/Background/Upgrades/CoffinsButton
]

var time_start
var pause_time := 0
var pause_start

var enemy_health = 10
var enemy_speed = 20
var enemy_damage = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	gameoverlay.hide()
	level_up_menu.hide()
	youwin.hide()
	update_xpbar()
	time_start = OS.get_unix_time()

func _process(delta):
	update_timer()

func update_timer():
	var t = OS.get_unix_time() - time_start - pause_time
	timer_label.text = "%02d:%02d" % [t / 60, t % 60]

func _on_Player_xp_gained():
	update_xpbar()

func update_xpbar():
	xpbar.max_value = player.next_level
	xpbar.value = player.xp

func _on_Player_level_up():
	level_up_menu.show()
	get_tree().paused = true
	pause_start = OS.get_unix_time()
	var weapons = player.get_weapons()
	for i in range(len(weapons)):
		if weapons[i] and weapons[i].level >= weapons[i].MAX_LEVEL:
			upgrade_buttons[i].disabled = true

func _on_Player_defeated():
	spawn_timer.stop()
	gameoverlay.show()
	get_tree().paused = true

func _on_Button_button_down():
	get_tree().paused = false
	get_tree().reload_current_scene()

func spawn_enemy():
	var spawn_dir = Vector2()
	spawn_dir.x = rand_range(-1,1)
	spawn_dir.y = rand_range(-1,1)
	var spawn_point = player.position + spawn_dir.normalized() * 200
	var enemy = enemy_scn.instance()
	set_enemy_stats(enemy)
	add_child(enemy)
	enemy.global_position = spawn_point

func _on_SpawnTimer_timeout():
	spawn_enemy()

func _on_BatsButton_button_down():
	player.levelup("bats")
	unpause()

func _on_FangsButton_button_down():
	player.levelup("fangs")
	unpause()

func _on_CoffinsButton_button_down():
	player.levelup("coffins")
	unpause()

func unpause():
	level_up_menu.hide()
	get_tree().paused = false
	pause_time += OS.get_unix_time() - pause_start

func set_enemy_stats(enemy):
	enemy.MOVE_SPEED = enemy_speed
	enemy.MAX_HEALTH = enemy_health
	enemy.DAMAGE = enemy_damage

func _on_Timer1_timeout():
	spawn_timer.wait_time = 1.5

func _on_Timer2_timeout():
	enemy_health = 20
	enemy_damage = 10

func _on_Timer3_timeout():
	spawn_timer.wait_time = 1

func _on_Timer4_timeout():
	enemy_health = 40
	spawn_timer.wait_time = 0.5

func _on_Timer5_timeout():
	enemy_scn = bishop_scn
	enemy_speed = 35
	enemy_health = 50
	spawn_timer.wait_time = 1.5

func _on_Timer6_timeout():
	spawn_timer.wait_time = 1

func _on_Timer7_timeout():
	enemy_health = 100

func _on_Timer8_timeout():
	spawn_timer.wait_time = 0.5

func _on_Timer9_timeout():
	enemy_health = 150
	spawn_timer.wait_time = 0.25

func _on_Timer10_timeout():
	get_tree().paused = true
	youwin.show()

func _on_KeepPlayingBtn_button_down():
	get_tree().paused = false
	youwin.hide()
