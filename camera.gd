extends Camera2D

var player

func _ready():
	player = get_node("../player")

	var solo = get_node("../solo")
	if solo == null or solo.tile_set == null:
		return
	var map_rect = solo.get_used_rect()
	if map_rect.size.x == 0 or map_rect.size.y == 0:
		return
	var cs = solo.tile_set.tile_size
	limit_left   = int(map_rect.position.x * cs.x)
	limit_top    = int(map_rect.position.y * cs.y)
	limit_right  = int((map_rect.position.x + map_rect.size.x) * cs.x)
	limit_bottom = int((map_rect.position.y + map_rect.size.y) * cs.y)

	zoom = Vector2(1.0, 1.0)

func _process(_delta):
	if is_instance_valid(player):
		position = player.position
