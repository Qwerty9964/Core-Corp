extends Node2D

@onready var terrain: TileMapLayer = $terrain


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed('mine'):
		break_tile()
	
	


func break_tile() -> void:
	var mouse_pos = get_global_mouse_position()
	
	var terrain_pos = terrain.to_local(mouse_pos)
	
	var tile_cords = terrain.local_to_map(terrain_pos)
	
	terrain.erase_cell(tile_cords)
