extends CharacterBody2D


const SPEED = 280.00
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1500
const DECCELERATION = 2000
const DASH_SPEED=400
var dash := false
var dash_direction
var direction
var dash_timer = 15
var dash_cooldown=0

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("dash") and dash == false and dash_cooldown == 0:
		dash=true
		dash_direction=direction
		$dashindicator.visible=true

	
	direction = Input.get_axis("move_left","move_right")
	
	if dash_cooldown!=0:
		dash_cooldown-=1
	
	if direction !=0:
		velocity.x = move_toward(velocity.x, SPEED*direction, ACCELERATION*delta)
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	if dash:
		velocity.x = DASH_SPEED*dash_direction
		dash_timer-=1
		
	if dash_timer==0:
		dash=false
		dash_timer=20
		dash_cooldown=150
		$dashindicator.visible=false
		
		
	

	move_and_slide()
