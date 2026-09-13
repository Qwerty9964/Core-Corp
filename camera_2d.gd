extends Camera2D



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.x !=0 or position.y!=0:
		var pos_dif:=Vector2(0,0)-position
		var move:= pos_dif*0.1
		position+=move
