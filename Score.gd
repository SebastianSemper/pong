extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var value

# Called when the node enters the scene tree for the first time.
func _ready():
	value = 0
	_update()

func _update():
	$Label.text = str(value)

func init(_position):
	$Label.rect_position = _position

func score():
	value += 1
	_update()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
