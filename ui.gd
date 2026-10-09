extends CanvasLayer

signal surface
var lives=3

@onready var heart1=$Panel/heart
@onready var heart2=$Panel/heart2
@onready var heart3=$Panel/heart3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Panel.lives=lives
	
	if lives==3:
		print(3)
		heart1.visible=true
		heart2.visible=true
		heart3.visible=true
		
	elif lives==2:
		print(2)
		heart1.visible=true
		heart2.visible=true
		heart3.visible=false
		
	elif lives==1:
		heart1.visible=true
		heart2.visible=false
		heart3.visible=false
		
	elif lives==0:
		heart1.visible=false
		heart2.visible=false
		heart3.visible=false
	


func _on_button_button_down() -> void:
	surface.emit()


func _on_character_lives_signal(char_lives) -> void:
	lives=char_lives
