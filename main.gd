extends Node2D

@onready var terrain: TileMapLayer = $terrain
var mode: String = "negative"
@onready var pickaxe: Node2D = $character/miningpivot/pickaxe
const MINING_PARTICLES = preload("res://mineparticle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pickaxe.visible = false
	
	if Input.is_action_pressed("mine_toggle"):
		pickaxe.visible = true
		if Input.is_action_pressed('mine'):
			if mode == "negative":
				pickaxe.rotation-=18*delta
				if pickaxe.rotation<-1.05:
					mode = "positive"
					
			elif mode == "positive":
				pickaxe.rotation+=18*delta
				if pickaxe.rotation>1.05:
					mode = "negative"
					
			break_tile()
	
	


func break_tile() -> void:
	var mouse_pos = get_global_mouse_position()
	
	$character/miningpivot.look_at(mouse_pos)
	
	var top_pickaxe_pos = $character/miningpivot/pickaxe/sprite/trackingpoint.global_position
	var top_terrain_pos = terrain.to_local(top_pickaxe_pos)
	var top_tile_cords = terrain.local_to_map(top_terrain_pos)
	
	
	
	var bottom_pickaxe_pos = $character/miningpivot/pickaxe/sprite/bottomtracking.global_position
	var bottom_terrain_pos = terrain.to_local(bottom_pickaxe_pos)
	var bottom_tile_cords = terrain.local_to_map(bottom_terrain_pos)
	
	if terrain.get_cell_source_id(top_tile_cords)!=-1 or terrain.get_cell_source_id(bottom_tile_cords)!=-1:
		activate_particles(top_pickaxe_pos)
		$character/miningpivot/pickaxe/sound.pitch_scale+=randf_range(-0.015,0.015)
		$character/miningpivot/pickaxe/sound.play()
		camera_shake()
		
	terrain.erase_cell(top_tile_cords)
	terrain.erase_cell(bottom_tile_cords)
	#terrain.erase_cell(Vector2i(tile_cords.x+1,tile_cords.y+1))
	#terrain.erase_cell(Vector2i(tile_cords.x,tile_cords.y+1))
	#terrain.erase_cell(Vector2i(tile_cords.x+1,tile_cords.y))
	
func activate_particles(cords) -> void:
	var particle_instance = MINING_PARTICLES.instantiate()
	particle_instance.position=cords
	add_child(particle_instance)
	particle_instance.restart()
	
func camera_shake() -> void:
	print("shook")
	for i in range(5):
		var shake_vector=Vector2(randf_range(-0.45,0.45),randf_range(-0.45,0.45))
		$character/Camera2D.position+=shake_vector
	
		
func _on_ui_surface() -> void:
	$character.position.y=140
