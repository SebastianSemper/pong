extends RigidBody2D

var default_pos
var max_init_speed = 500
var min_init_speed = 300

func init(_default_pos):
	default_pos = _default_pos
	position = default_pos
	
# Called when the node enters the scene tree for the first time.
func _ready():
	set_sleeping(1)

func shoot():
	var angle = rand_range(-30, +30) * PI / 180
	var speed = rand_range(min_init_speed, max_init_speed)
	var direction = sign(rand_range(-1, +1))
	apply_central_impulse(direction * Vector2(
		cos(angle) * speed, sin(angle) * speed
	))

func _process(delta):
	if randi()%100 == 0:
		apply_central_impulse(0.1 * linear_velocity)
