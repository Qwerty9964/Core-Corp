extends CharacterBody2D

var player: Node2D
var terrain
var active = false
const SPEED := 90
var abouttoexplode=false
var health=10
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if health<=0 and dead==false:
		explode_start()
		dead = true
		
		
	if abouttoexplode==true and $enemyexplodeparticles/GPUParticles2D.emitting == false:
		explode_end()
		
		
	var distance = global_position.distance_to(player.global_position)
	
	if distance<100:
		active=true
		
	if active:
		rotation+=1
		destroy_tiles()
		if distance > 350:
			active=false
		
		var direction := global_position.direction_to(player.global_position)
		velocity = direction*SPEED
		
		move_and_slide()
		
func destroy_tiles() -> void:
	var local_pos=terrain.to_local(global_position)
	var tile_cords=terrain.local_to_map(local_pos)
	
	var x = tile_cords.x
	var y = tile_cords.y
	
	terrain.erase_cell(Vector2i(x+1,y))
	terrain.erase_cell(Vector2i(x+1,y+1))
	terrain.erase_cell(Vector2i(x-1,y))
	terrain.erase_cell(Vector2i(x-1,y+1))
	terrain.erase_cell(Vector2i(x,y+1))
	terrain.erase_cell(Vector2i(x,y-1))
	
func explode_start() -> void:
	$enemyexplodeparticles/GPUParticles2D.emitting = true
	
	abouttoexplode=true
	$sprite.visible = false
	 
func explode_end() -> void:
	var local_pos=terrain.to_local(global_position)
	var tile_cords=terrain.local_to_map(local_pos)
	
	var x = tile_cords.x
	var y = tile_cords.y
	
	for i in range(x-2, x+2):
		for j in range(y-2,y+2):
			terrain.erase_cell(Vector2i(i,j))
			
	queue_free()
	
func take_damage() -> void:
	health-=5

func _on_detectionarea_body_entered(body: Node2D) -> void:
	if body==player and abouttoexplode==false:
		player.lives-=1
		explode_start()
