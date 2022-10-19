extends StaticBody2D

var start_position
var clamp_values
var max_speed = 20
var linear_damp
var linear_velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_damp = 10
	linear_velocity = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > clamp_values.y - $CollisionShape2D.shape.extents.y:
		linear_velocity += - 4 * linear_velocity
	if position.y < clamp_values.x + $CollisionShape2D.shape.extents.y:
		linear_velocity += - 4 * linear_velocity
		
	linear_velocity.y = clamp(linear_velocity.y, -20 * max_speed, + 20 * max_speed)
	position += delta * linear_velocity

func down():
	linear_velocity += Vector2(0,+max_speed)
	
func up():
	linear_velocity += Vector2(0,-max_speed)
	
func damp(delta):
	linear_velocity *= exp(-linear_damp * delta)

func init(_start_position, _clamp_values):
	start_position = _start_position
	clamp_values = _clamp_values
	position = start_position
