extends StaticBody2D

var start_position
var clamp_values
var max_speed = 20
var linear_damp = 10
var linear_velocity
var impulse_velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(0, 0)
	impulse_velocity = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > clamp_values.y - $CollisionShape2D.shape.extents.y:
		linear_velocity += - 2.0 * linear_velocity
	if position.y < clamp_values.x + $CollisionShape2D.shape.extents.y:
		linear_velocity += - 2.0 * linear_velocity
	
	if (pow(impulse_velocity.x, 2) + pow(impulse_velocity.y, 2) > 0):
		linear_velocity += impulse_velocity
	else:
		linear_velocity *= exp(-linear_damp * delta)
	
	linear_velocity.y = clamp(linear_velocity.y, -20 * max_speed, + 20 * max_speed)
	position += delta * linear_velocity
	impulse_velocity = Vector2(0,0)

func move_down():
	impulse_velocity = Vector2(0,+max_speed)
	
func move_up():
	impulse_velocity = Vector2(0,-max_speed)

func init(_start_position, _clamp_values):
	start_position = _start_position
	clamp_values = _clamp_values
	position = start_position

