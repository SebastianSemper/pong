extends Player

var up_event
var down_event

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(_character):
	._abstractInit(_character)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed(character.down_event):
		emit_signal("move_down")
	elif Input.is_action_pressed(character.up_event):
		emit_signal("move_up")
