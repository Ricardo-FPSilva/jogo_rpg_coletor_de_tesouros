extends Area2D

var player

func _ready():
	player = get_node("/root/Men/player")
	connect("body_entered", _on_body_entered)

	var frames = $AnimatedSprite2D.sprite_frames
	if frames:
		var nomes = frames.get_animation_names()
		if nomes.size() > 0:
			$AnimatedSprite2D.play(nomes[randi() % nomes.size()])

func _on_body_entered(body):
	if body == player:
		player.toma_tesouro(1)
		player.toma_xp(10)
		queue_free()
