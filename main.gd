extends Node2D

@onready var terrain: TileMapLayer = $terrain
var mode: String = "negative"
@onready var pickaxe: Node2D = $character/miningpivot/pickaxe
const MINING_PARTICLES = preload("res://mineparticle.tscn")

const SOURCE_ID = 0
const GRASS = Vector2i(0,0)
const DIRT = Vector2i(1,0)
const STONE = Vector2i(0,1)
const CRYSTAL = Vector2i(1,1)

var cave_noise := FastNoiseLite.new()
var crystal_noise := FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cave_noise.noise_type=FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	cave_noise.seed=randi()
	cave_noise.frequency=0.043
	
	cave_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	cave_noise.fractal_octaves = 4
	cave_noise.fractal_lacunarity = 2.0
	cave_noise.fractal_gain = 0.5
	
	crystal_noise.noise_type=FastNoiseLite.TYPE_PERLIN
	crystal_noise.seed=randi()
	crystal_noise.frequency=0.15
	
	cave_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	cave_noise.fractal_octaves = 6
	cave_noise.fractal_lacunarity = 2.0
	cave_noise.fractal_gain = 0.5
	
	generate_world()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pickaxe.visible = false
	
	if Input.is_action_just_pressed("surface"):
		_on_ui_surface()
	
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
	
	var left_pickaxe_pos = $character/miningpivot/pickaxe/sprite/trackingpoint.global_position
	var left_terrain_pos = terrain.to_local(left_pickaxe_pos)
	var left_tile_cords = terrain.local_to_map(left_terrain_pos)
	
	var bottom_pickaxe_pos = $character/miningpivot/pickaxe/sprite/bottomtracking.global_position
	var bottom_terrain_pos = terrain.to_local(bottom_pickaxe_pos)
	var bottom_tile_cords = terrain.local_to_map(bottom_terrain_pos)
	
	var right_pickaxe_pos = $character/miningpivot/pickaxe/sprite/righttracking.global_position
	var right_terrain_pos = terrain.to_local(right_pickaxe_pos)
	var right_tile_cords = terrain.local_to_map(right_terrain_pos)
	
	var handle_pickaxe_pos = $character/miningpivot/pickaxe/sprite/handletracking.global_position
	var handle_terrain_pos = terrain.to_local(handle_pickaxe_pos)
	var handle_tile_cords = terrain.local_to_map(handle_terrain_pos)
	
	var top_pickaxe_pos = $character/miningpivot/pickaxe/sprite/toptracking.global_position
	var top_terrain_pos = terrain.to_local(top_pickaxe_pos)
	var top_tile_cords = terrain.local_to_map(top_terrain_pos)
	
	if terrain.get_cell_source_id(top_tile_cords)!=-1 or terrain.get_cell_source_id(bottom_tile_cords)!=-1 or terrain.get_cell_source_id(handle_tile_cords)!=-1 or terrain.get_cell_source_id(right_tile_cords)!=-1:
		activate_particles(top_pickaxe_pos)
		$character/miningpivot/pickaxe/sound.pitch_scale+=randf_range(-0.015,0.015)
		$character/miningpivot/pickaxe/sound.play()
		camera_shake()
		
	terrain.erase_cell(left_tile_cords)
	terrain.erase_cell(bottom_tile_cords)
	terrain.erase_cell(handle_tile_cords)
	terrain.erase_cell(right_tile_cords)
	terrain.erase_cell(top_tile_cords)
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
		var shake_vector=Vector2(randf_range(-0.55,0.55),randf_range(-0.55,0.55))
		$character/Camera2D.position+=shake_vector
	
		
func _on_ui_surface() -> void:
	$character.global_position.y=-20
	
func generate_world() -> void:
	for x in range(600):
		for y in range(150):
			var cell
			var randomn := randf()
			var randomm := randf()
			var cave_noise_value = cave_noise.get_noise_2d(x,y)
			var crystal_noise_value = crystal_noise.get_noise_2d(x,y)
			var stone_chance = clamp(1 - remap(y*2.5,0,150,0,1.5),0,1)
			var grass_chance = clamp(remap(y*5,0,150,0,4), 0 ,1)
			
			if cave_noise_value < -0.287 and y >20:
				continue
				
			else:
				if crystal_noise_value>0.48 and y >30:
					cell=CRYSTAL
				
				elif randomn > stone_chance:
					cell=STONE
					
				else:
					print("grass_chance" + str(grass_chance))
					print("val" + str(randomn))
					if randomm > grass_chance:
						print("hello")
						cell = GRASS
						
					else:
						cell = DIRT
					
			terrain.set_cell(
				Vector2i(x,y),
				SOURCE_ID,
				cell
			)
