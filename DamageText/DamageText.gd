extends Node2D

var text = ""

onready var label = $Anchor/Label

func _ready():
	label.text = str(text)
