extends StaticBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(_position, extents):
	position = _position
	$CollisionShape2D.shape.extents = extents
	$ColorRect.margin_left = -extents.x
	$ColorRect.margin_right = extents.x
	$ColorRect.margin_top = -extents.y
	$ColorRect.margin_bottom = extents.y
	
	
