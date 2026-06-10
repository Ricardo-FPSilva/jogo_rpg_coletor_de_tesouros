extends CharacterBody2D

signal criou_bomba
signal ganhou

var velocidade = 250
var vida = 100
var tesouros = 0
var meu_xp = 10
var direcao = Vector2.DOWN

var nova_bomba = preload("res://bomba.tscn")
var interface
var map_bounds = Rect2(0, 0, 948, 1080)

@onready var anime = $AnimatedSprite2D

func _ready():
	interface = get_node("/root/Men/CanvasLayer")
	interface.atualiza_vida(vida)
	interface.atualiza_xp(meu_xp)
	interface.atualiza_tesouros(tesouros)
	_calc_map_bounds()

func _calc_map_bounds():
	var solo = get_node("/root/Men/solo")
	if solo == null or solo.tile_set == null:
		return
	var r = solo.get_used_rect()
	if r.size.x == 0:
		return
	var cs = solo.tile_set.tile_size
	map_bounds = Rect2(
		r.position.x * cs.x,
		r.position.y * cs.y,
		r.size.x * cs.x,
		r.size.y * cs.y
	)

func _physics_process(_delta):
	var vel = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		vel.y = -1
		direcao = Vector2(0, -1)
	elif Input.is_action_pressed("ui_down"):
		vel.y = 1
		direcao = Vector2(0, 1)
	elif Input.is_action_pressed("ui_left"):
		vel.x = -1
		direcao = Vector2(-1, 0)
	elif Input.is_action_pressed("ui_right"):
		vel.x = 1
		direcao = Vector2(1, 0)

	vel = vel.normalized()
	velocity = vel * velocidade
	move_and_slide()

	# Impede o player de sair do mapa
	position.x = clamp(position.x, map_bounds.position.x + 5, map_bounds.position.x + map_bounds.size.x - 5)
	position.y = clamp(position.y, map_bounds.position.y + 5, map_bounds.position.y + map_bounds.size.y - 5)

	if vel.x > 0:
		_play_anim("direita")
	elif vel.x < 0:
		_play_anim("esquerda")
	elif vel.y < 0:
		_play_anim("cima")
	elif vel.y > 0:
		_play_anim("baixo")
	elif direcao.x == 1:
		_play_anim("p_direita")
	elif direcao.x == -1:
		_play_anim("p_esquerda")
	elif direcao.y == -1:
		_play_anim("p_cima")
	else:
		_play_anim("p_baixo")

	if Input.is_action_just_pressed("poe_bomba") and meu_xp >= 10:
		toma_xp(-10)
		emit_signal("criou_bomba")

func _play_anim(anim: String):
	if anime.animation != anim:
		anime.play(anim)

func toma_dano(dano: int):
	vida -= dano
	if interface:
		interface.atualiza_vida(vida)
	if vida <= 0:
		morre()

func toma_xp(quantidade: int):
	meu_xp += quantidade
	if interface:
		interface.atualiza_xp(meu_xp)

func toma_tesouro(achado: int):
	tesouros += achado
	if interface:
		interface.atualiza_tesouros(tesouros)
	if tesouros >= 6:
		emit_signal("ganhou")

func morre():
	get_tree().change_scene_to_file("res://gameover.tscn")

func get_pos_x() -> float:
	return position.x

func get_pos_y() -> float:
	return position.y
