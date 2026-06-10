extends Node2D

var nova_bomba = preload("res://bomba.tscn")
var nova_cena_inimigo = preload("res://inimigo.tscn")
var nova_cena_tesouro = preload("res://tesouro.tscn")

var total_inimigos = 0
var LIMITE_INIMIGOS = 20
var tesouros_na_tela = 0
var LIMITE_TESOUROS = 8

var map_left   = 0.0
var map_top    = 0.0
var map_right  = 948.0
var map_bottom = 1080.0

func _ready():
	_calc_map_bounds()
	_build_object_collisions()
	$player.position = Vector2((map_left + map_right) / 2.0, (map_top + map_bottom) / 2.0)
	$player.connect("criou_bomba", _on_player_criou_bomba)
	$player.connect("ganhou", _on_player_ganhou)
	$cria_inimigo.connect("timeout", _on_cria_inimigo_timeout)
	$cria_tesouro.connect("timeout", _on_cria_tesouro_timeout)

func _build_object_collisions():
	var obj = $objetos
	var ts = obj.tile_set
	if ts == null:
		return
	var cs = ts.tile_size
	var shape = RectangleShape2D.new()
	shape.size = Vector2(cs.x, cs.y)
	var used = obj.get_used_cells()
	for cell in used:
		var sb = StaticBody2D.new()
		var col = CollisionShape2D.new()
		col.shape = shape
		sb.position = obj.map_to_local(cell)
		sb.add_child(col)
		add_child(sb)

func _calc_map_bounds():
	var solo = $solo
	if solo == null or solo.tile_set == null:
		return
	var r = solo.get_used_rect()
	if r.size.x == 0:
		return
	var cs = solo.tile_set.tile_size
	map_left   = r.position.x * cs.x
	map_top    = r.position.y * cs.y
	map_right  = (r.position.x + r.size.x) * cs.x
	map_bottom = (r.position.y + r.size.y) * cs.y

func _on_player_criou_bomba():
	var bomba = nova_bomba.instantiate()
	add_child(bomba)
	bomba.position.x = $player.get_pos_x()
	bomba.position.y = $player.get_pos_y()

func _on_player_ganhou():
	get_tree().change_scene_to_file("res://vitoria.tscn")

func _spawn_pos_livre() -> Vector2:
	var obj = $objetos
	for _i in range(50):
		var pos = Vector2(
			randf_range(map_left + 24, map_right - 24),
			randf_range(map_top + 24, map_bottom - 24)
		)
		var cell = obj.local_to_map(pos)
		if obj.get_cell_source_id(cell) == -1:
			return pos
	return Vector2((map_left + map_right) / 2.0, (map_top + map_bottom) / 2.0)

func _on_cria_inimigo_timeout():
	if total_inimigos < LIMITE_INIMIGOS:
		var inimigo = nova_cena_inimigo.instantiate()
		add_child(inimigo)
		inimigo.position = _spawn_pos_livre()
		total_inimigos += 1

func _on_cria_tesouro_timeout():
	if tesouros_na_tela <= LIMITE_TESOUROS:
		var tesouro = nova_cena_tesouro.instantiate()
		add_child(tesouro)
		tesouro.position = _spawn_pos_livre()
		tesouros_na_tela += 1
