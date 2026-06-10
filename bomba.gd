extends Area2D

func _ready():
	connect("body_entered", _on_body_entered)
	$Timer.connect("timeout", _on_timer_timeout)

func _on_body_entered(body):
	if body.name != "player":
		$AnimatedSprite2D.hide()
		$explosao.show()
		$explosao.play("explosao")
		$Timer.start()
		if body.has_method("morre"):
			body.morre()

func _on_timer_timeout():
	queue_free()
