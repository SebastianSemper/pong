extends Node
class_name Player
 
var character
signal move_up
signal move_down

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _abstractInit(_character):
	character = _character
	self.connect("move_down", character, "move_down")
	self.connect("move_up", character, "move_up")
	
func _receive_frame(frame):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
