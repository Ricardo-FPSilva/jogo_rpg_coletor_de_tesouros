extends CharacterBody2D

var velocidade = 60
var xp = 20
var dano = 20
var tempo_ataque = 1.0
var dist_ataque = 14.0
var dist_perseguicao = 150.0

@onready var timer = $Timer
var alvo

func _ready():
	alvo = get_node("/root/Men/player")
	timer.wait_time = tempo_ataque
	timer.start()
	timer.connect("timeout", _on_timer_timeout)

func _physics_process(_delta):
	if not is_instance_valid(alvo):
		return
	var distancia = position.distance_to(alvo.position)

	if distancia > dist_ataque and distancia < dist_perseguicao:
		var dir = (alvo.position - position).normalized()
		velocity = dir * velocidade
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _on_timer_timeout():
	if not is_instance_valid(alvo):
		return
	var distancia = position.distance_to(alvo.position)
	if distancia <= dist_ataque:
		alvo.toma_dano(dano)
	timer.wait_time = tempo_ataque
	timer.start()

func morre():
	if is_instance_valid(alvo):
		alvo.toma_xp(xp)
	queue_free()
