extends Node2D

const LOADING = preload("res://main/loading.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	globals.loading_type="main"
	get_tree().change_scene_to_file("res://main/main.tscn")
