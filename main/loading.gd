extends Node2D

const MAIN = preload("res://main/main.tscn")
var type = "null"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(globals)
	if globals.loading_type == "main":
		print("ran")
		get_tree().change_scene_to_packed(MAIN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
