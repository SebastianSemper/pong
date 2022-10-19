extends Node


var character
var up_event
var down_event

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(_character, _up_event, _down_event):
	character = _character
	up_event = _up_event
	down_event = _down_event


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed(down_event):
		character.down()
	elif Input.is_action_pressed(up_event):
		character.up()
	else:
		character.damp(delta)
